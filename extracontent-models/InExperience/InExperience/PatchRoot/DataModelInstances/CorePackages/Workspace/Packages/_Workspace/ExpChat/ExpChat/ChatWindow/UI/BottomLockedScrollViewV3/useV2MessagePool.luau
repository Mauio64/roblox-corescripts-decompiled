local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)
local UserProfiles = require(parent.UserProfiles)
local VerifiedBadgeDisplayStore = UserProfiles.Stores.VerifiedBadgeDisplayStore
local SharedFlags = require(parent.SharedFlags)
local ExpChatShared = require(parent.ExpChatShared)
require(ExpChat.MessageEffects.MessageEffect)
local getMessageEffects = require(ExpChat.MessageEffects.getMessageEffects)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatReportHistoricalRenders = SharedFlags.FFlagExpChatReportHistoricalRenders

local EngineFeatureTextChatReportEmojiTelemetryEnabled = require(ExpChat.Flags.EngineFeatureTextChatReportEmojiTelemetryEnabled)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local getChatWindowMessageEffects = require(ExpChat.MessageEffects.getChatWindowMessageEffects)

local TranslatedTextMessageV2 = require(ExpChat.ChatWindow.UI.TranslatedTextMessageV2)
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local isChatWindowEnlargeEnabled = require(ExpChat.isChatWindowEnlargeEnabled)

local Helpers = ExpChat.ChatWindow.Helpers
local getMessageSettings = require(Helpers.getMessageSettings)
local Localization = require(ExpChat.Localization)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)
local getMessageText = require(Helpers.getMessageText)

local Flags = ExpChat.Flags
local getFFlagExpChatUseUpdatedMessageRendered = require(Flags.getFFlagExpChatUseUpdatedMessageRendered)
local shouldReportMessageRender = require(ExpChat.shouldReportMessageRender)

local getFIntExpChatMessageRenderUserThrottlePermyriad = require(Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)
local fIntExpChatMessageRenderUserThrottlePermyriad = getFIntExpChatMessageRenderUserThrottlePermyriad()
local getFFlagExpChatExcludeFOMORenders = require(Flags.getFFlagExpChatExcludeFOMORenders)
local FFlagExpChatEnableFOMOUpsell = require(Flags.FFlagExpChatEnableFOMOUpsell)
local FFlagExpChatEnableCrossAgeChatActivity = require(Flags.FFlagExpChatEnableCrossAgeChatActivity)
local FFlagExpChatDynamicV2Pool = require(Flags.FFlagExpChatDynamicV2Pool)
local FFlagExpChatKeepV2PoolMounted = require(Flags.FFlagExpChatKeepV2PoolMounted)
local FFlagExpChatFixRateLimitedMessageRemoval = require(ExpChat.Flags.FFlagExpChatFixRateLimitedMessageRemoval)

local FFlagExpChatEvictFloodcheckedFromWindowOrder = require(ExpChat.Flags.FFlagExpChatEvictFloodcheckedFromWindowOrder)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatTopBannerForPresetChatAccess = require(Flags.FFlagExpChatTopBannerForPresetChatAccess)
local FFlagExpChatAddWindowSettingDependency = require(Flags.FFlagExpChatAddWindowSettingDependency)
local FFlagEnableInExpChatRewrite = require(Flags.FFlagEnableInExpChatRewrite)

local FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 = require(Flags.FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2)
local FIntExpChatVisibleARButtonPadding = require(Flags.FIntExpChatVisibleARButtonPadding)
local FIntExpChatDefaultARButtonPadding = require(Flags.FIntExpChatDefaultARButtonPadding)

local EngineFeatureExpChatGlobalChatEngineTelemetryEnabled = require(Flags.EngineFeatureExpChatGlobalChatEngineTelemetryEnabled)

local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local RewriteDropdown = require(ExpChat.ChatWindow.UI.TranslatedTextMessageV2.RewriteDropdown)
local GetRewriteDropdownStore = require(ExpChat.Stores.GetRewriteDropdownStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)
local getIsARButtonVisible = require(ExpChat.getIsARButtonVisible)

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local defineFastInt = game:DefineFastInt("ExpChatSlotBatchSize", 10)

