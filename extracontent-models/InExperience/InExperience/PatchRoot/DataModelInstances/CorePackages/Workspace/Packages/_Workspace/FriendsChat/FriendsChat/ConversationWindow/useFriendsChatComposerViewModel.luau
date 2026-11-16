local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
require(parent.Foundation)
local Autocomplete = require(parent.ChatUIPrimitives.Autocomplete)
require(parent.ChatUIPrimitives.MessageComposer)
local MessageDraftModel = require(parent.ChatUIPrimitives.MessageDraftModel)

local function useFriendsChatComposerViewModel(data)
	local canLocalUserChat = data.canLocalUserChat
	local timeoutOverlay = data.timeoutOverlay
	local onSend = data.onSend
	local onFocusGained = data.onFocusGained
	local onFocusLost = data.onFocusLost

	return {
		chatAvailability = React.useMemo(function()
			return {
				canSend = canLocalUserChat,
				reason = not canLocalUserChat and "timedOut" or nil,
				upsell = timeoutOverlay
			}
		end, { canLocalUserChat, timeoutOverlay }),
		messageDelivery = React.useMemo(function()
			return {
				sendMessageDraft = function(p)
					local plainText = MessageDraftModel.toPlainText(p)

					if plainText ~= nil then
						onSend(plainText)
					end
				end
			}
		end, { onSend }),
		autocomplete = React.useMemo(function()
			return {
				sources = { Autocomplete.BuiltIn.Emoji({ id = "friendsChatEmoji" }) }
			}
		end, {}),
		onFocusChanged = React.useCallback(function(flag: boolean)
			if flag then
				onFocusGained()
			else
				onFocusLost()
			end
		end, { onFocusGained, onFocusLost }),
		placeholderText = data.placeholderText,
		maximumCharacterLimit = data.maximumCharacterLimit,
		textBoxRef = data.textBoxRef,
		navigationTargetRef = data.navigationTargetRef,
		transparency = data.transparency
	}
end

return useFriendsChatComposerViewModel
