local AppChatNetworking = script:FindFirstAncestor("AppChatNetworking")
local parent = AppChatNetworking.Parent
local CHAT_PLATFORM_BASE_URL = require(AppChatNetworking.url.CHAT_PLATFORM_BASE_URL)

local RoduxNetworking = require(script.Parent.RoduxNetworking)
local Constants = require(AppChatNetworking.Constants)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

return RoduxNetworking.GET(script.Name, function(callback, conversation_id, cursor)
	return callback(CHAT_PLATFORM_BASE_URL):path("v1"):path("get-conversation-messages"):queryArgs({
		conversation_id = conversation_id,
		cursor = cursor,
		Constants.PageSize.GET_NEW_MESSAGES,
		include_cards = GetFFlagEnableSocialCards() and true or false
	}):setStatusIds({ conversation_id })
end)
