local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local createReactTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createReactTelemetryLayer")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")

return createReactTelemetryLayer(React.createContext(function()
	return {}
end), {
	context = "platformChat",
	locale = "unknown",
	entryPoint = "unknown",
	userId = "unknown",
	placement = ChatPlacementContext.Enum.Unknown
})
