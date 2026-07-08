local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Signals = require(ExpChatParent.Signals)
local SignalsReact = require(ExpChatParent.SignalsReact)
local DataHydration = require(ExpChatParent.DataHydration)
local UserProfiles = require(ExpChatParent.UserProfiles)
local VerifiedBadgeDisplayStore = UserProfiles.Stores.VerifiedBadgeDisplayStore
local SharedFlags = require(ExpChatParent.SharedFlags)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local useStore = require(ExpChatParent.RoactUtils).Hooks.RoactRodux.useStore
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local TranslatedTextMessageV2 = require(ExpChat.ChatWindow.UI.TranslatedTextMessageV2)
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local Helpers = ExpChat.ChatWindow.Helpers
local getMessageSettings = require(Helpers.getMessageSettings)
local getMessageText = require(Helpers.getMessageText)
local Flags = ExpChat.Flags
local getFFlagExpChatUseUpdatedMessageRendered = require(Flags.getFFlagExpChatUseUpdatedMessageRendered)
local v25 = require(Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)()
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
local v50 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()
local v51 = game:DefineFastInt("ExpChatSlotBatchSize", 10)

local function createSlot(t1: {[any]: any}) -- line: 68
	-- upvalues: React (copy), TextChatMessageChatActionType (copy), FFlagExpChatPresetChatEnabled (copy)
	local v56, v57 = React.createBinding("")
	local v58, v59 = React.createBinding("")
	local v60, v61 = React.createBinding(false)
	local v62, v63 = React.createBinding(0)
	local v64, v65 = React.createBinding(false)
	local v66, v67 = React.createBinding(t1)
	local v68, v69 = React.createBinding(t1)
	local v70, v71 = React.createBinding(false)
	local v72, v73 = React.createBinding(false)
	local v74, v75 = React.createBinding(false)
	local v76, v77 = React.createBinding(false)
	local v78 = React.createRef()
	local v79, v80 = React.createBinding(TextChatMessageChatActionType.Unknown)
	local v81 = nil
	local v82 = nil

	if FFlagExpChatPresetChatEnabled then
		v81, v82 = React.createBinding(false)
	end

	v78.current = {}

	return {
		bodyText = v56,
		setBodyText = v57,
		prefixText = v58,
		setPrefixText = v59,
		shouldShowTranslation = v60,
		setShowTranslation = v61,
		layoutOrder = v62,
		setLayoutOrder = v63,
		visible = v64,
		setVisible = v65,
		bodyTextProperties = v66,
		setBodyTextProperties = v67,
		prefixTextProperties = v68,
		setPrefixTextProperties = v69,
		message = v78,
		isUserVerified = v70,
		setIsUserVerified = v71,
		isTrustedConnection = v72,
		setIsTrustedConnection = v73,
		wasRewritten = v74,
		setWasRewritten = v75,
		isRewriteWindowOpen = v76,
		setIsRewriteWindowOpen = v77,
		chatActionType = v79,
		setChatActionType = v80,
		isPresetMessage = if not FFlagExpChatPresetChatEnabled then nil else v81,
		setIsPresetMessage = if not FFlagExpChatPresetChatEnabled then nil else v82
	}
end
local function resolvePrefixText(s1: string, t2: {[any]: any}, p1) -- line: 119
	-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), UserProfileStore (copy)
	if GetFFlagTextChatEnableUniverseChatTabs() and t2.isUniverseChat then
		return s1
	end

	local userId = t2.userId

	if not userId or tostring(userId) == "0" then
		return s1
	end

	local str = tostring(userId)
	local v88 = UserProfileStore.get().fetchNamesByUserIds({ str })(p1)
	local v89 = v88.data and v88.data[1]

	if not v89 or not v89.names then
		return s1
	end

	local v90 = v89.names.getDisplayName(p1)
	local v91 = v89.names.getInExperienceCombinedName(p1)

	if string.len(v90) > 0 and string.len(v91) > 0 and v90 ~= v91 then
		s1 = string.gsub(s1, v90, v91)
	end

	return s1
