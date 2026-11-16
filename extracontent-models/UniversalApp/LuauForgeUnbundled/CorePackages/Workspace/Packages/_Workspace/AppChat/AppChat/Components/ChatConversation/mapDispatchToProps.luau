local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/NetworkRequests/getOlderMessages")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/NetworkRequests/markConversationAsRead")
local sendTextMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/Thunks/sendTextMessage")
local getRemainingOlderMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/Thunks/getRemainingOlderMessages")
local updateTypingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/NetworkRequests/updateTypingStatus")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createFriendConversation")
local SendGameLinkMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendGameLinkMessage")

return function(callback)
	local function fn(p2, p3, p4, p5)
		return callback(module(p2, p3, p4))
	end

	return {
		getOlderMessages = function(p2, p3)
			return callback(getRemainingOlderMessages(fn, p2))
		end,
		sendMessage = function(p2, p3, p4)
			return callback(sendTextMessage(p2, p3, p4))
		end,
		sendGameLinkChatMessage = function(p2, p3)
			return callback(SendGameLinkMessage(p2, p3))
		end,
		createFriendConversation = function(p2, p3)
			return callback(module6(p2, p3))
		end,
		markConversationAsRead = function(p2)
			callback(module2(p2))
		end,
		postTypingStatus = function(p2, p3)
			return callback(updateTypingStatus(p2))
		end
	}
end
