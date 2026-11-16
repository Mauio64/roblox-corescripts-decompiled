local IXPService = game:GetService("IXPService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local parent2 = ExpChat.Parent
local UserProfiles = require(parent.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local SignalsReact = require(parent.SignalsReact)
local React = require(parent2.React)
local RoactRodux = require(parent.RoactRodux)
local SharedFlags = require(parent.SharedFlags)
local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local Foundation = require(parent.Foundation)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local Localization = require(ExpChat.Localization)

local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local UIBlox = require(parent.UIBlox)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatReportHistoricalRenders = SharedFlags.FFlagExpChatReportHistoricalRenders
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
local applyChatWindowMessageEffects = require(ExpChat.MessageEffects.applyChatWindowMessageEffects)
local getMessageEffects = require(ExpChat.MessageEffects.getMessageEffects)
local getChatWindowMessageEffects = require(ExpChat.MessageEffects.getChatWindowMessageEffects)
local getChatWindowPrefixOffset = require(ExpChat.MessageEffects.getChatWindowPrefixOffset)
local getChatWindowMessageLineHeight = require(ExpChat.MessageEffects.getChatWindowMessageLineHeight)
local MessageEffect = require(ExpChat.MessageEffects.MessageEffect)
local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local isChatWindowEnlargeEnabled = require(ExpChat.isChatWindowEnlargeEnabled)

local FFlagExpChatMessageEffectChatWindowEnlargePadding = require(ExpChat.Flags.FFlagExpChatMessageEffectChatWindowEnlargePadding)

local FFlagExpChatMessageEffectChatWindowEnlargeLineHeight = require(ExpChat.Flags.FFlagExpChatMessageEffectChatWindowEnlargeLineHeight)

local FIntExpChatMessageEffectChatWindowEnlargePaddingPixels = require(ExpChat.Flags.FIntExpChatMessageEffectChatWindowEnlargePaddingPixels)

local EngineFeatureTextChatReportEmojiTelemetryEnabled = require(ExpChat.Flags.EngineFeatureTextChatReportEmojiTelemetryEnabled)

local FFlagDebugMessageProfiling = require(ExpChat.Flags.FFlagDebugMessageProfiling)
local defineFastFlag = game:DefineFastFlag("ExpChatTranslationToggleSpacingFix", false)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)
local shouldReportMessageRender = require(ExpChat.shouldReportMessageRender)

local getFIntExpChatMessageRenderUserThrottlePermyriad = require(ExpChat.Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)
local fIntExpChatMessageRenderUserThrottlePermyriad = getFIntExpChatMessageRenderUserThrottlePermyriad()
local getFFlagExpChatExcludeFOMORenders = require(ExpChat.Flags.getFFlagExpChatExcludeFOMORenders)
local FFlagEnableInExpChatRewrite = require(ExpChat.Flags.FFlagEnableInExpChatRewrite)
local FStringInExpChatRewriteLabelKey = require(ExpChat.Flags.FStringInExpChatRewriteLabelKey)
local FStringInExpChatRewriteReasonKey = require(ExpChat.Flags.FStringInExpChatRewriteReasonKey)
local FFlagExpChatRewriteInline = require(ExpChat.Flags.FFlagExpChatRewriteInline)
local FFlagExpChatRewriteInlineIxpEnabled = require(ExpChat.Flags.FFlagExpChatRewriteInlineIxpEnabled)
local FFlagExpChatRewriteToggleAnalytics = require(ExpChat.Flags.FFlagExpChatRewriteToggleAnalytics)
local FStringExpChatRewriteInlineIxpLayer = require(ExpChat.Flags.FStringExpChatRewriteInlineIxpLayer)

local FIntExpChatWindowTransparencyRewriteInteractableThreshold = require(ExpChat.Flags.FIntExpChatWindowTransparencyRewriteInteractableThreshold)
local FFlagEnableInExpChatSummaryOnLua = require(ExpChat.Flags.FFlagEnableInExpChatSummaryOnLua)
local FFlagExpChatPolishSummaryMessageUI = require(ExpChat.Flags.FFlagExpChatPolishSummaryMessageUI)

local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(ExpChat.Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)
local summaryMessageRichText = require(ExpChat.summaryMessageRichText)

local useCursor = UIBlox.App.SelectionCursor.useCursor

local Config = require(ExpChat.Config)

local Helpers = ExpChat.ChatWindow.Helpers
local getMessageSettings = require(Helpers.getMessageSettings)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local duplicateInvisibleText = require(Helpers.duplicateInvisibleText)

local Flags = ExpChat.Flags
local isExperienceChatUserProfileApiEnabled = require(Flags.isExperienceChatUserProfileApiEnabled)
local FIntExpChatVisibleARButtonPadding = require(Flags.FIntExpChatVisibleARButtonPadding)
local FIntExpChatDefaultARButtonPadding = require(Flags.FIntExpChatDefaultARButtonPadding)
local FFlagExpChatTopBannerForPresetChatAccess = require(Flags.FFlagExpChatTopBannerForPresetChatAccess)
local FFlagExpChatFixLocalUserVerifiedBadge = require(Flags.FFlagExpChatFixLocalUserVerifiedBadge)
local FFlagExpChatUnconditionalCombinedNameHook = require(Flags.FFlagExpChatUnconditionalCombinedNameHook)
local ExpChatShared = require(parent2.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local useIsARButtonVisible = require(ExpChat.useIsARButtonVisible)
local isPresetMessage = ExpChatShared.isPresetMessage

function appendVerifiedBadge(value: string)
	return string.gsub(value, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
end

local function getNilName(_): nil
	return nil
end

local function fn(message)
	local v = getNilName
	local v2 = getNilName

	if
		(not GetFFlagTextChatEnableUniverseChatTabs() or message.textChannel ~= nil)
		and isExperienceChatUserProfileApiEnabled()
		and message.userId
	then
		local v3 = { (tostring(message.userId)) }
		local v4 = UserProfileStore.get().fetchNamesByUserIds(v3)(false).data[1]
		v = v4.names.getDisplayName
		v2 = v4.names.getInExperienceCombinedName
	end

	return {
		displayName = SignalsReact.useSignalBinding(v),
		inExperienceCombinedName = SignalsReact.useSignalBinding(v2)
	}
end

function trim(value)
	if value:match("^()%s*$") then
		return ""
	end

	return (value:match("^%s*(.*%S)"))
end

function getMessageText(flag: boolean?, value: string?, value2: string?)
	if value == nil or value == "" then
		return value2 or ""
	end

	if flag then
		return value or ""
	end

	return value2 or ""
end

local function calculateTransparency(p, p2) -- 3 equivalent calls inferred from this helper
	return p + p2 * (1 - p)
end

local function setTransparency(p, object) -- 12 equivalent calls inferred from this helper
	return object:map(function(p2)
		if p == nil then
			return 1
		end

		return calculateTransparency(p, p2) -- inferred equivalent call
	end)
end

local function useARButtonRightPadding() -- 2 equivalent calls inferred from this helper
	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		if useIsARButtonVisible() then
			return FIntExpChatVisibleARButtonPadding
		end

		return FIntExpChatDefaultARButtonPadding
	else
		local chatStatusStore = GetChatStatusStore(false)
		local v = showChatEnabledUI((SignalsReact.useSignalState(chatStatusStore.getChatStatus)))

		if not isChatRegionLocked() and v then
			return FIntExpChatVisibleARButtonPadding
		end

		return FIntExpChatDefaultARButtonPadding
	end
end

local function appendTrustedIndicator(value: string, trustedLabelText: string, p: number, textSize: number, p2)
	local hex = p2.Color.Shift.Shift_300.Color3:ToHex()
	local transparency = calculateTransparency(p2.Color.Shift.Shift_300.Transparency, p) -- inferred equivalent call

	local hex2 = p2.Color.Content.Emphasis.Color3:ToHex()
	local transparency2 = calculateTransparency(p2.Color.Content.Emphasis.Transparency, p) -- inferred equivalent call

	local v = textSize - 4

	local formatted = `{`{`{`{`<mark color='#{hex}' transparency='{transparency}'>`}<font transparency='1' weight='{600}' size='{v}'><stroke transparency='1'>_`}<font color='#{hex2}' transparency='{transparency2}'>{trustedLabelText}</font>`}_</stroke></font>`}</mark>`

	if string.find(value, ":([%S:]-)$") then
		return string.gsub(value, ":([%S:]-)$", ` {formatted} :%1`)
	end

	return `{value} {formatted}`
end

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function applyStyleToText(p, value, p2, p3: number?)
	local v2 = value or ""

	if p2.chatActionType == TextChatMessageChatActionType.Summary then
		return (summaryMessageRichText.wrapInSummaryMutedStyle(
			summaryMessageRichText.getSummaryIconPrefix(p3) .. " " .. v2,
			p.Color.Content.Muted.Color3:ToHex(),
			p3
		))
	end

	return v2
end

local function fn2(props)
	if FFlagDebugMessageProfiling then
		debug.profilebegin("TranslatedTextMessage")
	end

	local messageId = props.message.messageId or "UNKNOWN_MESSAGE_ID"
	React.useEffect(function()
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
			messageId = messageId
		})

		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
			messageId = messageId
		})
	end, { messageId })
	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local textSize

	if isSpatialUIEnabled then
		textSize = props.chatWindowSettings.SpatialPanelTextSize
	else
		textSize = props.chatWindowSettings.TextSize
	end

	local useLocalization = Localization.useLocalization
	local v2 = {
		trustedLabelText = "CoreScripts.TextChat.ChatWindow.TrustedLabel",
		hereLabel = FFlagExpChatGlobalTabDefault and "CoreScripts.TextChat.ChannelTabs.Here" or nil,
		rewrittenLabelText = nil,
		defaultRewrittenLabelText = nil
	}
	local rewrittenLabelText

	if FFlagExpChatRewriteInline then
		rewrittenLabelText = FStringInExpChatRewriteLabelKey
	end

	v2.rewrittenLabelText = rewrittenLabelText
	v2.defaultRewrittenLabelText = FFlagExpChatRewriteInline and "CoreScripts.TextChat.ChatWindow.RewrittenLabel" or nil
	local v3 = useLocalization(v2)
	local v4

	if FFlagExpChatRewriteInline then
		if v3.rewrittenLabelText and v3.rewrittenLabelText ~= "" then
			v4 = v3.rewrittenLabelText
		else
			v4 = v3.defaultRewrittenLabelText
		end
	else
		v4 = nil
	end

	local v5 = Foundation.Hooks.useTokens()

	local message = props.message
	local chatWindowSettings = props.chatWindowSettings
	local v6

	if FFlagExpChatGlobalTabDefault then
		v6 = v3.hereLabel
	end

	local messageSettings = getMessageSettings(message, chatWindowSettings, v6)

	local showTranslationButton = props.showTranslationButton
	local useTranslation = messageSettings.useTranslation
	local messageText = getMessageText(useTranslation, messageSettings.translation, messageSettings.text)
	local v7

	if isChatWindowEnlargeEnabled() then
		v7 = getMessageEffects(messageText)
		messageText = applyChatWindowMessageEffects(messageText, v7)
	else
		v7 = nil
	end

	local prefixText = messageSettings.prefixText or ""

	local v8 = nil

	if FFlagExpChatUnconditionalCombinedNameHook then
		v8 = fn(props.message)
	elseif not (GetFFlagTextChatEnableUniverseChatTabs() and props.message.textChannel == nil) then
		if isExperienceChatUserProfileApiEnabled() and props.message.userId then
			if FFlagDebugMessageProfiling then
				debug.profilebegin("useCombinedName")
			end

			v8 = fn(props.message)

			if FFlagDebugMessageProfiling then
				debug.profileend()
			end
		end
	end

	local userId = props.message.userId and tostring(props.message.userId)
	local isHiddenMessage

	if getFFlagExpChatExcludeFOMORenders() then
		isHiddenMessage = props.message.isHiddenMessage
	else
		isHiddenMessage = nil
	end

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v9 = userId and userId ~= ""
			local userId2 = Players.LocalPlayer and Players.LocalPlayer.UserId and tostring(Players.LocalPlayer.UserId)
			local v10 = userId2 and userId2 == userId

			if v9 and not (v10 or isHiddenMessage) then
				return (v.getIsTrustedConnection(userId).data(p))
			end

			return nil
		end)
	end, { userId, isHiddenMessage })

	local v10 = SignalsReact.useSignalBinding(v9)
	local v11

	if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled and not FFlagExpChatUseChannelTabsStore then
		v11 = useStore()
	else
		v11 = nil
	end

	if getFFlagExpChatUseUpdatedMessageRendered() then
		React.useEffect(function()
			if
				props.message.textChatMessageInstance
				and shouldSendHighFrequencyTelemetry(fIntExpChatMessageRenderUserThrottlePermyriad)
				and not (getFFlagExpChatExcludeFOMORenders() and props.message.isHiddenMessage)
			then
				local v12

				if FFlagExpChatReportHistoricalRenders then
					v12 = shouldReportMessageRender(props.message)
				else
					v12 = not props.message.isHistorical
				end

				if v12 then
					if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
						local v13 = -1

						if FFlagExpChatUseChannelTabsStore then
							local channelTabsStore = GetChannelTabsStore(false)
							local channelTabsState = channelTabsStore.getChannelTabsState(false)
							local selectedTabName = channelTabsStore.getSelectedTabName(false)

							if selectedTabName and channelTabsState.allChannelTabs[selectedTabName] then
								v13 = channelTabsState.allChannelTabs[selectedTabName].tabIndex
							end
						else
							local channelTabs = v11:getState().ChannelTabs
							local selectedTabName = channelTabs and channelTabs.selectedTabName

							if selectedTabName and channelTabs.allChannelTabs[selectedTabName] then
								v13 = channelTabs.allChannelTabs[selectedTabName].TabIndex
							end
						end

						if not EngineFeatureTextChatReportEmojiTelemetryEnabled then
							TextChatService:SendExpChatMessageClientRendered(
								props.message.textChatMessageInstance,
								"chat_window",
								v13
							)
							return
						end

						local v14 = not isChatWindowEnlargeEnabled() and {} or getChatWindowMessageEffects(v7)
						TextChatService:SendExpChatMessageClientRendered(
							props.message.textChatMessageInstance,
							"chat_window",
							v13,
							"",
							v14
						)
					else
						TextChatService:SendExpChatMessageClientRendered(
							props.message.textChatMessageInstance,
							"chat_window"
						)
					end
				end
			end
		end, {})
	end

	local bodyTextProperties = messageSettings.bodyTextProperties
	local prefixTextProperties = messageSettings.prefixTextProperties

	if not isSpatialUIEnabled then
		textSize = bodyTextProperties.TextSize
	end

	local v12 = textSize - 2
	local udim

	if isChatWindowEnlargeEnabled() then
		udim = UDim2.fromOffset(0, getChatWindowPrefixOffset(v7, prefixTextProperties.TextSize))
	end

	local lineHeight

	if FFlagExpChatMessageEffectChatWindowEnlargeLineHeight and isChatWindowEnlargeEnabled() then
		lineHeight = getChatWindowMessageLineHeight(v7, textSize, prefixTextProperties.TextSize)
	end

	local mapped = React.joinBindings(v8 == nil and {} or { v8.displayName, v8.inExperienceCombinedName }):map(function(list)
		local v13 = list[1] or ""
		local v14 = list[2] or ""

		local v15 = prefixText

		if string.len(v13) > 0 and string.len(v14) > 0 and v13 ~= v14 then
			v15 = string.gsub(v15, v13, v14)
		end

		if string.len(prefixText) > 0 and props.isUserVerified then
			return (appendVerifiedBadge(v15))
		end

		return v15
	end)

	local mapped2 = React.joinBindings({ mapped, v10, props.textTransparency }):map(function(list)
		local v13 = list[1] or ""
		local v14 = list[2] or false
		local item = list[3]
		local v15 = item == nil and 1 or item

		if string.len(prefixText) == 0 then
			return v13
		end

		if v14 then
			return (appendTrustedIndicator(v13, v3.trustedLabelText, v15, prefixTextProperties.TextSize, v5))
		end

		return v13
	end)

	local mapped3 = mapped2:map(function(p)
		if string.len(prefixText) == 0 then
			return p
		end

		return trim(p)
	end)

	local text = mapped2:map(function(p)
		local v13 = messageText

		if FFlagEnableInExpChatSummaryOnLua then
			local v14

			if FFlagExpChatPolishSummaryMessageUI then
				v14 = textSize
			end

			v13 = messageText or ""

			if props.message.chatActionType == TextChatMessageChatActionType.Summary then
				v13 = summaryMessageRichText.wrapInSummaryMutedStyle(
					summaryMessageRichText.getSummaryIconPrefix(v14) .. " " .. v13,
					v5.Color.Content.Muted.Color3:ToHex(),
					v14
				)
			end
		end

		if FFlagExpChatPresetChatEnabled and isPresetMessage(props.message) then
			v13 ..= ` {getPresetIconRichText(textSize)}`
		end

		if string.len(prefixText) == 0 then
			if FFlagEnableInExpChatSummaryOnLua then
				return v13
			end

			return messageText
		end

		if showTranslationButton then
			if defineFastFlag then
				v13 = "     " .. v13
			else
				v13 = "   " .. v13
			end
		end

		return duplicateInvisibleText(p, prefixTextProperties.FontFace, prefixTextProperties.TextSize) .. " " .. v13
	end)

	if FFlagExpChatRewriteInline then
		text = React.joinBindings({ text }):map(function(list)
			local v13 = list[1] or ""

			if not props.wasRewritten then
				return v13
			end

			local v14

			if props.isRewriteMenuOpen then
				v14 = Foundation.Enums.IconName.ChevronLargeUp
			else
				v14 = Foundation.Enums.IconName.ChevronLargeDown
			end

			return `{v13} <font size='{prefixTextProperties.TextSize - 4}' color='#{v5.Color.Content.Muted.Color3:ToHex()}'>{`({v4})`}<font transparency='1'><stroke transparency='1'>_</stroke></font>{`<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{v14}</font>`}</font>`
		end)
	end

	local selectionImageObject = useCursor()
	local udim2

	if FFlagExpChatMessageEffectChatWindowEnlargePadding and isChatWindowEnlargeEnabled() then
		local v13

		if v7 then
			v13 = not table.find(v7, MessageEffect.ChatWindowEnlarge) and 0
				or FIntExpChatMessageEffectChatWindowEnlargePaddingPixels
		else
			v13 = 0
		end

		udim2 = UDim.new(0, v13)
	end

	local uiPadding

	if FFlagEnableInExpChatRewrite then
		local v13 = useARButtonRightPadding() -- inferred equivalent call
		uiPadding = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v13),
			PaddingTop = udim2,
			PaddingBottom = udim2
		})
	else
		local chatStatusStore = GetChatStatusStore(false)
		local v13 = showChatEnabledUI((SignalsReact.useSignalState(chatStatusStore.getChatStatus)))
		local v14 = not isChatRegionLocked() and v13

		local createElement = React.createElement
		local v15

		if v14 then
			v15 = FIntExpChatVisibleARButtonPadding
		else
			v15 = FIntExpChatDefaultARButtonPadding
		end

		uiPadding = createElement("UIPadding", {
			PaddingRight = UDim.new(0, v15),
			PaddingTop = udim2,
			PaddingBottom = udim2
		})
	end

	local interactable

	if FFlagExpChatRewriteInline and props.wasRewritten then
		if props.chatWindowTransparencyBindable == nil then
			interactable = true
		elseif typeof(props.chatWindowTransparencyBindable) == "number" then
			interactable = props.chatWindowTransparencyBindable < FIntExpChatWindowTransparencyRewriteInteractableThreshold
		else
			interactable = props.chatWindowTransparencyBindable:map(function(p): boolean
				return p < FIntExpChatWindowTransparencyRewriteInteractableThreshold
			end)
		end
	end

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v14 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1
	}
	local prefixText2

	if string.len(prefixText) > 0 then
		prefixText2 = React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = prefixTextProperties.FontFace,
			LineHeight = lineHeight,
			Position = udim,
			RichText = true,
			Text = mapped2,
			TextColor3 = prefixTextProperties.TextColor3,
			TextSize = prefixTextProperties.TextSize,
			TextStrokeColor3 = prefixTextProperties.TextStrokeColor3,
			TextStrokeTransparency = setTransparency( -- inferred equivalent call
				prefixTextProperties.TextStrokeTransparency,
				props.textTransparency
			),
			TextTransparency = setTransparency(0, props.textTransparency), -- inferred equivalent call
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}, {
			UIGradient = prefixTextProperties.UIGradient ~= nil and React.createElement(
				"UIGradient",
				prefixTextProperties.UIGradient
			)
		})
	else
		prefixText2 = false
	end

	local createElement3 = React.createElement
	local v15 = FFlagExpChatRewriteInline and props.wasRewritten and "TextButton" or "TextLabel"
	local v16 = {
		["AutomaticSize"] = nil,
		["AutomaticSize"] = nil,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = bodyTextProperties.FontFace,
		LineHeight = lineHeight,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 0),
		Text = text,
		TextColor3 = bodyTextProperties.TextColor3,
		TextSize = textSize,
		TextStrokeColor3 = bodyTextProperties.TextStrokeColor3,
		TextStrokeTransparency = setTransparency(bodyTextProperties.TextStrokeTransparency, props.textTransparency), -- inferred equivalent call
		TextTransparency = setTransparency(0, props.textTransparency), -- inferred equivalent call
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	}

	local activated = React.Event.Activated
	local v17

	if FFlagExpChatRewriteInline and props.wasRewritten then
		v17 = props.onTextBodyActivated
	end

	v16[activated] = v17

	v16.Interactable = interactable
	local v18 = {
		PrefixText = prefixText2,
		BodyText = createElement3(v15, v16),
		TextMessageButton = 0
	}
	local textMessageButton

	if string.len(prefixText) ~= 0 then
		local createElement4 = React.createElement
		local v19 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = udim,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v20 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			TextButton = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				FontFace = prefixTextProperties.FontFace,
				LineHeight = lineHeight,
				RichText = true,
				SelectionImageObject = selectionImageObject,
				Size = UDim2.new(0, 0, 0, 0),
				Text = mapped3,
				TextSize = prefixTextProperties.TextSize,
				TextStrokeTransparency = 1,
				TextTransparency = 1,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 1,
				[React.Event.Activated] = function()
					props.onTextMessageLabelButtonActivated(props.message)
				end
			}),
			TranslationButton = 0
		}
		local translationButton

		if showTranslationButton then
			translationButton = React.createElement("ImageButton", {
				BackgroundTransparency = 1,
				HoverImage = "rbxasset://textures/translateIconDark.png",
				Image = "rbxasset://textures/translateIcon.png",
				ImageTransparency = setTransparency(0, props.textTransparency), -- inferred equivalent call
				LayoutOrder = 2,
				PressedImage = "rbxasset://textures/translateIconDark.png",
				SelectionImageObject = selectionImageObject,
				Size = UDim2.new(0, v12, 0, v12),
				[React.Event.Activated] = function()
					props.onToggle(not props.message.useTranslation, props.message.messageId)
				end
			})
		end

		v20.TranslationButton = translationButton
		textMessageButton = createElement4("Frame", v19, v20)
	end

	v18.TextMessageButton = textMessageButton
	local element = createElement("Frame", v13, {
		UIPadding = uiPadding,
		TextMessage = createElement2("Frame", v14, v18)
	})

	if FFlagDebugMessageProfiling then
		debug.profileend()
	end

	return element
