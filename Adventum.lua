function tcm(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.22, 0.69, 0.95) end
function tcd(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.52, 0.69, 0.95) end
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start)) == Start
end

local function addEntry(entry)
   tcm(entry)
   AdventumGatherCount = AdventumGatherCount + 1
   AdventumGather[AdventumGatherCount] = entry
end

SLASH_ADVENTUM1 = "/adventum"
SLASH_ADVENTUM2 = "/adv"
SlashCmdList["ADVENTUM"] = function(cmd)
   local entry = "INSERTED: " .. cmd
   addEntry(entry)
end 

local questMirror = {}

local ADDON_LOADED_EVENT = CreateFrame("Frame")
ADDON_LOADED_EVENT:RegisterEvent("ADDON_LOADED")
ADDON_LOADED_EVENT:SetScript("OnEvent",
  function(self, event, name)
    if name == "Adventum" then
       tcm("Adventum loaded")
       if AdventumGather == nil then
	  AdventumGatherCount = 0
	  AdventumGather = {}
       end
    end
  end
)

local PLAYER_LEVEL_UP_EVENT = CreateFrame("Frame")
PLAYER_LEVEL_UP_EVENT:RegisterEvent("PLAYER_LEVEL_UP")
PLAYER_LEVEL_UP_EVENT:SetScript("OnEvent",
  function(self, event, level)
     addEntry("LEVEL: " .. level)
  end
)

local function compareObjectives(questID, logIndex)
   local objectiveID = 1
   local objectiveDescription, objectiveType, objectiveComplete = GetQuestLogLeaderBoard(objectiveID, logIndex)
   while objectiveID < 10 and objectiveDescription do
      local oldObjective = questMirror[questID].objectives[objectiveID]
      if oldObjective then
	 tcd("   " .. objectiveDescription .. " " .. tostring(objectiveComplete) .. " vs " .. oldObjective.objectiveDescription .. " " .. tostring(oldObjective.objectiveComplete) )
	 local objectiveCount = string.match(objectiveDescription, ": [0-9]+/[0-9]+")
	 if objectiveCount ~= oldObjective.objectiveCount or objectiveComplete ~= oldObjective.objectiveComplete then
	    local entry = "QLU OBJECTIVE: " .. objectiveDescription .. " " .. tostring(objectiveComplete)
	    oldObjective.objectiveCount = objectiveCount
	    oldObjective.objectiveDescription = objectiveDescription
	    oldObjective.objectiveComplete = objectiveComplete
	    addEntry(entry)
	 end
      else
	 tcd(questID .. " [" .. questMirror[questID].title .. "]   no oldObjective to compare (" .. objectiveID .. ") " .. objectiveDescription .. " " .. objectiveType .. " " .. tostring(objectiveComplete))
      end
      objectiveID = objectiveID + 1
      objectiveDescription, objectiveType, objectiveComplete = GetQuestLogLeaderBoard(objectiveID, logIndex)
   end
end

local function fillObjectives(questID, logIndex)
   local objectiveID = 1
   local objectiveDescription, objectiveType, objectiveComplete = GetQuestLogLeaderBoard(objectiveID, logIndex)
   while objectiveID < 10 and objectiveDescription do
      if objectiveID == 1 then
	 questMirror[questID].objectives = {}
      end
      local objectiveCount = string.match(objectiveDescription, ": [0-9]+/[0-9]+")
      questMirror[questID].objectives[objectiveID] = { objectiveDescription=objectiveDescription, objectiveCount=objectiveCount, objectiveType=objectiveType, objectiveComplete=objectiveComplete }
      tcd("   " .. objectiveDescription .. " " .. objectiveType .. " " .. tostring(objectiveComplete))
      objectiveID = objectiveID + 1
      objectiveDescription, objectiveType, objectiveComplete = GetQuestLogLeaderBoard(objectiveID, logIndex)
   end
end


