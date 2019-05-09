AdventumGold = { r=0.83, g=0.69, b=0.95, a=1 }
AdventumRed = { r=0.71, g=0.11, b=0.003, a=1 }
AdventumGrey = { r=0.6059, g=0.5706, b=0.4882, a=1 }
function AdventumToChatDebug(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.9, 0.7, 0.7) end
function AdventumToChatBold(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.9, 0.3, 0.7) end
function AdventumToChatGrey(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, AdventumGrey.r, AdventumGrey.g, AdventumGrey.b) end
function AdventumToChatRed(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, AdventumRed.r, AdventumRed.g, AdventumRed.b) end
function AdventumToChatGold(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, AdventumGold.r, AdventumGold.g, AdventumGold.b) end
AdventumActiveQuests = {}
AdventumQuestDB = {}
AdventumNodeTrail = {}
local CompletedQuests

local report
local yellow = AdventumGold
local red = AdventumRed
local grey = AdventumGrey
local activeQuest
local activeIgnoreQuests
local questDB
local latestDing

local ADDON_LOADED_EVENT = CreateFrame("Frame")
local QUEST_LOG_UPDATE_EVENT = CreateFrame("Frame")
local QUEST_WATCH_UPDATE_EVENT = CreateFrame("Frame")
local PLAYER_LEVEL_UP_EVENT = CreateFrame("Frame")
local BAG_UPDATE_EVENT = CreateFrame("Frame")
local QUEST_TURNED_IN_EVENT = CreateFrame("Frame")
local QUEST_ACCEPTED_EVENT = CreateFrame("Frame")
local CHAT_MSG_SYSTEM_EVENT = CreateFrame("Frame") -- wrath baby
local UNIT_QUEST_LOG_CHANGED_EVENT = CreateFrame("Frame") -- wrath baby

BINDING_HEADER_ADVENTUM = "Adventum"

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start)) == Start
end

function string.ends(String,Start)
   return string.sub(String,string.len(String) - string.len(Start),string.len(String)) == Start
end

local tcd = AdventumToChatDebug
local tcb = AdventumToChatBold
local tcg = AdventumToChatGrey
local tcr = AdventumToChatRed
local tcy = AdventumToChatGold

local latestLooted

function AdventumIsInBag(name, ...)
   for bagID = 0, NUM_BAG_FRAMES do
      local bagName = GetBagName(bagID)
      for slot = 1, GetContainerNumSlots(bagID) do
	 local itemLink = GetContainerItemLink(bagID, slot)
	 if itemLink then
	    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemLink)
	    if itemStackCount then
	       tcd("Found item: " .. itemName .. " count: " .. itemStackCount)
	    else
	       tcd("Found item: " .. itemName)
	    end
	    if itemName == name then
	       tcb("Found requested item ".. itemName .. " in " .. bagName .. "[".. slot.."].")
	       return true
	    end
	 end
      end
   end
   return false
end

function AdventumPlayerLevel()
   if latestDing then
      return latestDing
   else
      return UnitLevel("player")
   end
end

local function setToDone(qID)
   local logIndex = 1
   local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)   
   while titleFromQuestLog do
      if qID == questID then
	 SelectQuestLogEntry(logIndex)
	 AbandonQuest()
	 tcb("Abandoned " .. questDB[questID].t)
      end
      logIndex = logIndex + 1
      titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
   end
   AdventumIgnoreQuests[qID] = 1
   tcb("Tagging as Done: " .. questDB[qID].t)
end

function Adventum_SkipForward()
   tcb("TODO: Skipping by tagging quests as done")
   local currentNode = AdventumNodeTrail[AdventumNode]
   tcb("Skip node " .. tostring(currentNode))
   if currentNode.actions.Accept then
      tcb("accept node")
      for i, v in ipairs(currentNode.actions.Accept) do
	 setToDone(v)
      end
   end
   if currentNode.actions.Complete then
      tcb("complete node")
      for i, v in ipairs(currentNode.actions.Complete) do
	 setToDone(v)
      end
   end
   if currentNode.actions.Deliver then
      tcb("deliver node")
      for i, v in ipairs(currentNode.actions.Deliver) do
	 setToDone(v)
      end
   end
   report()
end

function Adventum_Toggle()
   if AdventumCanvas:IsShown() then
      AdventumCanvas:Hide()
   else
      AdventumCanvas:Show()
   end
end

function Adventum_Backup()
   AdventumBackup = AdventumIgnoreQuests
end

function Adventum_Restore()
   AdventumIgnoreQuests = AdventumBackup
end

