local IXPService = game:GetService("IXPService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatParent2 = ExpChat.Parent
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local UserProfileStore = require(ExpChatParent.UserProfiles).Stores.UserProfileStore
local SignalsReact = require(ExpChatParent.SignalsReact)
local React = require(ExpChatParent2.React)
local RoactRodux = require(ExpChatParent.RoactRodux)
local SharedFlags = require(ExpChatParent.SharedFlags)
local DataHydration = require(ExpChatParent.DataHydration)
local Signals = require(ExpChatParent.Signals)
local Foundation = require(ExpChatParent.Foundation)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Localization = require(ExpChat.Localization)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local showChatEnabledUI = require(ExpChat.showChatEnabledUI)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local UIBlox = require(ExpChatParent.UIBlox)
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local useStore = require(ExpChatParent.RoactUtils).Hooks.RoactRodux.useStore
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local FFlagDebugMessageProfiling = require(ExpChat.Flags.FFlagDebugMessageProfiling)
local v31 = game:DefineFastFlag("ExpChatTranslationToggleSpacingFix", false)
local getFFlagExpChatUseUpdatedMessageRendered = require(ExpChat.Flags.getFFlagExpChatUseUpdatedMessageRendered)
local v33 = require(ExpChat.Flags.getFIntExpChatMessageRenderUserThrottlePermyriad)()
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
local duplicateInvisibleText = require(Helpers.duplicateInvisibleText)
local Flags = ExpChat.Flags
local isExperienceChatUserProfileApiEnabled = require(Flags.isExperienceChatUserProfileApiEnabled)
local FIntExpChatVisibleARButtonPadding = require(Flags.FIntExpChatVisibleARButtonPadding)
local FIntExpChatDefaultARButtonPadding = require(Flags.FIntExpChatDefaultARButtonPadding)
local FFlagAEGIS2EnableGatesForExpChat = require(Flags.FFlagAEGIS2EnableGatesForExpChat)
local FFlagExpChatPerfTracking = require(ExpChatParent.SharedFlags).FFlagExpChatPerfTracking
local FFlagExpChatTopBannerForPresetChatAccess = require(Flags.FFlagExpChatTopBannerForPresetChatAccess)
local ExpChatShared = require(ExpChatParent2.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local useIsARButtonVisible = require(ExpChat.useIsARButtonVisible)
local isPresetMessage = ExpChatShared.isPresetMessage

function appendVerifiedBadge(s1: string) -- line: 80
	-- upvalues: Config (copy)
	return string.gsub(s1, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
end

local function v65(p1) -- line: 84
	-- upvalues: UserProfileStore (copy), SignalsReact (copy)
	local str = tostring(p1.userId)
	local v80 = UserProfileStore.get().fetchNamesByUserIds({ str })(false).data[1]
	local v81 = SignalsReact.useSignalBinding(v80.names.getDisplayName)
	local v82 = SignalsReact.useSignalBinding(v80.names.getInExperienceCombinedName)

	return {
		displayName = v81,
		inExperienceCombinedName = v82
	}
end

function trim(p2) -- line: 93
	if p2:match("^()%s*$") then
		return ""
	end

	return (p2:match("^%s*(.*%S)"))
end
function getMessageText(b1: boolean?, s2: string?, s3: string?) -- line: 97
	if s2 == nil or s2 == "" then
		return s3 or ""
	end

	if b1 then
		return s2 or ""
	end

	return s3 or ""
end

local function calculateTransparency(p3, p4) -- line: 107
	return p3 + p4 * (1 - p3)
end
local function setTransparency(p5, p6) -- line: 111
	return p6:map(function(p7) -- line: 112
		-- upvalues: p5 (copy)
		if p5 == nil then
			return 1
		end

		local v234 = p5

		return v234 + p7 * (1 - v234)
	end)
end
local function useARButtonRightPadding() -- line: 117
	-- upvalues: FFlagExpChatPresetChatEnabled (copy), FFlagExpChatTopBannerForPresetChatAccess (copy), useIsARButtonVisible (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), SignalsReact (copy), showChatEnabledUI (copy), isChatRegionLocked (copy)
	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		if useIsARButtonVisible() then
			return FIntExpChatVisibleARButtonPadding
		end

		return FIntExpChatDefaultARButtonPadding
	end

	local v91 = true

	if FFlagAEGIS2EnableGatesForExpChat then
		local v92 = GetChatStatusStore(false)
		local v93 = SignalsReact.useSignalState(v92.getChatStatus)

		v91 = showChatEnabledUI(v93)
	end

	if not isChatRegionLocked() and v91 then
		return FIntExpChatVisibleARButtonPadding
	end

	return FIntExpChatDefaultARButtonPadding
end
local function appendTrustedIndicator(s4: string, s5: string, n1: number, n2: number, p8) -- line: 142
	local v99 = p8.Color.Shift.Shift_300.Color3:ToHex()
	local Shift_300Transparency = p8.Color.Shift.Shift_300.Transparency
	local v101 = Shift_300Transparency + n1 * (1 - Shift_300Transparency)
	local v102 = p8.Color.Content.Emphasis.Color3:ToHex()
	local EmphasisTransparency = p8.Color.Content.Emphasis.Transparency
	local v104 = EmphasisTransparency + n1 * (1 - EmphasisTransparency)
	local v105 = n2 - 4
	local v106 = `{ `{ `{ `{ `<mark color='#{ v99 }' transparency='{ v101 }'>` }<font transparency='1' weight='{ 600 }' size='{ v105 }'><stroke transparency='1'>_` }<font color='#{ v102 }' transparency='{ v104 }'>{ s5 }</font>` }_</stroke></font>` }</mark>`

	if string.find(s4, ":([%S:]-)$") then
		return string.gsub(s4, ":([%S:]-)$", ` { v106 } :%1`)
	end

	return `{ s4 } { v106 }`
end

local v70 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function applyStyleToText(p9, p10, p11, n3: number?) -- line: 179
	-- upvalues: TextChatMessageChatActionType (copy), summaryMessageRichText (copy)
	local v111 = p10 or ""

	if p11.chatActionType == TextChatMessageChatActionType.Summary then
		v111 = summaryMessageRichText.wrapInSummaryMutedStyle(summaryMessageRichText.getSummaryIconPrefix(n3) .. " " .. v111, p9.Color.Content.Muted.Color3:ToHex(), n3)
	end

	return v111
end
local function v72(p12) -- line: 192
	-- upvalues: FFlagDebugMessageProfiling (copy), FFlagExpChatPerfTracking (copy), React (copy), ExpChatPerfTracker (copy), Localization (copy), FFlagExpChatRewriteInline (copy), FStringInExpChatRewriteLabelKey (copy), Foundation (copy), getMessageSettings (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), isExperienceChatUserProfileApiEnabled (copy), v65 (copy), getFFlagExpChatExcludeFOMORenders (copy), Signals (copy), Players (copy), v70 (copy), SignalsReact (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), useStore (copy), getFFlagExpChatUseUpdatedMessageRendered (copy), shouldSendHighFrequencyTelemetry (copy), v33 (copy), GetChannelTabsStore (copy), TextChatService (copy), appendTrustedIndicator (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPolishSummaryMessageUI (copy), TextChatMessageChatActionType (copy), summaryMessageRichText (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconRichText (copy), v31 (copy), duplicateInvisibleText (copy), FFlagExpChatEnableFocusNavigation (copy), useCursor (copy), FFlagEnableInExpChatRewrite (copy), useARButtonRightPadding (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), showChatEnabledUI (copy), isChatRegionLocked (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy), FIntExpChatWindowTransparencyRewriteInteractableThreshold (copy)
	if FFlagDebugMessageProfiling then
		debug.profilebegin("TranslatedTextMessage")
	end

	if FFlagExpChatPerfTracking then
		local v113 = p12.message.messageId or "UNKNOWN_MESSAGE_ID"

		React.useEffect(function() -- line: 198
			-- upvalues: ExpChatPerfTracker (copy), v113 (copy)
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
				messageId = v113
			})
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
				messageId = v113
			})
		end, { v113 })
	end

	local isSpatialUIEnabled = p12.isSpatialUIEnabled
	local v115 = if not isSpatialUIEnabled then p12.chatWindowSettings.TextSize else p12.chatWindowSettings.SpatialPanelTextSize
	local v116 = Localization.useLocalization({
		trustedLabelText = "CoreScripts.TextChat.ChatWindow.TrustedLabel",
		rewrittenLabelText = if not FFlagExpChatRewriteInline then nil else FStringInExpChatRewriteLabelKey,
		defaultRewrittenLabelText = if not FFlagExpChatRewriteInline then nil else "CoreScripts.TextChat.ChatWindow.RewrittenLabel"
	})
	local u117 = nil

	if FFlagExpChatRewriteInline then
		u117 = if not v116.rewrittenLabelText or v116.rewrittenLabelText == "" then v116.defaultRewrittenLabelText else v116.rewrittenLabelText
	end

	local v118 = Foundation.Hooks.useTokens()
	local v119 = getMessageSettings(p12.message, p12.chatWindowSettings)
	local showTranslationButton = p12.showTranslationButton
	local useTranslation = v119.useTranslation
	local v122 = getMessageText(useTranslation, v119.translation, v119.text)
	local v123 = v119.prefixText or ""
	local v124 = nil

	if GetFFlagTextChatEnableUniverseChatTabs() and p12.message.textChannel == nil then
		v124 = nil
	elseif isExperienceChatUserProfileApiEnabled() and p12.message.userId then
		if FFlagDebugMessageProfiling then
			debug.profilebegin("useCombinedName")
		end

		v124 = v65(p12.message)

		if FFlagDebugMessageProfiling then
			debug.profileend()
		end
	end

	local v125 = p12.message.userId and tostring(p12.message.userId)
	local v126 = if not getFFlagExpChatExcludeFOMORenders() then nil else p12.message.isHiddenMessage
	local v127 = React.useMemo(function() -- line: 251
		-- upvalues: Signals (copy), v125 (copy), Players (copy), v126 (copy), v70 (copy)
		return Signals.createComputed(function(p13) -- line: 252
			-- upvalues: v125 (copy), Players (copy), v126 (copy), v70 (copy)
			local v288 = v125 and v125 ~= ""
			local v289 = Players.LocalPlayer and (Players.LocalPlayer.UserId and tostring(Players.LocalPlayer.UserId))
			local v290 = v289 and v289 == v125

			if v288 and (not v290 and not v126) then
				return (v70.getIsTrustedConnection(v125).data(p13))
			end

			return nil
		end)
	end, {
		v125,
		v126
	})
	local v128 = SignalsReact.useSignalBinding(v127)
	local v129 = if not EngineFeatureExpChatGlobalChatEngineTelemetryEnabled or FFlagExpChatUseChannelTabsStore then nil else useStore()

	if getFFlagExpChatUseUpdatedMessageRendered() then
		React.useEffect(function() -- line: 273
			-- upvalues: p12 (copy), shouldSendHighFrequencyTelemetry (copy), v33 (copy), getFFlagExpChatExcludeFOMORenders (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), v129 (copy), TextChatService (copy)
			if p12.message.textChatMessageInstance and shouldSendHighFrequencyTelemetry(v33) and (not getFFlagExpChatExcludeFOMORenders() or not p12.message.isHiddenMessage) then
				if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
					local n4 = -1

					if FFlagExpChatUseChannelTabsStore then
						local v236 = GetChannelTabsStore(false)
						local v237 = v236.getChannelTabsState(false)
						local v238 = v236.getSelectedTabName(false)

						if v238 and v237.allChannelTabs[v238] then
							n4 = v237.allChannelTabs[v238].tabIndex
						end
					else
						local ChannelTabs = v129:getState().ChannelTabs
						local v240 = ChannelTabs and ChannelTabs.selectedTabName

						if v240 and ChannelTabs.allChannelTabs[v240] then
							n4 = ChannelTabs.allChannelTabs[v240].TabIndex
						end
					end

					TextChatService:SendExpChatMessageClientRendered(p12.message.textChatMessageInstance, "chat_window", n4)

					return
				end

				TextChatService:SendExpChatMessageClientRendered(p12.message.textChatMessageInstance, "chat_window")
			end
		end, {})
	end

	local bodyTextProperties = v119.bodyTextProperties
	local prefixTextProperties = v119.prefixTextProperties
	local v132 = if not isSpatialUIEnabled then bodyTextProperties.TextSize else v115
	local v133 = v132 - 2
	local v134 = React.joinBindings((if v124 == nil then {} else {
		v124.displayName,
		v124.inExperienceCombinedName
	})):map(function(p14) -- line: 318
		-- upvalues: v123 (copy), p12 (copy)
		local v242 = p14[1] or ""
		local v243 = p14[2] or ""
		local v244 = v123

		if string.len(v242) > 0 and (string.len(v243) > 0 and v242 ~= v243) then
			v244 = string.gsub(v244, v242, v243)
		end

		if string.len(v123) > 0 and p12.isUserVerified then
			v244 = appendVerifiedBadge(v244)
		end

		return v244
	end)
	local v135 = React.joinBindings({
		v134,
		v128,
		p12.textTransparency
	}):map(function(p15) -- line: 339
		-- upvalues: v123 (copy), appendTrustedIndicator (copy), v116 (copy), prefixTextProperties (copy), v118 (copy)
		local v246 = p15[1] or ""
		local v247 = p15[2] or false
		local v248 = p15[3]

		if v248 == nil then
			v248 = 1
		end

		if string.len(v123) == 0 then
			return v246
		end

		if v247 then
			v246 = appendTrustedIndicator(v246, v116.trustedLabelText, v248, prefixTextProperties.TextSize, v118)
		end

		return v246
	end)
	local v136 = v135:map(function(p16) -- line: 360
		-- upvalues: v123 (copy)
		if string.len(v123) == 0 then
			return p16
		end

		return trim(p16)
	end)
	local v137 = v135:map(function(p17) -- line: 367
		-- upvalues: v122 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPolishSummaryMessageUI (copy), v132 (copy), v118 (copy), p12 (copy), TextChatMessageChatActionType (copy), summaryMessageRichText (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconRichText (copy), v123 (copy), showTranslationButton (copy), v31 (copy), duplicateInvisibleText (copy), prefixTextProperties (copy)
		local v251 = v122

		if FFlagEnableInExpChatSummaryOnLua then
			local v252 = if not FFlagExpChatPolishSummaryMessageUI then nil else v132
			local v253 = v118
			local v254 = v122
			local message = p12.message

			v251 = v254 or ""

			if message.chatActionType == TextChatMessageChatActionType.Summary then
				v251 = summaryMessageRichText.wrapInSummaryMutedStyle(summaryMessageRichText.getSummaryIconPrefix(v252) .. " " .. v251, v253.Color.Content.Muted.Color3:ToHex(), v252)
			end
		end

		if FFlagExpChatPresetChatEnabled and isPresetMessage(p12.message) then
			v251 ..= (" %*"):format((getPresetIconRichText(v132)))
		end

		if string.len(v123) == 0 then
			if FFlagEnableInExpChatSummaryOnLua then
				return v251
			end

			return v122
		end

		if showTranslationButton then
			v251 = if not v31 then "   " .. v251 else "     " .. v251
		end

		return duplicateInvisibleText(p17, prefixTextProperties.FontFace, prefixTextProperties.TextSize) .. " " .. v251
	end)

	if FFlagExpChatRewriteInline then
		v137 = React.joinBindings({ v137 }):map(function(p18) -- line: 392
			-- upvalues: p12 (copy), Foundation (copy), prefixTextProperties (copy), v118 (copy), u117 (ref)
			local v257 = p18[1] or ""

			if not p12.wasRewritten then
				return v257
			end

			local v258 = if not p12.isRewriteMenuOpen then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp

			return `{ v257 } <font size='{ prefixTextProperties.TextSize - 4 }' color='#{ v118.Color.Content.Muted.Color3:ToHex() }'>{ `({ u117 })` }<font transparency='1'><stroke transparency='1'>_</stroke></font>{ `<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{ v258 }</font>` }</font>`
		end)
	end

	local v138 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local v140

	if FFlagEnableInExpChatRewrite then
		local v139 = useARButtonRightPadding()

		v140 = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v139)
		})
	else
		local v141 = true

		if FFlagAEGIS2EnableGatesForExpChat then
			local v142 = GetChatStatusStore(false)
			local v143 = SignalsReact.useSignalState(v142.getChatStatus)

			v141 = showChatEnabledUI(v143)
		end

		local v144 = not isChatRegionLocked() and v141

		v140 = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, if not v144 then FIntExpChatDefaultARButtonPadding else FIntExpChatVisibleARButtonPadding)
		})
	end

	local v145 = nil

	if FFlagExpChatRewriteInline and p12.wasRewritten then
		v145 = p12.chatWindowTransparencyBindable == nil or if typeof(p12.chatWindowTransparencyBindable) ~= "number" then p12.chatWindowTransparencyBindable:map(function(p19) -- line: 450
			-- upvalues: FIntExpChatWindowTransparencyRewriteInteractableThreshold (copy)
			return p19 < FIntExpChatWindowTransparencyRewriteInteractableThreshold
		end) else p12.chatWindowTransparencyBindable < FIntExpChatWindowTransparencyRewriteInteractableThreshold
	end

	local createElement = React.createElement
	local t1 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = p12.LayoutOrder
	}
	local t2 = {
		UIPadding = v140
	}
	local createElement2 = React.createElement
	local t3 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t4 = {}
	local v152 = false

	if string.len(v123) > 0 then
		local createElement3 = React.createElement
		local t5 = {
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = prefixTextProperties.FontFace,
			Text = v135,
			TextColor3 = prefixTextProperties.TextColor3,
			TextSize = prefixTextProperties.TextSize,
			TextStrokeColor3 = prefixTextProperties.TextStrokeColor3
		}
		local TextStrokeTransparency = prefixTextProperties.TextStrokeTransparency

		t5.TextStrokeTransparency = p12.textTransparency:map(function(p20) -- line: 112
			-- upvalues: TextStrokeTransparency (copy)
			if TextStrokeTransparency == nil then
				return 1
			end

			local v261 = TextStrokeTransparency

			return v261 + p20 * (1 - v261)
		end)

		local n5 = 0

		t5.TextTransparency = p12.textTransparency:map(function(p21) -- line: 112
			-- upvalues: n5 (copy)
			if n5 == nil then
				return 1
			end

			local v263 = n5

			return v263 + p21 * (1 - v263)
		end)
		t5.TextXAlignment = Enum.TextXAlignment.Left
		t5.TextYAlignment = Enum.TextYAlignment.Top
		v152 = createElement3("TextLabel", t5, {
			UIGradient = prefixTextProperties.UIGradient ~= nil and React.createElement("UIGradient", prefixTextProperties.UIGradient)
		})
	end

	t4.PrefixText = v152

	local createElement4 = React.createElement
	local v158 = (not FFlagExpChatRewriteInline or not p12.wasRewritten) and "TextLabel" or "TextButton"
	local t6 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = bodyTextProperties.FontFace,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 0),
		Text = v137,
		TextColor3 = bodyTextProperties.TextColor3,
		TextSize = v132,
		TextStrokeColor3 = bodyTextProperties.TextStrokeColor3
	}
	local TextStrokeTransparency = bodyTextProperties.TextStrokeTransparency

	t6.TextStrokeTransparency = p12.textTransparency:map(function(p22) -- line: 112
		-- upvalues: TextStrokeTransparency (copy)
		if TextStrokeTransparency == nil then
			return 1
		end

		local v265 = TextStrokeTransparency

		return v265 + p22 * (1 - v265)
	end)

	local n6 = 0

	t6.TextTransparency = p12.textTransparency:map(function(p23) -- line: 112
		-- upvalues: n6 (copy)
		if n6 == nil then
			return 1
		end

		local v267 = n6

		return v267 + p23 * (1 - v267)
	end)
	t6.TextWrapped = true
	t6.TextXAlignment = Enum.TextXAlignment.Left
	t6.TextYAlignment = Enum.TextYAlignment.Top
	t6[React.Event.Activated] = if not FFlagExpChatRewriteInline or not p12.wasRewritten then nil else p12.onTextBodyActivated
	t6.Interactable = v145
	t4.BodyText = createElement4(v158, t6)

	local v169

	if string.len(v123) ~= 0 then
		local createElement5 = React.createElement
		local t7 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local t8 = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			TextButton = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				FontFace = prefixTextProperties.FontFace,
				RichText = true,
				SelectionImageObject = v138,
				Size = UDim2.new(0, 0, 0, 0),
				Text = v136,
				TextSize = prefixTextProperties.TextSize,
				TextStrokeTransparency = 1,
				TextTransparency = 1,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 1,
				[React.Event.Activated] = function() -- line: 543
					-- upvalues: p12 (copy)
					p12.onTextMessageLabelButtonActivated(p12.message)
				end
			})
		}
		local v168

		if showTranslationButton then
			local createElement6 = React.createElement
			local t9 = {
				BackgroundTransparency = 1,
				HoverImage = "rbxasset://textures/translateIconDark.png",
				Image = "rbxasset://textures/translateIcon.png"
			}
			local n7 = 0

			t9.ImageTransparency = p12.textTransparency:map(function(p24) -- line: 112
				-- upvalues: n7 (copy)
				if n7 == nil then
					return 1
				end

				local v269 = n7

				return v269 + p24 * (1 - v269)
			end)
			t9.LayoutOrder = 2
			t9.PressedImage = "rbxasset://textures/translateIconDark.png"
			t9.SelectionImageObject = v138
			t9.Size = UDim2.new(0, v133, 0, v133)
			t9[React.Event.Activated] = function() -- line: 558
				-- upvalues: p12 (copy)
				p12.onToggle(not p12.message.useTranslation, p12.message.messageId)
			end
			v168 = createElement6("ImageButton", t9)
		else
			v168 = nil
		end

		t8.TranslationButton = v168
		v169 = createElement5("Frame", t7, t8)
	else
		v169 = nil
	end

	t4.TextMessageButton = v169
	t2.TextMessage = createElement2("Frame", t3, t4)

	local v170 = createElement("Frame", t1, t2)

	if FFlagDebugMessageProfiling then
		debug.profileend()
	end

	return v170
