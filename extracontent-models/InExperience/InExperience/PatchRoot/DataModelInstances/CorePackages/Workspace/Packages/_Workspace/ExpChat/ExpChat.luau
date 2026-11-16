local parent = script.Parent
local ExpChatShared = require(parent.ExpChatShared)

local ActionBindableEvent = ExpChatShared.ActionBindableEvent
local useExpChatMessagesReducerSlice = require(script.useExpChatMessagesReducerSlice)

local ExpChat = {
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	["Events"] = nil,
	Events = require(script.Events),
	mountClientApp = require(script.mountClientApp)
}
local listenToDispatch = require(script.listenToDispatch)
ExpChat.listenToDispatch = listenToDispatch(ActionBindableEvent)
ExpChat.GlobalFlags = require(script.GlobalFlags)
ExpChat.getExperienceChatVisualConfig = require(script.getExperienceChatVisualConfig)
ExpChat.Stores = require(script.Stores)
ExpChat.Hooks = { useExpChatMessagesReducerSlice = useExpChatMessagesReducerSlice }

ExpChat.isUserChatEnabled = require(script.isUserChatEnabled)
ExpChat.requestSelectTab = require(script.ExternalNavigation.requestSelectTab)
ExpChat.requestSelectFriendsTab = require(script.ExternalNavigation.requestSelectFriendsTab)
ExpChat.isHistoricalMessage = require(script.isHistoricalMessage)
ExpChat.shouldSkipHistoricalMessage = require(script.shouldSkipHistoricalMessage)
ExpChat.shouldSuppressUnreadForTabMetadata = require(script.shouldSuppressUnreadForTabMetadata)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
ExpChat.ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
ExpChat["jest.config"] = script["jest.config"]
ExpChat["jest.bench.config"] = script["jest.bench.config"]
ExpChat["mockDataModel-jest.config"] = script["mockDataModel-jest.config"]
return ExpChat
