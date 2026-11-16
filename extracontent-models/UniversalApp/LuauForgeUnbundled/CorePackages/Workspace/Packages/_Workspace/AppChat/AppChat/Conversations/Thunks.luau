return {
	createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation"),
	SendPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendPolicies"),
	SendTextMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendTextMessage"),
	SendMessageUsingPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendMessageUsingPolicy"),
	ReceivedChatResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/ReceivedChatResponse"),
	getAllFriendsAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getAllFriendsAsync"),
	getLocalUserFriendsCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getLocalUserFriendsCount"),
	getAllUserPresences = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getAllUserPresences"),
	paginateAndRefreshConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/paginateAndRefreshConversations"),
	DEPRECATED_getLocalUserConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/DEPRECATED_getLocalUserConversations"),
	fetchChatMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchChatMetadata"),
	NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoChat"),
	NavigateIntoSquadLobby = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoSquadLobby"),
	NavigateIntoSquadLobbyIfExists = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/NavigateIntoSquadLobbyIfExists")
}