local function initQuestMirror()
   questMirror = {}
   local logIndex = 1
   local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
   while title do
      if not isHeader then
	 questMirror[questID] = { title = title, logIndex = logIndex, isComplete = isComplete }
	 tcd("Init: " .. questID .. " [".. title .. "] " .. logIndex .. " " .. tostring(isComplete))
	 fillObjectives(questID, logIndex)
      end
      logIndex = logIndex + 1
      title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
   end
end

local function updateQuestMirror()
   local logIndex = 1
   local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
   while title do
      if not isHeader then
	 if questMirror[questID] == nil then
	    questMirror[questID] = { title = title, logIndex = logIndex, isComplete = isComplete }
	    fillObjectives(questID, logIndex)
	    local entry = "QLU NEW: " .. questID .. " [" .. title .. "]"
	    addEntry(entry)
	 else
	    tcd("Compare: " .. questID .. " [" .. title .. "]: " .. tostring(isComplete) .. " vs " .. tostring(questMirror[questID].isComplete))
	    compareObjectives(questID, logIndex)
	    if questMirror[questID].isComplete ~= isComplete then
	       tcb("QLU COMPLETED " .. questID .. " [" .. title .. "]")
	       questMirror[questID].isComplete = isComplete
	    end
	 end
      end
      logIndex = logIndex + 1
      title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
   end
end

local QUEST_LOG_UPDATE_EVENT = CreateFrame("Frame")
QUEST_LOG_UPDATE_EVENT:RegisterEvent("QUEST_LOG_UPDATE")
QUEST_LOG_UPDATE_EVENT:SetScript("OnEvent",
  function()
     initQuestMirror()
     QUEST_LOG_UPDATE_EVENT:SetScript("OnEvent",
       function(self, event, name)
	  updateQuestMirror()
       end
     )
  end
)

local removedQuests = {}

local QUEST_TURNED_IN_EVENT = CreateFrame("Frame")
QUEST_TURNED_IN_EVENT:RegisterEvent("QUEST_TURNED_IN")
QUEST_TURNED_IN_EVENT:SetScript("OnEvent",
   function(self, event, questID, xpReward, moneyReward)
      local entry = ""
      if questMirror[questID] then
	 entry = "QUEST_TURNED_IN: " .. questID .. " [" .. questMirror[questID].title .. "]"
	 questMirror[questID] = nil
      else
	 entry = "QUEST_TURNED_IN: " .. questID .. " [" .. removedQuests[questID] .. "]"
      end
      addEntry(entry)
  end
)


local QUEST_REMOVED_EVENT = CreateFrame("Frame")
QUEST_REMOVED_EVENT:RegisterEvent("QUEST_REMOVED")
QUEST_REMOVED_EVENT:SetScript("OnEvent",
   function(self, event, questID, xpReward, moneyReward)
      if questMirror[questID] then
	 local entry = "QUEST_REMOVED: " .. questID .. " [" .. questMirror[questID].title .. "]"
	 addEntry(entry)
	 removedQuests[questID] = questMirror[questID].title
	 questMirror[questID] = nil
      end
  end
)


local QUEST_ACCEPTED_EVENT = CreateFrame("Frame")
QUEST_ACCEPTED_EVENT:RegisterEvent("QUEST_ACCEPTED")
QUEST_ACCEPTED_EVENT:SetScript("OnEvent",
   function(self, event, logIndex, questID)
      local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questIDFromLog, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      local entry = "QUEST_ACCEPTED: " .. questID .. " [" .. title .. "] " .. questIDFromLog
--      tcd(entry)
  end
)

local QUEST_WATCH_UPDATE_EVENT = CreateFrame("Frame")
QUEST_WATCH_UPDATE_EVENT:RegisterEvent("QUEST_WATCH_UPDATE")
QUEST_WATCH_UPDATE_EVENT:SetScript("OnEvent",
   function(self, event, logIndex)
      local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      local entry = "QUEST_WATCH_UPDATE: " .. questID .. " [".. title .. "]"
--      tcd(entry)
  end
)

