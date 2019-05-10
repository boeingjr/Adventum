local function tcd(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.5, 0.5, 0.5) end
local function tcb(msg) DEFAULT_CHAT_FRAME:AddMessage(msg, 0.9, 0.3, 0.7) end
local tcg
local tcr
local tcy

local questDB
local activeQuests

local yellow
local red
local grey

function AdventumClassesSetLocals()
   tcd = AdventumToChatDebug
   tcb = AdventumToChatBold
   tcg = AdventumToChatGrey
   tcr = AdventumToChatRed
   tcy = AdventumToChatGold

   tcg = function(msg) end
   tcr = function(msg) end
   tcy = function(msg) end

   yellow = AdventumGold
   red = AdventumRed
   grey = AdventumGrey

   questDB = AdventumQuestDB
end



do 
   local currentLine = 0
   local function updateLine(msg, c)
      if currentLine < 1 then
	 tcb("Adventum currentLine not properly set, msg: " .. msg)
      elseif currentLine > 16 then
	 tcb("Adventum overflow for message " .. msg)
      else
	 local widget
	 if currentLine == 1 then
	    widget = Adventum_Line1
	 elseif currentLine == 2 then
	    widget = Adventum_Line2
	 elseif currentLine == 3 then
	    widget = Adventum_Line3
	 elseif currentLine == 4 then
	    widget = Adventum_Line4
	 elseif currentLine == 5 then
	    widget = Adventum_Line5
	 elseif currentLine == 6 then
	    widget = Adventum_Line6
	 elseif currentLine == 7 then
	    widget = Adventum_Line7
	 elseif currentLine == 8 then
	    widget = Adventum_Line8
	 elseif currentLine == 9 then
	    widget = Adventum_Line9
	 elseif currentLine == 10 then
	    widget = Adventum_Line10
	 elseif currentLine == 11 then
	    widget = Adventum_Line11
	 elseif currentLine == 12 then
	    widget = Adventum_Line12
	 elseif currentLine == 13 then
	    widget = Adventum_Line13
	 elseif currentLine == 14 then
	    widget = Adventum_Line14
	 elseif currentLine == 15 then
	    widget = Adventum_Line15
	 elseif currentLine == 16 then
	    widget = Adventum_Line16
	 end
	 widget:SetText(msg)
	 widget:SetTextColor(c.r, c.g, c.b, c.a)
	 currentLine = currentLine + 1
      end
   end

-- define Task classes where completion of a task can be decided by lookups on a set of quest ids only

   local mtII = {
      __tostring = function(tbl) 
	 local result = tbl.class .. ": "
	 for i, v in ipairs(tbl) do
	    if i > 1 then result = result .. ", " end
	    result = result .. "[" .. questDB[tbl[i]].t .."]"
	 end 
	 return result
      end,
   }

   local function acceptReport(obj)
      local res = true
      tcd("acceptNode: "..tostring(obj))
      local freshQuestLog = {}
      local logIndex = 1
      local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      while titleFromQuestLog do
	 if not isHeader then
	    freshQuestLog[questID] = true
	 end
	 logIndex = logIndex + 1
	 titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      end
      for i,qID in ipairs(obj) do
	 if freshQuestLog[qID] then
	    local line = "Accepted: " .. questDB[qID].t -- report it is picked up (OK)
--	    tcg(line)
	    updateLine(line, grey)
	 elseif IsQuestFlaggedCompleted(qID) then
	    local line = "Did:      " .. questDB[qID].t -- report it was tagged as ignored (warn)
--	    tcy(line)
	    updateLine(line, yellow)
	 elseif AdventumIgnoreQuests[qID] then
	    local line = "Ignored:      " .. questDB[qID].t -- report it was tagged as ignored (warn)
--	    tcy(line)
	    updateLine(line, yellow)
	 else
	    local line = "Accept:   " .. questDB[qID].t -- report it must be picked up (OK)
--	    tcr(line)
	    updateLine(line, red)
	    res = false
	 end
      end
      return res
   end

   function newAccept(tbl)
      setmetatable(tbl, mtII)
      tbl.class = "Accept"
      return tbl
   end

   local function deliverReport(obj)
      local res = true
--      tcd("deliverNode: "..tostring(obj))
      local freshQuestLog = {}
      local logIndex = 1
      local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      while titleFromQuestLog do
	 if not isHeader then
	    if isComplete then
	       freshQuestLog[questID] = true
	    else
	       local ii = 1
	       local defined = GetQuestLogLeaderBoard(ii, logIndex)
	       if defined == nil then
--		  tcd("not marked as completed but has no objectives: " .. titleFromQuestLog)
		  freshQuestLog[questID] = true
	       else
		  freshQuestLog[questID] = false
	       end
	    end
	 end
	 logIndex = logIndex + 1
	 titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      end
      for i,qID in ipairs(obj) do