SLASH_TEST1 = "/adventum"
SLASH_TEST2 = "/avt"
SlashCmdList["TEST"] = function(msg)
   tcd("Adventum help TODO")
end 

BAG_UPDATE_EVENT:SetScript("OnEvent",
  function(self, event)
     tcd("Handler: BAG_UPDATE_EVENT")
     report()
  end
)

local function clearLines()
   Adventum_Line1:SetText("")
   Adventum_Line2:SetText("")
   Adventum_Line3:SetText("")
   Adventum_Line4:SetText("")
   Adventum_Line5:SetText("")
   Adventum_Line6:SetText("")
   Adventum_Line7:SetText("")
   Adventum_Line8:SetText("")
   Adventum_Line9:SetText("")
   Adventum_Line10:SetText("")
   Adventum_Line11:SetText("")
   Adventum_Line12:SetText("")
   Adventum_Line13:SetText("")
   Adventum_Line14:SetText("")
   Adventum_Line15:SetText("")
   Adventum_Line16:SetText("")
end

report = function()
   tcd("At node " .. AdventumNode)
   Adventum_Line16:SetText("At node " .. AdventumNode)
   Adventum_Line16:SetTextColor(yellow.r, yellow.g, yellow.b, yellow.a)
   local currentNode = AdventumNodeTrail[AdventumNode]
   local doProgress = AdventumClassesReport(currentNode)
   if doProgress then
      if currentNode.Loot then
	 BAG_UPDATE_EVENT:UnregisterEvent("BAG_UPDATE")
      end
      if currentNode.nxt == "" then
	 tcd("At end of node trail")
	 clearLines()
	 Adventum_Line1:SetText("At end of node trail after " .. AdventumNode)
	 Adventum_Line1:SetTextColor(yellow.r, yellow.g, yellow.b, yellow.a)
       else
	 tcd("Moving to node " .. currentNode.nxt)
	 AdventumNode = currentNode.nxt
	 if AdventumNodeTrail[AdventumNode].Loot then
	     BAG_UPDATE_EVENT:RegisterEvent("BAG_UPDATE")
	  end
	 clearLines()
	 report()
      end
   end
end

ADDON_LOADED_EVENT:RegisterEvent("ADDON_LOADED")
ADDON_LOADED_EVENT:SetScript("OnEvent",
  function()
    if arg1 == "Adventum" then
       tcd("ADDON_LOADED for Adventum happened") 
       local _, classFilename, _ = UnitClass("player")
       AdventumPlayerClass = classFilename
       AdventumQuestDB = Adventum_Belf_1_12_QDB
--       AdventumQuestDB = Adventum_Orc_1_12_QDB
--       AdventumNodeTrail = Adventum_Orc_1_12_NodeTrail()
--       AdventumQuestDB = Adventum_Undead_1_12_QDB
--       AdventumNodeTrail = Adventum_Undead_1_12_NodeTrail()
       questDB = AdventumQuestDB
       AdventumClassesSetLocals()
       AdventumNodeTrail = Adventum_Belf_1_12()
       AdventumIsInBag("fake thing", 3) -- TODO removeme
       tcb("saw a " .. AdventumPlayerClass)
       for id, data in pairs(questDB) do
	  if data.n then
	     local boddeh = questDB[data.n]
	     if boddeh then
		questDB[data.n].p = id
	     end
	  end
       end
       if AdventumIgnoreQuests == nil then
	  AdventumIgnoreQuests = {}
       end
       clearLines()
       AdventumNode = "first"

	local logIndex = 1
	local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
	while titleFromQuestLog do
	   if not isHeader then
	      tcd("Got " .. titleFromQuestLog .. " (".. questID ..")")
	   end
	   logIndex = logIndex + 1
	   titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
	end
    end
  end
)

-- TODO: remove this method for Classic, wrath API specific, Classic offers this as a global function
function IsQuestFlaggedCompleted(questID)
--   tcd("Checking if quest flagged as completed: " .. questDB[questID].t)
   return CompletedQuests[questID]
end

-- TODO: remove this for Classic, wrath specific, Classic can call IsIsQuestFlaggedCompleted directly
local wrathInitialized
local wrathQueried
local QUEST_QUERY_COMPLETE_EVENT = CreateFrame("Frame")
QUEST_QUERY_COMPLETE_EVENT:RegisterEvent("QUEST_QUERY_COMPLETE")
QUEST_QUERY_COMPLETE_EVENT:SetScript("OnEvent",
   function()
      tcd("Handler: QUEST_QUERY_COMPLETE_EVENT")
      CompletedQuests = GetQuestsCompleted()
      report()
   end
)