end

local function TranslatedTextMessageWithToggle(_)
	return RoactRodux.connect(function() end, function(_)
		return {
			onToggle = function(flag: boolean, p: string)
				GetMessagesStore(false).toggleMessageTranslation(flag, p)
			end
		}
	end)(fn2)
end

local function RewriteLabelWithButton(props)
	local v2 = Foundation.Hooks.useTokens()
	local v3 = Localization.useLocalization({
		rewrittenLabelText = FStringInExpChatRewriteLabelKey,
		defaultRewrittenLabelText = "CoreScripts.TextChat.ChatWindow.RewrittenLabel"
	})
	local v4

	if v3.rewrittenLabelText and v3.rewrittenLabelText ~= "" then
		v4 = v3.rewrittenLabelText
	else
		v4 = v3.defaultRewrittenLabelText
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "size-full-0 auto-y row align-y-center gap-xsmall",
		LayoutOrder = props.LayoutOrder
	}
	local children = {
		Label = React.createElement(Foundation.Text, {
			Text = "(" .. v4 .. ")",
			tag = "size-0-0 auto-xy text-caption-small text-align-x-left",
			LayoutOrder = 1,
			RichText = true,
			textStyle = {
				Color3 = v2.Color.Content.Muted.Color3,
				Transparency = setTransparency(v2.Color.Content.Muted.Transparency, props.textTransparency) -- inferred equivalent call
			},
			stroke = {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = setTransparency(0.5, props.textTransparency), -- inferred equivalent call
				Thickness = v2.Stroke.Thin
			}
		}),
		IconButton = 0
	}

	local createElement2 = React.createElement
	local iconButton = Foundation.IconButton
	local v6 = {
		size = Foundation.Enums.InputSize.XSmall,
		icon = 0,
		variant = 0,
		isCircular = true,
		LayoutOrder = 2,
		Visible = 0,
		onActivated = 0
	}
	local icon

	if props.isRewriteMenuOpen then
		icon = Foundation.Enums.IconName.ChevronLargeUp
	else
		icon = Foundation.Enums.IconName.ChevronLargeDown
	end

	v6.icon = icon

	v6.variant = Foundation.Enums.ButtonVariant.Utility

	v6.Visible = props.textTransparency:map(function(p): boolean
		return p < 1
	end)

	v6.onActivated = props.onActivated
	children.IconButton = createElement2(iconButton, v6)
	return createElement(view, v5, children)
