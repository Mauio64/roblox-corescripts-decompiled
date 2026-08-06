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
local FFlagExpChatFixLocalUserVerifiedBadge = require(Flags.FFlagExpChatFixLocalUserVerifiedBadge)
local ExpChatShared = require(ExpChatParent2.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local useIsARButtonVisible = require(ExpChat.useIsARButtonVisible)
local isPresetMessage = ExpChatShared.isPresetMessage

function appendVerifiedBadge(s1: string) -- line: 81
	-- upvalues: Config (copy)
	return string.gsub(s1, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
end

local function v66(p1) -- line: 85
	-- upvalues: UserProfileStore (copy), SignalsReact (copy)
	local str = tostring(p1.userId)
	local v81 = UserProfileStore.get().fetchNamesByUserIds({ str })(false).data[1]
	local v82 = SignalsReact.useSignalBinding(v81.names.getDisplayName)
	local v83 = SignalsReact.useSignalBinding(v81.names.getInExperienceCombinedName)

	return {
		displayName = v82,
		inExperienceCombinedName = v83
	}
end

function trim(p2) -- line: 94
	if p2:match("^()%s*$") then
		return ""
	end

	return (p2:match("^%s*(.*%S)"))
end
function getMessageText(b1: boolean?, s2: string?, s3: string?) -- line: 98
	if s2 == nil or s2 == "" then
		return s3 or ""
	end

	if b1 then
		return s2 or ""
	end

	return s3 or ""
end

local function calculateTransparency(p3, p4) -- line: 108
	return p3 + p4 * (1 - p3)
end
local function setTransparency(p5, p6) -- line: 112
	return p6:map(function(p7) -- line: 113
		-- upvalues: p5 (copy)
		if p5 == nil then
			return 1
		end

		local v235 = p5

		return v235 + p7 * (1 - v235)
	end)
end
local function useARButtonRightPadding() -- line: 118
	-- upvalues: FFlagExpChatPresetChatEnabled (copy), FFlagExpChatTopBannerForPresetChatAccess (copy), useIsARButtonVisible (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), SignalsReact (copy), showChatEnabledUI (copy), isChatRegionLocked (copy)
	if FFlagExpChatPresetChatEnabled and FFlagExpChatTopBannerForPresetChatAccess then
		if useIsARButtonVisible() then
			return FIntExpChatVisibleARButtonPadding
		end

		return FIntExpChatDefaultARButtonPadding
	end

	local v92 = true

	if FFlagAEGIS2EnableGatesForExpChat then
		local v93 = GetChatStatusStore(false)
		local v94 = SignalsReact.useSignalState(v93.getChatStatus)

		v92 = showChatEnabledUI(v94)
	end

	if not isChatRegionLocked() and v92 then
		return FIntExpChatVisibleARButtonPadding
	end

	return FIntExpChatDefaultARButtonPadding
end
local function appendTrustedIndicator(s4: string, s5: string, n1: number, n2: number, p8) -- line: 143
	local v100 = p8.Color.Shift.Shift_300.Color3:ToHex()
	local Shift_300Transparency = p8.Color.Shift.Shift_300.Transparency
	local v102 = Shift_300Transparency + n1 * (1 - Shift_300Transparency)
	local v103 = p8.Color.Content.Emphasis.Color3:ToHex()
	local EmphasisTransparency = p8.Color.Content.Emphasis.Transparency
	local v105 = EmphasisTransparency + n1 * (1 - EmphasisTransparency)
	local v106 = n2 - 4
	local v107 = `{ `{ `{ `{ `<mark color='#{ v100 }' transparency='{ v102 }'>` }<font transparency='1' weight='{ 600 }' size='{ v106 }'><stroke transparency='1'>_` }<font color='#{ v103 }' transparency='{ v105 }'>{ s5 }</font>` }_</stroke></font>` }</mark>`

	if string.find(s4, ":([%S:]-)$") then
		return string.gsub(s4, ":([%S:]-)$", ` { v107 } :%1`)
	end

	return `{ s4 } { v107 }`
end

local v71 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function applyStyleToText(p9, p10, p11, n3: number?) -- line: 180
	-- upvalues: TextChatMessageChatActionType (copy), summaryMessageRichText (copy)
	local v112 = p10 or ""

	if p11.chatActionType == TextChatMessageChatActionType.Summary then
		v112 = summaryMessageRichText.wrapInSummaryMutedStyle(summaryMessageRichText.getSummaryIconPrefix(n3) .. " " .. v112, p9.Color.Content.Muted.Color3:ToHex(), n3)
	end

	return v112
end
local function v73(p12) -- line: 193
	-- upvalues: FFlagDebugMessageProfiling (copy), FFlagExpChatPerfTracking (copy), React (copy), ExpChatPerfTracker (copy), Localization (copy), FFlagExpChatRewriteInline (copy), FStringInExpChatRewriteLabelKey (copy), Foundation (copy), getMessageSettings (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), isExperienceChatUserProfileApiEnabled (copy), v66 (copy), getFFlagExpChatExcludeFOMORenders (copy), Signals (copy), Players (copy), v71 (copy), SignalsReact (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), useStore (copy), getFFlagExpChatUseUpdatedMessageRendered (copy), shouldSendHighFrequencyTelemetry (copy), v33 (copy), GetChannelTabsStore (copy), TextChatService (copy), appendTrustedIndicator (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPolishSummaryMessageUI (copy), TextChatMessageChatActionType (copy), summaryMessageRichText (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconRichText (copy), v31 (copy), duplicateInvisibleText (copy), FFlagExpChatEnableFocusNavigation (copy), useCursor (copy), FFlagEnableInExpChatRewrite (copy), useARButtonRightPadding (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), showChatEnabledUI (copy), isChatRegionLocked (copy), FIntExpChatVisibleARButtonPadding (copy), FIntExpChatDefaultARButtonPadding (copy), FIntExpChatWindowTransparencyRewriteInteractableThreshold (copy)
	if FFlagDebugMessageProfiling then
		debug.profilebegin("TranslatedTextMessage")
	end

	if FFlagExpChatPerfTracking then
		local v114 = p12.message.messageId or "UNKNOWN_MESSAGE_ID"

		React.useEffect(function() -- line: 199
			-- upvalues: ExpChatPerfTracker (copy), v114 (copy)
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
				messageId = v114
			})
			ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
				messageId = v114
			})
		end, { v114 })
	end

	local isSpatialUIEnabled = p12.isSpatialUIEnabled
	local v116 = if not isSpatialUIEnabled then p12.chatWindowSettings.TextSize else p12.chatWindowSettings.SpatialPanelTextSize
	local v117 = Localization.useLocalization({
		trustedLabelText = "CoreScripts.TextChat.ChatWindow.TrustedLabel",
		rewrittenLabelText = if not FFlagExpChatRewriteInline then nil else FStringInExpChatRewriteLabelKey,
		defaultRewrittenLabelText = if not FFlagExpChatRewriteInline then nil else "CoreScripts.TextChat.ChatWindow.RewrittenLabel"
	})
	local u118 = nil

	if FFlagExpChatRewriteInline then
		u118 = if not v117.rewrittenLabelText or v117.rewrittenLabelText == "" then v117.defaultRewrittenLabelText else v117.rewrittenLabelText
	end

	local v119 = Foundation.Hooks.useTokens()
	local v120 = getMessageSettings(p12.message, p12.chatWindowSettings)
	local showTranslationButton = p12.showTranslationButton
	local useTranslation = v120.useTranslation
	local v123 = getMessageText(useTranslation, v120.translation, v120.text)
	local v124 = v120.prefixText or ""
	local v125 = nil

	if GetFFlagTextChatEnableUniverseChatTabs() and p12.message.textChannel == nil then
		v125 = nil
	elseif isExperienceChatUserProfileApiEnabled() and p12.message.userId then
		if FFlagDebugMessageProfiling then
			debug.profilebegin("useCombinedName")
		end

		v125 = v66(p12.message)

		if FFlagDebugMessageProfiling then
			debug.profileend()
		end
	end

	local v126 = p12.message.userId and tostring(p12.message.userId)
	local v127 = if not getFFlagExpChatExcludeFOMORenders() then nil else p12.message.isHiddenMessage
	local v128 = React.useMemo(function() -- line: 252
		-- upvalues: Signals (copy), v126 (copy), Players (copy), v127 (copy), v71 (copy)
		return Signals.createComputed(function(p13) -- line: 253
			-- upvalues: v126 (copy), Players (copy), v127 (copy), v71 (copy)
			local v289 = v126 and v126 ~= ""
			local v290 = Players.LocalPlayer and (Players.LocalPlayer.UserId and tostring(Players.LocalPlayer.UserId))
			local v291 = v290 and v290 == v126

			if v289 and (not v291 and not v127) then
				return (v71.getIsTrustedConnection(v126).data(p13))
			end

			return nil
		end)
	end, {
		v126,
		v127
	})
	local v129 = SignalsReact.useSignalBinding(v128)
	local v130 = if not EngineFeatureExpChatGlobalChatEngineTelemetryEnabled or FFlagExpChatUseChannelTabsStore then nil else useStore()

	if getFFlagExpChatUseUpdatedMessageRendered() then
		React.useEffect(function() -- line: 274
			-- upvalues: p12 (copy), shouldSendHighFrequencyTelemetry (copy), v33 (copy), getFFlagExpChatExcludeFOMORenders (copy), EngineFeatureExpChatGlobalChatEngineTelemetryEnabled (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), v130 (copy), TextChatService (copy)
			if p12.message.textChatMessageInstance and shouldSendHighFrequencyTelemetry(v33) and (not getFFlagExpChatExcludeFOMORenders() or not p12.message.isHiddenMessage) then
				if EngineFeatureExpChatGlobalChatEngineTelemetryEnabled then
					local n4 = -1

					if FFlagExpChatUseChannelTabsStore then
						local v237 = GetChannelTabsStore(false)
						local v238 = v237.getChannelTabsState(false)
						local v239 = v237.getSelectedTabName(false)

						if v239 and v238.allChannelTabs[v239] then
							n4 = v238.allChannelTabs[v239].tabIndex
						end
					else
						local ChannelTabs = v130:getState().ChannelTabs
						local v241 = ChannelTabs and ChannelTabs.selectedTabName

						if v241 and ChannelTabs.allChannelTabs[v241] then
							n4 = ChannelTabs.allChannelTabs[v241].TabIndex
						end
					end

					TextChatService:SendExpChatMessageClientRendered(p12.message.textChatMessageInstance, "chat_window", n4)

					return
				end

				TextChatService:SendExpChatMessageClientRendered(p12.message.textChatMessageInstance, "chat_window")
			end
		end, {})
	end

	local bodyTextProperties = v120.bodyTextProperties
	local prefixTextProperties = v120.prefixTextProperties
	local v133 = if not isSpatialUIEnabled then bodyTextProperties.TextSize else v116
	local v134 = v133 - 2
	local v135 = React.joinBindings((if v125 == nil then {} else {
		v125.displayName,
		v125.inExperienceCombinedName
	})):map(function(p14) -- line: 319
		-- upvalues: v124 (copy), p12 (copy)
		local v243 = p14[1] or ""
		local v244 = p14[2] or ""
		local v245 = v124

		if string.len(v243) > 0 and (string.len(v244) > 0 and v243 ~= v244) then
			v245 = string.gsub(v245, v243, v244)
		end

		if string.len(v124) > 0 and p12.isUserVerified then
			v245 = appendVerifiedBadge(v245)
		end

		return v245
	end)
	local v136 = React.joinBindings({
		v135,
		v129,
		p12.textTransparency
	}):map(function(p15) -- line: 340
		-- upvalues: v124 (copy), appendTrustedIndicator (copy), v117 (copy), prefixTextProperties (copy), v119 (copy)
		local v247 = p15[1] or ""
		local v248 = p15[2] or false
		local v249 = p15[3]

		if v249 == nil then
			v249 = 1
		end

		if string.len(v124) == 0 then
			return v247
		end

		if v248 then
			v247 = appendTrustedIndicator(v247, v117.trustedLabelText, v249, prefixTextProperties.TextSize, v119)
		end

		return v247
	end)
	local v137 = v136:map(function(p16) -- line: 361
		-- upvalues: v124 (copy)
		if string.len(v124) == 0 then
			return p16
		end

		return trim(p16)
	end)
	local v138 = v136:map(function(p17) -- line: 368
		-- upvalues: v123 (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPolishSummaryMessageUI (copy), v133 (copy), v119 (copy), p12 (copy), TextChatMessageChatActionType (copy), summaryMessageRichText (copy), FFlagExpChatPresetChatEnabled (copy), isPresetMessage (copy), getPresetIconRichText (copy), v124 (copy), showTranslationButton (copy), v31 (copy), duplicateInvisibleText (copy), prefixTextProperties (copy)
		local v252 = v123

		if FFlagEnableInExpChatSummaryOnLua then
			local v253 = if not FFlagExpChatPolishSummaryMessageUI then nil else v133
			local v254 = v119
			local v255 = v123
			local message = p12.message

			v252 = v255 or ""

			if message.chatActionType == TextChatMessageChatActionType.Summary then
				v252 = summaryMessageRichText.wrapInSummaryMutedStyle(summaryMessageRichText.getSummaryIconPrefix(v253) .. " " .. v252, v254.Color.Content.Muted.Color3:ToHex(), v253)
			end
		end

		if FFlagExpChatPresetChatEnabled and isPresetMessage(p12.message) then
			v252 ..= (" %*"):format((getPresetIconRichText(v133)))
		end

		if string.len(v124) == 0 then
			if FFlagEnableInExpChatSummaryOnLua then
				return v252
			end

			return v123
		end

		if showTranslationButton then
			v252 = if not v31 then "   " .. v252 else "     " .. v252
		end

		return duplicateInvisibleText(p17, prefixTextProperties.FontFace, prefixTextProperties.TextSize) .. " " .. v252
	end)

	if FFlagExpChatRewriteInline then
		v138 = React.joinBindings({ v138 }):map(function(p18) -- line: 393
			-- upvalues: p12 (copy), Foundation (copy), prefixTextProperties (copy), v119 (copy), u118 (ref)
			local v258 = p18[1] or ""

			if not p12.wasRewritten then
				return v258
			end

			local v259 = if not p12.isRewriteMenuOpen then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp

			return `{ v258 } <font size='{ prefixTextProperties.TextSize - 4 }' color='#{ v119.Color.Content.Muted.Color3:ToHex() }'>{ `({ u118 })` }<font transparency='1'><stroke transparency='1'>_</stroke></font>{ `<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{ v259 }</font>` }</font>`
		end)
	end

	local v139 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local v141

	if FFlagEnableInExpChatRewrite then
		local v140 = useARButtonRightPadding()

		v141 = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, v140)
		})
	else
		local v142 = true

		if FFlagAEGIS2EnableGatesForExpChat then
			local v143 = GetChatStatusStore(false)
			local v144 = SignalsReact.useSignalState(v143.getChatStatus)

			v142 = showChatEnabledUI(v144)
		end

		local v145 = not isChatRegionLocked() and v142

		v141 = React.createElement("UIPadding", {
			PaddingRight = UDim.new(0, if not v145 then FIntExpChatDefaultARButtonPadding else FIntExpChatVisibleARButtonPadding)
		})
	end

	local v146 = nil

	if FFlagExpChatRewriteInline and p12.wasRewritten then
		v146 = p12.chatWindowTransparencyBindable == nil or if typeof(p12.chatWindowTransparencyBindable) ~= "number" then p12.chatWindowTransparencyBindable:map(function(p19) -- line: 451
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
		UIPadding = v141
	}
	local createElement2 = React.createElement
	local t3 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local t4 = {}
	local v153 = false

	if string.len(v124) > 0 then
		local createElement3 = React.createElement
		local t5 = {
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = prefixTextProperties.FontFace,
			Text = v136,
			TextColor3 = prefixTextProperties.TextColor3,
			TextSize = prefixTextProperties.TextSize,
			TextStrokeColor3 = prefixTextProperties.TextStrokeColor3
		}
		local TextStrokeTransparency = prefixTextProperties.TextStrokeTransparency

		t5.TextStrokeTransparency = p12.textTransparency:map(function(p20) -- line: 113
			-- upvalues: TextStrokeTransparency (copy)
			if TextStrokeTransparency == nil then
				return 1
			end

			local v262 = TextStrokeTransparency

			return v262 + p20 * (1 - v262)
		end)

		local n5 = 0

		t5.TextTransparency = p12.textTransparency:map(function(p21) -- line: 113
			-- upvalues: n5 (copy)
			if n5 == nil then
				return 1
			end

			local v264 = n5

			return v264 + p21 * (1 - v264)
		end)
		t5.TextXAlignment = Enum.TextXAlignment.Left
		t5.TextYAlignment = Enum.TextYAlignment.Top
		v153 = createElement3("TextLabel", t5, {
			UIGradient = prefixTextProperties.UIGradient ~= nil and React.createElement("UIGradient", prefixTextProperties.UIGradient)
		})
	end

	t4.PrefixText = v153

	local createElement4 = React.createElement
	local v159 = (not FFlagExpChatRewriteInline or not p12.wasRewritten) and "TextLabel" or "TextButton"
	local t6 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = bodyTextProperties.FontFace,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 0),
		Text = v138,
		TextColor3 = bodyTextProperties.TextColor3,
		TextSize = v133,
		TextStrokeColor3 = bodyTextProperties.TextStrokeColor3
	}
	local TextStrokeTransparency = bodyTextProperties.TextStrokeTransparency

	t6.TextStrokeTransparency = p12.textTransparency:map(function(p22) -- line: 113
		-- upvalues: TextStrokeTransparency (copy)
		if TextStrokeTransparency == nil then
			return 1
		end

		local v266 = TextStrokeTransparency

		return v266 + p22 * (1 - v266)
	end)

	local n6 = 0

	t6.TextTransparency = p12.textTransparency:map(function(p23) -- line: 113
		-- upvalues: n6 (copy)
		if n6 == nil then
			return 1
		end

		local v268 = n6

		return v268 + p23 * (1 - v268)
	end)
	t6.TextWrapped = true
	t6.TextXAlignment = Enum.TextXAlignment.Left
	t6.TextYAlignment = Enum.TextYAlignment.Top
	t6[React.Event.Activated] = if not FFlagExpChatRewriteInline or not p12.wasRewritten then nil else p12.onTextBodyActivated
	t6.Interactable = v146
	t4.BodyText = createElement4(v159, t6)

	local v170

	if string.len(v124) ~= 0 then
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
				SelectionImageObject = v139,
				Size = UDim2.new(0, 0, 0, 0),
				Text = v137,
				TextSize = prefixTextProperties.TextSize,
				TextStrokeTransparency = 1,
				TextTransparency = 1,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = 1,
				[React.Event.Activated] = function() -- line: 544
					-- upvalues: p12 (copy)
					p12.onTextMessageLabelButtonActivated(p12.message)
				end
			})
		}
		local v169

		if showTranslationButton then
			local createElement6 = React.createElement
			local t9 = {
				BackgroundTransparency = 1,
				HoverImage = "rbxasset://textures/translateIconDark.png",
				Image = "rbxasset://textures/translateIcon.png"
			}
			local n7 = 0

			t9.ImageTransparency = p12.textTransparency:map(function(p24) -- line: 113
				-- upvalues: n7 (copy)
				if n7 == nil then
					return 1
				end

				local v270 = n7

				return v270 + p24 * (1 - v270)
			end)
			t9.LayoutOrder = 2
			t9.PressedImage = "rbxasset://textures/translateIconDark.png"
			t9.SelectionImageObject = v139
			t9.Size = UDim2.new(0, v134, 0, v134)
			t9[React.Event.Activated] = function() -- line: 559
				-- upvalues: p12 (copy)
				p12.onToggle(not p12.message.useTranslation, p12.message.messageId)
			end
			v169 = createElement6("ImageButton", t9)
		else
			v169 = nil
		end

		t8.TranslationButton = v169
		v170 = createElement5("Frame", t7, t8)
	else
		v170 = nil
	end

	t4.TextMessageButton = v170
	t2.TextMessage = createElement2("Frame", t3, t4)

	local v171 = createElement("Frame", t1, t2)

	if FFlagDebugMessageProfiling then
		debug.profileend()
	end

	return v171
