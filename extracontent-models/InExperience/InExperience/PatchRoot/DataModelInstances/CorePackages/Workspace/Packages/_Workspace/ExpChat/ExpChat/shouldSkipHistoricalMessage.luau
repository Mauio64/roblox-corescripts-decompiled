local ExpChat = script:FindFirstAncestor("ExpChat")
local FFlagExpChatIgnoreHistoricalMessages = require(ExpChat.Flags.FFlagExpChatIgnoreHistoricalMessages)

return function(p)
	return FFlagExpChatIgnoreHistoricalMessages and p.IsHistorical == true
end