local function createSlot(chatWindowSettings)
	local binding, setBodyText = React.createBinding("")
	local binding2, setPrefixText = React.createBinding("")
	local binding3, setShowTranslation = React.createBinding(false)
	local binding4, setLayoutOrder = React.createBinding(0)
	local binding5, setVisible = React.createBinding(false)
	local binding6, setBodyTextProperties = React.createBinding(chatWindowSettings)
	local binding7, setPrefixTextProperties = React.createBinding(chatWindowSettings)
	local binding8, setIsUserVerified = React.createBinding(false)
	local binding9, setIsTrustedConnection = React.createBinding(false)
	local binding10, setWasRewritten = React.createBinding(false)
	local binding11, setIsRewriteWindowOpen = React.createBinding(false)
	local ref = React.createRef()
	local binding12, setChatActionType = React.createBinding(TextChatMessageChatActionType.Unknown)
	local isPresetMessage, setIsPresetMessage

	if FFlagExpChatPresetChatEnabled then
		isPresetMessage, setIsPresetMessage = React.createBinding(false)
	end

	local effects, setEffects

	if isChatWindowEnlargeEnabled() then
		effects, setEffects = React.createBinding(nil)
	end

	ref.current = {}

	if not FFlagExpChatPresetChatEnabled then
		isPresetMessage = nil
	end

	if not FFlagExpChatPresetChatEnabled then
		setIsPresetMessage = nil
	end

	if not isChatWindowEnlargeEnabled() then
		effects = nil
	end

	if not isChatWindowEnlargeEnabled() then
		setEffects = nil
	end

	return {
		bodyText = binding,
		setBodyText = setBodyText,
		prefixText = binding2,
		setPrefixText = setPrefixText,
		shouldShowTranslation = binding3,
		setShowTranslation = setShowTranslation,
		layoutOrder = binding4,
		setLayoutOrder = setLayoutOrder,
		visible = binding5,
		setVisible = setVisible,
		bodyTextProperties = binding6,
		setBodyTextProperties = setBodyTextProperties,
		prefixTextProperties = binding7,
		setPrefixTextProperties = setPrefixTextProperties,
		message = ref,
		isUserVerified = binding8,
		setIsUserVerified = setIsUserVerified,
		isTrustedConnection = binding9,
		setIsTrustedConnection = setIsTrustedConnection,
		wasRewritten = binding10,
		setWasRewritten = setWasRewritten,
		isRewriteWindowOpen = binding11,
		setIsRewriteWindowOpen = setIsRewriteWindowOpen,
		chatActionType = binding12,
		setChatActionType = setChatActionType,
		isPresetMessage = isPresetMessage,
		setIsPresetMessage = setIsPresetMessage,
		effects = effects,
		setEffects = setEffects
	}
end

local function resolvePrefixText(prefixText: string, p, p2)
	if GetFFlagTextChatEnableUniverseChatTabs() and p.isUniverseChat then
		return prefixText
	end

	local userId = p.userId

	if not userId or tostring(userId) == "0" then
		return prefixText
	end

	local v2 = { (tostring(userId)) }
	local v3 = UserProfileStore.get().fetchNamesByUserIds(v2)(p2)
	local v4 = v3.data and v3.data[1]

	if not (v4 and v4.names) then
		return prefixText
	end

	local displayName = v4.names.getDisplayName(p2)
	local v5 = v4.names.getInExperienceCombinedName(p2)

	if string.len(displayName) > 0 and string.len(v5) > 0 and displayName ~= v5 then
		prefixText = string.gsub(prefixText, displayName, v5)
	end

	return prefixText
end

