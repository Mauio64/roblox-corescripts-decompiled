local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local FFlagAppChatPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration")
local FFlagAppChatRemoveAliasesSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemoveAliasesSlice")
local FFlagAppChatRemovePlaceInfosAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatRemovePlaceInfosAsync")
local FFlagAppChatUseDataHydrationForChatTimeouts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForChatTimeouts")
local FFlagAppChatUseDataHydrationForPlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForPlaceInfos")
local FFlagAppChatUseSignalsForAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForAppLoaded")
local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

local FFlagAppChatUseSignalsForExternalNavigationRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForExternalNavigationRequest")
local FFlagAppChatUseSignalsForLastEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForLastEntryPoint")

return function()
	local combineReducers = Rodux.combineReducers

	local v6 = if not FFlagAppChatUseDataHydrationForPlaceInfos then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlaceInfoRodux").Reducers.PlaceInfosReducer else nil

	local v7 = if not FFlagAppChatRemovePlaceInfosAsync then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlaceInfoRodux").Reducers.PlaceInfosAsyncReducer else nil

	local v8 = if not FFlagAppChatRemoveAliasesSlice then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/Aliases") else nil
	local v9 = if not FFlagAppChatUseSignalsForAppLoaded then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/AppLoaded") else nil

	local v10 = if not FFlagAppChatUseSignalsForChatSettings then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ChatSettings") else nil

	local v11 = if not FFlagAppChatUseDataHydrationForChatTimeouts then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ChatTimeouts") else nil
	local v5 = {
		PlaceInfos = v6,
		PlaceInfosAsync = v7,
		Aliases = v8,
		AppLoaded = v9,
		ChatSettings = v10,
		ChatTimeouts = v11,
		Conversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/Conversations"),
		ConversationsAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ConversationsAsync"),
		Friends = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/Friends"),
		ExternalNavigationRequest = 0,
		LastEntryPoint = 0,
		Modals = 0,
		ParticipantMetadata = 0,
		Presence = 0,
		networkStatus = 0
	}

	local v12 = if not FFlagAppChatUseSignalsForExternalNavigationRequest then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ExternalNavigationRequest") else nil
	v5.ExternalNavigationRequest = v12

	local v13 = if not FFlagAppChatUseSignalsForLastEntryPoint then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/LastEntryPoint") else nil
	v5.LastEntryPoint = v13
	v5.Modals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/Modals")
	v5.ParticipantMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ParticipantMetadata")
	local v14 = if not FFlagAppChatPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/Presence") else nil
	v5.Presence = v14
	v5.networkStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking").installReducer()
	return combineReducers(v5)
end
