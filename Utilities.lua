function AdventumToChatGeneral(msg, c) DEFAULT_CHAT_FRAME:AddMessage("tcg: " .. msg, c.r, c.g, c.b) end
function string.starts(String,Start) return string.sub(String,1,string.len(Start)) == Start end
