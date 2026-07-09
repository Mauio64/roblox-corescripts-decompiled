local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Telemetry = AppChat.Telemetry
local createReactTelemetryLayer = require(Telemetry.createReactTelemetryLayer)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

return createReactTelemetryLayer(React.createContext(function() -- line: 21
	return {}
end), {
	context = "platformChat",
	locale = "unknown",
	entryPoint = "unknown",
	userId = "unknown",
	placement = ChatPlacementContext.Enum.Unknown
})
