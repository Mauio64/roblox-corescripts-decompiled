local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpressionCatalogResource = require(parent.ChatUIPrimitives.ExpressionCatalogResource)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local TextChannelWindowAnalytics = require(script.Parent.TextChannelWindowAnalytics)
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useInExperienceLocalization = ChatUIPrimitives2.Hooks.useInExperienceLocalization
local Logger = require(script.Parent.Logger)
local Message = require(script.Parent.Message)
local MessageWriterContext = require(script.Parent.MessageWriterContext)
local runVirtualChatCommands = require(script.Parent.runVirtualChatCommands)
local useCanSendToChannel = require(script.Parent.useCanSendToChannel)
local useCanSendToChannel2 = useCanSendToChannel.useCanSendToChannel
local SharedFlags = require(parent.SharedFlags)
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local sendTextToChannel = require(script.Parent.sendTextToChannel)
local getFFlagExpChatUseChatMuteStore = require(script.Parent.getFFlagExpChatUseChatMuteStore)

local FFlagExpChatTextChannelWindowThemeByBackground = require(script.Parent.Flags.FFlagExpChatTextChannelWindowThemeByBackground)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatComposerFigmaParity = SharedFlags2.FFlagExpChatComposerFigmaParity

local FFlagExpChatTextChannelWindowExpressionTray = require(script.Parent.Flags.FFlagExpChatTextChannelWindowExpressionTray)

local FFlagExpChatTextChannelWindowExpressionTrayEmoji = require(script.Parent.Flags.FFlagExpChatTextChannelWindowExpressionTrayEmoji)
local FFlagExpChatTextChannelWindowFocusNav = require(script.Parent.Flags.FFlagExpChatTextChannelWindowFocusNav)

local FFlagDebugExpChatTextChannelWindowStaticExpressions = require(script.Parent.Flags.FFlagDebugExpChatTextChannelWindowStaticExpressions)

local FFlagExpChatTextChannelWindowMessageComposer = require(script.Parent.Flags.FFlagExpChatTextChannelWindowMessageComposer)

local FFlagExpChatTCWRestoreSendSelectionGatedByInputMode = require(script.Parent.Flags.FFlagExpChatTCWRestoreSendSelectionGatedByInputMode)
local getDebugExpressionCatalog = require(script.Parent.TextChannelWindowExpressionTray.getDebugExpressionCatalog)
local sendExpression = require(script.Parent.TextChannelWindowExpressionTray.sendExpression)
local useTextChannelWindowComposerViewModel = require(script.Parent.useTextChannelWindowComposerViewModel)
local catalogResource

if FFlagDebugExpChatTextChannelWindowStaticExpressions then
	catalogResource = ExpressionCatalogResource.createStatic(getDebugExpressionCatalog())
else
	catalogResource = nil
end

local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local MessageComposer = require(parent.ChatUIPrimitives.MessageComposer)
local useFocusInputBar = ChatUIPrimitives.Hooks.useFocusInputBar

