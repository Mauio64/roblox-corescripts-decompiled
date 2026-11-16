local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local Telemetry = AppChat.Telemetry
local createReactTelemetryLayer = require(Telemetry.createReactTelemetryLayer)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

return createReactTelemetryLayer(React.createContext(function()
	return {}
end), {
	context = "platformChat",
	locale = "unknown",
	entryPoint = "unknown",
	userId = "unknown",
	placement = ChatPlacementContext.Enum.Unknown
})
