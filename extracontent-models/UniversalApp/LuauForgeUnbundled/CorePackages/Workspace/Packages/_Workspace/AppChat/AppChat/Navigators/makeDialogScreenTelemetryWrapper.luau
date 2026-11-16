local ChatDialogTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDialogTelemetryLayer")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

return function(p2)
	return function(p3)
		local v5 = if p3.navigation then p3.navigation.getParam("conversationId") else nil

		local v6 = React.useMemo(function()
			return { conversationId = v5 }
		end, { v5 })
		return React.createElement(ChatDialogTelemetryLayer.Provider, { value = v6 }, React.createElement(p2, p3))
	end
end