--	 tcd("looking at quest with ID " .. qID)
	 if freshQuestLog[qID] ~= nil and not freshQuestLog[qID] then
--	    tcd("FIRST looking at quest with ID " .. qID)
	    -- is this a quest that has nothing on todo list?  these are not marked as completed
	    local line = "Not complete for deliver: " .. questDB[qID].t  -- report it needs to be delivered (warn)
	    updateLine(line, yellow)
--	    tcy(line)
	 elseif freshQuestLog[qID] then
--	    tcd("SEC looking at quest with ID " .. qID)
	    local line = "Deliver:   " .. questDB[qID].t -- report it needs to be delivered (OK)
--	    tcr(line)
	    updateLine(line, red)
	    res = false
	 elseif IsQuestFlaggedCompleted(qID) then
--	    tcd("THIRD looking at quest with ID " .. qID)
	    local line = "Did:   " .. questDB[qID].t -- report it needs to be delivered (OK)
--	    tcr(line)
	    updateLine(line, red)
	 elseif AdventumIgnoreQuests[qID] then
--	    tcd("FOURTH looking at quest with ID " .. qID)
	    local line = "Ignored: " .. questDB[qID].t  -- report it was delivered (OK)
--	    tcg(line)
	    updateLine(line, grey)
	 else
--	    tcd("FIFTH looking at quest with ID " .. qID)
	    local line = "Not in quest log: " .. questDB[qID].t -- report it was not picked up (warn)
	    updateLine(line, yellow)
--	    tcy(line) -- report it was not picked up (warn)
	 end
      end
      return res
   end

   function newDeliver(tbl)
      setmetatable(tbl, mtII)
      tbl.class = "Deliver"
      return tbl
   end

   local function completeReport(obj)
      local res = true
--      tcd("completeNode: "..tostring(obj))
      local freshQuestLog = {}
      local logIndex = 1
      local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      while titleFromQuestLog do
	 if not isHeader then
	    if isComplete then
	       freshQuestLog[questID] = { completed = true, index = logIndex, }
	    else
	       freshQuestLog[questID] = { completed = false, index = logIndex, } 
	    end
	 end
	 logIndex = logIndex + 1
	 titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)
      end
      for i,qID in ipairs(obj) do
	 if freshQuestLog[qID] ~= nil and freshQuestLog[qID].completed then
	    local line = "Completed: " .. questDB[qID].t -- report it is completed (OK)
--	    tcg(line)
	    updateLine(line, grey)
	 elseif freshQuestLog[qID] ~= nil and not freshQuestLog[qID].completed then
	    local line = "Complete:  " .. questDB[qID].t -- report it needs to be completed (OK)
--	    tcr(line)
	    updateLine(line, red)
	    AddQuestWatch(freshQuestLog[qID].index) -- the addon turns off auto quest watch to make this work bettah
	    res = false
	 elseif AdventumIgnoreQuests[qID] then
	    local line = "Ignored:       " .. questDB[qID].t -- report it was done before (warn)
--	    tcy(line)
	    updateLine(line, yellow)
	 elseif IsQuestFlaggedCompleted(qID) then
	    local line = "Did:       " .. questDB[qID].t -- report it was done before (warn)
--	    tcy(line)
	    updateLine(line, yellow)
	 else
	    local line = "Not in active list: " .. questDB[qID].t -- report it was not picked up (warn)
	    updateLine(line, yellow)
--	    tcy(line)
	 end
      end
      return res
   end

   function newComplete(tbl)
      setmetatable(tbl, mtII)
      tbl.class = "Complete"
      return tbl
   end

   local function otherReport(obj)
      for i,v in ipairs(obj) do
--	 tcy(v)
	 updateLine(v, yellow)
      end
      return true
   end

   function newOther(...)
      local obj = {...}
      obj.class = "Other"
      return obj
   end

   local function dingReport(obj)
      if AdventumPlayerLevel() < obj.lvl then 
	 local line = "Grind to level " .. obj.lvl
--	 tcy(line)
	 updateLine(line, yellow)
	 return false
      end
      return true
   end

   function newDing(v)
      local obj = {}
      obj.lvl = v
      obj.class = "Ding"
      return obj
   end

   local function lootReport(obj)
      local res = true
      tcd("loot report")
      tcd("loot report" .. tostring(obj))
      for qID,list in pairs(obj.tbl) do
	 tcd("looking at loot for quest .. " .. qID)
	 if not IsQuestFlaggedCompleted(qID) and not AdventumIgnoreQuests[qID] then
	    for i, v in ipairs(list) do
	       if AdventumIsInBag(v) then
		  local line = "Looted: " .. v
