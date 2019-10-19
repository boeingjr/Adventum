local function tcm(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.10, 0.40, 0.99) end
local function tcd(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.5, 0.5, 0.5) end
local tcg = AdventumToChatGeneral
local function GetZone() return tostring(GetZoneText()) .. " - " .. tostring(GetSubZoneText()) end

local function testThis() 
   tcd("testing")
   local index = 1
   local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)
   while name do
      tcd("GetProfessionInfo" .. tostring(name) .. " " .. tostring(skillLevel))
      index = index + 1 
      name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)
   end

end

SLASH_ADVENTUM1 = "/adventum"
SLASH_ADVENTUM2 = "/adv"
SlashCmdList["ADVENTUM"] = function(cmd)
   testThis()
end

local ADDON_LOADED_EVENT = CreateFrame("Frame")
local PLAYER_LEVEL_UP_EVENT = CreateFrame("Frame")
local QUEST_LOG_UPDATE_EVENT = CreateFrame("Frame")
local QUEST_TURNED_IN_EVENT = CreateFrame("Frame")
local QUEST_REMOVED_EVENT = CreateFrame("Frame")
local QUEST_ACCEPTED_EVENT = CreateFrame("Frame")
local QUEST_WATCH_UPDATE_EVENT = CreateFrame("Frame")
local ZONE_CHANGED_EVENT = CreateFrame("Frame")
local HEARTHSTONE_BOUND_EVENT = CreateFrame("Frame")
local UI_INFO_MESSAGE_EVENT = CreateFrame("Frame")

AdventumNodeTrails = {}

local function ReportWhatToDo()
   tcd("at node " .. AdventumProgress.currentNode .. " in trail " .. AdventumProgress.nodeTrail)
   local n = AdventumNodeTrail[AdventumProgress.currentNode]
   local progress
   if n then
      progress = AdventumReport(n)
      if progress then
         local t = AdventumProgress.currentNode
         AdventumProgress.currentNode = n.nxt
         tcm("Moved from node " .. t .. " to node " .. tostring(AdventumProgress.currentNode))
         if AdventumProgress.currentNode == nil then
            if (AdventumPlayerRace == "dwarf" or AdventumPlayer == "gnome" or "AdventumPlayerRace" == "human") and UnitLevel("player") < 13 then
               tcd("Setting Node Trail to Elwynn_DunMorogh_NodeTrail")
               AdventumProgress.nodeTrail = "Elwynn_DunMorogh_NodeTrail"
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
               AdventumProgress.currentNode = "first"
            else
               tcd("No node trail")
            end
         end
         ReportWhatToDo()
      end     
   end
end

ADDON_LOADED_EVENT:RegisterEvent("ADDON_LOADED")
PLAYER_LEVEL_UP_EVENT:RegisterEvent("PLAYER_LEVEL_UP")
QUEST_LOG_UPDATE_EVENT:RegisterEvent("QUEST_LOG_UPDATE")
QUEST_TURNED_IN_EVENT:RegisterEvent("QUEST_TURNED_IN")
QUEST_REMOVED_EVENT:RegisterEvent("QUEST_REMOVED")
QUEST_ACCEPTED_EVENT:RegisterEvent("QUEST_ACCEPTED")
QUEST_WATCH_UPDATE_EVENT:RegisterEvent("QUEST_WATCH_UPDATE")
ZONE_CHANGED_EVENT:RegisterEvent("ZONE_CHANGED") -- subzone
ZONE_CHANGED_EVENT:RegisterEvent("ZONE_CHANGED_NEW_AREA") -- zone
ZONE_CHANGED_EVENT:RegisterEvent("ZONE_CHANGED_INDOORS") -- indoors
HEARTHSTONE_BOUND_EVENT:RegisterEvent("HEARTHSTONE_BOUND")
UI_INFO_MESSAGE_EVENT:RegisterEvent("UI_INFO_MESSAGE")

