local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
require(parent.Foundation)
local ExpChatShared = require(parent.ExpChatShared)
local Autocomplete = require(parent.ChatUIPrimitives.Autocomplete)
require(parent.ChatUIPrimitives.MessageComposer)
local MessageDraftModel = require(parent.ChatUIPrimitives.MessageDraftModel)
local FFlagFriendsChatVoiceTyping = require(FriendsChat.Flags.FFlagFriendsChatVoiceTyping)

local logger = ExpChatShared.Logger:new(script.Name)

local function useFriendsChatComposerViewModel(data)
	local canLocalUserChat = data.canLocalUserChat
	local timeoutOverlay = data.timeoutOverlay
	local onSend = data.onSend
	local onFocusGained = data.onFocusGained
	local onFocusLost = data.onFocusLost

	local chatAvailability = React.useMemo(function()
		return {
			canSend = canLocalUserChat,
			reason = not canLocalUserChat and "timedOut" or nil,
			upsell = timeoutOverlay
		}
	end, { canLocalUserChat, timeoutOverlay })

	local messageDelivery = React.useMemo(function()
		return {
			sendMessageDraft = function(p)
				local plainText = MessageDraftModel.toPlainText(p)

				if plainText ~= nil then
					onSend(plainText)
				end
			end
		}
	end, { onSend })

	local autocomplete = React.useMemo(function()
		return {
			sources = { Autocomplete.BuiltIn.Emoji({ id = "friendsChatEmoji" }) }
		}
	end, {})

	local onFocusChanged = React.useCallback(function(flag: boolean)
		if flag then
			onFocusGained()
		else
			onFocusLost()
		end
	end, { onFocusGained, onFocusLost })
	local dictation

	if FFlagFriendsChatVoiceTyping then
		dictation = React.useMemo(function()
			return { surfaceName = "FriendsChat", logger = logger }
		end, {})
	end

	return {
		chatAvailability = chatAvailability,
		messageDelivery = messageDelivery,
		autocomplete = autocomplete,
		dictation = dictation,
		onFocusChanged = onFocusChanged,
		placeholderText = data.placeholderText,
		maximumCharacterLimit = data.maximumCharacterLimit,
		textBoxRef = data.textBoxRef,
		navigationTargetRef = data.navigationTargetRef,
		transparency = data.transparency
	}
end

return useFriendsChatComposerViewModel