local function TextChatWindowInputBarHost(props)
	local targetChannel = props.targetChannel
	local v = Foundation.Hooks.useTokens()
	local guiService = props.guiService or GuiService
	local focusNavEnabled = props.focusNavEnabled
	local textBoxRef = props.textBoxRef

	local v2 = useLastInputMode()

	local v3 = useCanSendToChannel2(props.targetChannel, props.localUserId)

	local v4 = useInExperienceLocalization()
	local v5 = React.useMemo(function()
		return {
			placeholder = v4("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v4("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled"),
			chatUnavailable = v4("CoreScripts.TextChat.InputBar.Hint.ChatUnavailable"),
			readOnly = v4("CoreScripts.TextChat.Error.ReadOnlyChannel"),
			presetDisclaimer = v4("Feature.Chat.PresetChat.Disclaimer")
		}
	end, { v4 })

	local v6 = MessageWriterContext.useMessageWriter()
	local name

	if targetChannel then
		name = targetChannel.Name
	else
		name = nil
	end

	local onSend = React.useCallback(function(p: string)
		if not v3 then
			return
		end

		if targetChannel and p ~= "" then
			if focusNavEnabled and (not FFlagExpChatTCWRestoreSendSelectionGatedByInputMode or v2 == "Focus") then
				local current

				if textBoxRef then
					current = textBoxRef.current
				end

				if current then
					guiService.SelectedCoreObject = current
				end
			end

			local v7 = getFFlagExpChatUseChatMuteStore()
				and props.localUserId
				and runVirtualChatCommands(p, props.localUserId)

			if v7 then
				if v6 then
					local write = v6.write
					local createSystemMessage = Message.createSystemMessage

					local key = v7.key
					local v8

					if next(v7.args) then
						v8 = v7.args
					end

					write(createSystemMessage(v4(key, v8)))
				end
			elseif FFlagExpChatTextChannelWindowExpressionTrayEmoji then
				task.spawn(sendTextToChannel, targetChannel, p)
			else
				task.spawn(function()
					local success, result = pcall(function()
						if getFFlagExpChatProtectedChatInternalAPIs() then
							targetChannel:SendInternalAsync(p)
						else
							targetChannel:SendAsync(p)
						end
					end)

					if success then
						TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Send, {
							result = "success",
							has_target = name ~= nil,
							target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(name)
						})
						return
					end

					Logger:warning("SendAsync failed: {}", result)
					TextChannelWindowAnalytics.emit(TextChannelWindowAnalytics.Counters.Send, {
						result = "failure",
						has_target = name ~= nil,
						target_text_channel_category = TextChannelWindowAnalytics.getChannelCategory(name)
					})
				end)
			end
		end
	end, {
		targetChannel,
		v3,
		v4,
		props.localUserId,
		v6,
		name,
		focusNavEnabled,
		v2,
		textBoxRef,
		guiService
	})

	local v7 = props.canLocalUserChat == nil or props.canLocalUserChat
	local v8

	if v7 then
		v8 = not (targetChannel == nil) and v3
	else
		v8 = v7
	end

	local v9

	if targetChannel == nil then
		v9 = v5.chatUnavailable
	else
		v9 = if v3 then v5.disabled else v5.readOnly
	end

	local autocomplete = React.useMemo(function()
		return { commands = nil, emojis = true }
	end, {})

	local v10 = useFocusInputBar(props.textBoxRef)
	local sendExpression2 = React.useCallback(function(p)
		return sendExpression(p, targetChannel, v7)
	end, { targetChannel, v7 })
	local expressionTray

	if FFlagExpChatTextChannelWindowExpressionTray and FFlagExpChatComposerFigmaParity then
		expressionTray = {
			sendExpression = sendExpression2,
			canLocalUserChat = v7,
			canSend = v3 and targetChannel ~= nil,
			onKeyboardActivated = v10.focus,
			footerText = v5.presetDisclaimer,
			focusNavEnabled = 0,
			onOpenChanged = 0,
			catalogResource = 0
		}
		expressionTray.focusNavEnabled = focusNavEnabled == true and FFlagExpChatTextChannelWindowFocusNav
		local onOpenChanged

		if FFlagExpChatTextChannelWindowFocusNav then
			onOpenChanged = props.onExpressionTrayOpenChanged
		end

		expressionTray.onOpenChanged = onOpenChanged
		expressionTray.catalogResource = catalogResource
	end

	local expressionTray2 = expressionTray
		and {
			catalogResource = expressionTray.catalogResource,
			onKeyboardActivated = expressionTray.onKeyboardActivated,
			canSend = expressionTray.canSend,
			onOpenChanged = expressionTray.onOpenChanged
		}
		or nil
	local disabledOverlay

	if v9 and v9 ~= "" then
		disabledOverlay = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			padding = {
				left = UDim.new(0, 16),
				right = UDim.new(0, 4),
				top = UDim.new(0, 10),
				bottom = UDim.new(0, 10)
			}
		}, {
			Text = React.createElement(Foundation.Text, {
				testId = "--social-exp-chat-text-input-disabled",
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-muted",
				Text = v9
			})
		})
	end

	if FFlagExpChatTextChannelWindowMessageComposer then
		local v11 = useTextChannelWindowComposerViewModel({
			canChat = v8,
			canChatFreely = v7,
			targetChannel = targetChannel,
			disabledOverlay = disabledOverlay,
			onSend = onSend,
			expressionTray = expressionTray2,
			windowName = props.windowName,
			placeholderText = v5.placeholder,
			textBoxRef = v10.ref,
			fontFace = props.fontFace
		})

		return React.createElement(MessageComposer, v11)
	end

	local createElement = React.createElement
	local v11 = {
		onSend = onSend,
		canLocalUserChat = v8,
		textSize = v.Typography.CaptionMedium.FontSize,
		fontFace = props.fontFace,
		placeholderText = v5.placeholder,
		disabledChatPlaceholderText = v9,
		autocomplete = autocomplete,
		maximumCharacterLimit = 200,
		themedColors = FFlagExpChatTextChannelWindowThemeByBackground,
		textBoxRef = v10.ref,
		expressionTray = expressionTray,
		composerLayout = FFlagExpChatComposerFigmaParity,
		selectionImageObject = 0
	}
	local selectionImageObject

	if focusNavEnabled then
		selectionImageObject = props.selectionCursor
	end

	v11.selectionImageObject = selectionImageObject
	return createElement(ChatInputBarView, v11)
end

return React.memo(TextChatWindowInputBarHost)
