function ToChatToDo(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg, 1.0, 0, 0)
  end
  
  function ToChatDone(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg, 0, 1.0, 0)
  end
  
  function ToChatInfo(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end
  
  function ToChatDebug(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg)
  end
  
  local FirstNode_Belf_1_to_7 = "AcceptKillManaWyrms"
  local NodeTasks_Belf_1_to_7 = {
    ["AcceptKillManaWyrms"] = {["Accept"] = { 8325 }, ["P"] = "", ["N"] = "CompleteManaWyrms"},
    ["CompleteManaWyrms"] = { ["Complete"] = { 8325 }, ["P"] = "AcceptKillManaWyrms", ["N"] = "DeliverManaWyrms" },
    ["DeliverManaWyrms"] = { ["Deliver"] = { 8325 }, ["P"] = "CompleteManaWyrms", ["N"] = "AcceptLynxCollars" },
    ["AcceptLynxCollars"] = { ["Accept"] = { 8326 }, ["P"] = "DeliverManaWyrms", ["N"] = "CompleteLynxCollars" },
    ["CompleteLynxCollars"] = { ["Complete"] = { 8326 }, ["P"] = "AcceptLynxCollars", ["N"] = "DeliverLynxCollars" },
    ["DeliverLynxCollars"] = { ["Deliver"] = { 8326 }, ["P"] = "CompleteLynxCollars", ["N"] = "AcceptBigRound" },
    ["AcceptBigRound"] = { ["Accept"] = { 8327, 37440, 37443, 37442, 37439 }, ["Other"] = "Sell", ["P"] = "DeliverLynxCollars", ["N"] = "SolaniansJournal" }, -- 37440=8336, 37443=8330, 37442=8345, 37439=8346
    ["SolaniansJournal"] = { ["PickUp"] = { [37443] = { "Solanian's Journal" } }, ["P"] = "AcceptBigRound", ["N"] = "GoToLanthan" },
    ["GoToLanthan"] = { ["Deliver"] = { 8327 }, ["Other"] = "Kill on the way", ["P"] = "SolaniansJournal", ["N"] = "AcceptAggression" },
    ["AcceptAggression"] = { ["Accept"] = { 8334 }, ["P"] = "GoToLanthan", ["N"] = "KillAllAndSolaniansOtherTwo" },
    ["KillAllAndSolaniansOtherTwo"] = { ["Complete"] = { 8334, 37440, 37443, 37439 }, ["P"] = "AcceptAggression", ["N"] = "Shrine" },
    ["Shrine"] = { ["Complete"] = { 37442 }, ["P"] = "KillAllAndSolaniansOtherTwo", ["N"] = "TurninMost" }, -- 37442 = 8345
    ["TurninMost"] = { ["Deliver"] = { 8334, 37440, 37443, 37439, 37442 }, [ "Other" ] = "Sell", ["P"] = "Shrine", ["N"] = "TurninAggression" },
    ["TurninAggression"] = { ["Deliver"] = { 8334 }, ["P"] = "TurninMost", ["N"] = "AcceptFelendren" },
    ["AcceptFelendren" ] = { ["Accept"] = { 8335 }, ["P"] = "TurninAggression", ["N"] = "CompleteFelendrenAndPickUpTainted" },
    ["CompleteFelendrenAndPickUpTainted"] = { ["Accept"] = { 8338 }, ["Complete"]= { 8335 }, ["P"] = "AcceptFelendren", ["N"] = "HearthOrGoTo" },
    ["HearthOrGoTo"] = { ["Hearth"] = { ["Zones"] = { "Sunstrider Isle" }, ["Reason"] = { 8338, 8335 } }, ["P"] = "CompleteFelendrenAndPickUpTainted", ["N"] = "TurnInFelendren" },
    ["TurnInFelendren"] = { ["Other"] = "Sell", ["Deliver"] = { 8335, 8338 }, ["P"] = "HearthOrGoTo", ["N"] = "AcceptAidingTheOutrunners" },
    ["AcceptAidingTheOutrunners"] = { ["Accept"] = { 8347 }, ["P"] = "TurnInFelendren", ["N"] = "DeliverAidingTheOutrunners" },
    ["DeliverAidingTheOutrunners"] = { ["Deliver"] = { 8347 }, ["P"] = "AcceptAidingTheOutrunners", ["N"] = "AcceptPickUpFromCorpse" },
    ["AcceptPickUpFromCorpse"] = { ["Accept"] = { 9704 }, ["P"] = "DeliverAidingTheOutrunners", ["N"] = "DeliverPickUpFromCorpse" },
    ["DeliverPickUpFromCorpse"] = { ["Deliver"] = { 9704 }, ["P"] = "AcceptPickUpFromCorpse", ["N"] = "AcceptPickUpFromCorpseReturn" },
    ["AcceptPickUpFromCorpseReturn"] = { ["Accept"] = { 9705 }, ["P"] = "DeliverPickUpFromCorpse", ["N"] = "DeliverPickUpFromCorpseReturn" },
    ["DeliverPickUpFromCorpseReturn"] = { ["Deliver"] = { 9705 }, ["P"] = "AcceptPickUpFromCorpseReturn", ["N"] = "AcceptInnQuest" },
    ["AcceptInnQuest"] = { ["Accept"] = { 8350 }, ["P"] = "TurnInFelendren", ["N"] = "DeliverInnQuest" },
    ["DeliverInnQuest"] = { ["Deliver"] = { 8350 }, ["P"] = "AcceptInnQuest", ["N"] = "AcceptFirstQuestsInFalconwingSquare" },
    ["AcceptFirstQuestsInFalconwingSquare"] = { ["HS"] = "Falconwing Inn", ["Accept"] = {8472, 8468, 8463}, ["Other"] = "Sell and train profession if wanted", ["P"] = "DeliverInnQuest", ["N"] = "CompleteFirstQuestsFromFalconwingSquare" },
    ["CompleteFirstQuestsFromFalconwingSquare"] = { ["Complete"] = {8472, 8468, 8463}, ["P"] = "AcceptFirstQuestsInFalconwingSquare", ["N"] = "DeliverFirstQuestsInFalconwingSquare"  },
    ["DeliverFirstQuestsInFalconwingSquare"] = { ["Deliver"] = {8472, 8468, 8463}, ["Accept"] = {9352, 8895}, ["P"] = "CompleteFirstQuestsFromFalconwingSquare", ["N"] = "DeliverNorthSanctum"  },
    ["DeliverNorthSanctum"] = { ["Deliver"] = {8895}, ["Accept"] = {9119}, ["P"] = "DeliverFirstQuestsInFalconwingSquare", ["N"] = ""  }
  }
  
  local FirstNode_Undead_1_to_6 = "AcceptFirst"
  local NodeTasks_Undead_1_to_6 = {
    ["AcceptFirst"] = {["Accept"] = { 8325 }, ["P"] = "", ["N"] = "DeliverFirst"},
    ["DeliverFirst"] = { ["Complete"] = { 8325 }, ["P"] = "AcceptFirst", ["N"] = "" },
  }
  
  local FirstNode = FirstNode_Undead_1_to_6
  local NodeTasks = NodeTasks_Undead_1_to_6
  local HardcodedQuestNames = {
    [8338] = "Tainted Arcane Sliver"
  }
  function Adventum_OnLoad()
    ToChatDebug("Adventum loaded")
  end
  function Adventum_OnEvent()
    ToChatDebug("Adventum on event")
  end
  
  SLASH_TEST1 = "/adventum"
  SLASH_TEST2 = "/avt"
  SlashCmdList["TEST"] = function(msg)
     ToChatDebug("Adventum help TODO")
  end 
  
  local AddonLoaded = CreateFrame("Frame")
  AddonLoaded:RegisterEvent("ADDON_LOADED")
  AddonLoaded:SetScript("OnEvent",
    function(self, event, arg1)
      if arg1 == "Adventum" then
        ToChatDebug("ADDON_LOADED fired, must be before QUEST_LOG_UPDATE")
        if AdventumNode == nil or AdventumNode == "" then
          AdventumNode = FirstNode
        end
      end
    end
  )
  local LootEvent = CreateFrame("Frame")
  local ZoneChangedEvent = CreateFrame("Frame")
  local QuestTurnedInEventFrame = CreateFrame("Frame")
  local QuestAcceptedEventFrame = CreateFrame("Frame")
  local QuestWatchUpdateEventFrame = CreateFrame("Frame")
  
  local QuestTitleFromID
  local CurrentQuestLog = {}
  
  
  function QueryQuestTitleFromID() 
    local MyScanningTooltip = CreateFrame("GameTooltip", "MyScanningTooltip", UIParent, "GameTooltipTemplate")
    QuestTitleFromID = setmetatable({}, { __index = function(t, id)
      MyScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
      MyScanningTooltip:SetHyperlink("quest:"..id)
      local title = MyScanningTooltipTextLeft1:GetText()
      MyScanningTooltip:Hide()
      if title and title ~= RETRIEVING_DATA then
        t[id] = title
        return title
      end
    end })
  end
  
  function GetQuestTitleFromID(questID)
    local title = QuestTitleFromID[questID]
    if title == nil then 
      QueryQuestTitleFromID() 
      title = QuestTitleFromID[questID]
    end
    if title == nil then title = HardcodedQuestNames[questID] end
    if title == nil then title = "Quest ID " .. questID end
    return title
  end
  
  function ProcessHS(hs)
    local res = true
    if hs == GetBindLocation() then
      ToChatDone("Bound HS to "..hs)
    else
      ToChatToDo("Bind HS to "..hs)
      res = false
    end
    return res
  end
  
  function ProcessAccept(accept)
    local res = true
    for i,v in ipairs(accept) do
      if CurrentQuestLog[v] ~= nil then
        ToChatDone("Got [".. GetQuestTitleFromID(v) .."]")
      elseif IsQuestFlaggedCompleted(v) then
        ToChatDone("Did [".. GetQuestTitleFromID(v) .."]")
      else
        ToChatToDo("Get [".. GetQuestTitleFromID(v) .."]")
        res = false
      end
    end
    return res
  end
  
  function ProcessDo(doit)
    for i,v in ipairs(doit) do
      local q = CurrentQuestLog[v]
      if q ~= nil then
        if q ~= 1 then 
          ToChatInfo("Do what you can from [".. GetQuestTitleFromID(v) .."]")
        end
      end
    end
  end
  
  function ProcessComplete(complete)
    local res = true
    for i,v in ipairs(complete) do
      local q = CurrentQuestLog[v]
      if q ~= nil then
        if q == 1 then 
          ToChatDone("Completed [".. GetQuestTitleFromID(v) .."]")
        else
          res = false
          ToChatToDo("Complete  [".. GetQuestTitleFromID(v) .."]")
        end
      else
        if IsQuestFlaggedCompleted(v) then
          ToChatDone("You already delivered [".. GetQuestTitleFromID(v) .."]")
        else
          -- we assume not picking up a quest is on purpose, so we should move on without completing it, we just inform a bit
          ToChatInfo("You never picked up [".. GetQuestTitleFromID(v) .."]")
        end
      end
    end
    return res
  end
    
  function ProcessDeliver(deliver)
    local res = true
    for i,v in ipairs(deliver) do
      local q = CurrentQuestLog[v]
      if q ~= nil then
        ToChatToDo("Deliver  [".. GetQuestTitleFromID(v) .."]")
        res = false
      end
    end
    return res
  end
  
  function QuestProgressIndicatesItemNeeded(item, questID) 
    local logIndex = GetQuestLogIndexByID(questID)
    local size = GetNumQuestLeaderBoards(logIndex)
    for oI=1, size, 1 do
      local description, objectiveType, isCompleted = GetQuestLogLeaderBoard(oI, logIndex)
  --    local itemName, numItems, numNeeded = description:match("(.*):%s*([%d]+)%s*/%s*([%d]+)")
      local numItems, numNeeded, itemName = description:match("%s*([%d]+)%s*/%s*([%d]+)%s(.*)")
      if itemName == item then
        ToChatDebug("looking for " .. itemName .. " " .. numItems .. "/" .. numNeeded)
        if isCompleted then 
          ToChatDebug("is done ")
          return false
        else
          ToChatDebug("isn't done ")
          return true
        end
      end
    end
  end
  
  
  local debugJournalSeenOnce = false
  function IsInBag(item, questID)
    return not QuestProgressIndicatesItemNeeded(item, questID)
  end
  
  local currentPickUps
  function BuildCurrentPickUps(pickup) 
    ToChatDebug("BuildCurrentPickUps ran")
    local cur = {}
    local count = 0
    for questID, items in pairs(pickup) do
      if CurrentQuestLog[questID] ~= nil then
        for i, item in ipairs(items) do
          -- TODO: check if quest log indicates user has the item
          if QuestProgressIndicatesItemNeeded(item, questID) then
            cur[item] = questID
            count = count + 1
          end
        end
      end
    end
    if count > 0 then 
      currentPickUps = cur
      LootEvent:RegisterEvent("CHAT_MSG_LOOT")
      for i, qID in pairs(currentPickUps) do
        ToChatDebug("pick up item "..i.." for quest "..qID)
      end
    end
  end
  
  function ProcessPickUp(pickup)
    if currentPickUps == nil then return true end
    local res = true
    for item, questID in pairs(currentPickUps) do
      if CurrentQuestLog[questID] ~= nil then
        if not IsInBag(item, questID) then
          ToChatToDo("Pick up   [".. item .."]")
          res = false
        end
      else
        currentPickups[item] = nil
      end
    end
    if res then 
      ToChatDebug("Unregistering and setting currentPickUps to nil")
      currentPickUps = nil
      LootEvent:UnregisterEvent("CHAT_MSG_LOOT")
    end
    return res
  end
  
  function GetCurrentZone()
    local cur = GetSubZoneText()
    if (cur == nil or cur == '') then 
      cur = GetZoneText()
    end
    return cur
  end
  
  local isHearthRegistered = false
  
  function ProcessHearth(hearth) 
    local reason = hearth["Reason"]
    local reasonOld = true
    for i, questID in ipairs(reason) do 
      if CurrentQuestLog[questID] ~= nil then
        reasonOld = false
      end
    end
    if reasonOld then
      return true
    end
    
    if not isHearthRegistered then
      isHearthRegistered = true
      ZoneChangedEvent:RegisterEvent("ZONE_CHANGED")
      ZoneChangedEvent:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    end
    local currentZone = GetCurrentZone()
    local dazones = ""
    local zones = hearth["Zones"]
    for i, zone in ipairs(zones) do
      dazones = "'".. zone .. "' "
      if zone == currentZone then
        ZoneChangedEvent:UnregisterEvent("ZONE_CHANGED")
        ZoneChangedEvent:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
        isHearthRegistered = false
        return true
      end
    end
    ToChatToDo("Hearth or go to " .. dazones)
    return false
  end
  
  function ProcessOther(other)
    ToChatInfo(other)
  end
  
  function ReportWhatToDo() 
    local cur
    ToChatDebug("at node " .. AdventumNode)
    
    local continue_1_to_7
    local node = NodeTasks[AdventumNode]
  
    local hs = node["HS"]
    if hs ~= nil then
      ToChatDebug(AdventumNode .. " has HS = " .. hs)
      if not ProcessHS(hs) then continue = false end
    end
    local accept = node["Accept"]
    if accept ~= nil then
      ToChatDebug(AdventumNode .. " has Accept")
      if not ProcessAccept(accept) then continue = false end
    end
    local doit = node["Do"]
    if doit ~= nil then
      ToChatDebug(AdventumNode .. " has Do")
      ProcessDo(doit)
    end
    local pickup = node["PickUp"]
    if pickup ~= nil then
      ToChatDebug(AdventumNode .. " has PickUp")
      if currentPickUps == nil then
        BuildCurrentPickUps(pickup)
      end
      if not ProcessPickUp(pickup) then continue = false end
    end
    local complete = node["Complete"]
    if complete ~= nil then
      ToChatDebug(AdventumNode .. " has Complete")
      if not ProcessComplete(complete) then continue = false end
    end
    local deliver = node["Deliver"]
    if deliver ~= nil then
      ToChatDebug(AdventumNode .. " has Deliver")
      if not ProcessDeliver(deliver) then continue = false end
    end
    local other = node["Other"]
    if other ~= nil then
      ToChatDebug(AdventumNode .. " has Other")
      ProcessOther(other)
    end
    local hearth = node["Hearth"]
    if hearth ~= nil then
      ToChatDebug(AdventumNode .. " has Hearth")
      if not ProcessHearth(hearth) then continue = false end
    end
    if continue then
      ToChatDebug("done with node " .. AdventumNode)
      AdventumNode = node["N"]
      if AdventumNode == "" then 
        ToChatInfo("end of node trail, if not yet max level, check if there are more guides")
        QuestWatchUpdateEventFrame:UnregisterEvent("QUEST_WATCH_UPDATE")
        QuestAcceptedEventFrame:UnegisterEvent("QUEST_ACCEPTED")
        QuestTurnedInEventFrame:UnegisterEvent("QUEST_TURNED_IN")
      else
        ToChatInfo("moving to node " .. AdventumNode)
        ReportWhatToDo()
      end
    else
      ToChatDebug("not done with ".. AdventumNode)
    end
  end
  
  -- this event is fired upon login,
  -- some time after the quest log has been filled in, allowing us
  -- to fill in our quest titles
  -- it fires a lot after that, too, so we stop subscribing to it
  local InitQuestLogUpdateEvent = CreateFrame("Frame")
  InitQuestLogUpdateEvent:RegisterEvent("QUEST_LOG_UPDATE")
  InitQuestLogUpdateEvent:SetScript("OnEvent",
    function(self, event)
      InitQuestLogUpdateEvent:UnregisterEvent("QUEST_LOG_UPDATE")
      ToChatDebug("QUEST_LOG_UPDATE fired, must be after ADDON_LOADED")
      if AdventumNode == nil then
        AdventumNode = FirstNode
      end
      QueryQuestTitleFromID()
      local i = 1
      while GetQuestLogTitle(i) do
        local titleFromQuestLog, a, b, isHeader, c, isComplete, e, questID = GetQuestLogTitle(i)
        if ( not isHeader ) then
          if isComplete == nil then isComplete = 0 end
          CurrentQuestLog[questID] = isComplete
          DEFAULT_CHAT_FRAME:AddMessage(titleFromQuestLog .. " (" .. questID .. ") " .. GetQuestTitleFromID(questID))
        end --if
        i = i + 1
      end --while
      ReportWhatToDo()
      end --function
  )
  
  --local ZoneEvent = CreateFrame("Frame")
  --ZoneEvent:RegisterEvent("MINIMAP_ZONE_CHANGED")
  --ZoneEvent:SetScript("OnEvent",
  --  function(self, event)
  --    local currentZone = GetMinimapZoneText()
  --    print("Current zone is "..currentZone)
  --  end
  --)
  
  
  --LootEvent:RegisterEvent("CHAT_MSG_LOOT")
  LootEvent:SetScript("OnEvent",
    function(self, event, msg)
      ToChatDebug("This happened")
      local m = (string.match(msg, "%[(.-)%]"))
      ToChatDebug("Received "..m)
      for item, questID in pairs(currentPickUps) do
        ToChatDebug("inside for loop for "..item)
        if item == m then
          ToChatDebug("Found for quest"..item)
          currentPickUps[item] = nil
          break
        end
      end
      ReportWhatToDo()
    end
  )
   
  ZoneChangedEvent:SetScript("OnEvent",
    function(self, event)
      ReportWhatToDo()
    end
  )
  
  --[[
  local PlayerEnteringWorldEvent = CreateFrame("Frame")
  PlayerEnteringWorldEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
  PlayerEnteringWorldEvent:SetScript("OnEvent",
    function(self, event)
      ToChatDebug("player entering world")
    end
  )
  ]]
  
  QuestTurnedInEventFrame:RegisterEvent("QUEST_TURNED_IN")
  QuestTurnedInEventFrame:SetScript("OnEvent",
    function(self, event, questID, xpReward, moneyReward)
      local title = GetQuestTitleFromID(questID)
      ToChatDebug('Saw quest turned in: '..questID..' title: '..title)
      CurrentQuestLog[questID] = nil
      ReportWhatToDo()
    end
  )
  
  QuestAcceptedEventFrame:RegisterEvent("QUEST_ACCEPTED")
  QuestAcceptedEventFrame:SetScript("OnEvent",
    function(self, event, logIndex, questID)
      local titleFromQuestLog, a, b, isHeader, c, isComplete, e, questID = GetQuestLogTitle(logIndex)
      local title = GetQuestTitleFromID(questID)
      ToChatDebug('Accepted ('..questID..')  '..title)
      if isComplete == nil then isComplete = 0 end
      CurrentQuestLog[questID] = isComplete
      ReportWhatToDo()
    end
  )
  
  local completeCheckLogIndex
  
  local QuestLogUpdateEvent = CreateFrame("Frame")
  QuestLogUpdateEvent:SetScript("OnEvent",
    function(self, event)
      QuestLogUpdateEvent:UnregisterEvent("QUEST_LOG_UPDATE")
      local titleFromQuestLog, a, b, isHeader, c, isComplete, e, questID = GetQuestLogTitle(completeCheckLogIndex)
      if isComplete then 
        completeCheckLogIndex = nil
        ToChatDebug("logupdate -- Done with " .. titleFromQuestLog)
        CurrentQuestLog[questID] = 1
        ReportWhatToDo()
      else
        ToChatDebug("Not done with " .. titleFromQuestLog)
      end
    end --function
  )
  
  QuestWatchUpdateEventFrame:RegisterEvent("QUEST_WATCH_UPDATE")
  QuestWatchUpdateEventFrame:SetScript("OnEvent",
    function(self, event, logIndex)
      local titleFromQuestLog, a, b, isHeader, c, isComplete, e, questID = GetQuestLogTitle(logIndex)
      if isComplete then
        ToChatDebug("watch -- Done with " .. titleFromQuestLog)
        CurrentQuestLog[questID] = 1
        ReportWhatToDo()
      else
        completeCheckLogIndex = logIndex
        ToChatDebug("Update on [".. titleFromQuestLog.. "], waiting to test for completion")
        QuestLogUpdateEvent:RegisterEvent("QUEST_LOG_UPDATE")
        end
    end
  )
  
d  