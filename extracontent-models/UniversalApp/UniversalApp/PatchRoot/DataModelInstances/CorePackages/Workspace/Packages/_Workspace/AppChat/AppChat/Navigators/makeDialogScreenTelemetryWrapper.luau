local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
local React = require(AppChatParent.React)

return function(p1) -- line: 10
	-- upvalues: React (copy), ChatDialogTelemetryLayer (copy)
	return function(t1: {[any]: any}) -- line: 11
		-- upvalues: React (copy), ChatDialogTelemetryLayer (copy), p1 (copy)
		local v7 = if not t1.navigation then nil else t1.navigation.getParam("conversationId")
		local v8 = React.useMemo(function() -- line: 14
			-- upvalues: v7 (copy)
			return {
				conversationId = v7
			}
		end, { v7 })

		return React.createElement(ChatDialogTelemetryLayer.Provider, {
			value = v8
		}, React.createElement(p1, t1))
	end
end
