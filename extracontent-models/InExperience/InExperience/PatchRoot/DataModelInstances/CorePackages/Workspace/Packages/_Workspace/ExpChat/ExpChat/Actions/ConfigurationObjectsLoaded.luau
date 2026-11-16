local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		bubbleChatSettings = data.bubbleChatSettings or {},
		chatWindowSettings = data.chatWindowSettings or {},
		chatInputBarSettings = data.chatInputBarSettings or {},
		channelTabsSettings = data.channelTabsSettings or {}
	}
end)