end
local function TranslatedTextMessageWithToggle(_) -- line: 573
	-- upvalues: RoactRodux (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), v72 (copy)
	return RoactRodux.connect(function() -- line: 574
	end, function(p26) -- line: 574
		-- upvalues: FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy)
		return {
			onToggle = function(b2: boolean, s6: string) -- line: 576
				-- upvalues: FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), p26 (copy)
				if FFlagExpChatUseMessagesStore then
					GetMessagesStore(false).toggleMessageTranslation(b2, s6)

					return
				end

				p26({
					type = "ChatTranslationMessageToggled",
					useTranslation = b2,
					messageId = s6
				})
			end
		}
	end)(v72)
end
local function RewriteLabelWithButton(p27) -- line: 592
	-- upvalues: Foundation (copy), Localization (copy), FStringInExpChatRewriteLabelKey (copy), React (copy)
	local v173 = Foundation.Hooks.useTokens()
	local v174 = Localization.useLocalization({
		defaultRewrittenLabelText = "CoreScripts.TextChat.ChatWindow.RewrittenLabel",
		rewrittenLabelText = FStringInExpChatRewriteLabelKey
	})
	local v175 = if not v174.rewrittenLabelText or v174.rewrittenLabelText == "" then v174.defaultRewrittenLabelText else v174.rewrittenLabelText
	local createElement = React.createElement
	local View = Foundation.View
	local t10 = {
		tag = "size-full-0 auto-y row align-y-center gap-xsmall",
		LayoutOrder = p27.LayoutOrder
	}
	local t11 = {}
	local createElement7 = React.createElement
	local FoundationText = Foundation.Text
	local t12 = {
		tag = "size-0-0 auto-xy text-caption-small text-align-x-left",
		LayoutOrder = 1,
		RichText = true,
		Text = "(" .. v175 .. ")"
	}
	local t13 = {
		Color3 = v173.Color.Content.Muted.Color3
	}
	local MutedTransparency = v173.Color.Content.Muted.Transparency

	t13.Transparency = p27.textTransparency:map(function(p28) -- line: 112
		-- upvalues: MutedTransparency (copy)
		if MutedTransparency == nil then
			return 1
		end

		local v272 = MutedTransparency

		return v272 + p28 * (1 - v272)
	end)
	t12.textStyle = t13

	local t14 = {
		Color = Color3.fromRGB(0, 0, 0)
	}
	local n8 = 0.5

	t14.Transparency = p27.textTransparency:map(function(p29) -- line: 112
		-- upvalues: n8 (copy)
		if n8 == nil then
			return 1
		end

		local v274 = n8

		return v274 + p29 * (1 - v274)
	end)
	t14.Thickness = v173.Stroke.Thin
	t12.stroke = t14
	t11.Label = createElement7(FoundationText, t12)
	t11.IconButton = React.createElement(Foundation.IconButton, {
		isCircular = true,
		LayoutOrder = 2,
		size = Foundation.Enums.InputSize.XSmall,
		icon = if not p27.isRewriteMenuOpen then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp,
		variant = Foundation.Enums.ButtonVariant.Utility,
		Visible = p27.textTransparency:map(function(p30) -- line: 630
			return p30 < 1
		end),
		onActivated = p27.onActivated
	})

	return createElement(View, t10, t11)