end

local function TranslatedTextMessageWrapper(props)
	local messageSettings = getMessageSettings(props.message, props.chatWindowSettings)
	local showTranslationButton = props.showTranslationButton

	local v2 = nil

	local state = nil
	local setState = nil
	local v3, text, wasRewritten, originalText, v4, v5

	if FFlagEnableInExpChatRewrite then
		v3 = math.max(useARButtonRightPadding() - FIntExpChatDefaultARButtonPadding, 0) -- inferred equivalent call
		local v6 = Localization.useLocalization({
			rewrittenReasonLabelText = FStringInExpChatRewriteReasonKey,
			defaultRewrittenReasonLabelText = "CoreScripts.TextChat.ChatWindows.RewrittenReasonLabel"
		})

		if v6.rewrittenReasonLabelText and v6.rewrittenReasonLabelText ~= "" then
			text = v6.rewrittenReasonLabelText
		else
			text = v6.defaultRewrittenReasonLabelText
		end

		v2 = Foundation.Hooks.useTokens()
		state, setState = React.useState(false)

		wasRewritten = messageSettings.wasRewritten
		originalText = messageSettings.originalText
		local v7 = wasRewritten

		if v7 then
			if originalText == nil then
				v7 = false
			else
				v7 = originalText ~= ""
			end
		end

		v4 = v7

		v5 = React.useCallback(function()
			if FFlagExpChatRewriteToggleAnalytics then
				ExpChatShared.Analytics:TelemetryLogEvent(
					ExpChatShared.Analytics.RewriteDropdownToggledConfig,
					{
						messageId = props.message.messageId,
						isDropdownOpen = tostring(state),
						showOriginalText = tostring(v4)
					},
					ExpChatShared.Analytics.DefaultStandardizedFields
				)
			end

			setState(function(p): boolean
				return not p
			end)
		end, { state, v4, props.message.messageId })

		if FFlagExpChatRewriteInlineIxpEnabled then
			React.useEffect(function()
				if wasRewritten then
					IXPService:LogFlagLinkedUserLayerExposure(FStringExpChatRewriteInlineIxpLayer)
				end
			end, { wasRewritten })
		end
	else
		wasRewritten = false
		v4 = false
		v3 = 0
		text = ""
	end

	local v6

	if FFlagExpChatRewriteInline and wasRewritten then
		v6 = dictionary.join(props, {
			isRewriteMenuOpen = state,
			wasRewritten = wasRewritten,
			onTextBodyActivated = v5,
			LayoutOrder = 1
		})
	elseif FFlagEnableInExpChatRewrite and wasRewritten then
		v6 = dictionary.join(props, { LayoutOrder = 1 })
	else
		v6 = props
	end

	local translatedTextMessage

	if showTranslationButton then
		translatedTextMessage = React.createElement(TranslatedTextMessageWithToggle, v6)
	else
		translatedTextMessage = React.createElement(fn2, v6)
	end

	if not (FFlagEnableInExpChatRewrite and wasRewritten) then
		return translatedTextMessage
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		tag = `size-full-0 auto-y align-y-top col{FFlagExpChatRewriteInline and " gap-xsmall" or ""}`,
		LayoutOrder = props.LayoutOrder
	}
	local uiPadding

	if state then
		uiPadding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 4) })
	end

	local rewriteLabelWithButton

	if wasRewritten and not FFlagExpChatRewriteInline then
		rewriteLabelWithButton = React.createElement(RewriteLabelWithButton, {
			onActivated = v5,
			isRewriteMenuOpen = state,
			transparencyValue = props.transparencyValue,
			textTransparency = props.textTransparency,
			LayoutOrder = 2
		})
	end

	local dropdownMenu

	if state then
		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v8 = {
			tag = "align-x-left col radius-medium gap-xxsmall padding-small",
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -FIntExpChatDefaultARButtonPadding, 0, 0),
			LayoutOrder = 3,
			backgroundStyle = {
				Color3 = v2.Color.Common.Scrim.Color3,
				Transparency = setTransparency(0.7, props.transparencyValue) -- inferred equivalent call
			}
		}
		local originalText2

		if v4 then
			originalText2 = React.createElement(Foundation.Text, {
				Text = originalText,
				tag = "text-body-small text-align-x-left",
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -v3, 0, 0),
				LayoutOrder = 1,
				RichText = true,
				TextWrapped = true,
				textStyle = {
					Color3 = v2.Color.Content.Muted.Color3,
					Transparency = setTransparency(v2.Color.Content.Muted.Transparency, props.textTransparency) -- inferred equivalent call
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = setTransparency(0.5, props.textTransparency), -- inferred equivalent call
					Thickness = v2.Stroke.Thin
				}
			})
		end

		local divider

		if v4 then
			divider = React.createElement(Foundation.Divider, {
				orientation = Foundation.Enums.Orientation.Horizontal,
				LayoutOrder = 2,
				Visible = props.textTransparency:map(function(p): boolean
					return p < 1
				end),
				DividerVariant = Foundation.Enums.DividerVariant.Default
			})
		end

		dropdownMenu = createElement2(view2, v8, {
			OriginalText = originalText2,
			Divider = divider,
			ReasoningText = React.createElement(Foundation.Text, {
				Text = text,
				tag = "text-body-small text-align-x-left",
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -v3, 0, 0),
				LayoutOrder = 3,
				RichText = true,
				TextWrapped = true,
				textStyle = {
					Color3 = v2.Color.Content.Default.Color3,
					Transparency = setTransparency(v2.Color.Content.Default.Transparency, props.textTransparency) -- inferred equivalent call
				},
				stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Transparency = setTransparency(0.5, props.textTransparency), -- inferred equivalent call
					Thickness = v2.Stroke.Thin
				}
			})
		})
	end

	return (createElement(view, v7, {
		UIPadding = uiPadding,
		TranslatedTextMessage = translatedTextMessage,
		RewriteLabelWithButton = rewriteLabelWithButton,
		DropdownMenu = dropdownMenu
	}))