local latestWatchUpdate

QUEST_LOG_UPDATE_EVENT:RegisterEvent("QUEST_LOG_UPDATE")
QUEST_LOG_UPDATE_EVENT:SetScript("OnEvent",
  function(self, event)
    tcd("Handler: QUEST_LOG_UPDATE_EVENT")
    QUEST_LOG_UPDATE_EVENT:UnregisterEvent("QUEST_LOG_UPDATE")
    if latestWatchUpdate then
      local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(latestWatchUpdate)
      latestWatchUpdate = nil
      tcd("UPDATE: update on quest " .. titleFromQuestLog)
      report()
    else
       tcd("UPDATE: initialization")
       QueryQuestsCompleted() -- TODO: remove for Classic, this was wrath API
       -- do whatever needs to be done initially
       -- TODO: call report() here when Classic, for wrath, call report in QUEST_QUERY_COMPLETE_EVENT handler
    end
  end
)
    
QUEST_WATCH_UPDATE_EVENT:RegisterEvent("QUEST_WATCH_UPDATE")
QUEST_WATCH_UPDATE_EVENT:SetScript("OnEvent", 
    function(self, event, logIndex)
      tcd("Handler: QUEST_LOG_WATCH_EVENT " .. logIndex)
      local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      tcd("WATCH: watch on quest " .. titleFromQuestLog)
      latestWatchUpdate = logIndex
      QUEST_LOG_UPDATE_EVENT:RegisterEvent("QUEST_LOG_UPDATE")
      report()
    end
)

-- TODO: this event will fire in Classic
QUEST_TURNED_IN_EVENT:RegisterEvent("QUEST_TURNED_IN")
QUEST_TURNED_IN_EVENT:SetScript("OnEvent",
  function(self, event, questID, xpReward, moneyReward)
     if questID then
	tcd("turned in quest " .. questDB[questID])
     else
	tcd("turned in quest")
     end
     report()
  end
)
  
local completesQuest

-- wrath API doesn't have a QUEST_COMPLETED, assume we always get a chat message indicating completion
CHAT_MSG_SYSTEM_EVENT:RegisterEvent("CHAT_MSG_SYSTEM")
CHAT_MSG_SYSTEM_EVENT:SetScript("OnEvent",
  function(self, event, questID, xpReward, moneyReward)
      tcd("Handler: CHAT_MSG_SYSTEM")
      QueryQuestsCompleted() -- TODO: remove for Classic, this was wrath API
     -- this event is fired whenever a quest dialog is closed
     -- this could be a good time to check if we've completed more quests
  end
)

QUEST_ACCEPTED_EVENT:RegisterEvent("QUEST_ACCEPTED")
QUEST_ACCEPTED_EVENT:SetScript("OnEvent",
  function(self, event, logIndex, questID)
    local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
    tcd("Accepted " .. titleFromQuestLog .. "(".. questID .. ")")
    report()
  end
)
  

