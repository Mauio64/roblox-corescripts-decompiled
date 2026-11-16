local AppChat = script:FindFirstAncestor("AppChat")

local Messages = script.Parent.Messages
local getOlderMessages = require(Messages.NetworkRequests.getOlderMessages)
local markConversationAsRead = require(Messages.NetworkRequests.markConversationAsRead)
local sendTextMessage = require(Messages.Thunks.sendTextMessage)
local getRemainingOlderMessages = require(Messages.Thunks.getRemainingOlderMessages)
local updateTypingStatus = require(Messages.NetworkRequests.updateTypingStatus)
local createFriendConversation = require(AppChat.Conversations.Thunks.createFriendConversation)
local SendGameLinkMessage = require(AppChat.Conversations.Thunks.SendGameLinkMessage)

return function(callback)
	local function fn(p, p2, p3, _)
		return callback(getOlderMessages(p, p2, p3))
	end

	return {
		getOlderMessages = function(p, _)
			return callback(getRemainingOlderMessages(fn, p))
		end,
		sendMessage = function(p, p2, p3)
			return callback(sendTextMessage(p, p2, p3))
		end,
		sendGameLinkChatMessage = function(p, p2)
			return callback(SendGameLinkMessage(p, p2))
		end,
		createFriendConversation = function(p, p2)
			return callback(createFriendConversation(p, p2))
		end,
		markConversationAsRead = function(p)
			callback(markConversationAsRead(p))
		end,
		postTypingStatus = function(p, _)
			return callback(updateTypingStatus(p))
		end
	}
end
