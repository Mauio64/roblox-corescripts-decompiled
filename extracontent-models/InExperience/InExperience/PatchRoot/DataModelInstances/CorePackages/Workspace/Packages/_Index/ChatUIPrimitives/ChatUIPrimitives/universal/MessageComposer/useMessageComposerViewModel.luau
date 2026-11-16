local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(script.Parent.Parent.Types)
local MessageDraftModel = require(script.Parent.Parent.MessageDraftModel)
require(ChatUIPrimitives.UniversalMessage.Types)
require(ChatUIPrimitives.createExpressionCatalogResource)
local messageDraftFromExpressionContent = require(script.Parent.Parent.messageDraftFromExpressionContent)

require(ChatUIPrimitives.universal.Autocomplete.AutocompleteTypes)
require(ChatUIPrimitives.Components.ChatInputBar.ChatInputBarView)
local getTextLengthIfValidUtf8 = require(ChatUIPrimitives.Components.ChatInputBar.getTextLengthIfValidUtf8)
local ModerationTimeout = require(script.Parent.ModerationTimeout)
local FFlagExpChatMessageComposerDictation = require(ChatUIPrimitives.Flags.FFlagExpChatMessageComposerDictation)
local useChatInputBarDictation = require(ChatUIPrimitives.Components.ChatInputBar.Dictation.useChatInputBarDictation)
local Components = require(parent.DictationCore.Components)
require(parent.DictationCore.Constants)
local getDictationInputMode = require(ChatUIPrimitives.Components.ChatInputBar.Dictation.getDictationInputMode)
local DictationWaveformOverlay = require(ChatUIPrimitives.Components.ChatInputBar.Dictation.DictationWaveformOverlay)