ADDON_LOADED_EVENT:SetScript("OnEvent",
   function(self, event, name)
      if name == "Adventum" then
         tcm("Adventum loaded: ".. UnitRace("player") .. " lvl " .. UnitLevel("player") .. " " ..UnitClass("player"))
         AdventumPlayerClass = string.lower(UnitClass("player"))
         AdventumPlayerRace = string.lower(UnitRace("player"))
         tcd("Adventum loaded: ".. AdventumPlayerRace .. " lvl " .. UnitLevel("player") .. " " .. AdventumPlayerClass)
         if AdventumProgress == nil then
            AdventumProgress = {}
         end
         if AdventumProgress.currentNode == nil or AdventumProgress.currentNode == "" then
            tcd("Setting node to first")
            AdventumProgress.currentNode = "first"
         end
         if AdventumProgress.nodeTrail == nil then
            if (AdventumPlayerRace == "dwarf" or AdventumPlayerRace == "gnome") and UnitLevel("player") < 7 then
               AdventumProgress.nodeTrail = "Dwarf_Gnome_Start_Nodetrail"
               tcd("Setting Node Trail to " .. AdventumProgress.nodeTrail)
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
            elseif (AdventumPlayerRace == "human") and UnitLevel("player") < 7 then
               AdventumProgress.nodeTrail = "Human_Start_Nodetrail"
               tcd("Setting Node Trail to " .. AdventumProgress.nodeTrail)
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
            elseif (AdventumPlayerRace == "dwarf" or AdventumPlayer == "gnome" or "AdventumPlayerRace" == "human") and UnitLevel("player") < 13 then
               AdventumProgress.nodeTrail = "Elwynn_DunMorogh_Nodetrail"
               tcd("Setting Node Trail to " .. AdventumProgress.nodeTrail)
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
            elseif (AdventumPlayerRace == "night elf") and UnitLevel("player") < 13 then
               AdventumProgress.nodeTrail = "NightElf_Start_Nodetrail"
               tcd("Setting Node Trail to " .. AdventumProgress.nodeTrail)
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
            elseif UnitLevel("player") < 20 then
               AdventumProgress.nodeTrail = "Alliance_13_20_Nodetrail"
               tcd("Setting Node Trail to " .. AdventumProgress.nodeTrail)
               AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
            else
               tcd("No node trail")
            end
         else
            AdventumNodeTrail = AdventumNodeTrails[AdventumProgress.nodeTrail]
         end
      end
   end
)
   
PLAYER_LEVEL_UP_EVENT:SetScript("OnEvent",
   function(self, event, level)
      tcm("PLAYER_LEVEL_UP_EVENT " .. level)
   end
)

QUEST_LOG_UPDATE_EVENT:SetScript("OnEvent",
   function(self, event)
      -- tcd("QUEST_LOG_UPDATE")
      ReportWhatToDo()
   end
)

QUEST_TURNED_IN_EVENT:SetScript("OnEvent",
   function(self, event, questID, xpReward, moneyReward)
      local title
      if AdventumQuestDB[questID] then
         title = AdventumQuestDB[questID].t
         if title == nil then
            title = "EMPTY TITLE"
         end
      else
         title = "NO DB ENTRY"
      end
      local entry = "QUEST_TURNED_IN: {" .. questID .. "} [" .. title .. "]"
      tcm(entry)
   end
)

QUEST_REMOVED_EVENT:SetScript("OnEvent",
   function(self, event, questID)
      local title
      if AdventumQuestDB[questID] then
         title = AdventumQuestDB[questID].t
         if title == nil then
            title = "EMPTY TITLE"
         end
      else
         title = "NO DB ENTRY"
      end
      local entry = "QUEST_REMOVED: {" .. questID .. "} [" .. title .. "]"
      tcm(entry)
   end
)

QUEST_ACCEPTED_EVENT:SetScript("OnEvent",
   function(self, event, logIndex, questID)
      local logTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      local title
      if AdventumQuestDB[questID] then
         title = AdventumQuestDB[questID].t
         if title == nil then
            title = "EMPTY TITLE"
         end
      else
         title = "NO DB ENTRY"
      end
      local entry = "QUEST_ACCEPTED: {" .. questID .. "} [" .. logTitle .. "] [" .. title .. "]"
      tcm(entry)
   end
)

QUEST_WATCH_UPDATE_EVENT:SetScript("OnEvent",
   function(self, event, logIndex)
      local logTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      local title
      if AdventumQuestDB[questID] then
         title = AdventumQuestDB[questID].t
         if title == nil then
            title = "EMPTY TITLE"
         end
      else
         title = "NO DB ENTRY"
      end
      local entry = "QUEST_WATCH_UPDATE: {" .. questID .. "} [" .. logTitle .. "] [" .. title .. "]"
      tcm(entry)
   end
)

