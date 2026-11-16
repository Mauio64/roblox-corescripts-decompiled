local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Rodux = require(parent.Rodux)

local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)
local FFlagAppChatRemoveAliasesSlice = require(AppChat.Flags.FFlagAppChatRemoveAliasesSlice)
local FFlagAppChatRemovePlaceInfosAsync = require(AppChat.Flags.FFlagAppChatRemovePlaceInfosAsync)
local FFlagAppChatUseDataHydrationForChatTimeouts = require(AppChat.Flags.FFlagAppChatUseDataHydrationForChatTimeouts)
local FFlagAppChatUseDataHydrationForPlaceInfos = require(AppChat.Flags.FFlagAppChatUseDataHydrationForPlaceInfos)
local FFlagAppChatUseSignalsForAppLoaded = require(AppChat.Flags.FFlagAppChatUseSignalsForAppLoaded)
local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

local FFlagAppChatUseSignalsForExternalNavigationRequest = require(AppChat.Flags.FFlagAppChatUseSignalsForExternalNavigationRequest)
local FFlagAppChatUseSignalsForLastEntryPoint = require(AppChat.Flags.FFlagAppChatUseSignalsForLastEntryPoint)

return function()
	local combineReducers = Rodux.combineReducers
	local placeInfosReducer

	if not FFlagAppChatUseDataHydrationForPlaceInfos then
		local PlaceInfoRodux = require(parent.PlaceInfoRodux)
		placeInfosReducer = PlaceInfoRodux.Reducers.PlaceInfosReducer
	end

	local placeInfosAsyncReducer

	if not FFlagAppChatRemovePlaceInfosAsync then
		local PlaceInfoRodux = require(parent.PlaceInfoRodux)
		placeInfosAsyncReducer = PlaceInfoRodux.Reducers.PlaceInfosAsyncReducer
	end

	local aliases

	if not FFlagAppChatRemoveAliasesSlice then
		aliases = require(script.Aliases)
	end

	local appLoaded

	if not FFlagAppChatUseSignalsForAppLoaded then
		appLoaded = require(AppChat.installReducer.AppLoaded)
	end

	local chatSettings

	if not FFlagAppChatUseSignalsForChatSettings then
		chatSettings = require(AppChat.installReducer.ChatSettings)
	end

	local chatTimeouts

	if not FFlagAppChatUseDataHydrationForChatTimeouts then
		chatTimeouts = require(AppChat.installReducer.ChatTimeouts)
	end

	local v = {
		PlaceInfos = placeInfosReducer,
		PlaceInfosAsync = placeInfosAsyncReducer,
		Aliases = aliases,
		AppLoaded = appLoaded,
		ChatSettings = chatSettings,
		ChatTimeouts = chatTimeouts,
		Conversations = require(AppChat.installReducer.Conversations),
		ConversationsAsync = require(AppChat.installReducer.ConversationsAsync),
		Friends = require(script.Friends),
		ExternalNavigationRequest = 0,
		LastEntryPoint = 0,
		Modals = 0,
		ParticipantMetadata = 0,
		Presence = 0,
		networkStatus = 0
	}
	local externalNavigationRequest

	if not FFlagAppChatUseSignalsForExternalNavigationRequest then
		externalNavigationRequest = require(AppChat.installReducer.ExternalNavigationRequest)
	end

	v.ExternalNavigationRequest = externalNavigationRequest
	local lastEntryPoint

	if not FFlagAppChatUseSignalsForLastEntryPoint then
		lastEntryPoint = require(script.LastEntryPoint)
	end

	v.LastEntryPoint = lastEntryPoint
	v.Modals = require(script.Modals)
	v.ParticipantMetadata = require(script.ParticipantMetadata)
	local presence

	if not FFlagAppChatPresenceStoreMigration then
		presence = require(script.Presence)
	end

	v.Presence = presence
	local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
	v.networkStatus = RoduxNetworking.installReducer()
	return combineReducers(v)
end