local function useMessageComposerViewModel(props)
	local v = Foundation.Hooks.useTokens()
	local selectionImageObject = Foundation.Hooks.useCursor(Foundation.Enums.CursorType.RoundedRect)
	local moderationTimeout = props.moderationTimeout
	local transparency = props.transparency
	local v2

	if moderationTimeout == nil then
		v2 = false
	else
		v2 = moderationTimeout.status ~= "none"
	end

	local v3

	if moderationTimeout == nil then
		v3 = false
	else
		v3 = moderationTimeout.status == "active"
	end

	local canLocalUserChat = props.chatAvailability.canSend and not v2
	local sendMessageDraft = props.messageDelivery.sendMessageDraft
	local onFocusChanged = props.onFocusChanged
	local expressionTray = props.expressionTray
	local destinationSubtitle = props.destinationSubtitle
	local v4

	if expressionTray and expressionTray.canSend ~= nil then
		v4 = expressionTray.canSend
	else
		v4 = props.chatAvailability.canSend
	end

	local canSend = v4 and not v2
	local ref = React.useRef(sendMessageDraft)
	ref.current = sendMessageDraft

	local onSend = React.useCallback(function(p: string)
		ref.current(MessageDraftModel.fromPlainText(p))
	end, {})

	local sendExpression = React.useCallback(function(p): boolean
		local v5 = messageDraftFromExpressionContent(p)

		if v5 == nil then
			return false
		end

		ref.current(v5)
		return true
	end, {})

	local autocomplete = props.autocomplete
	local autocompleteOptions = React.useMemo(function()
		if autocomplete == nil then
			return nil
		end

		return {
			sources = autocomplete.sources,
			onAction = function(p): boolean
				if p.kind ~= "sendDraft" then
					return false
				end

				ref.current(p.draft)
				return true
			end
		}
	end, { autocomplete })

	local onFocusGained = React.useCallback(function()
		if onFocusChanged then
			onFocusChanged(true)
		end
	end, { onFocusChanged })

	local onFocusLost = React.useCallback(function()
		if onFocusChanged then
			onFocusChanged(false)
		end
	end, { onFocusChanged })
	local catalogResource

	if expressionTray then
		catalogResource = expressionTray.catalogResource
	else
		catalogResource = nil
	end

	local onKeyboardActivated

	if expressionTray then
		onKeyboardActivated = expressionTray.onKeyboardActivated
	else
		onKeyboardActivated = nil
	end

	local cooldownDurationSeconds

	if expressionTray then
		cooldownDurationSeconds = expressionTray.cooldownDurationSeconds
	else
		cooldownDurationSeconds = nil
	end

	local cooldownScope

	if expressionTray then
		cooldownScope = expressionTray.cooldownScope
	else
		cooldownScope = nil
	end

	local onOpenChanged

	if expressionTray then
		onOpenChanged = expressionTray.onOpenChanged
	else
		onOpenChanged = nil
	end

	local v5 = expressionTray ~= nil
	local expressionTray2 = React.useMemo(function()
		if v5 then
			return {
				sendExpression = sendExpression,
				canLocalUserChat = canLocalUserChat,
				canSend = canSend,
				catalogResource = catalogResource,
				onKeyboardActivated = onKeyboardActivated,
				cooldownDurationSeconds = cooldownDurationSeconds,
				cooldownScope = cooldownScope,
				focusNavEnabled = true,
				onOpenChanged = onOpenChanged
			}
		end

		return nil
	end, {
		v5,
		sendExpression,
		canLocalUserChat,
		canSend,
		catalogResource,
		onKeyboardActivated,
		cooldownDurationSeconds,
		cooldownScope,
		onOpenChanged
	})

	local disabledOverlay = React.useMemo(function()
		if v2 then
			return React.createElement(ModerationTimeout, {
				state = moderationTimeout,
				transparency = transparency
			})
		end

		return nil
	end, { v2, moderationTimeout, transparency })

	local textBoxRef = props.textBoxRef
	local navigationTargetRef = props.navigationTargetRef

	local ref2 = React.useRef(nil)
	local textBoxRef2 = textBoxRef or ref2

	React.useLayoutEffect(function()
		if not canLocalUserChat or navigationTargetRef == nil then
			return
		end

		local current = textBoxRef2.current

		if current == nil then
			return
		end

		navigationTargetRef.current = current
		return function()
			if navigationTargetRef.current == current then
				navigationTargetRef.current = nil
			end
		end
	end, { navigationTargetRef, textBoxRef2, canLocalUserChat })

	if not disabledOverlay then
		if canLocalUserChat then
			disabledOverlay = nil
		else
			disabledOverlay = props.chatAvailability.upsell
		end
	end

	local onChange, primary, centerOverlay, isAudioActive, enableFocusedWrite

	if FFlagExpChatMessageComposerDictation then
		local state, setState = React.useState(true)
		onChange = React.useCallback(function(p: string)
			setState(p == "")
		end, {})

		React.useEffect(function()
			if not canLocalUserChat then
				setState(true)
			end
		end, { canLocalUserChat })

		local maximumCharacterLimit = props.maximumCharacterLimit

		local v6 = React.useCallback(function(p: string)
			if p == "" then
				return
			end

			local textLengthIfValidUtf8 = getTextLengthIfValidUtf8(p)

			if
				maximumCharacterLimit ~= nil
				and textLengthIfValidUtf8 ~= nil
				and maximumCharacterLimit < textLengthIfValidUtf8
			then
				return
			end

			onSend(p)
			local current = textBoxRef2.current

			if current then
				current.Text = ""
			end

			setState(true)
		end, { onSend, textBoxRef2, maximumCharacterLimit })

		local v7, v8, v9 = useChatInputBarDictation(props.dictation, textBoxRef2, v6, state, canLocalUserChat)
		local v10 = v7 and canLocalUserChat

		local onActivated = React.useCallback(function()
			local current = textBoxRef2.current
			v6(not current and "" or current.Text)
		end, { v6, textBoxRef2 })

		local dictation = v8.dictation
		local isMicVisible = v8.isMicVisible
		local isSubmitVisible = v8.isSubmitVisible
		local v11

		if props.dictation then
			v11 = props.dictation.handsFreeEnabled
		end

		local dictationInputMode = getDictationInputMode(v11)

		primary = React.useMemo(function()
			if not v10 then
				return nil
			end

			local createElement = React.createElement
			local fragment = React.Fragment
			local createElement2 = React.createElement
			local view = Foundation.View

			local createElement3 = React.createElement
			local iconButton = Foundation.IconButton
			local v12 = {
				testId = "--social-exp-chat-iconbutton-dictation-send",
				icon = Foundation.Enums.IconName.ArrowMediumUp,
				variant = 0,
				size = 0,
				isCircular = true,
				isDisabled = 0,
				onActivated = 0
			}
			local variant

			if state then
				variant = Foundation.Enums.ButtonVariant.Standard
			else
				variant = Foundation.Enums.ButtonVariant.Emphasis
			end

			v12.variant = variant

			v12.size = Foundation.Enums.InputSize.Small

			v12.isDisabled = state
			v12.onActivated = onActivated
			return createElement(fragment, nil, {
				SendButton = createElement2(view, { tag = "auto-xy", Visible = isSubmitVisible }, {
					Content = createElement3(iconButton, v12)
				}),
				DictationMic = React.createElement(Foundation.View, {
					tag = "auto-xy",
					Visible = isMicVisible
				}, {
					Content = React.createElement(Components.MicButton, {
						getDictationState = dictation.getDictationState,
						getIsMicInUseElsewhere = dictation.getIsMicInUseElsewhere,
						onStart = dictation.startDictation,
						onStop = dictation.stopDictation,
						countdownProgress = dictation.bindings.countdownProgress,
						inputMode = dictationInputMode
					})
				})
			})
		end, {
			v10,
			isMicVisible,
			isSubmitVisible,
			dictation.getDictationState,
			dictation.getIsMicInUseElsewhere,
			dictation.startDictation,
			dictation.stopDictation,
			dictation.bindings.countdownProgress,
			dictationInputMode,
			state,
			onActivated
		})

		if v10 then
			centerOverlay = React.createElement(DictationWaveformOverlay, {
				isAudioActive = v8.isAudioActive,
				isAudioActiveBinding = dictation.bindings.isAudioActive,
				audioDeviceInput = dictation.audioDeviceInput,
				onWaveformSample = v8.onWaveformSample,
				transcribedSamplesBinding = v8.transcribedSamplesBinding,
				lineHeight = v.Typography.BodyMedium.FontSize,
				transparencyValue = transparency or 0
			})
		end

		if v10 then
			isAudioActive = v8.isAudioActive
		end

		if v10 then
			enableFocusedWrite = not v9
		end
	end

	local v6 = {
		composerLayout = true,
		themedColors = true,
		onSend = onSend,
		canLocalUserChat = canLocalUserChat,
		disabledOverlay = disabledOverlay,
		pillStrokeStyle = 0,
		expressionTray = 0,
		sideChipText = 0,
		showSideChip = 0,
		onSideChipActivated = 0,
		placeholderText = 0,
		maximumCharacterLimit = 0,
		autocompleteOptions = 0,
		textBoxRef = 0,
		selectionImageObject = 0,
		fontFace = 0,
		transparencyValue = 0,
		onFocusGained = 0,
		onFocusLost = 0,
		enableFocusedWrite = 0,
		onChange = 0,
		primary = 0,
		centerOverlay = 0,
		centerOverlayTextHidden = 0
	}
	local pillStrokeStyle

	if v3 then
		pillStrokeStyle = v.Color.System.Alert
	end

	v6.pillStrokeStyle = pillStrokeStyle
	v6.expressionTray = expressionTray2
	local sideChipText

	if destinationSubtitle then
		sideChipText = destinationSubtitle.text
	end

	v6.sideChipText = sideChipText
	v6.showSideChip = destinationSubtitle ~= nil
	local onSideChipActivated

	if destinationSubtitle then
		onSideChipActivated = destinationSubtitle.onActivated
	end

	v6.onSideChipActivated = onSideChipActivated
	v6.placeholderText = props.placeholderText
	v6.maximumCharacterLimit = props.maximumCharacterLimit
	v6.autocompleteOptions = autocompleteOptions
	v6.textBoxRef = textBoxRef2
	v6.selectionImageObject = selectionImageObject
	v6.fontFace = props.fontFace
	v6.transparencyValue = transparency

	if not onFocusChanged then
		onFocusGained = nil
	end

	v6.onFocusGained = onFocusGained

	if not onFocusChanged then
		onFocusLost = nil
	end

	v6.onFocusLost = onFocusLost
	v6.enableFocusedWrite = enableFocusedWrite
	v6.onChange = onChange
	v6.primary = primary
	v6.centerOverlay = centerOverlay
	v6.centerOverlayTextHidden = isAudioActive
	return v6
end

return useMessageComposerViewModel
