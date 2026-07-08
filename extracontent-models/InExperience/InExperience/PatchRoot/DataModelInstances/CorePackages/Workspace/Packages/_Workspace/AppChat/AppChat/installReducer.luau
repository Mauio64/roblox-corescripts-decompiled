local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Rodux = require(AppChatParent.Rodux)

return function() -- line: 5
	-- upvalues: Rodux (copy), AppChatParent (copy), AppChat (copy)
	return Rodux.combineReducers({
		PlaceInfos = require(AppChatParent.PlaceInfoRodux).Reducers.PlaceInfosReducer,
		PlaceInfosAsync = require(AppChatParent.PlaceInfoRodux).Reducers.PlaceInfosAsyncReducer,
		Aliases = require(script.Aliases),
		AppLoaded = require(AppChat.installReducer.AppLoaded),
		ChatSettings = require(AppChat.installReducer.ChatSettings),
		ChatTimeouts = require(AppChat.installReducer.ChatTimeouts),
		Conversations = require(AppChat.installReducer.Conversations),
		ConversationsAsync = require(AppChat.installReducer.ConversationsAsync),
		Friends = require(script.Friends),
		ExternalNavigationRequest = require(AppChat.installReducer.ExternalNavigationRequest),
		LastEntryPoint = require(script.LastEntryPoint),
		Modals = require(script.Modals),
		ParticipantMetadata = require(script.ParticipantMetadata),
		Presence = require(script.Presence),
		ToggleChatPaused = require(AppChat.installReducer.ToggleChatPaused),
		networkStatus = require(AppChat.Http.RoduxNetworking).installReducer(),
		unreadMessageCount = require(script.UnreadMessageCount)
	})
end