--		  tcg(line)
		  updateLine(line, grey)
	       else
		  local line = "Loot:   " .. v
--		  tcy(line)
		  updateLine(line, yellow)
		  res = false
	       end
	    end
	 end
      end
      return res
   end

   function newLoot(tbl)
      local obj = {}
      obj.tbl = tbl
      obj.lvl = v
      obj.class = "Loot"
      return obj
   end

-- define Node class
   local mt = {
      __tostring = function(tbl)
	 local result
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

   local function add(self, task)
      self.actions[task.class] = task
      return self
   end

   local function oldaccept(self, ...)
      local obj = newAccept(...)
      self.actions[obj.class] = obj
      return self
   end

   local function olddeliver(self, ...)
      local obj = newDeliver(...)
      self.actions[obj.class] = obj
      return self
   end

   local function oldcomplete(self, ...)
      local obj = newComplete(...)
      self.actions[obj.class] = obj
      return self
   end

   local function accept(self, ...)
      local tbl = {...}
      local stripped = {}
      local i = 1
      for ii, questID in ipairs(tbl) do
	 if questDB[questID].class == nil or questDB[questID].class == AdventumPlayerClass then
	    stripped[i] = questID
	    i = i+1
--	    tcd("Do accept: " .. questDB[questID].t)
	 else
--	    tcd("For " .. questDB[questID].class .. ", not for ".. AdventumPlayerClass..": " .. questDB[questID].t)
	 end
      end
      if i > 1 then
	 local obj = newAccept(stripped)
	 self.actions[obj.class] = obj
      end
      return self
   end

   local function deliver(self, ...)
      local tbl = {...}
      local stripped = {}
      local i = 1
      for ii, questID in ipairs(tbl) do
	 if questDB[questID].class == nil or questDB[questID].class == AdventumPlayerClass then
	    stripped[i] = questID
	    i = i+1
--	    tcd("Do deliver: " .. questDB[questID].t)
	 else
--	    tcd("Not for this class: " .. questDB[questID].t)
	 end
      end
      if i > 1 then
	 local obj = newDeliver(stripped)
	 self.actions[obj.class] = obj
      end
      return self
   end

   local function complete(self, ...)
      local tbl = {...}
      local stripped = {}
      local i = 1
      for ii, questID in ipairs(tbl) do
	 if questDB[questID].class == nil or questDB[questID].class == AdventumPlayerClass then
	    stripped[i] = questID
	    i = i+1
--	    tcd("Do complete: " .. questDB[questID].t)
	 else
--	    tcd("Not for this class: " .. questDB[questID].t)
	 end
      end
      if i > 1 then
	 local obj = newComplete(stripped)
	 self.actions[obj.class] = obj
      end
      return self
   end

   local function other(self, ...)
      local obj = newOther(...)
      self.actions[obj.class] = obj
      return self
   end

   local function ding(self, level)
      local obj = newDing(level)
      self.actions[obj.class] = obj
      return self
   end

   local function loot(self, tbl)
      local stripped = {}
      local y = false
      for questID, t in pairs(tbl) do
	 if questDB[questID].class == nil or questDB[questID].class == AdventumPlayerClass then
	    stripped[questID] = t
	    y = true
	 end
      end
      if y then
	 local obj = newLoot(tbl)
	 self.actions[obj.class] = obj
      end
      return self
   end

   local function get(self, class)
      return self.actions[class]
   end

   function AdventumClassesReport(node)
      currentLine = 1
      local result = true
      for actionName, obj in pairs(node.actions) do
	 local res

	 if obj.class == "Accept" then
	    res = acceptReport(obj)
	 elseif obj.class == "Deliver" then
	    res = deliverReport(obj)
	 elseif obj.class == "Complete" then
	    res = completeReport(obj)
	 elseif obj.class == "Loot" then
	    res = lootReport(obj)
	 elseif obj.class == "Ding" then
	    res = dingReport(obj)
	 elseif obj.class == "Other" then
	    res = otherReport(obj)
	 end

	 if res == nil or not res then
	    result = false
	 end
      end

      return result

   end

   function AdventumClassesNewNode(name, previous)
      if previous then
	 tcd("creating new node "..name.." with ".. previous.name .. " as previous")
      else
	 tcd("creating new node ".. name)
      end
      local obj = { prv = "", nxt = "",  name = name, actions = {}, 
		    accept = accept,
		    deliver = deliver,
		    complete = complete,
		    other = other, 
		    ding = ding, 
		    loot = loot,
		    get = get }
      if previous then 
	 obj.prv = previous.name
	 previous.nxt = name
      end
      setmetatable(obj, mt)
      return obj
   end


end

