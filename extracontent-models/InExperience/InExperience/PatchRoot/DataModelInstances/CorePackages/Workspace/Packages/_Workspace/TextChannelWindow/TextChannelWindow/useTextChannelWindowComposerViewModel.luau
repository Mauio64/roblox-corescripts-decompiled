local parent = script.Parent.Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local Autocomplete = require(parent.ChatUIPrimitives.Autocomplete)
require(parent.ChatUIPrimitives.MessageComposer)
local Logger = require(script.Parent.Logger)
local sendMessageDraft = require(script.Parent.TextChannelWindowExpressionTray.sendMessageDraft)

local FFlagExpChatTextChannelWindowDictationHandsFree = require(script.Parent.Flags.FFlagExpChatTextChannelWindowDictationHandsFree)

local function useTextChannelWindowComposerViewModel(data)
	local canChat = data.canChat
	local canChatFreely = data.canChatFreely
	local targetChannel = data.targetChannel
	local disabledOverlay = data.disabledOverlay
	local onSend = data.onSend
	local windowName = data.windowName

	local chatAvailability = React.useMemo(function()
		local v = { canSend = canChat, upsell = nil }
		local upsell

		if not canChat then
			upsell = disabledOverlay
		end

		v.upsell = upsell
		return v
	end, { canChat, disabledOverlay })

	local messageDelivery = React.useMemo(function()
		return {
			sendMessageDraft = function(p)
				sendMessageDraft(p, targetChannel, canChatFreely, onSend)
			end
		}
	end, { onSend, targetChannel, canChatFreely })

	local autocomplete = React.useMemo(function()
		return {
			sources = { Autocomplete.BuiltIn.Emoji({ id = "textChannelWindowEmoji" }) }
		}
	end, {})
	local v

	if FFlagExpChatTextChannelWindowDictationHandsFree then
		v = Responsive.usePreferredInput() == Responsive.Input.Directional
	else
		v = false
	end

	local handsFreeEnabled = FFlagExpChatTextChannelWindowDictationHandsFree and not v
	local dictation = React.useMemo(function()
		return { surfaceName = windowName, logger = Logger, handsFreeEnabled = handsFreeEnabled }
	end, { windowName, handsFreeEnabled })

	return {
		chatAvailability = chatAvailability,
		messageDelivery = messageDelivery,
		autocomplete = autocomplete,
		expressionTray = data.expressionTray,
		dictation = dictation,
		placeholderText = data.placeholderText,
		maximumCharacterLimit = 200,
		textBoxRef = data.textBoxRef,
		fontFace = data.fontFace
	}
end

return useTextChannelWindowComposerViewModel
