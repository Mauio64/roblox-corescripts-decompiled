local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Messages = script.Parent.Messages
local getOlderMessages = require(Messages.NetworkRequests.getOlderMessages)
local markConversationAsRead = require(Messages.NetworkRequests.markConversationAsRead)
local sendTextMessage = require(Messages.Thunks.sendTextMessage)
local getRemainingOlderMessages = require(Messages.Thunks.getRemainingOlderMessages)
local updateTypingStatus = require(Messages.NetworkRequests.updateTypingStatus)
local createFriendConversation = require(AppChat.Conversations.Thunks.createFriendConversation)
local SendGameLinkMessage = require(AppChat.Conversations.Thunks.SendGameLinkMessage)
local Logger = require(AppChat.Logger)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

return function(p1) -- line: 17
	-- upvalues: getOlderMessages (copy), getRemainingOlderMessages (copy), sendTextMessage (copy), SendGameLinkMessage (copy), createFriendConversation (copy), markConversationAsRead (copy), updateTypingStatus (copy), AppChatNetworking (copy), Logger (copy)
	local function v14(p2, p3, p4, _) -- line: 18
		-- upvalues: p1 (copy), getOlderMessages (copy)
		return p1(getOlderMessages(p2, p3, p4))
	end

	return {
		getOlderMessages = function(p6, _) -- line: 23
			-- upvalues: p1 (copy), getRemainingOlderMessages (copy), v14 (copy)
			return p1(getRemainingOlderMessages(v14, p6))
		end,
		sendMessage = function(p8, p9, p10) -- line: 26
			-- upvalues: p1 (copy), sendTextMessage (copy)
			return p1(sendTextMessage(p8, p9, p10))
		end,
		sendGameLinkChatMessage = function(p11, p12) -- line: 29
			-- upvalues: p1 (copy), SendGameLinkMessage (copy)
			return p1(SendGameLinkMessage(p11, p12))
		end,
		createFriendConversation = function(p13, p14) -- line: 32
			-- upvalues: p1 (copy), createFriendConversation (copy)
			return p1(createFriendConversation(p13, p14))
		end,
		markConversationAsRead = function(p15) -- line: 35
			-- upvalues: p1 (copy), markConversationAsRead (copy)
			p1(markConversationAsRead(p15))
		end,
		postTypingStatus = function(p16, _) -- line: 38
			-- upvalues: p1 (copy), updateTypingStatus (copy)
			return p1(updateTypingStatus(p16))
		end,
		getUnreadConversationCount = function() -- line: 43
			-- upvalues: p1 (copy), AppChatNetworking (copy), Logger (copy)
			return p1(AppChatNetworking.rodux.GetConversationMetadata.API()):catch(function(p18) -- line: 44
				-- upvalues: Logger (copy)
				Logger:error(`Failure in GetConversationMetadata. Error: { tostring(p18) }`)
			end)
		end
	}
end
