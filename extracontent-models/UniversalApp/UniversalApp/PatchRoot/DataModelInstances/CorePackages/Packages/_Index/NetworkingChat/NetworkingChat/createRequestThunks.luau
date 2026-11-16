require(script.Parent.networkingChatTypes)
local networkRequests = script.Parent.networkRequests
local createAddToConversation = require(networkRequests.createAddToConversation)
local createRemoveFromConversation = require(networkRequests.createRemoveFromConversation)
local createRenameGroupConversation = require(networkRequests.createRenameGroupConversation)
local createStartGroupConversation = require(networkRequests.createStartGroupConversation)
local createStartOneToOneConversation = require(networkRequests.createStartOneToOneConversation)
local createSetConversationUniverse = require(networkRequests.createSetConversationUniverse)
local createResetConversationUniverse = require(networkRequests.createResetConversationUniverse)
local createSendMessage = require(networkRequests.createSendMessage)
local createSendGameLinkMessage = require(networkRequests.createSendGameLinkMessage)
local createUpdateUserTypingStatus = require(networkRequests.createUpdateUserTypingStatus)
local createMarkAsRead = require(networkRequests.createMarkAsRead)
local createMarkAsSeen = require(networkRequests.createMarkAsSeen)
local createGetMessages = require(networkRequests.createGetMessages)
local createGetUserConversations = require(networkRequests.createGetUserConversations)
local createGetConversations = require(networkRequests.createGetConversations)
local createGetLatestMessages = require(networkRequests.createGetLatestMessages)
local createGetUnreadConversationCount = require(networkRequests.createGetUnreadConversationCount)
local createGetUnreadMessages = require(networkRequests.createGetUnreadMessages)
local createGetChatSettings = require(networkRequests.createGetChatSettings)
local createGetRolloutSettings = require(networkRequests.createGetRolloutSettings)
local createGetMetadata = require(networkRequests.createGetMetadata)

return function(p)
	return {
		AddToConversation = createAddToConversation(p),
		RemoveFromConversation = createRemoveFromConversation(p),
		RenameGroupConversation = createRenameGroupConversation(p),
		StartGroupConversation = createStartGroupConversation(p),
		StartOneToOneConversation = createStartOneToOneConversation(p),
		SetConversationUniverse = createSetConversationUniverse(p),
		ResetConversationUniverse = createResetConversationUniverse(p),
		SendMessage = createSendMessage(p),
		SendGameLinkMessage = createSendGameLinkMessage(p),
		UpdateUserTypingStatus = createUpdateUserTypingStatus(p),
		MarkAsRead = createMarkAsRead(p),
		MarkAsSeen = createMarkAsSeen(p),
		GetMessages = createGetMessages(p),
		GetUserConversations = createGetUserConversations(p),
		GetConversations = createGetConversations(p),
		GetLatestMessages = createGetLatestMessages(p),
		GetUnreadConversationCount = createGetUnreadConversationCount(p),
		GetUnreadMessages = createGetUnreadMessages(p),
		GetChatSettings = createGetChatSettings(p),
		GetRolloutSettings = createGetRolloutSettings(p),
		GetMetadata = createGetMetadata(p)
	}
end
