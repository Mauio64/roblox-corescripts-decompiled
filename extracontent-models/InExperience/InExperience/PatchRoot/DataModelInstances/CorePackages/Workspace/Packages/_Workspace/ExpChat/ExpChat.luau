local scriptParent = script.Parent
local ActionBindableEvent = require(scriptParent.ExpChatShared).ActionBindableEvent
local useExpChatMessagesReducerSlice = require(script.useExpChatMessagesReducerSlice)

return {
	Events = require(script.Events),
	mountClientApp = require(script.mountClientApp),
	listenToDispatch = require(script.listenToDispatch)(ActionBindableEvent),
	GlobalFlags = require(script.GlobalFlags),
	getExperienceChatVisualConfig = require(script.getExperienceChatVisualConfig),
	Stores = require(script.Stores),
	Hooks = {
		useExpChatMessagesReducerSlice = useExpChatMessagesReducerSlice
	},
	isUserChatEnabled = require(script.isUserChatEnabled),
	shouldSuppressUnreadForTabMetadata = require(script.shouldSuppressUnreadForTabMetadata),
	ExpChatPerfTracker = require(scriptParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker,
	["jest.config"] = script["jest.config"],
	["jest.bench.config"] = script["jest.bench.config"],
	["mockDataModel-jest.config"] = script["mockDataModel-jest.config"]
}