end
local function TranslatedTextMessageWithToggle(_) -- line: 574
	-- upvalues: RoactRodux (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), v73 (copy)
	return RoactRodux.connect(function() -- line: 575
	end, function(p26) -- line: 575
		-- upvalues: FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy)
		return {
			onToggle = function(b2: boolean, s6: string) -- line: 577
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
	end)(v73)
end
local function RewriteLabelWithButton(p27) -- line: 593
	-- upvalues: Foundation (copy), Localization (copy), FStringInExpChatRewriteLabelKey (copy), React (copy)
	local v174 = Foundation.Hooks.useTokens()
	local v175 = Localization.useLocalization({
		defaultRewrittenLabelText = "CoreScripts.TextChat.ChatWindow.RewrittenLabel",
		rewrittenLabelText = FStringInExpChatRewriteLabelKey
	})
	local v176 = if not v175.rewrittenLabelText or v175.rewrittenLabelText == "" then v175.defaultRewrittenLabelText else v175.rewrittenLabelText
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
		Text = "(" .. v176 .. ")"
	}
	local t13 = {
		Color3 = v174.Color.Content.Muted.Color3
	}
	local MutedTransparency = v174.Color.Content.Muted.Transparency

	t13.Transparency = p27.textTransparency:map(function(p28) -- line: 113
		-- upvalues: MutedTransparency (copy)
		if MutedTransparency == nil then
			return 1
		end

		local v273 = MutedTransparency

		return v273 + p28 * (1 - v273)
	end)
	t12.textStyle = t13

	local t14 = {
		Color = Color3.fromRGB(0, 0, 0)
	}
	local n8 = 0.5

	t14.Transparency = p27.textTransparency:map(function(p29) -- line: 113
		-- upvalues: n8 (copy)
		if n8 == nil then
			return 1
		end

		local v275 = n8

		return v275 + p29 * (1 - v275)
	end)
	t14.Thickness = v174.Stroke.Thin
	t12.stroke = t14
	t11.Label = createElement7(FoundationText, t12)
	t11.IconButton = React.createElement(Foundation.IconButton, {
		isCircular = true,
		LayoutOrder = 2,
		size = Foundation.Enums.InputSize.XSmall,
		icon = if not p27.isRewriteMenuOpen then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp,
		variant = Foundation.Enums.ButtonVariant.Utility,
		Visible = p27.textTransparency:map(function(p30) -- line: 631
			return p30 < 1
		end),
		onActivated = p27.onActivated
	})

	return createElement(View, t10, t11)
