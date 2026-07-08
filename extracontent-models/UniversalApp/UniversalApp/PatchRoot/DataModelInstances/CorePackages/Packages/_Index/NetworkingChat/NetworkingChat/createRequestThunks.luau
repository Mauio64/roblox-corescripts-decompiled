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

return function(p1) -- line: 26
	-- upvalues: createAddToConversation (copy), createRemoveFromConversation (copy), createRenameGroupConversation (copy), createStartGroupConversation (copy), createStartOneToOneConversation (copy), createSetConversationUniverse (copy), createResetConversationUniverse (copy), createSendMessage (copy), createSendGameLinkMessage (copy), createUpdateUserTypingStatus (copy), createMarkAsRead (copy), createMarkAsSeen (copy), createGetMessages (copy), createGetUserConversations (copy), createGetConversations (copy), createGetLatestMessages (copy), createGetUnreadConversationCount (copy), createGetUnreadMessages (copy), createGetChatSettings (copy), createGetRolloutSettings (copy), createGetMetadata (copy)
	return {
		AddToConversation = createAddToConversation(p1),
		RemoveFromConversation = createRemoveFromConversation(p1),
		RenameGroupConversation = createRenameGroupConversation(p1),
		StartGroupConversation = createStartGroupConversation(p1),
		StartOneToOneConversation = createStartOneToOneConversation(p1),
		SetConversationUniverse = createSetConversationUniverse(p1),
		ResetConversationUniverse = createResetConversationUniverse(p1),
		SendMessage = createSendMessage(p1),
		SendGameLinkMessage = createSendGameLinkMessage(p1),
		UpdateUserTypingStatus = createUpdateUserTypingStatus(p1),
		MarkAsRead = createMarkAsRead(p1),
		MarkAsSeen = createMarkAsSeen(p1),
		GetMessages = createGetMessages(p1),
		GetUserConversations = createGetUserConversations(p1),
		GetConversations = createGetConversations(p1),
		GetLatestMessages = createGetLatestMessages(p1),
		GetUnreadConversationCount = createGetUnreadConversationCount(p1),
		GetUnreadMessages = createGetUnreadMessages(p1),
		GetChatSettings = createGetChatSettings(p1),
		GetRolloutSettings = createGetRolloutSettings(p1),
		GetMetadata = createGetMetadata(p1)
	}
end