ZONE_CHANGED_EVENT:SetScript("OnEvent",
   function(self, event)
      if event == "ZONE_CHANGED" then
         tcm("ZONE_CHANGED: ".. GetZone())
      elseif event == "ZONE_CHANGED_NEW_AREA" then
         tcm("ZONE_CHANGED_NEW_AREA: ".. tostring(z) .. " - " .. tostring(sz))
      elseif event == "ZONE_CHANGED_INDOORS" then
         tcm("ZONE_CHANGED_NEW_AREA: ".. tostring(z) .. " - " .. tostring(sz))
      end
   end
)

HEARTHSTONE_BOUND_EVENT:SetScript("OnEvent",
   function(self, event)
      local bindLocation = GetBindLocation();
      tcm("HEARTHSTONE_BOUND: " .. tostring(bindLocation))
   end
)

UI_INFO_MESSAGE_EVENT:SetScript("OnEvent", 
   function(self, event, anumber, msg)
      -- 281 New flight path discovered! in Trade District
      if string.match(msg, "New flight path discovered!") then
         local zone = tostring(GetZone())
         local entry = "UI_INFO_MESSAGE: " .. anumber .. " " .. zone
         tcm(entry)
         if AdventumProgress.flightpaths == nil then
            AdventumProgress.flightpaths = {}
         end
         table.insert(AdventumProgress.flightpaths, zone)
      end
   end
)
local AdventumCurrentLine = 0

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

local function updateLine(msg, c)
   if AdventumCurrentLine < 1 then
      tcm("Adventum l not properly set, msg: " .. msg)
   elseif AdventumCurrentLine > 16 then
      tcm("Adventum overflow for message " .. msg)
   else
      local widget
      if AdventumCurrentLine == 1 then
         widget = Adventum_Line1
      elseif AdventumCurrentLine == 2 then
         widget = Adventum_Line2
      elseif AdventumCurrentLine == 3 then
         widget = Adventum_Line3
      elseif AdventumCurrentLine == 4 then
         widget = Adventum_Line4
      elseif AdventumCurrentLine == 5 then
         widget = Adventum_Line5
      elseif AdventumCurrentLine == 6 then
         widget = Adventum_Line6
      elseif AdventumCurrentLine == 7 then
         widget = Adventum_Line7
      elseif AdventumCurrentLine == 8 then
         widget = Adventum_Line8
      elseif AdventumCurrentLine == 9 then
         widget = Adventum_Line9
      elseif AdventumCurrentLine == 10 then
         widget = Adventum_Line10
      elseif AdventumCurrentLine == 11 then
         widget = Adventum_Line11
      elseif AdventumCurrentLine == 12 then
         widget = Adventum_Line12
      elseif AdventumCurrentLine == 13 then
         widget = Adventum_Line13
      elseif AdventumCurrentLine == 14 then
         widget = Adventum_Line14
      elseif AdventumCurrentLine == 15 then
         widget = Adventum_Line15
      elseif AdventumCurrentLine == 16 then
         widget = Adventum_Line16
      end
      widget:SetText(msg)
      widget:SetTextColor(c.r, c.g, c.b, c.a)
      AdventumCurrentLine = AdventumCurrentLine + 1
   end
end

-- TODO: need to implement these properly
local AdventumPlayerClass = ""
local AdventumPlayerRace = ""
local AdventumPlayerCooking = 0

-- TODO: need to implement the ability for users to ignore quests
local AdventumIgnoreQuests = {}