local function useV2MessagePool(data)
	local hereLabel

	if FFlagExpChatGlobalTabDefault then
		hereLabel = Localization.useLocalization({
			hereLabel = "CoreScripts.TextChat.ChannelTabs.Here"
		}).hereLabel
	else
		hereLabel = nil
	end

	local messagesStore = data.messagesStore
	local enabled = data.enabled
	local chatWindowSettings = data.chatWindowSettings
	local v2

	if FFlagExpChatKeepV2PoolMounted and enabled then
		v2 = data.visible ~= false
	else
		v2 = enabled
	end

	local v3

	if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled and not FFlagExpChatUseChannelTabsStore then
		v3 = useStore()
	else
		v3 = nil
	end

	local chatStatusStore = GetChatStatusStore(false)
	local v4 = SignalsReact.useSignalBinding(chatStatusStore.getChatStatus)
	local arButtonPadding

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		local presetChatStore = GetPresetChatStore(false)
		local v5 = {
			v4,
			SignalsReact.useSignalBinding(presetChatStore.getIsEnabled),
			(SignalsReact.useSignalBinding(presetChatStore.getAccessLevel))
		}
		arButtonPadding = React.joinBindings(v5):map(function(list)
			local isARButtonVisible = getIsARButtonVisible(list[1], list[2], list[3])
			local v6

			if isARButtonVisible then
				v6 = FIntExpChatVisibleARButtonPadding
			else
				v6 = FIntExpChatDefaultARButtonPadding
			end

			return UDim.new(0, v6)
		end)
	else
		arButtonPadding = v4:map(function(p)
			local v5 = not isChatRegionLocked() and showChatEnabledUI(p)
			local v6

			if v5 then
				v6 = FIntExpChatVisibleARButtonPadding
			else
				v6 = FIntExpChatDefaultARButtonPadding
			end

			return UDim.new(0, v6)
		end)
	end

	local v5

	if FFlagExpChatDynamicV2Pool and enabled then
		local v6

		if data.isChannelBarVisible and data.targetTextChannel then
			v6 = messagesStore.getWindowMessagesInOrderByTabId(false)[data.targetTextChannel.Name] or {}
		else
			v6 = messagesStore.getWindowMessagesInOrder(false) or {}
		end

		v5 = math.min(math.ceil(#v6 / defineFastInt) * defineFastInt, 50)
	else
		v5 = 50
	end

	local state, setState = React.useState(v5)
	local current2 = not FFlagExpChatDynamicV2Pool and 50 or state
	local ref = React.useRef(nil)

	if enabled and not ref.current then
		local current = {}

		for i = 1, current2 do
			current[i] = createSlot(chatWindowSettings)
		end

		ref.current = current
	end

	if FFlagExpChatDynamicV2Pool and enabled and ref.current then
		for i = #ref.current + 1, current2 do
			ref.current[i] = createSlot(chatWindowSettings)
		end
	end

	local ref2 = React.useRef({})
	local ref3 = React.useRef(0)

	local ref4 = React.useRef(current2)
	ref4.current = current2

	local function createSlotEffects(data2, componentId: string, messagesStore2, chatWindowSettings2, showTranslationButton: boolean)
		local messageComponent = messagesStore2.registerMessageComponent(componentId)
		local layoutOrderSignal = messagesStore2.getLayoutOrderSignal(componentId)

		local effect = Signals.createEffect(function(p)
			local v6 = messageComponent(p)
			local v7, v8

			if FFlagEnableInExpChatRewrite then
				v7 = GetRewriteDropdownStore(false)
				v8 = v7.getOpenMessageId(p)
			end

			if v6 then
				local current = messagesStore2.getMessage(v6)(p)

				if current then
					local v9

					if FFlagExpChatGlobalTabDefault then
						v9 = hereLabel
					end

					local messageSettings = getMessageSettings(current, chatWindowSettings2, v9)

					local v10 = showTranslationButton

					if v10 then
						if messageSettings.translation == nil then
							v10 = false
						else
							v10 = messageSettings.translation ~= ""
						end
					end

					local messageText = getMessageText(
						messageSettings.useTranslation,
						messageSettings.translation,
						messageSettings.text
					)
					local bodyTextProperties = messageSettings.bodyTextProperties
					local prefixTextProperties = messageSettings.prefixTextProperties

					data2.setBodyText(messageText)
					data2.setPrefixText(resolvePrefixText(messageSettings.prefixText or "", current, p))
					data2.setShowTranslation(v10)
					data2.setVisible(not FFlagExpChatFixRateLimitedMessageRemoval or current.isVisibleInChatWindow)

					data2.setBodyTextProperties(bodyTextProperties)
					data2.setPrefixTextProperties(prefixTextProperties)
					data2.message.current = current

					if FFlagExpChatPresetChatEnabled then
						data2.setIsPresetMessage((current.presetId or "") ~= "")
					end

					if isChatWindowEnlargeEnabled() then
						data2.setEffects(getMessageEffects(messageText))
					end

					if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
						data2.setChatActionType(current.chatActionType or TextChatMessageChatActionType.Unknown)
					end

					if FFlagEnableInExpChatRewrite then
						data2.setWasRewritten(messageSettings.wasRewritten or false)

						if v8 == v6 then
							v7.setComponentId(componentId)
							data2.setIsRewriteWindowOpen(true)
						else
							data2.setIsRewriteWindowOpen(false)
						end
					end

					if not FFlagEnableVerifiedBadgeStore then
						data2.setIsUserVerified(false)
						return
					end

					local userId = tonumber(current.userId)

					if not userId then
						data2.setIsUserVerified(false)
						return
					end

					local v11 = VerifiedBadgeDisplayStore.get()
					data2.setIsUserVerified(v11.isBadgeVisible(userId))
				elseif FFlagExpChatEvictFloodcheckedFromWindowOrder then
					data2.setVisible(false)
				end
			else
				data2.setVisible(false)
				data2.setIsUserVerified(false)

				if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
					data2.setChatActionType(TextChatMessageChatActionType.Unknown)
				end
			end
		end)
		local cleanupLayout

		if layoutOrderSignal then
			cleanupLayout = Signals.createEffect(function(p)
				local v6 = layoutOrderSignal(p)
				data2.setLayoutOrder(v6)
			end)
		end

		local cleanupTelemetry

		if getFFlagExpChatUseUpdatedMessageRendered() then
			cleanupTelemetry = Signals.createEffect(function(p)
				local v6 = messageComponent(p)

				if v6 then
					local v7 = messagesStore2.getMessage(v6)(false)

					if
						v7
						and v7.textChatMessageInstance
						and shouldSendHighFrequencyTelemetry(fIntExpChatMessageRenderUserThrottlePermyriad)
						and not (getFFlagExpChatExcludeFOMORenders() and v7.isHiddenMessage)
					then
						local v8

						if FFlagExpChatReportHistoricalRenders then
							v8 = shouldReportMessageRender(v7)
						else
							v8 = not v7.isHistorical
						end

						if v8 then
							if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
								local v9 = -1

								if FFlagExpChatUseChannelTabsStore then
									local channelTabsStore = GetChannelTabsStore(false)
									local channelTabsState = channelTabsStore.getChannelTabsState(false)
									local selectedTabName = channelTabsStore.getSelectedTabName(false)

									if selectedTabName and channelTabsState.allChannelTabs[selectedTabName] then
										v9 = channelTabsState.allChannelTabs[selectedTabName].tabIndex
									end
								else
									local channelTabs = v3:getState().ChannelTabs
									local selectedTabName = channelTabs and channelTabs.selectedTabName

									if selectedTabName and channelTabs.allChannelTabs[selectedTabName] then
										v9 = channelTabs.allChannelTabs[selectedTabName].TabIndex
									end
								end

								if not EngineFeatureTextChatReportEmojiTelemetryEnabled then
									TextChatService:SendExpChatMessageClientRendered(
										v7.textChatMessageInstance,
										"chat_window",
										v9
									)
									return
								end

								local v10

								if isChatWindowEnlargeEnabled() then
									local v11

									if FFlagExpChatGlobalTabDefault then
										v11 = hereLabel
									end

									local messageSettings = getMessageSettings(v7, chatWindowSettings2, v11)

									v10 = getChatWindowMessageEffects(getMessageEffects((getMessageText(
										messageSettings.useTranslation,
										messageSettings.translation,
										messageSettings.text
									))))
								else
									v10 = {}
								end

								TextChatService:SendExpChatMessageClientRendered(
									v7.textChatMessageInstance,
									"chat_window",
									v9,
									"",
									v10
								)
							else
								TextChatService:SendExpChatMessageClientRendered(
									v7.textChatMessageInstance,
									"chat_window"
								)
							end
						end
					end
				end
			end)
		end

		return {
			cleanupMsg = effect,
			cleanupLayout = cleanupLayout,
			cleanupTelemetry = cleanupTelemetry,
			cleanupTc = Signals.createEffect(function(p)
				local v6 = messageComponent(p)

				local v7 = v6 and messagesStore2.getMessage(v6)(false)

				if v7 then
					local userId = v7.userId
					local isHiddenMessage

					if FFlagExpChatEnableFOMOUpsell or FFlagExpChatEnableCrossAgeChatActivity then
						isHiddenMessage = v7.isHiddenMessage
					end

					local v8 = userId and userId ~= ""
					local userId2 = Players.LocalPlayer
						and Players.LocalPlayer.UserId
						and tostring(Players.LocalPlayer.UserId)
					local v9 = userId2 and userId2 == userId
					local v10

					if v8 and not v9 and not isHiddenMessage then
						v10 = v.getIsTrustedConnection(userId).data(p)
					else
						v10 = false
					end

					data2.setIsTrustedConnection(v10)
				end
			end),
			componentId = componentId
		}
	end

	local v6 = {}

	if FFlagExpChatAddWindowSettingDependency then
		table.insert(v6, chatWindowSettings)
	end

	if FFlagExpChatKeepV2PoolMounted then
		table.insert(v6, v2)
	end

	React.useEffect(function()
		if not v2 then
			return
		end

		for i = 1, current2 do
			local slotEffects = createSlotEffects(
				ref.current[i],
				"msg-component-" .. i,
				messagesStore,
				chatWindowSettings,
				data.showTranslationButton
			)

			table.insert(ref2.current, slotEffects)
		end

		ref3.current = current2
		local v7

		if GetFFlagTextChatEnableUniverseChatTabs() then
			v7 = data.selectedChannelName

			if messagesStore.getChannelTabsConfigurationEnabled(false) and data.targetTextChannel then
				v7 = data.targetTextChannel.Name
			end
		elseif data.isChannelBarVisible and data.targetTextChannel then
			v7 = data.targetTextChannel.Name
		end

		messagesStore.setActiveChannelFilter(v7)
		messagesStore.repopulateMessageComponents()

		return function()
			for _, v8 in ipairs(ref2.current) do
				if v8.cleanupMsg then
					pcall(v8.cleanupMsg)
				end

				if v8.cleanupLayout then
					pcall(v8.cleanupLayout)
				end

				if v8.cleanupTelemetry then
					pcall(v8.cleanupTelemetry)
				end

				if v8.cleanupTc then
					pcall(v8.cleanupTc)
				end

				messagesStore.unregisterMessageComponent(v8.componentId)
			end

			ref2.current = {}
			ref3.current = 0

			if FFlagEnableInExpChatRewrite then
				GetRewriteDropdownStore(false).setComponentId(nil)
			end
		end
	end, v6)

	if FFlagExpChatDynamicV2Pool and enabled then
		React.useEffect(function()
			if FFlagExpChatKeepV2PoolMounted and not v2 then
				return
			end

			local current = ref3.current

			if current2 <= current then
				return
			end

			for i = current + 1, current2 do
				local slotEffects = createSlotEffects(
					ref.current[i],
					"msg-component-" .. i,
					messagesStore,
					chatWindowSettings,
					data.showTranslationButton
				)

				table.insert(ref2.current, slotEffects)
			end

			ref3.current = current2
			messagesStore.repopulateMessageComponents()
		end, FFlagExpChatKeepV2PoolMounted and { current2, v2 } or { current2 })

		React.useEffect(function()
			if FFlagExpChatKeepV2PoolMounted and not v2 then
				return
			end

			local effect = Signals.createEffect(function(p)
				local activeChannelFilter = messagesStore.getActiveChannelFilter(p)
				local v7

				if activeChannelFilter then
					v7 = messagesStore.getWindowMessagesInOrderByTabId(p)[activeChannelFilter] or {}
				else
					v7 = messagesStore.getWindowMessagesInOrder(p) or {}
				end

				local v8 = math.min(math.ceil((#v7 + 2) / defineFastInt) * defineFastInt, 50)

				if ref4.current < v8 then
					setState(v8)
				end
			end)

			return function()
				if effect then
					pcall(effect)
				end
			end
		end, FFlagExpChatKeepV2PoolMounted and { v2 } or {})
	end

	local ref5 = React.useRef(false)
	local useEffect = React.useEffect
	local function fn()
		if not v2 then
			ref5.current = false
			return
		end

		if not ref5.current then
			ref5.current = true
			return
		end

		local v7

		if GetFFlagTextChatEnableUniverseChatTabs() then
			v7 = data.selectedChannelName

			if messagesStore.getChannelTabsConfigurationEnabled(false) and data.targetTextChannel then
				v7 = data.targetTextChannel.Name
			end
		elseif data.isChannelBarVisible and data.targetTextChannel then
			v7 = data.targetTextChannel.Name
		end

		messagesStore.setActiveChannelFilter(v7)
		messagesStore.repopulateMessageComponents()
	end

	local targetTextChannel = data.targetTextChannel
	local isChannelBarVisible = data.isChannelBarVisible
	local v7

	if GetFFlagTextChatEnableUniverseChatTabs() then
		v7 = data.selectedChannelName
	end

	useEffect(fn, { v2, targetTextChannel, isChannelBarVisible, v7 })

	return {
		children = React.useMemo(function()
			if not enabled then
				return nil
			end

			local children = {}

			for i = 1, current2 do
				local v8 = "msg-component-" .. i
				local v9 = ref.current[i]
				local createElement = React.createElement
				local v10 = {
					originalBodyText = v9.bodyText,
					originalPrefixText = v9.prefixText,
					shouldShowTranslationToggle = v9.shouldShowTranslation,
					bodyTextProperties = v9.bodyTextProperties,
					prefixTextProperties = v9.prefixTextProperties,
					layoutOrder = v9.layoutOrder,
					visible = v9.visible,
					textTransparency = data.textTransparency,
					isUserVerified = v9.isUserVerified,
					userId = v9.userId,
					useTranslation = v9.useTranslation,
					messageId = v9.messageId,
					isSpatialUIEnabled = data.isSpatialUIEnabled,
					chatWindowSettings = chatWindowSettings,
					onTextMessageLabelButtonActivated = data.onTextMessageLabelButtonActivated,
					message = v9.message,
					isTrustedConnection = v9.isTrustedConnection,
					wasRewritten = 0,
					isRewriteWindowOpen = 0,
					chatActionType = 0,
					chatWindowTransparencyBindable = 0,
					arButtonPadding = 0,
					isPresetMessage = 0,
					effects = 0
				}
				local wasRewritten

				if FFlagEnableInExpChatRewrite then
					wasRewritten = v9.wasRewritten
				end

				v10.wasRewritten = wasRewritten
				local isRewriteWindowOpen

				if FFlagEnableInExpChatRewrite then
					isRewriteWindowOpen = v9.isRewriteWindowOpen
				end

				v10.isRewriteWindowOpen = isRewriteWindowOpen
				local chatActionType

				if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
					chatActionType = v9.chatActionType
				end

				v10.chatActionType = chatActionType

				v10.chatWindowTransparencyBindable = data.chatWindowTransparencyBindable
				v10.arButtonPadding = arButtonPadding
				local isPresetMessage

				if FFlagExpChatPresetChatEnabled then
					isPresetMessage = v9.isPresetMessage
				end

				v10.isPresetMessage = isPresetMessage
				local effects

				if isChatWindowEnlargeEnabled() then
					effects = v9.effects
				end

				v10.effects = effects
				children[v8] = createElement(TranslatedTextMessageV2, v10)
			end

			if FFlagEnableInExpChatRewrite then
				children["$rewrite-dropdown"] = React.createElement(RewriteDropdown, {
					textTransparency = data.textTransparency,
					arButtonPadding = arButtonPadding
				})
			end

			children["$layout"] = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			return children
		end, FFlagExpChatKeepV2PoolMounted and { enabled, current2 } or {
			enabled,
			data.textTransparency,
			data.isSpatialUIEnabled,
			chatWindowSettings,
			data.onTextMessageLabelButtonActivated,
			current2
		})
	}
end

return useV2MessagePool