-- in this section, we just dump the various events while debuggging
-- comment out registering the event if you don't want this dump, as it is quite spammy.
-- you can also silence events you know you don't want by adding them in the noDump array with entry set to true

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
   CHAT_MSG_ADDON = true,
   CHAT_MSG_GUILD = true,
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
   UPDATE_INVENTORY_DURABILITY = true,
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
   LOADING_SCREEN_DISABLED = true,
--   PLAYER_AURAS_CHANGED = true,
--   PLAYER_GUILD_UPDATE = true,
--   PLAYER_ENTERING_WORLD = true,
   PLAYER_UNGHOST = true,
--   PLAYER_LOGIN = true,
   LANGUAGE_LIST_CHANGED = true,
   UNIT_PET = true,
   PET_BAR_UPDATE = true,
   UPDATE_LFG_TYPES = true,
   UPDATE_MOUSEOVER_UNIT = true,
   ADDON_LOADED = true,
   VARIABLES_LOADED = true,
   CHAT_MSG_SYSTEM = true,   
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
--   QUEST_WATCH_UPDATE = true,
--   QUEST_LOG_UPDATE = true,
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
   PLAYER_STARTED_MOVING = true,
   PLAYER_STOPPED_MOVING = true,
   UI_ERROR_MESSAGE = true,
   UNIT_INVENTORY_CHANGED = true,
   UNIT_HEALTH_FREQUENT = true,
   UNIT_POWER_FREQUENT = true,
   UNIT_POWER_UPDATE = true,
   SPELLCAST_FAILED = true,
   ACTIONBAR_SHOWGRID = true,
   ITEM_DATA_LOAD_RESULT = true,
   ACTIONBAR_HIDEGRID = true,
   TRAINER_UPDATE = true,
   MODIFIER_STATE_CHANGED = true,
   UNIT_MAXMANA = true,
   UNIT_TARGET = true,
   UNIT_DAMAGE = true,
   UNIT_RANGED_DAMAGE = true,
   UNIT_ATTACK_POWER = true,
   ITEM_PUSH = true,
   LEARNED_SPELL_IN_TAB = true,
   SPELLCAST_INTERRUPTED = true,
   UNIT_ENERGY = true,
   GUILD_ROSTER_UPDATE = true,
   GUILD_RANKS_UPDATE = true,
   PORTRAITS_UPDATED = true,
   STORE_PURCHASE_LIST_UPDATED = true,
   UI_SCALE_CHANGED = true,
   UPDATE_FACTION = true,
   SPELL_DATA_LOAD_RESULT = true,
   SPELL_TEXT_UPDATE = true,
   CHANNEL_UI_UPDATE = true,
   UPDATE_FLOATING_CHAT_WINDOWS = true,
   COMPACT_UNIT_FRAME_PROFILES_LOADED = true,
   INITIAL_CLUBS_LOADED = true,
}

local ALL_EVENT = CreateFrame("Frame")
--ALL_EVENT:RegisterAllEvents()
ALL_EVENT:SetScript("OnEvent", 
   function(self, event, ...)
      local dump = "event happened: " .. event
      local arg1, arg2, arg3, arg4, arg5, arg6 = ...
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
      elseif string.starts(event, "CHAT_MSG_") then
--      if string.starts(event, "CHAT_MSG_") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "VOICE_CHAT_") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "BN_") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "CURSOR_UPDATE") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "MODIFIER_STATE_CHANGED") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "COMBAT_LOG") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "UPDATE_CHAT_COLOR") then
	 -- do nothing
	 dump = nil
      elseif string.starts(event, "PET_") then
	 -- do nothing
	 dump = nil
      else
	 DEFAULT_CHAT_FRAME:AddMessage(dump, 0.22, 0.22, 0.22)
      end
  end
)