end

local function areEqual(data, data2)
	local v2

	if
		data.message.text == data2.message.text
		and data.message.prefixText == data2.message.prefixText
		and data.message.translation == data2.message.translation
		and data.message.useTranslation == data2.message.useTranslation
		and data.message.messageId == data2.message.messageId
	then
		if FFlagExpChatFixLocalUserVerifiedBadge then
			if data.message.userId == data2.message.userId then
				v2 = data.isUserVerified == data2.isUserVerified
			else
				v2 = false
			end
		else
			v2 = true
		end

		if not v2 then
			return v2
		end

		if data.chatWindowSettings == data2.chatWindowSettings then
			local v3

			if FFlagEnableInExpChatRewrite then
				if data.message.wasRewritten == data2.message.wasRewritten then
					v3 = data.message.originalText == data2.message.originalText
				else
					v3 = false
				end
			else
				v3 = true
			end

			v2 = v3
				and (not FFlagExpChatRewriteInline or data.chatWindowTransparencyBindable == data2.chatWindowTransparencyBindable)
				and (not FFlagEnableInExpChatSummaryOnLua or data.message.chatActionType == data2.message.chatActionType)

			if not v2 then
				return v2
			end

			if FFlagExpChatPresetChatEnabled then
				return data.message.presetId == data2.message.presetId
			end

			v2 = true
			return true
		end
	end

	v2 = false
	return false
end

return React.memo(TranslatedTextMessageWrapper, areEqual)