end
local function useV2MessagePool(t3: {[any]: any}) -- line: 184
	-- upvalues: FFlagExpChatKeepV2PoolMounted (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), useStore (copy), GetChatStatusStore (copy), SignalsReact (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatTopBannerForPresetChatAccess (copy), GetPresetChatStore (copy), React (copy), getIsARButtonVisible (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy), isChatRegionLocked (copy), showChatEnabledUI (copy), FFlagExpChatDynamicV2Pool (copy), v51 (copy), createSlot (copy), Signals (copy), FFlagEnableInExpChatRewrite (copy), GetRewriteDropdownStore (copy), getMessageSettings (copy), getMessageText (copy), resolvePrefixText (copy), FFlagExpChatFixRateLimitedMessageRemoval (copy), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), TextChatMessageChatActionType (copy), FFlagEnableVerifiedBadgeStore (copy), VerifiedBadgeDisplayStore (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), getFFlagExpChatUseUpdatedMessageRendered (copy), shouldSendHighFrequencyTelemetry (copy), v25 (copy), getFFlagExpChatExcludeFOMORenders (copy), GetChannelTabsStore (copy), TextChatService (copy), FFlagExpChatEnableFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), Players (copy), v50 (copy), FFlagExpChatAddWindowSettingDependency (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), TranslatedTextMessageV2 (copy), RewriteDropdown (copy)
	local messagesStore = t3.messagesStore
	local enabled = t3.enabled
	local chatWindowSettings = t3.chatWindowSettings
	local v96 = if not FFlagExpChatKeepV2PoolMounted then enabled else enabled and t3.visible ~= false
	local v97 = if not EngineFeatureExpChatGlobalChatEngineTelemetryEnabled or FFlagExpChatUseChannelTabsStore then nil else useStore()
	local v98 = GetChatStatusStore(false)
	local v99 = SignalsReact.useSignalBinding(v98.getChatStatus)
	local u103

	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		local v100 = GetPresetChatStore(false)
		local v101 = SignalsReact.useSignalBinding(v100.getIsEnabled)
		local v102 = SignalsReact.useSignalBinding(v100.getAccessLevel)

		u103 = React.joinBindings({
			v99,
			v101,
			v102
		}):map(function(p2) -- line: 207
			-- upvalues: getIsARButtonVisible (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy)
			local v119 = p2[1]
			local v120 = p2[2]
			local v121 = p2[3]
			local v122 = getIsARButtonVisible(v119, v120, v121)

			return UDim.new(0, if not v122 then FIntExpChatDefaultARButtonPadding else FIntExpChatVisibleARButtonPadding)
		end)
	else
		u103 = v99:map(function(p3) -- line: 215
			-- upvalues: isChatRegionLocked (copy), showChatEnabledUI (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy)
			local v124 = not isChatRegionLocked() and showChatEnabledUI(p3)

			return UDim.new(0, if not v124 then FIntExpChatDefaultARButtonPadding else FIntExpChatVisibleARButtonPadding)
		end)
	end

	local n1 = 50

	if FFlagExpChatDynamicV2Pool and enabled then
		n1 = math.min(math.ceil(#(if not t3.isChannelBarVisible or not t3.targetTextChannel then messagesStore.getWindowMessagesInOrder(false) or {} else messagesStore.getWindowMessagesInOrderByTabId(false)[t3.targetTextChannel.Name] or {}) / v51) * v51, 50)
	end

	local v105, v106 = React.useState(n1)
	local v107 = not FFlagExpChatDynamicV2Pool and 50 or v105
	local v108 = React.useRef(nil)

	if enabled and not v108.current then
		local t4 = {}

		for i = 1, v107 do
			t4[i] = createSlot(chatWindowSettings)
		end

		v108.current = t4
	end

	if FFlagExpChatDynamicV2Pool and enabled and v108.current then
		for i = #v108.current + 1, v107 do
			v108.current[i] = createSlot(chatWindowSettings)
		end
	end

	local v112 = React.useRef({})
	local v113 = React.useRef(0)
	local v114 = React.useRef(v107)

	v114.current = v107

	local function createSlotEffects(p4, s2: string, p5, t5: {[any]: any}, b1: boolean) -- line: 265
		-- upvalues: Signals (copy), FFlagEnableInExpChatRewrite (copy), GetRewriteDropdownStore (copy), getMessageSettings (copy), getMessageText (copy), resolvePrefixText (copy), FFlagExpChatFixRateLimitedMessageRemoval (copy), FFlagExpChatPresetChatEnabled (copy), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), TextChatMessageChatActionType (copy), FFlagEnableVerifiedBadgeStore (copy), VerifiedBadgeDisplayStore (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy), getFFlagExpChatUseUpdatedMessageRendered (copy), shouldSendHighFrequencyTelemetry (copy), v25 (copy), getFFlagExpChatExcludeFOMORenders (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), v97 (copy), TextChatService (copy), FFlagExpChatEnableFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), Players (copy), v50 (copy)
		local v130 = p5.registerMessageComponent(s2)
		local v131 = p5.getLayoutOrderSignal(s2)
		local v132 = Signals.createEffect(function(p6) -- line: 275
			-- upvalues: v130 (copy), FFlagEnableInExpChatRewrite (copy), GetRewriteDropdownStore (copy), p5 (copy), getMessageSettings (copy), t5 (copy), b1 (copy), getMessageText (copy), p4 (copy), resolvePrefixText (copy), FFlagExpChatFixRateLimitedMessageRemoval (copy), FFlagExpChatPresetChatEnabled (copy), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), TextChatMessageChatActionType (copy), s2 (copy), FFlagEnableVerifiedBadgeStore (copy), VerifiedBadgeDisplayStore (copy), FFlagExpChatEvictFloodcheckedFromWindowOrder (copy)
			local v149 = v130(p6)
			local v150 = nil
			local v151 = nil

			if FFlagEnableInExpChatRewrite then
				v151 = GetRewriteDropdownStore(false)
				v150 = v151.getOpenMessageId(p6)
			end

			if v149 then
				local v152 = p5.getMessage(v149)(p6)

				if v152 then
					local v153 = getMessageSettings(v152, t5)
					local v154 = b1 and (v153.translation ~= nil and v153.translation ~= "")
					local useTranslation = v153.useTranslation
					local v156 = getMessageText(useTranslation, v153.translation, v153.text)
					local bodyTextProperties = v153.bodyTextProperties
					local prefixTextProperties = v153.prefixTextProperties

					p4.setBodyText(v156)
					p4.setPrefixText((resolvePrefixText(v153.prefixText or "", v152, p6)))
					p4.setShowTranslation(v154)
					p4.setVisible(not FFlagExpChatFixRateLimitedMessageRemoval or v152.isVisibleInChatWindow)
					p4.setBodyTextProperties(bodyTextProperties)
					p4.setPrefixTextProperties(prefixTextProperties)
					p4.message.current = v152

					if FFlagExpChatPresetChatEnabled then
						p4.setIsPresetMessage((v152.presetId or "") ~= "")
					end

					if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
						p4.setChatActionType(v152.chatActionType or TextChatMessageChatActionType.Unknown)
					end

					if FFlagEnableInExpChatRewrite then
						p4.setWasRewritten(v153.wasRewritten or false)

						if v150 == v149 then
							v151.setComponentId(s2)
							p4.setIsRewriteWindowOpen(true)
						else
							p4.setIsRewriteWindowOpen(false)
						end
					end

					if FFlagEnableVerifiedBadgeStore then
						local num = tonumber(v152.userId)

						if num then
							local v160 = VerifiedBadgeDisplayStore.get()

							p4.setIsUserVerified(v160.isBadgeVisible(num))

							return
						end

						p4.setIsUserVerified(false)

						return
					end

					p4.setIsUserVerified(false)

					return
				end

				if FFlagExpChatEvictFloodcheckedFromWindowOrder then
					p4.setVisible(false)

					return
				end
			else
				p4.setVisible(false)
				p4.setIsUserVerified(false)

				if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
					p4.setChatActionType(TextChatMessageChatActionType.Unknown)
				end
			end
		end)
		local v133 = if not v131 then nil else Signals.createEffect(function(p7) -- line: 347
			-- upvalues: v131 (copy), p4 (copy)
			local v162 = v131(p7)

			p4.setLayoutOrder(v162)
		end)
		local v134 = if not getFFlagExpChatUseUpdatedMessageRendered() then nil else Signals.createEffect(function(p8) -- line: 354
			-- upvalues: v130 (copy), p5 (copy), shouldSendHighFrequencyTelemetry (copy), v25 (copy), getFFlagExpChatExcludeFOMORenders (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), v97 (copy), TextChatService (copy)
			local v164 = v130(p8)

			if v164 then
				local v165 = p5.getMessage(v164)(false)

				if v165 and v165.textChatMessageInstance and shouldSendHighFrequencyTelemetry(v25) and (not getFFlagExpChatExcludeFOMORenders() or not v165.isHiddenMessage) then
					if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
						local n2 = -1

						if FFlagExpChatUseChannelTabsStore then
							local v167 = GetChannelTabsStore(false)
							local v168 = v167.getChannelTabsState(false)
							local v169 = v167.getSelectedTabName(false)

							if v169 and v168.allChannelTabs[v169] then
								n2 = v168.allChannelTabs[v169].tabIndex
							end
						else
							local ChannelTabs = v97:getState().ChannelTabs
							local v171 = ChannelTabs and ChannelTabs.selectedTabName

							if v171 and ChannelTabs.allChannelTabs[v171] then
								n2 = ChannelTabs.allChannelTabs[v171].TabIndex
							end
						end

						TextChatService:SendExpChatMessageClientRendered(v165.textChatMessageInstance, "chat_window", n2)

						return
					end

					TextChatService:SendExpChatMessageClientRendered(v165.textChatMessageInstance, "chat_window")
				end
			end
		end)
		local v135 = Signals.createEffect(function(p9) -- line: 398
			-- upvalues: v130 (copy), p5 (copy), FFlagExpChatEnableFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), Players (copy), v50 (copy), p4 (copy)
			local v173 = v130(p9)

			if v173 then
				local v174 = p5.getMessage(v173)(false)

				if v174 then
					local userId = v174.userId
					local v176 = if not FFlagExpChatEnableFOMOUpsell and not FFlagExpChatEnableCrossAgeChatActivity then nil else v174.isHiddenMessage
					local v177 = userId and userId ~= ""
					local v178 = Players.LocalPlayer and (Players.LocalPlayer.UserId and tostring(Players.LocalPlayer.UserId))
					local v179 = v178 and v178 == userId
					local v180 = not not (v177 and (not v179 and not v176)) and v50.getIsTrustedConnection(userId).data(p9)

					p4.setIsTrustedConnection(v180)
				end
			end
		end)

		return {
			cleanupMsg = v132,
			cleanupLayout = v133,
			cleanupTelemetry = v134,
			cleanupTc = v135,
			componentId = s2
		}
	end

	local t6 = {}

	if FFlagExpChatAddWindowSettingDependency then
		table.insert(t6, chatWindowSettings)
	end

	if FFlagExpChatKeepV2PoolMounted then
		table.insert(t6, v96)
	end

	React.useEffect(function() -- line: 446
		-- upvalues: v96 (copy), v107 (copy), createSlotEffects (copy), v108 (copy), messagesStore (copy), chatWindowSettings (copy), t3 (copy), v112 (copy), v113 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), FFlagEnableInExpChatRewrite (copy), GetRewriteDropdownStore (copy)
		if not v96 then
			return
		end

		for i = 1, v107 do
			local v137 = createSlotEffects(v108.current[i], "msg-component-" .. i, messagesStore, chatWindowSettings, t3.showTranslationButton)

			table.insert(v112.current, v137)
		end

		v113.current = v107

		local selectedChannelName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedChannelName = t3.selectedChannelName

			if messagesStore.getChannelTabsConfigurationEnabled(false) and t3.targetTextChannel then
				selectedChannelName = t3.targetTextChannel.Name
			end
		else
			selectedChannelName = if not t3.isChannelBarVisible or not t3.targetTextChannel then nil else t3.targetTextChannel.Name
		end

		messagesStore.setActiveChannelFilter(selectedChannelName)
		messagesStore.repopulateMessageComponents()

		return function() -- line: 480
			-- upvalues: v112 (copy), messagesStore (copy), v113 (copy), FFlagEnableInExpChatRewrite (copy), GetRewriteDropdownStore (copy)
			for _, v in ipairs(v112.current) do
				if v.cleanupMsg then
					pcall(v.cleanupMsg)
				end

				if v.cleanupLayout then
					pcall(v.cleanupLayout)
				end

				if v.cleanupTelemetry then
					pcall(v.cleanupTelemetry)
				end

				if v.cleanupTc then
					pcall(v.cleanupTc)
				end

				messagesStore.unregisterMessageComponent(v.componentId)
			end

			v112.current = {}
			v113.current = 0

			if FFlagEnableInExpChatRewrite then
				GetRewriteDropdownStore(false).setComponentId(nil)
			end
		end
	end, t6)

	if FFlagExpChatDynamicV2Pool and enabled then
		React.useEffect(function() -- line: 507
			-- upvalues: FFlagExpChatKeepV2PoolMounted (copy), v96 (copy), v113 (copy), v107 (copy), createSlotEffects (copy), v108 (copy), messagesStore (copy), chatWindowSettings (copy), t3 (copy), v112 (copy)
			if FFlagExpChatKeepV2PoolMounted and not v96 then
				return
			end

			local current = v113.current

			if current >= v107 then
				return
			end

			for i = current + 1, v107 do
				local v141 = createSlotEffects(v108.current[i], "msg-component-" .. i, messagesStore, chatWindowSettings, t3.showTranslationButton)

				table.insert(v112.current, v141)
			end

			v113.current = v107
			messagesStore.repopulateMessageComponents()
		end, if not FFlagExpChatKeepV2PoolMounted then { v107 } else {
			v107,
			v96
		})
		React.useEffect(function() -- line: 536
			-- upvalues: FFlagExpChatKeepV2PoolMounted (copy), v96 (copy), Signals (copy), messagesStore (copy), v51 (copy), v114 (copy), v106 (copy)
			if FFlagExpChatKeepV2PoolMounted and not v96 then
				return
			end

			local v142 = Signals.createEffect(function(p10) -- line: 541
				-- upvalues: messagesStore (copy), v51 (copy), v114 (copy), v106 (copy)
				local v184 = messagesStore.getActiveChannelFilter(p10)
				local v185 = math.min(math.ceil((#(if not v184 then messagesStore.getWindowMessagesInOrder(p10) or {} else messagesStore.getWindowMessagesInOrderByTabId(p10)[v184] or {}) + 2) / v51) * v51, 50)

				if v185 > v114.current then
					v106(v185)
				end
			end)

			return function() -- line: 558
				-- upvalues: v142 (copy)
				if v142 then
					pcall(v142)
				end
			end
		end, if not FFlagExpChatKeepV2PoolMounted then {} else { v96 })
	end

	local v117 = React.useRef(false)

	React.useEffect(function() -- line: 569
		-- upvalues: v96 (copy), v117 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), t3 (copy), messagesStore (copy)
		if not v96 then
			v117.current = false

			return
		end

		if not v117.current then
			v117.current = true

			return
		end

		local selectedChannelName

		if GetFFlagTextChatEnableUniverseChatTabs() then
			selectedChannelName = t3.selectedChannelName

			if messagesStore.getChannelTabsConfigurationEnabled(false) and t3.targetTextChannel then
				selectedChannelName = t3.targetTextChannel.Name
			end
		else
			selectedChannelName = if not t3.isChannelBarVisible or not t3.targetTextChannel then nil else t3.targetTextChannel.Name
		end

		messagesStore.setActiveChannelFilter(selectedChannelName)
		messagesStore.repopulateMessageComponents()
	end, {
		v96,
		t3.targetTextChannel,
		t3.isChannelBarVisible,
		if not GetFFlagTextChatEnableUniverseChatTabs() then nil else t3.selectedChannelName
	})

	return {
		children = React.useMemo(function() -- line: 603
			-- upvalues: enabled (copy), v107 (copy), v108 (copy), React (copy), TranslatedTextMessageV2 (copy), t3 (copy), chatWindowSettings (copy), FFlagEnableInExpChatRewrite (copy), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), u103 (ref), FFlagExpChatPresetChatEnabled (copy), RewriteDropdown (copy)
			if not enabled then
				return nil
			end

			local t7 = {}

			for i = 1, v107 do
				local v146 = "msg-component-" .. i
				local v147 = v108.current[i]

				t7[v146] = React.createElement(TranslatedTextMessageV2, {
					originalBodyText = v147.bodyText,
					originalPrefixText = v147.prefixText,
					shouldShowTranslationToggle = v147.shouldShowTranslation,
					bodyTextProperties = v147.bodyTextProperties,
					prefixTextProperties = v147.prefixTextProperties,
					layoutOrder = v147.layoutOrder,
					visible = v147.visible,
					textTransparency = t3.textTransparency,
					isUserVerified = v147.isUserVerified,
					userId = v147.userId,
					useTranslation = v147.useTranslation,
					messageId = v147.messageId,
					isSpatialUIEnabled = t3.isSpatialUIEnabled,
					chatWindowSettings = chatWindowSettings,
					onTextMessageLabelButtonActivated = t3.onTextMessageLabelButtonActivated,
					message = v147.message,
					isTrustedConnection = v147.isTrustedConnection,
					wasRewritten = if not FFlagEnableInExpChatRewrite then nil else v147.wasRewritten,
					isRewriteWindowOpen = if not FFlagEnableInExpChatRewrite then nil else v147.isRewriteWindowOpen,
					chatActionType = if not FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then nil else v147.chatActionType,
					chatWindowTransparencyBindable = t3.chatWindowTransparencyBindable,
					arButtonPadding = u103,
					isPresetMessage = if not FFlagExpChatPresetChatEnabled then nil else v147.isPresetMessage
				})
			end

			if FFlagEnableInExpChatRewrite then
				t7["$rewrite-dropdown"] = React.createElement(RewriteDropdown, {
					textTransparency = t3.textTransparency,
					arButtonPadding = u103
				})
			end

			t7["$layout"] = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			return t7
		end, if not FFlagExpChatKeepV2PoolMounted then {
			enabled,
			t3.textTransparency,
			t3.isSpatialUIEnabled,
			chatWindowSettings,
			t3.onTextMessageLabelButtonActivated,
			v107
		} else {
			enabled,
			v107
		})
	}
end

return useV2MessagePool