end
local function TranslatedTextMessageWrapper(p31) -- line: 639
	-- upvalues: getMessageSettings (copy), FFlagEnableInExpChatRewrite (copy), useARButtonRightPadding (copy), FIntExpChatDefaultARButtonPadding (copy), Localization (copy), FStringInExpChatRewriteReasonKey (copy), Foundation (copy), React (copy), FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy), FFlagExpChatRewriteInlineIxpEnabled (copy), IXPService (copy), FStringExpChatRewriteInlineIxpLayer (copy), FFlagExpChatRewriteInline (copy), Dictionary (copy), TranslatedTextMessageWithToggle (copy), v73 (copy), RewriteLabelWithButton (copy)
	local v189 = getMessageSettings(p31.message, p31.chatWindowSettings)
	local showTranslationButton = p31.showTranslationButton
	local v191 = nil
	local u192 = nil
	local u193 = nil
	local v194 = nil
	local originalText = nil
	local u196 = false
	local u197 = false
	local n9 = 0
	local s7 = ""

	if FFlagEnableInExpChatRewrite then
		n9 = math.max(useARButtonRightPadding() - FIntExpChatDefaultARButtonPadding, 0)

		local v200 = Localization.useLocalization({
			defaultRewrittenReasonLabelText = "CoreScripts.TextChat.ChatWindows.RewrittenReasonLabel",
			rewrittenReasonLabelText = FStringInExpChatRewriteReasonKey
		})

		s7 = if not v200.rewrittenReasonLabelText or v200.rewrittenReasonLabelText == "" then v200.defaultRewrittenReasonLabelText else v200.rewrittenReasonLabelText
		v191 = Foundation.Hooks.useTokens()

		local v201, v202 = React.useState(false)

		u192 = v201
		u193 = v202
		u197 = v189.wasRewritten
		originalText = v189.originalText
		u196 = u197 and (originalText ~= nil and originalText ~= "")
		v194 = React.useCallback(function() -- line: 670
			-- upvalues: FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy), p31 (copy), u192 (ref), u196 (ref), u193 (ref)
			if FFlagExpChatRewriteToggleAnalytics then
				ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.RewriteDropdownToggledConfig, {
					messageId = p31.message.messageId,
					isDropdownOpen = tostring(u192),
					showOriginalText = tostring(u196)
				}, ExpChatShared.Analytics.DefaultStandardizedFields)
			end

			u193(function(p32) -- line: 678
				return not p32
			end)
		end, {
			u192,
			u196,
			p31.message.messageId
		})

		if FFlagExpChatRewriteInlineIxpEnabled then
			React.useEffect(function() -- line: 684
				-- upvalues: u197 (ref), IXPService (copy), FStringExpChatRewriteInlineIxpLayer (copy)
				if u197 then
					IXPService:LogFlagLinkedUserLayerExposure(FStringExpChatRewriteInlineIxpLayer)
				end
			end, { u197 })
		end
	end

	local v203 = p31

	if FFlagExpChatRewriteInline and u197 then
		v203 = Dictionary.join(v203, {
			LayoutOrder = 1,
			isRewriteMenuOpen = u192,
			wasRewritten = u197,
			onTextBodyActivated = v194
		})
	elseif FFlagEnableInExpChatRewrite and u197 then
		v203 = Dictionary.join(v203, {
			LayoutOrder = 1
		})
	end

	local v204 = if not showTranslationButton then React.createElement(v73, v203) else React.createElement(TranslatedTextMessageWithToggle, v203)

	if FFlagEnableInExpChatRewrite and u197 then
		local createElement = React.createElement
		local View = Foundation.View
		local t15 = {
			tag = `size-full-0 auto-y align-y-top col{ not FFlagExpChatRewriteInline and "" or " gap-xsmall" }`,
			LayoutOrder = p31.LayoutOrder
		}
		local t16 = {
			UIPadding = if not u192 then nil else React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 4)
			}),
			TranslatedTextMessage = v204,
			RewriteLabelWithButton = if not u197 or FFlagExpChatRewriteInline then nil else React.createElement(RewriteLabelWithButton, {
				LayoutOrder = 2,
				onActivated = v194,
				isRewriteMenuOpen = u192,
				transparencyValue = p31.transparencyValue,
				textTransparency = p31.textTransparency
			})
		}
		local v230

		if u192 then
			local createElement8 = React.createElement
			local View2 = Foundation.View
			local t17 = {
				tag = "align-x-left col radius-medium gap-xxsmall padding-small",
				LayoutOrder = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, -FIntExpChatDefaultARButtonPadding, 0, 0)
			}
			local t18 = {
				Color3 = v191.Color.Common.Scrim.Color3
			}
			local n10 = 0.7

			t18.Transparency = p31.transparencyValue:map(function(p33) -- line: 113
				-- upvalues: n10 (copy)
				if n10 == nil then
					return 1
				end

				local v278 = n10

				return v278 + p33 * (1 - v278)
			end)
			t17.backgroundStyle = t18

			local t19 = {}
			local v222

			if u196 then
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
					Color3 = v191.Color.Content.Muted.Color3
				}
				local MutedTransparency = v191.Color.Content.Muted.Transparency

				t21.Transparency = p31.textTransparency:map(function(p34) -- line: 113
					-- upvalues: MutedTransparency (copy)
					if MutedTransparency == nil then
						return 1
					end

					local v280 = MutedTransparency

					return v280 + p34 * (1 - v280)
				end)
				t20.textStyle = t21

				local t22 = {
					Color = Color3.fromRGB(0, 0, 0)
				}
				local n11 = 0.5

				t22.Transparency = p31.textTransparency:map(function(p35) -- line: 113
					-- upvalues: n11 (copy)
					if n11 == nil then
						return 1
					end

					local v282 = n11

					return v282 + p35 * (1 - v282)
				end)
				t22.Thickness = v191.Stroke.Thin
				t20.stroke = t22
				v222 = createElement9(FoundationText, t20)
			else
				v222 = nil
			end

			t19.OriginalText = v222
			t19.Divider = if not u196 then nil else React.createElement(Foundation.Divider, {
				LayoutOrder = 2,
				orientation = Foundation.Enums.Orientation.Horizontal,
				Visible = p31.textTransparency:map(function(p36) -- line: 772
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
				Color3 = v191.Color.Content.Default.Color3
			}
			local DefaultTransparency = v191.Color.Content.Default.Transparency

			t24.Transparency = p31.textTransparency:map(function(p37) -- line: 113
				-- upvalues: DefaultTransparency (copy)
				if DefaultTransparency == nil then
					return 1
				end

				local v285 = DefaultTransparency

				return v285 + p37 * (1 - v285)
			end)
			t23.textStyle = t24

			local t25 = {
				Color = Color3.fromRGB(0, 0, 0)
			}
			local n12 = 0.5

			t25.Transparency = p31.textTransparency:map(function(p38) -- line: 113
				-- upvalues: n12 (copy)
				if n12 == nil then
					return 1
				end

				local v287 = n12

				return v287 + p38 * (1 - v287)
			end)
			t25.Thickness = v191.Stroke.Thin
			t23.stroke = t25
			t19.ReasoningText = createElement10(FoundationText, t23)
			v230 = createElement8(View2, t17, t19)
		else
			v230 = nil
		end

		t16.DropdownMenu = v230
		v204 = createElement(View, t15, t16)
	end

	return v204
end
local function areEqual(p39, p40) -- line: 812
	-- upvalues: FFlagExpChatFixLocalUserVerifiedBadge (copy), FFlagEnableInExpChatRewrite (copy), FFlagExpChatRewriteInline (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagExpChatPresetChatEnabled (copy)
	local v233 = false

	if p39.message.text == p40.message.text then
		v233 = false

		if p39.message.prefixText == p40.message.prefixText then
			v233 = false

			if p39.message.translation == p40.message.translation then
				v233 = false

				if p39.message.useTranslation == p40.message.useTranslation then
					v233 = false

					if p39.message.messageId == p40.message.messageId then
						v233 = not FFlagExpChatFixLocalUserVerifiedBadge or p39.message.userId == p40.message.userId and p39.isUserVerified == p40.isUserVerified

						if v233 then
							v233 = false

							if p39.chatWindowSettings == p40.chatWindowSettings then
								v233 = not FFlagEnableInExpChatRewrite or p39.message.wasRewritten == p40.message.wasRewritten and p39.message.originalText == p40.message.originalText

								if v233 then
									v233 = not FFlagExpChatRewriteInline or p39.chatWindowTransparencyBindable == p40.chatWindowTransparencyBindable

									if v233 then
										v233 = not FFlagEnableInExpChatSummaryOnLua or p39.message.chatActionType == p40.message.chatActionType

										if v233 then
											if FFlagExpChatPresetChatEnabled then
												return p39.message.presetId == p40.message.presetId
											end

											v233 = true
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return v233
end

return React.memo(TranslatedTextMessageWrapper, areEqual)