local noDump = {
   PLAYER_ALIVE = true,
   CINEMATIC_START = true,
   CINEMATIC_STOP = true,
   UNIT_ATTACK = true,
   UNIT_NAME_UPDATE = true,
   IGNORELIST_UPDATE = true,
   FRIENDLIST_UPDATE = true,
   UNIT_RANGED_ATTACK_POWER = true,
   CHAT_MSG_CHANNEL = true,
   CHAT_MSG_CHANNEL_NOTICE = true,
   CHAT_MSG_SKILL = true,
   PARTY_INVITE_QUEST = true,
   MINIMAP_UPDATE_ZOOM = true,
   ZONE_CHANGED_INDOORS = true,
   WORLD_MAP_UPDATE = true,
   DISPLAY_SIZE_CHANGED = true,
   PLAYER_FARSIGHT_FOCUS_CHANGED = true,
   UNIT_PORTRAIT_UPDATE = true,
   UNIT_MODEL_CHANGED = true,
   UPDATE_CHAT_WINDOWS = true,
   UPDATE_WORLD_STATES = true,
   UPDATE_BONUS_ACTIONBAR = true,
   MEETINGSTONE_CHANGED = true,
   TABARD_CANSAVE_CHANGED = true,
   SPELLS_CHANGED = true,
   UPDATE_INSTANCE_INFO = true,
   UPDATE_PENDING_MAIL = true,
   UPDATE_MACROS = true,
   UPDATE_TICKET = true,
   CURSOR_UPDATE = true,
   UPDATE_BINDINGS = true,
   PLAYER_AURAS_CHANGED = true,
   PLAYER_GUILD_UPDATE = true,
   PLAYER_ENTERING_WORLD = true,
   PLAYER_UNGHOST = true,
   PLAYER_LOGIN = true,
   LANGUAGE_LIST_CHANGED = true,
   UNIT_PET = true,
   PET_BAR_UPDATE = true,
   UPDATE_LFG_TYPES = true,
   UPDATE_MOUSEOVER_UNIT = true,
   ADDON_LOADED = true,
   VARIABLES_LOADED = true,
   CHAT_MSG_SYSTEM = true,   
   CHAT_MSG_LOOT = true,
   UNIT_MANA = true,
   ACTIONBAR_UPDATE_COOLDOWN = true,
   SPELL_UPDATE_USABLE = true,
   SPELL_UPDATE_COOLDOWN = true,
   UNIT_COMBAT = true,
   PLAYER_TARGET_CHANGED = true,
   ACTIONBAR_UPDATE_USABLE = true,
   CURRENT_SPELL_CAST_CHANGED = true,
   SPELLCAST_DELAYED = true,
   UNIT_HEALTH = true,
   ACTIONBAR_UPDATE_STATE = true,
   ACTIONBAR_SLOT_CHANGED = true,
   BAG_UPDATE = true,
   UNIT_AURA = true,
   UNIT_STATS = true,
   UNIT_RESISTANCES = true,
   UNIT_MAXHEALTH = true,
   SPELLCAST_START = true,
   SPELLCAST_STOP = true,
   UPDATE_CHAT_COLOR = true,
   COMBAT_TEXT_UPDATE = true,
   SKILL_LINES_CHANGED = true,
   UNIT_FLAGS = true,
   UNIT_LOYALTY = true,
   UNIT_DEFENSE = true,
   LOOT_SLOT_CLEARED = true,
   ITEM_LOCK_CHANGED = true,
   UNIT_DYNAMIC_FLAGS = true,
   LOOT_CLOSED = true,
   QUEST_WATCH_UPDATE = true,
   QUEST_LOG_UPDATE = true,
   UPDATE_INVENTORY_ALERTS = true,
   LOOT_OPENED = true,
   PLAYER_MONEY = true,
   UNIT_FACTION = true,
   CHAT_MSG_MONEY = true,
   PLAYER_XP_UPDATE = true,
   PLAYER_FLAGS_CHANGED = true,
   PLAYER_LEAVE_COMBAT = true,
   PLAYER_ENTER_COMBAT = true,
   PLAYER_REGEN_ENABLED = true,
   PLAYER_REGEN_DISABLED = true,
   UI_ERROR_MESSAGE = true,
   UNIT_INVENTORY_CHANGED = true,
   SPELLCAST_FAILED = true,
   ACTIONBAR_SHOWGRID = true,
   ACTIONBAR_HIDEGRID = true,
   GOSSIP_SHOW = true,
   GOSSIP_CLOSE = true,
   TRAINER_UPDATE = true,
   TRAINER_SHOW = true,
   TRAINER_HIDE = true,
   UNIT_MAXMANA = true,
   UNIT_DAMAGE = true,
   UNIT_RANGED_DAMAGE = true,
   UNIT_ATTACK_POWER = true,
   ITEM_PUSH = true,
   LEARNED_SPELL_IN_TAB = true,
   SPELLCAST_INTERRUPTED = true,
   UNIT_ENERGY = true,
}

PLAYER_LEVEL_UP_EVENT:RegisterEvent("PLAYER_LEVEL_UP")
PLAYER_LEVEL_UP_EVENT:SetScript("OnEvent",
  function()
     tcd("Handler: PLAYER_LEVEL_UP_EVENT " .. arg1)
     latestDing = arg1
     report()
  end
)

local ALL_EVENT = CreateFrame("Frame")
--ALL_EVENT:RegisterAllEvents()
ALL_EVENT:SetScript("OnEvent", 
   function()
      local dump = "event happened: " .. event
      if arg1 then
	 dump = dump .. " " .. tostring(arg1)
      end
      if arg2 then
	 dump = dump .. " " .. tostring(arg2)
      end
      if arg3 then
	 dump = dump .. " " .. tostring(arg3)
      end
      if arg4 then
	 dump = dump .. " " .. tostring(arg4)
      end
      if arg5 then
	 dump = dump .. " " .. tostring(arg5)
      end
      if arg6 then
	 dump = dump .. " " .. tostring(arg6)
      end
      if noDump[event] then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "CHAT_MSG_COMBAT") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "COMBAT_LOG") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "PET_") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "CHAT_MSG_SPELL") then
	 -- do nothing
	 dump = nil
      else
	 tcd(dump)
      end
  end
)
