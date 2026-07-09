local AppChat = script:FindFirstAncestor("AppChat")
local AppChatNetworking = require(AppChat.Parent.AppChatNetworking)
local NetworkingChat = require(AppChat.Http.NetworkingChat)
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

return {
	setup = function() -- line: 10
		-- upvalues: AppChatNetworking (copy), NetworkingChat (copy), NetworkingPresence (copy), NetworkingFriends (copy)
		AppChatNetworking.rodux.GetConversationMetadata.Mock.clear()
		AppChatNetworking.rodux.GetConversationMetadata.Mock.reply(function() -- line: 12
			return {
				responseBody = {
					global_unread_message_count = 0
				}
			}
		end)
		NetworkingChat.GetUnreadConversationCount.Mock.clear()
		NetworkingChat.GetUnreadConversationCount.Mock.reply(function() -- line: 21
			return {
				responseBody = {
					data = {}
				}
			}
		end)
		NetworkingChat.MarkAsRead.Mock.clear()
		NetworkingChat.MarkAsRead.Mock.reply(function() -- line: 26
			return {
				responseBody = {
					data = {}
				}
			}
		end)
		AppChatNetworking.rodux.MarkConversation.Mock.clear()
		AppChatNetworking.rodux.MarkConversation.Mock.reply(function() -- line: 31
			return {
				responseBody = {
					data = {}
				}
			}
		end)
		NetworkingPresence.GetPresencesFromUserIds.Mock.clear()
		NetworkingPresence.GetPresencesFromUserIds.Mock.reply(function() -- line: 36
			return {
				responseBody = {
					userPresences = {}
				}
			}
		end)
		NetworkingFriends.GetFriendsFromUserId.Mock.clear()
		NetworkingFriends.GetFriendsFromUserId.Mock.reply(function() -- line: 41
			return {
				responseBody = {
					data = {}
				}
			}
		end)
		AppChatNetworking.rodux.GetOlderMessages.Mock.clear()
		AppChatNetworking.rodux.GetOlderMessages.Mock.reply(function() -- line: 46
			return {
				responseBody = {}
			}
		end)
		AppChatNetworking.rodux.GetChatModerationStatuses.Mock.clear()
		AppChatNetworking.rodux.GetChatModerationStatuses.Mock.reply(function() -- line: 51
			return {
				responseBody = {}
			}
		end)
		AppChatNetworking.rodux.RecordModalSequenceResponse.Mock.clear()
		AppChatNetworking.rodux.RecordModalSequenceResponse.Mock.reply(function() -- line: 56
			return {
				responseBody = {}
			}
		end)
	end,
	teardown = function() -- line: 61
		-- upvalues: AppChatNetworking (copy), NetworkingChat (copy), NetworkingPresence (copy), NetworkingFriends (copy)
		AppChatNetworking.rodux.GetConversationMetadata.Mock.clear()
		NetworkingChat.GetUnreadConversationCount.Mock.clear()
		NetworkingChat.MarkAsRead.Mock.clear()
		AppChatNetworking.rodux.MarkConversation.Mock.clear()
		NetworkingPresence.GetPresencesFromUserIds.Mock.clear()
		NetworkingFriends.GetFriendsFromUserId.Mock.clear()
		AppChatNetworking.rodux.GetOlderMessages.Mock.clear()
		AppChatNetworking.rodux.GetChatModerationStatuses.Mock.clear()
		AppChatNetworking.rodux.RecordModalSequenceResponse.Mock.clear()
	end
}