end
local function TranslatedTextMessageWrapper(p31) -- line: 638
	-- upvalues: getMessageSettings (copy), FFlagEnableInExpChatRewrite (copy), useARButtonRightPadding (copy), FIntExpChatDefaultARButtonPadding (copy), Localization (copy), FStringInExpChatRewriteReasonKey (copy), Foundation (copy), React (copy), FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy), FFlagExpChatRewriteInlineIxpEnabled (copy), IXPService (copy), FStringExpChatRewriteInlineIxpLayer (copy), FFlagExpChatRewriteInline (copy), Dictionary (copy), TranslatedTextMessageWithToggle (copy), v72 (copy), RewriteLabelWithButton (copy)
	local v188 = getMessageSettings(p31.message, p31.chatWindowSettings)
	local showTranslationButton = p31.showTranslationButton
	local v190 = nil
	local u191 = nil
	local u192 = nil
	local v193 = nil
	local originalText = nil
	local u195 = false
	local u196 = false
	local n9 = 0
	local s7 = ""

	if FFlagEnableInExpChatRewrite then
		n9 = math.max(useARButtonRightPadding() - FIntExpChatDefaultARButtonPadding, 0)

		local v199 = Localization.useLocalization({
			defaultRewrittenReasonLabelText = "CoreScripts.TextChat.ChatWindows.RewrittenReasonLabel",
			rewrittenReasonLabelText = FStringInExpChatRewriteReasonKey
		})

		s7 = if not v199.rewrittenReasonLabelText or v199.rewrittenReasonLabelText == "" then v199.defaultRewrittenReasonLabelText else v199.rewrittenReasonLabelText
		v190 = Foundation.Hooks.useTokens()

		local v200, v201 = React.useState(false)

		u191 = v200
		u192 = v201
		u196 = v188.wasRewritten
		originalText = v188.originalText
		u195 = u196 and (originalText ~= nil and originalText ~= "")
		v193 = React.useCallback(function() -- line: 669
			-- upvalues: FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy), p31 (copy), u191 (ref), u195 (ref), u192 (ref)
			if FFlagExpChatRewriteToggleAnalytics then
				ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.RewriteDropdownToggledConfig, {
					messageId = p31.message.messageId,
					isDropdownOpen = tostring(u191),
					showOriginalText = tostring(u195)
				}, ExpChatShared.Analytics.DefaultStandardizedFields)
			end

			u192(function(p32) -- line: 677
				return not p32
			end)
		end, {
			u191,
			u195,
			p31.message.messageId
		})

		if FFlagExpChatRewriteInlineIxpEnabled then
			React.useEffect(function() -- line: 683
				-- upvalues: u196 (ref), IXPService (copy), FStringExpChatRewriteInlineIxpLayer (copy)
				if u196 then
					IXPService:LogFlagLinkedUserLayerExposure(FStringExpChatRewriteInlineIxpLayer)
				end
			end, { u196 })
		end
	end

	local v202 = p31

	if FFlagExpChatRewriteInline and u196 then
		v202 = Dictionary.join(v202, {
			LayoutOrder = 1,
			isRewriteMenuOpen = u191,
			wasRewritten = u196,
			onTextBodyActivated = v193
		})
	elseif FFlagEnableInExpChatRewrite and u196 then
		v202 = Dictionary.join(v202, {
			LayoutOrder = 1
		})
	end

	local v203 = if not showTranslationButton then React.createElement(v72, v202) else React.createElement(TranslatedTextMessageWithToggle, v202)

	if FFlagEnableInExpChatRewrite and u196 then
		local createElement = React.createElement
		local View = Foundation.View
		local t15 = {
			tag = `size-full-0 auto-y align-y-top col{ not FFlagExpChatRewriteInline and "" or " gap-xsmall" }`,
			LayoutOrder = p31.LayoutOrder
		}
		local t16 = {
			UIPadding = if not u191 then nil else React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 4)
			}),
			TranslatedTextMessage = v203,
			RewriteLabelWithButton = if not u196 or FFlagExpChatRewriteInline then nil else React.createElement(RewriteLabelWithButton, {
				LayoutOrder = 2,
				onActivated = v193,
				isRewriteMenuOpen = u191,
				transparencyValue = p31.transparencyValue,
				textTransparency = p31.textTransparency
			})
		}
		local v229

		if u191 then
			local createElement8 = React.createElement
			local View2 = Foundation.View
			local t17 = {
				tag = "align-x-left col radius-medium gap-xxsmall padding-small",
				LayoutOrder = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -FIntExpChatDefaultARButtonPadding, 0, 0)
			}
			local t18 = {
				Color3 = v190.Color.Common.Scrim.Color3
			}
			local n10 = 0.7

			t18.Transparency = p31.transparencyValue:map(function(p33) -- line: 112
				-- upvalues: n10 (copy)
				if n10 == nil then
					return 1
				end

				local v277 = n10

				return v277 + p33 * (1 - v277)
			end)
			t17.backgroundStyle = t18

			local t19 = {}
			local v221

			if u195 then
				local createElement9 = React.createElement
				local FoundationText = Foundation.Text
				local t20 = {
					tag = "text-body-small text-align-x-left",
					LayoutOrder = 1,
					RichText = true,
					TextWrapped = true,
					Text = originalText,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, -n9, 0, 0)
				}
				local t21 = {
					Color3 = v190.Color.Content.Muted.Color3
				}
				local MutedTransparency = v190.Color.Content.Muted.Transparency

				t21.Transparency = p31.textTransparency:map(function(p34) -- line: 112
					-- upvalues: MutedTransparency (copy)
					if MutedTransparency == nil then
						return 1
					end

					local v279 = MutedTransparency

					return v279 + p34 * (1 - v279)
				end)
				t20.textStyle = t21

				local t22 = {
					Color = Color3.fromRGB(0, 0, 0)
				}
				local n11 = 0.5

				t22.Transparency = p31.textTransparency:map(function(p35) -- line: 112
					-- upvalues: n11 (copy)
					if n11 == nil then
						return 1
					end

					local v281 = n11

					return v281 + p35 * (1 - v281)
				end)
				t22.Thickness = v190.Stroke.Thin
				t20.stroke = t22
				v221 = createElement9(FoundationText, t20)
			else
				v221 = nil
			end

			t19.OriginalText = v221
			t19.Divider = if not u195 then nil else React.createElement(Foundation.Divider, {
				LayoutOrder = 2,
				orientation = Foundation.Enums.Orientation.Horizontal,
				Visible = p31.textTransparency:map(function(p36) -- line: 771
					return p36 < 1
				end),
				DividerVariant = Foundation.Enums.DividerVariant.Default
			})

			local createElement10 = React.createElement
			local FoundationText = Foundation.Text
			local t23 = {
				tag = "text-body-small text-align-x-left",
				LayoutOrder = 3,
				RichText = true,
				TextWrapped = true,
				Text = s7,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -n9, 0, 0)
			}
			local t24 = {
				Color3 = v190.Color.Content.Default.Color3
			}
			local DefaultTransparency = v190.Color.Content.Default.Transparency

			t24.Transparency = p31.textTransparency:map(function(p37) -- line: 112
				-- upvalues: DefaultTransparency (copy)
				if DefaultTransparency == nil then
					return 1
				end

				local v284 = DefaultTransparency

				return v284 + p37 * (1 - v284)
			end)
			t23.textStyle = t24

			local t25 = {
				Color = Color3.fromRGB(0, 0, 0)
			}
			local n12 = 0.5

			t25.Transparency = p31.textTransparency:map(function(p38) -- line: 112
				-- upvalues: n12 (copy)
				if n12 == nil then
					return 1
				end

				local v286 = n12

				return v286 + p38 * (1 - v286)
			end)
			t25.Thickness = v190.Stroke.Thin
			t23.stroke = t25
			t19.ReasoningText = createElement10(FoundationText, t23)
			v229 = createElement8(View2, t17, t19)
		else
			v229 = nil
		end

		t16.DropdownMenu = v229
		v203 = createElement(View, t15, t16)
	end

	return v203
