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
AdventumName = nil

BINDING_HEADER_ADVENTUM = "Adventum"

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start)) == Start
end

function string.ends(String,Ends)
   return string.sub(String,string.len(String) - string.len(Ends) + 1) == Ends
end

function AdventumForEachLogQuest(f)
   local logIndex = 1
   local titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)     
   while titleFromQuestLog do
      if not isHeader then
	 f(titleFromQuestLog, level, isComplete, questID, logIndex)
      end
      logIndex = logIndex + 1
      titleFromQuestLog, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(logIndex)     
   end
   
end