-- the node tables with their various methods
-- AdventumNode (aka node) is the wrapper table.
-- calling accept, complete etc on a node will fill the node with subtables of the accept, complete kind etc
do
   local questDB = AdventumQuestDB

   local mtII = {
      __tostring = function(tbl) 
         local result = tbl.class .. ": "
         for i, v in ipairs(tbl) do
            if i > 1 then result = result .. ", " end
            result = result .. "{" .. tbl[i] .. "} [" .. questDB[tbl[i]].t .."]"
         end 
         return result
      end,
   }

   local function forQuestsInLog(doit)
      local questLog = {}
      local logIndex = 1
      local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      while title do
         if not isHeader then
            doit(questLog, logIndex, title, questID, isComplete)
         end
         logIndex = logIndex + 1
         title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(logIndex)
      end
      return questLog
   end

   local function fillObj(flavor, ...)
      local obj = {}
      obj.class = flavor
      local i = 1
      for ii, questID in ipairs({...}) do
         -- TODO: need to expand this to also account for race and profession quests
         local qDB = questDB[questID]
         if qDB == nil then 
            tcm("WARNING: No data for questID " .. questID)
         elseif (qDB.s == nil or qDB.s == AdventumPlayerClass) and (qDB.e == nil or qDB.e == AdventumPlayerRace) and (qDB.cooking == nil or qDB.cooking < AdventumPlayerCooking) then
            obj[i] = questID
            i = i+1
            -- tcd(flavor .. ": " .. qDB.t)
         else
            tcd(flavor .. " is for " .. "class " .. tostring(qDB.s) .. " and race " .. tostring(qDB.e) .. " with cooking at " .. tostring(qDB.cooking))
         end
      end
      return i, obj
   end

   local function accept(self, ...)
      local i, obj = fillObj("accept", ...)
      if i > 1 then
         setmetatable(obj, mtII)
         self.actions[obj.class] = obj
         obj.report = function (self)
            local res = true
            local currentQuestLog = forQuestsInLog(function(_questLog, _logIndex, _title, _questID, _isComplete) 
               _questLog[_questID] = true
            end)
            for i,qID in ipairs(self) do
               if currentQuestLog[qID] then
                  local line = "Accepted: " .. questDB[qID].t -- report it is picked up (OK)
                  -- tcd(line, Colors.darkslategrey)
                  updateLine(line, Colors.darkslategrey)
               elseif IsQuestFlaggedCompleted(qID) then
                  local line = "Did:      " .. questDB[qID].t -- report it was tagged as done (warn)
                  -- tcd(line)
                  updateLine(line, Colors.darkslategrey)
               elseif AdventumIgnoreQuests[qID] then
                  local line = "Ignored:      " .. questDB[qID].t -- report it was tagged as ignored (warn)
                  -- tcd(line)
                  updateLine(line, Colors.yellow)
               else
                  local line = "Accept:   " .. questDB[qID].t -- report it must be picked up (OK)
                  tcd(line)
                  updateLine(line, Colors.red)
                  res = false
               end
            end
            return res
         end
      end
      return self
   end

   local function turnin(self, ...)
      local i, obj = fillObj("turnin", ...)
      if i > 1 then
         setmetatable(obj, mtII)
         self.actions[obj.class] = obj
         obj.report = function (self)
            local res = true
            local completedStatusOnQuest = forQuestsInLog(function(_questLog, _logIndex, _title, _questID, _isComplete) 
               if _isComplete then
                  _questLog[_questID] = true
               else
                  local ii = 1
                  local defined = GetQuestLogLeaderBoard(ii, _logIndex)
                  if defined == nil then
                     tcd("not marked as completed but has no objectives: " .. _title)
                     _questLog[_questID] = true
                  else
                     _questLog[_questID] = false
                  end
               end
            end)
            for i,qID in ipairs(self) do
               if completedStatusOnQuest[qID] ~= nil and not completedStatusOnQuest[qID] then
                  -- I can't really see how this can happen unless we're out of sync with our nodes
                  -- actually it can happen if we have a turnin task on same node as complete task for same quest
                  local line = "Not complete for turnin: " .. questDB[qID].t  -- report it needs to be delivered (warn)
                  updateLine(line, Colors.yellow)
                  -- tcd(line)
               elseif completedStatusOnQuest[qID] then
                  local line = "Turn in:   " .. questDB[qID].t -- report it needs to be delivered (OK)
                  -- tcd(line)
                  updateLine(line, Colors.red)
                  res = false
               elseif IsQuestFlaggedCompleted(qID) then
                  local line = "Did:   " .. questDB[qID].t -- report it needs to be delivered (OK)
                  -- tcd(line)
                  updateLine(line, Colors.darkslategrey)
               elseif AdventumIgnoreQuests[qID] then
                  local line = "Ignored: " .. questDB[qID].t  -- report it was delivered (OK)
                  -- tcd(line)
                  updateLine(line, Colors.grey)
               else
                  local line = "Not in quest log: " .. questDB[qID].t -- report it was not picked up (warn)
                  updateLine(line, Colors.yellow)
                  -- tcd(line) -- report it was not picked up (warn)
               end
            end
            return res
         end
      end
      return self
   end

   local function objective(self, ...)
      tcd("objective called, get an objective of a quest done")
      return self
   end

   local function complete(self, ...)
      local i, obj = fillObj("complete", ...)
      if i > 1 then
         setmetatable(obj, mtII)
         self.actions[obj.class] = obj
         obj.report = function (self)
            local res = true
            local freshQuestLog = forQuestsInLog(function(_questLog, _logIndex, _title, _questID, _isComplete) 
               if _isComplete then
                  _questLog[_questID] = { completed = true, index = _logIndex, }
               else
                  _questLog[_questID] = { completed = false, index = _logIndex, } 
               end
            end)
            for i,qID in ipairs(self) do
               if freshQuestLog[qID] ~= nil and freshQuestLog[qID].completed then
                  local line = "Completed: " .. questDB[qID].t -- report it is completed (OK)
                  -- tcd(line)
                  updateLine(line, Colors.grey)
               elseif freshQuestLog[qID] ~= nil and not freshQuestLog[qID].completed then
                  local line = "Complete:  " .. questDB[qID].t -- report it needs to be completed (OK)
                  -- tcd(line)
                  updateLine(line, Colors.red)
                  AddQuestWatch(freshQuestLog[qID].index) -- the addon turns off auto quest watch to make this work bettah
                  res = false
               elseif AdventumIgnoreQuests[qID] then
                  local line = "Ignored:       " .. questDB[qID].t -- report it was done before (warn)
                  -- tcd(line)
                  updateLine(line, Colors.yellow)
               elseif IsQuestFlaggedCompleted(qID) then
                  local line = "Did:       " .. questDB[qID].t -- report it was done before (warn)
                  -- tcd(line)
                  updateLine(line, Colors.darkslategrey)
               else
                  local line = "Not in active list: " .. questDB[qID].t -- report it was not picked up (warn)
                  -- tcd(line)
                  updateLine(line, Colors.yellow)
               end
            end
            return res
         end
      end
      return self
   end

   local function tip(self, ...)
      local obj = {...}
      obj.class = "tip"
      obj.report = function (self) 
         for i,v in ipairs(obj) do
            -- tcd(v)
            updateLine("Tip: " .. v, Colors.yellow)
         end
         return true
      end
      setmetatable(obj, {
         __tostring = function(tbl)
            local result = ""
            local first = true
            for i, content in ipairs(tbl) do
               if first then
                  result = tbl.class .. ": " .. tostring(content)
                  first = false
               else
                  result = result .. " :: " .. tostring(content)
               end
            end
            return result
         end,
         })
      self.actions[obj.class] = obj
      return self
   end

   local function ding(self, ...)
      tcd("ding called")
      return self
   end

   local function loot(self, ...)
      tcd("loot called")
      return self
   end

   local function fp(self, ...)
      tcd("fp called")
      return self
   end

   local function hearth(self, ...)
      tcd("hearth called")
      return self
   end

   local function travel(self, ...)
      local obj = {...}
      obj.class = "travel"
      obj.report = function (self) 
         for i,v in ipairs(obj) do
            -- tcd(v)
            updateLine(v, Colors.yellow)
         end
         return true
      end
      setmetatable(obj, {
         __tostring = function(tbl)
            local result = ""
            local first = true
            for i, content in ipairs(tbl) do
               if first then
                  result = tbl.class .. ": " .. tostring(content)
                  first = false
               else
                  result = result .. " :: " .. tostring(content)
               end
            end
            return result
         end,
         })
      self.actions[obj.class] = obj
      return self
   end

   local function get(self, ...)
      tcd("get called")
      return self
   end

   function AdventumReport(node)
      clearLines()
      AdventumCurrentLine = 1
      local result = true
      for actionName, object in pairs(node.actions) do
         local res = object:report()
         if res == nil or not res then
            result = false
         end
      end
      return result
   end

   function AdventumNode(name, previous)
      if previous then
         tcd("creating new node "..name.." with ".. previous.name .. " as previous")
      else
         tcd("creating new node ".. name)
      end
      local obj = { prv = "", nxt = "",  name = name, actions = {}, 
         accept = accept,
         turnin = turnin,
         objective = objective,
         complete = complete,
         tip = tip, 
         ding = ding, 
         loot = loot,
         fp = fp,
         hearth = hearth,
         travel = travel,
         get = get
      }
      if previous then 
         obj.prv = previous.name
         previous.nxt = name
      end
      setmetatable(obj, {
         __tostring = function(tbl)
            local result = ""
            local first = true
            for actionType, content in pairs(tbl.actions) do
               if first then
                  result = tbl.name .. ": " .. tostring(content)
                  first = false
               else
                  result = result .. " :: " .. tostring(content)
                  end
            end
            return result
         end,
         }
      )
      return obj
   end
end