end
local function areEqual(p39, p40) -- line: 811
	-- upvalues: FFlagEnableInExpChatRewrite (copy), FFlagExpChatRewriteInline (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
	local v232 = false

	if p39.message.text == p40.message.text then
		v232 = false

		if p39.message.prefixText == p40.message.prefixText then
			v232 = false

			if p39.message.translation == p40.message.translation then
				v232 = false

				if p39.message.useTranslation == p40.message.useTranslation then
					v232 = false

					if p39.message.messageId == p40.message.messageId then
						v232 = false

						if p39.chatWindowSettings == p40.chatWindowSettings then
							v232 = not FFlagEnableInExpChatRewrite or p39.message.wasRewritten == p40.message.wasRewritten and p39.message.originalText == p40.message.originalText

							if v232 then
								v232 = not FFlagExpChatRewriteInline or p39.chatWindowTransparencyBindable == p40.chatWindowTransparencyBindable

								if v232 then
									v232 = not FFlagEnableInExpChatSummaryOnLua or p39.message.chatActionType == p40.message.chatActionType

									if v232 then
										if FFlagExpChatPresetChatEnabled then
											return p39.message.presetId == p40.message.presetId
										end

										v232 = true
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return v232
end

return React.memo(TranslatedTextMessageWrapper, areEqual)
