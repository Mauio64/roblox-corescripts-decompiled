local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Foundation = require(ExpChatParent.Foundation)
local React = require(ExpChatParent.React)
local UIBlox = require(ExpChatParent.UIBlox)
local Localization = require(ExpChat.Localization)
local Flags = ExpChat.Flags
local FFlagExpChatEnableFocusNavigation = require(Flags.FFlagExpChatEnableFocusNavigation)
local FFlagDebugMessageProfiling = require(Flags.FFlagDebugMessageProfiling)
local FFlagEnableInExpChatRewrite = require(Flags.FFlagEnableInExpChatRewrite)
local FFlagExpChatRewriteInline = require(Flags.FFlagExpChatRewriteInline)
local FFlagExpChatRewriteToggleAnalytics = require(Flags.FFlagExpChatRewriteToggleAnalytics)
local FStringInExpChatRewriteLabelKey = require(Flags.FStringInExpChatRewriteLabelKey)
local FIntExpChatWindowTransparencyRewriteInteractableThreshold = require(Flags.FIntExpChatWindowTransparencyRewriteInteractableThreshold)
local FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 = require(Flags.FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2)
local FFlagExpChatPolishSummaryMessageUI = require(Flags.FFlagExpChatPolishSummaryMessageUI)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatLiftMessageV2Utils = require(Flags.FFlagExpChatLiftMessageV2Utils)
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local summaryMessageRichText = require(ExpChat.summaryMessageRichText)
local RewriteToggle = require(script.Parent.RewriteToggle)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetRewriteDropdownStore = require(ExpChat.Stores.GetRewriteDropdownStore)
local FFlagLuaAppPerfTrackerUseLogger = require(ExpChatParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger
local v27 = game:DefineFastFlag("ExpChatMessageV2PerfTracking3", false) and FFlagLuaAppPerfTrackerUseLogger
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local getMessageTextSize = require(ExpChatParent.ChatUIPrimitives).Utils.getMessageTextSize
local useFinishChatWindowMessageRenderIntervals = require(ExpChatParent.ChatUIPrimitives).Hooks.useFinishChatWindowMessageRenderIntervals
local useCursor = UIBlox.App.SelectionCursor.useCursor
local Config = require(ExpChat.Config)
local Helpers = ExpChat.ChatWindow.Helpers
local duplicateInvisibleText = require(Helpers.duplicateInvisibleText)
local mergeBindableScalar = require(Helpers.mergeBindableScalar)

local function calculateTransparency(n1: number, n2: number) -- line: 50
	return n1 + n2 * (1 - n1)
end
local function appendVerifiedBadge(s1: string) -- line: 54
	-- upvalues: Config (copy)
	return string.gsub(s1, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
end
local function trim(s2: string) -- line: 58
	if s2:match("^()%s*$") then
		return ""
	end

	return (s2:match("^%s*(.*%S)"))
end
local function getPropertyFromObjBinding(p1, s3: string) -- line: 62
	return p1:map(function(p2) -- line: 66
		-- upvalues: s3 (copy)
		if p2 then
			return p2[s3]
		end

		return nil
	end)
end
local function appendTrustedIndicator(s4: string, s5: string, n3: number, n4: number, p3) -- line: 71
	local v53 = p3.Color.Shift.Shift_300.Color3:ToHex()
	local Shift_300Transparency = p3.Color.Shift.Shift_300.Transparency
	local v55 = Shift_300Transparency + n3 * (1 - Shift_300Transparency)
	local v56 = p3.Color.Content.Emphasis.Color3:ToHex()
	local EmphasisTransparency = p3.Color.Content.Emphasis.Transparency
	local v58 = EmphasisTransparency + n3 * (1 - EmphasisTransparency)
	local v59 = n4 - 4
	local v60 = `{ `{ `{ `{ `<mark color='#{ v53 }' transparency='{ v55 }'>` }<font transparency='1' weight='{ 600 }' size='{ v59 }'><stroke transparency='1'>_` }<font color='#{ v56 }' transparency='{ v58 }'>{ s5 }</font>` }_</stroke></font>` }</mark>`

	if string.find(s4, ":([%S:]-)$") then
		return string.gsub(s4, ":([%S:]-)$", ` { v60 } :%1`)
	end

	return `{ s4 } { v60 }`
end
local function TranslatedTextMessage(t1: {[any]: any}) -- line: 130
	-- upvalues: FFlagDebugMessageProfiling (copy), FFlagExpChatLiftMessageV2Utils (copy), getMessageTextSize (copy), Localization (copy), FFlagExpChatRewriteInline (copy), FFlagEnableInExpChatRewrite (copy), FStringInExpChatRewriteLabelKey (copy), Foundation (copy), React (copy), v27 (copy), useFinishChatWindowMessageRenderIntervals (copy), ExpChatPerfTracker (copy), GetMessagesStore (copy), GetRewriteDropdownStore (copy), FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy), Config (copy), appendTrustedIndicator (copy), trim (copy), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), FFlagExpChatPolishSummaryMessageUI (copy), FFlagExpChatPresetChatEnabled (copy), getPresetIconRichText (copy), TextChatMessageChatActionType (copy), summaryMessageRichText (copy), duplicateInvisibleText (copy), FIntExpChatWindowTransparencyRewriteInteractableThreshold (copy), FFlagExpChatEnableFocusNavigation (copy), useCursor (copy), mergeBindableScalar (copy), RewriteToggle (copy)
	if FFlagDebugMessageProfiling then
		debug.profilebegin("TranslatedTextMessage")
	end

	local isSpatialUIEnabled = t1.isSpatialUIEnabled
	local v63 = if not FFlagExpChatLiftMessageV2Utils then if not isSpatialUIEnabled then t1.chatWindowSettings.TextSize else t1.chatWindowSettings.SpatialPanelTextSize else getMessageTextSize(t1.chatWindowSettings, isSpatialUIEnabled)
	local v64 = Localization.useLocalization({
		trustedLabelText = "CoreScripts.TextChat.ChatWindow.TrustedLabel",
		rewrittenLabelText = if not FFlagExpChatRewriteInline or not FFlagEnableInExpChatRewrite then nil else FStringInExpChatRewriteLabelKey,
		defaultRewrittenLabelText = if not FFlagExpChatRewriteInline or not FFlagEnableInExpChatRewrite then nil else "CoreScripts.TextChat.ChatWindow.RewrittenLabel"
	})
	local u65 = nil

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		u65 = if not v64.rewrittenLabelText or v64.rewrittenLabelText == "" then v64.defaultRewrittenLabelText else v64.rewrittenLabelText
	end

	local v66 = Foundation.Hooks.useTokens()
	local v67 = if not FFlagExpChatLiftMessageV2Utils then nil else React.useCallback(function() -- line: 169
		-- upvalues: t1 (copy)
		if t1.message and t1.message.current then
			return t1.message.current.messageId
		end

		return nil
	end, { t1.message })
	local v68 = if not v27 then nil else if not FFlagExpChatLiftMessageV2Utils then React.useCallback(function() -- line: 179
		-- upvalues: t1 (copy), ExpChatPerfTracker (copy)
		local v129 = t1.message.current.messageId or "UNKNOWN_MESSAGE_ID"

		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
			messageId = v129
		})
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
			messageId = v129
		})
	end, { t1.message }) else useFinishChatWindowMessageRenderIntervals(v67)
	local v69 = if not v27 then nil else React.useCallback(function(p4) -- line: 192
		-- upvalues: v68 (copy)
		if p4 and (p4.Text and p4.Text ~= "") then
			v68()
		end
	end, { v68 })
	local v70 = React.useCallback(function() -- line: 199
		-- upvalues: t1 (copy)
		t1.onTextMessageLabelButtonActivated(t1.message.current)
	end, { t1.onTextMessageLabelButtonActivated })
	local v71 = React.useCallback(function() -- line: 203
		-- upvalues: t1 (copy), GetMessagesStore (copy)
		local current = t1.message.current

		GetMessagesStore(false).toggleMessageTranslation(not current.useTranslation, current.messageId)
	end, {})
	local v72 = nil

	if FFlagEnableInExpChatRewrite then
		v72 = React.useCallback(function() -- line: 211
			-- upvalues: t1 (copy), GetRewriteDropdownStore (copy), FFlagExpChatRewriteToggleAnalytics (copy), ExpChatShared (copy)
			local current = t1.message.current

			if current and current.messageId then
				local v133 = GetRewriteDropdownStore(false)

				if FFlagExpChatRewriteToggleAnalytics then
					local v134 = v133.getOpenMessageId(false) == current.messageId
					local v135 = current.wasRewritten and (current.originalText ~= nil and current.originalText ~= "")

					ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.RewriteDropdownToggledConfig, {
						messageId = current.messageId,
						isDropdownOpen = tostring(v134),
						showOriginalText = tostring(v135)
					}, ExpChatShared.Analytics.DefaultStandardizedFields)
				end

				v133.toggleDropdown(current.messageId)
			end
		end, { t1.message })
	end

	local t2 = {
		t1.originalPrefixText,
		t1.isUserVerified
	}

	table.insert(t2, t1.isTrustedConnection)
	table.insert(t2, t1.textTransparency)
	table.insert(t2, t1.prefixTextProperties)

	local v74 = React.joinBindings(t2):map(function(p5) -- line: 236
		-- upvalues: Config (copy), appendTrustedIndicator (copy), v64 (copy), v66 (copy)
		local v137 = p5[1]
		local v138 = p5[2]

		if string.len(v137) > 0 then
			if v138 then
				v137 = string.gsub(v137, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
			end

			local v139 = p5[3] or false
			local v140 = if p5[4] ~= nil then p5[4] else 1
			local v141 = p5[5]

			if v139 then
				v137 = appendTrustedIndicator(v137, v64.trustedLabelText, v140, v141.TextSize, v66)
			end
		end

		return v137
	end)
	local v75 = v74:map(trim)
	local v76 = t1.bodyTextProperties:map(function(p6) -- line: 265
		-- upvalues: isSpatialUIEnabled (copy), v63 (copy)
		if isSpatialUIEnabled then
			return v63
		end

		return p6.TextSize
	end)
	local t3 = {
		v74,
		t1.shouldShowTranslationToggle,
		t1.originalBodyText,
		t1.prefixTextProperties
	}

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		table.insert(t3, t1.wasRewritten)
		table.insert(t3, t1.isRewriteWindowOpen)
	end

	local u78 = nil

	if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
		u78 = #t3 + 1
		table.insert(t3, t1.chatActionType)
	end

	local u79 = nil

	if FFlagExpChatPolishSummaryMessageUI or FFlagExpChatPresetChatEnabled then
		u79 = #t3 + 1
		table.insert(t3, v76)
	end

	local u80 = nil

	if FFlagExpChatPresetChatEnabled and t1.isPresetMessage ~= nil then
		u80 = #t3 + 1
		table.insert(t3, t1.isPresetMessage)
	end

	local v81 = React.joinBindings(t3):map(function(p7) -- line: 295
		-- upvalues: FFlagExpChatPresetChatEnabled (copy), u80 (ref), getPresetIconRichText (copy), u79 (ref), FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 (copy), u78 (ref), TextChatMessageChatActionType (copy), FFlagExpChatPolishSummaryMessageUI (copy), summaryMessageRichText (copy), v66 (copy), duplicateInvisibleText (copy), FFlagExpChatRewriteInline (copy), FFlagEnableInExpChatRewrite (copy), Foundation (copy), u65 (ref)
		local v144 = p7[1]
		local v145 = p7[2]
		local v146 = p7[3]
		local v147 = p7[4]

		if FFlagExpChatPresetChatEnabled and (u80 ~= nil and p7[u80]) then
			v146 ..= (" %*"):format((getPresetIconRichText(p7[u79])))
		end

		if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 and p7[u78] == TextChatMessageChatActionType.Summary then
			local v148 = nil

			if FFlagExpChatPolishSummaryMessageUI then
				v148 = p7[u79]
			end

			v146 = summaryMessageRichText.wrapInSummaryMutedStyle(summaryMessageRichText.getSummaryIconPrefix(v148) .. " " .. v146, v66.Color.Content.Muted.Color3:ToHex(), v148)
		end

		if string.len(v144) > 0 then
			if v145 then
				v146 = "     " .. v146
			end

			v146 = duplicateInvisibleText(v144, v147.FontFace, v147.TextSize) .. " " .. v146
		end

		if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
			local v149 = p7[5]
			local v150 = p7[6]

			if v149 then
				local v151 = if not v150 then Foundation.Enums.IconName.ChevronLargeDown else Foundation.Enums.IconName.ChevronLargeUp

				v146 = `{ v146 } <font size='{ v147.TextSize - 4 }' color='#{ v66.Color.Content.Muted.Color3:ToHex() }'>{ `({ u65 })` }<font transparency='1'><stroke transparency='1'>_</stroke></font>{ `<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{ v151 }</font>` }</font>`
			end
		end

		return v146
	end)
	local v82 = v76:map(function(p8) -- line: 354
		return UDim2.new(0, p8 - 2, 0, p8 - 2)
	end)
	local v83 = t1.originalPrefixText:map(function(p9) -- line: 357
		return string.len(p9) > 0
	end)
	local s6 = "UIGradient"
	local v85 = t1.prefixTextProperties:map(function(p10) -- line: 66
		-- upvalues: s6 (copy)
		if p10 then
			return p10[s6]
		end

		return nil
	end)
	local v86 = nil
	local v87 = nil

	if FFlagEnableInExpChatRewrite then
		local wasRewritten = t1.wasRewritten

		v86 = wasRewritten:map(function(p11) -- line: 367
			-- upvalues: FFlagExpChatRewriteInline (copy)
			return p11 and not FFlagExpChatRewriteInline
		end)

		if FFlagExpChatRewriteInline then
			local chatWindowTransparencyBindable = t1.chatWindowTransparencyBindable

			if chatWindowTransparencyBindable == nil then
				v87 = wasRewritten
			elseif typeof(chatWindowTransparencyBindable) == "number" then
				local v90 = chatWindowTransparencyBindable < FIntExpChatWindowTransparencyRewriteInteractableThreshold

				v87 = wasRewritten:map(function(p12) -- line: 378
					-- upvalues: v90 (copy)
					return p12 and v90
				end)
			else
				v87 = React.joinBindings({
					wasRewritten,
					chatWindowTransparencyBindable
				}):map(function(p13) -- line: 385
					-- upvalues: FIntExpChatWindowTransparencyRewriteInteractableThreshold (copy)
					return p13[1] and p13[2] < FIntExpChatWindowTransparencyRewriteInteractableThreshold
				end)
			end
		end
	end

	local v91 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()
	local createElement = React.createElement
	local t4 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = t1.layoutOrder,
		Visible = t1.visible
	}
	local t5 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingRight = t1.arButtonPadding
		}),
		ColumnLayout = if not FFlagEnableInExpChatRewrite or FFlagExpChatRewriteInline then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local createElement2 = React.createElement
	local t6 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = if not FFlagEnableInExpChatRewrite then nil else 1
	}
	local t7 = {}
	local createElement3 = React.createElement
	local t8 = {
		BackgroundTransparency = 1,
		RichText = true,
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local s7 = "FontFace"

	t8.FontFace = t1.prefixTextProperties:map(function(p14) -- line: 66
		-- upvalues: s7 (copy)
		if p14 then
			return p14[s7]
		end

		return nil
	end)
	t8.Text = v74

	local s8 = "TextColor3"

	t8.TextColor3 = t1.prefixTextProperties:map(function(p15) -- line: 66
		-- upvalues: s8 (copy)
		if p15 then
			return p15[s8]
		end

		return nil
	end)

	local s9 = "TextSize"

	t8.TextSize = t1.prefixTextProperties:map(function(p16) -- line: 66
		-- upvalues: s9 (copy)
		if p16 then
			return p16[s9]
		end

		return nil
	end)

	local s10 = "TextStrokeColor3"

	t8.TextStrokeColor3 = t1.prefixTextProperties:map(function(p17) -- line: 66
		-- upvalues: s10 (copy)
		if p17 then
			return p17[s10]
		end

		return nil
	end)

	local s11 = "TextStrokeTransparency"

	t8.TextStrokeTransparency = mergeBindableScalar(t1.prefixTextProperties:map(function(p18) -- line: 66
		-- upvalues: s11 (copy)
		if p18 then
			return p18[s11]
		end

		return nil
	end), t1.textTransparency)
	t8.TextTransparency = mergeBindableScalar(0, t1.textTransparency)
	t8.TextXAlignment = Enum.TextXAlignment.Left
	t8.TextYAlignment = Enum.TextYAlignment.Top
	t8.Visible = v83

	local t9 = {}
	local createElement4 = React.createElement
	local t10 = {}
	local s12 = "Enabled"

	t10.Enabled = v85:map(function(p19) -- line: 66
		-- upvalues: s12 (copy)
		if p19 then
			return p19[s12]
		end

		return nil
	end)

	local s13 = "Color"

	t10.Color = v85:map(function(p20) -- line: 66
		-- upvalues: s13 (copy)
		if p20 then
			return p20[s13]
		end

		return nil
	end)

	local s14 = "Offset"

	t10.Offset = v85:map(function(p21) -- line: 66
		-- upvalues: s14 (copy)
		if p21 then
			return p21[s14]
		end

		return nil
	end)

	local s15 = "Rotation"

	t10.Rotation = v85:map(function(p22) -- line: 66
		-- upvalues: s15 (copy)
		if p22 then
			return p22[s15]
		end

		return nil
	end)

	local s16 = "Transparency"

	t10.Transparency = v85:map(function(p23) -- line: 66
		-- upvalues: s16 (copy)
		if p23 then
			return p23[s16]
		end

		return nil
	end)
	t9.UIGradient = createElement4("UIGradient", t10)
	t7.PrefixText = createElement3("TextLabel", t8, t9)

	local createElement5 = React.createElement
	local v114 = (not FFlagExpChatRewriteInline or not FFlagEnableInExpChatRewrite) and "TextLabel" or "TextButton"
	local t11 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}
	local s17 = "FontFace"

	t11.FontFace = t1.bodyTextProperties:map(function(p24) -- line: 66
		-- upvalues: s17 (copy)
		if p24 then
			return p24[s17]
		end

		return nil
	end)
	t11.RichText = true
	t11.Size = UDim2.new(1, 0, 0, 0)
	t11.Text = v81

	local s18 = "TextColor3"

	t11.TextColor3 = t1.bodyTextProperties:map(function(p25) -- line: 66
		-- upvalues: s18 (copy)
		if p25 then
			return p25[s18]
		end

		return nil
	end)
	t11.TextSize = v76

	local s19 = "TextStrokeColor3"

	t11.TextStrokeColor3 = t1.bodyTextProperties:map(function(p26) -- line: 66
		-- upvalues: s19 (copy)
		if p26 then
			return p26[s19]
		end

		return nil
	end)

	local s20 = "TextStrokeTransparency"

	t11.TextStrokeTransparency = mergeBindableScalar(t1.bodyTextProperties:map(function(p27) -- line: 66
		-- upvalues: s20 (copy)
		if p27 then
			return p27[s20]
		end

		return nil
	end), t1.textTransparency)
	t11.TextTransparency = mergeBindableScalar(0, t1.textTransparency)
	t11.TextWrapped = true
	t11.TextXAlignment = Enum.TextXAlignment.Left
	t11.TextYAlignment = Enum.TextYAlignment.Top
	t11[React.Change.Text] = if not v27 then nil else v69
	t11[React.Event.Activated] = if not FFlagExpChatRewriteInline or not FFlagEnableInExpChatRewrite then nil else v72
	t11.Interactable = if not FFlagExpChatRewriteInline or not FFlagEnableInExpChatRewrite then nil else v87
	t7.BodyText = createElement5(v114, t11)

	local createElement6 = React.createElement
	local t12 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = v83
	}
	local t13 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		})
	}
	local createElement7 = React.createElement
	local t14 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}
	local s21 = "FontFace"

	t14.FontFace = t1.prefixTextProperties:map(function(p28) -- line: 66
		-- upvalues: s21 (copy)
		if p28 then
			return p28[s21]
		end

		return nil
	end)
	t14.RichText = true
	t14.SelectionImageObject = v91
	t14.Size = UDim2.new(0, 0, 0, 0)
	t14.Text = v75

	local s22 = "TextSize"

	t14.TextSize = t1.prefixTextProperties:map(function(p29) -- line: 66
		-- upvalues: s22 (copy)
		if p29 then
			return p29[s22]
		end

		return nil
	end)
	t14.TextStrokeTransparency = 1
	t14.TextTransparency = 1
	t14.TextWrapped = true
	t14.TextXAlignment = Enum.TextXAlignment.Left
	t14.TextYAlignment = Enum.TextYAlignment.Top
	t14.LayoutOrder = 1
	t14[React.Event.Activated] = v70
	t13.TextButton = createElement7("TextButton", t14)
	t13.TranslationButton = React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		HoverImage = "rbxasset://textures/translateIconDark.png",
		Image = "rbxasset://textures/translateIcon.png",
		ImageTransparency = mergeBindableScalar(0, t1.textTransparency),
		LayoutOrder = 2,
		PressedImage = "rbxasset://textures/translateIconDark.png",
		SelectionImageObject = v91,
		Size = v82,
		Visible = t1.shouldShowTranslationToggle,
		[React.Event.Activated] = v71
	})
	t7.TextMessageButton = createElement6("Frame", t12, t13)
	t5.TextMessage = createElement2("Frame", t6, t7)
	t5.RewriteToggle = if not FFlagEnableInExpChatRewrite or FFlagExpChatRewriteInline then nil else React.createElement(RewriteToggle, {
		LayoutOrder = 2,
		isRewriteMenuOpen = t1.isRewriteWindowOpen,
		textTransparency = t1.textTransparency,
		onActivated = v72,
		Visible = v86
	})

	local v127 = createElement("Frame", t4, t5)

	if FFlagDebugMessageProfiling then
		debug.profileend()
	end

	return v127
end

return React.memo(TranslatedTextMessage)
