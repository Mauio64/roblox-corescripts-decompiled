local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
local React = require(parent.React)

return function(p)
	return function(p2)
		local conversationId

		if p2.navigation then
			conversationId = p2.navigation.getParam("conversationId")
		else
			conversationId = nil
		end

		local v = React.useMemo(function()
			return { conversationId = conversationId }
		end, { conversationId })
		return React.createElement(ChatDialogTelemetryLayer.Provider, { value = v }, React.createElement(p, p2))
	end
end
