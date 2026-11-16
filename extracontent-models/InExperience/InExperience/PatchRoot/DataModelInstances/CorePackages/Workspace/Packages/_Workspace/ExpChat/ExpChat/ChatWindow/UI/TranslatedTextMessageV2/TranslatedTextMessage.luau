local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local Localization = require(ExpChat.Localization)

local Flags = ExpChat.Flags
local FFlagDebugMessageProfiling = require(Flags.FFlagDebugMessageProfiling)
local FFlagEnableInExpChatRewrite = require(Flags.FFlagEnableInExpChatRewrite)
local FFlagExpChatRewriteInline = require(Flags.FFlagExpChatRewriteInline)
local FFlagExpChatRewriteToggleAnalytics = require(Flags.FFlagExpChatRewriteToggleAnalytics)
local FStringInExpChatRewriteLabelKey = require(Flags.FStringInExpChatRewriteLabelKey)

local FIntExpChatWindowTransparencyRewriteInteractableThreshold = require(Flags.FIntExpChatWindowTransparencyRewriteInteractableThreshold)

local FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 = require(Flags.FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2)
local FFlagExpChatPolishSummaryMessageUI = require(Flags.FFlagExpChatPolishSummaryMessageUI)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local isChatWindowEnlargeEnabled = require(ExpChat.isChatWindowEnlargeEnabled)

local FFlagExpChatMessageEffectChatWindowEnlargePadding = require(Flags.FFlagExpChatMessageEffectChatWindowEnlargePadding)

local FFlagExpChatMessageEffectChatWindowEnlargeLineHeight = require(Flags.FFlagExpChatMessageEffectChatWindowEnlargeLineHeight)

local FIntExpChatMessageEffectChatWindowEnlargePaddingPixels = require(Flags.FIntExpChatMessageEffectChatWindowEnlargePaddingPixels)
local getPresetIconRichText = ExpChatShared.getPresetIconRichText
local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local summaryMessageRichText = require(ExpChat.summaryMessageRichText)

local RewriteToggle = require(script.Parent.RewriteToggle)

local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetRewriteDropdownStore = require(ExpChat.Stores.GetRewriteDropdownStore)

local MessageEffect = require(ExpChat.MessageEffects.MessageEffect)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local getMessageTextSize = ChatUIPrimitives.Utils.getMessageTextSize

local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local useFinishChatWindowMessageRenderIntervals = ChatUIPrimitives2.Hooks.useFinishChatWindowMessageRenderIntervals
local applyChatWindowMessageEffects = require(ExpChat.MessageEffects.applyChatWindowMessageEffects)
local getChatWindowPrefixOffset = require(ExpChat.MessageEffects.getChatWindowPrefixOffset)
local getChatWindowMessageLineHeight = require(ExpChat.MessageEffects.getChatWindowMessageLineHeight)

local useCursor = UIBlox.App.SelectionCursor.useCursor

local Config = require(ExpChat.Config)

local Helpers = ExpChat.ChatWindow.Helpers
local duplicateInvisibleText = require(Helpers.duplicateInvisibleText)
local mergeBindableScalar = require(Helpers.mergeBindableScalar)

local function calculateTransparency(transparency: number, p: number) -- 2 equivalent calls inferred from this helper
	return transparency + p * (1 - transparency)
end

local function appendVerifiedBadge(value: string) -- 1 equivalent call inferred from this helper
	return string.gsub(value, ":(%S-)$", Config.VERIFIED_EMOJI .. ":%1")
end

local function trim(value: string)
	if value:match("^()%s*$") then
		return ""
	end

	return (value:match("^%s*(.*%S)"))
end

local function getPropertyFromObjBinding(object, p: string) -- 17 equivalent calls inferred from this helper
	return object:map(function(p2)
		if p2 then
			return p2[p]
		end

		return nil
	end)
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

local function TranslatedTextMessage(props)
	if FFlagDebugMessageProfiling then
		debug.profilebegin("TranslatedTextMessage")
	end

	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local messageTextSize = getMessageTextSize(props.chatWindowSettings, isSpatialUIEnabled)

	local useLocalization = Localization.useLocalization
	local rewrittenLabelText

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		rewrittenLabelText = FStringInExpChatRewriteLabelKey
	end

	local v = useLocalization({
		trustedLabelText = "CoreScripts.TextChat.ChatWindow.TrustedLabel",
		rewrittenLabelText = rewrittenLabelText,
		defaultRewrittenLabelText = FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite and "CoreScripts.TextChat.ChatWindow.RewrittenLabel" or nil
	})
	local v2

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		if v.rewrittenLabelText and v.rewrittenLabelText ~= "" then
			v2 = v.rewrittenLabelText
		else
			v2 = v.defaultRewrittenLabelText
		end
	else
		v2 = nil
	end

	local v3 = Foundation.Hooks.useTokens()

	local v4 = useFinishChatWindowMessageRenderIntervals((React.useCallback(function()
		if props.message and props.message.current then
			return props.message.current.messageId
		end

		return nil
	end, { props.message })))
	local v5 = React.useCallback(function(p)
		if p and p.Text and p.Text ~= "" then
			v4()
		end
	end, { v4 })

	local v6 = React.useCallback(function()
		props.onTextMessageLabelButtonActivated(props.message.current)
	end, { props.onTextMessageLabelButtonActivated })

	local v7 = React.useCallback(function()
		local current = props.message.current
		GetMessagesStore(false).toggleMessageTranslation(not current.useTranslation, current.messageId)
	end, {})
	local onActivated

	if FFlagEnableInExpChatRewrite then
		onActivated = React.useCallback(function()
			local current = props.message.current

			if current and current.messageId then
				local rewriteDropdownStore = GetRewriteDropdownStore(false)

				if FFlagExpChatRewriteToggleAnalytics then
					local v8 = rewriteDropdownStore.getOpenMessageId(false) == current.messageId
					local v9 = current.wasRewritten

					if v9 then
						if current.originalText == nil then
							v9 = false
						else
							v9 = current.originalText ~= ""
						end
					end

					ExpChatShared.Analytics:TelemetryLogEvent(
						ExpChatShared.Analytics.RewriteDropdownToggledConfig,
						{
							messageId = current.messageId,
							isDropdownOpen = tostring(v8),
							showOriginalText = tostring(v9)
						},
						ExpChatShared.Analytics.DefaultStandardizedFields
					)
				end

				rewriteDropdownStore.toggleDropdown(current.messageId)
			end
		end, { props.message })
	end

	local v8 = { props.originalPrefixText, props.isUserVerified }
	table.insert(v8, props.isTrustedConnection)
	table.insert(v8, props.textTransparency)
	table.insert(v8, props.prefixTextProperties)

	local mapped = React.joinBindings(v8):map(function(list)
		local item = list[1]
		local item2 = list[2]

		if string.len(item) > 0 then
			if item2 then
				item = appendVerifiedBadge(item) -- inferred equivalent call
			end

			local v9 = list[3] or false
			local v10 = list[4] == nil and 1 or list[4]
			local item3 = list[5]

			if v9 then
				item = appendTrustedIndicator(item, v.trustedLabelText, v10, item3.TextSize, v3)
			end
		end

		return item
	end)

	local mapped2 = mapped:map(trim)

	local mapped3 = props.bodyTextProperties:map(function(p)
		if isSpatialUIEnabled then
			return messageTextSize
		end

		return p.TextSize
	end)

	local values = {
		mapped,
		props.shouldShowTranslationToggle,
		props.originalBodyText,
		props.prefixTextProperties
	}

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		table.insert(values, props.wasRewritten)
		table.insert(values, props.isRewriteWindowOpen)
	end

	local v9

	if FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2 then
		v9 = #values + 1
		table.insert(values, props.chatActionType)
	else
		v9 = nil
	end

	local v10

	if FFlagExpChatPolishSummaryMessageUI or FFlagExpChatPresetChatEnabled then
		v10 = #values + 1
		table.insert(values, mapped3)
	else
		v10 = nil
	end

	local v11

	if FFlagExpChatPresetChatEnabled and props.isPresetMessage ~= nil then
		v11 = #values + 1
		table.insert(values, props.isPresetMessage)
	else
		v11 = nil
	end

	local v12

	if isChatWindowEnlargeEnabled() and props.effects ~= nil then
		v12 = #values + 1
		table.insert(values, props.effects)
	else
		v12 = nil
	end

	local mapped4 = React.joinBindings(values):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local v13 = list[3]
		local item3 = list[4]

		if isChatWindowEnlargeEnabled() and v12 ~= nil then
			v13 = applyChatWindowMessageEffects(v13, list[v12])
		end

		if FFlagExpChatPresetChatEnabled and v11 ~= nil and list[v11] then
			v13 ..= ` {getPresetIconRichText(list[v10])}`
		end

		if
			FFlagEnableInExpChatSummaryOnLuaForTranslatedMessageV2
			and list[v9] == TextChatMessageChatActionType.Summary
		then
			local v14

			if FFlagExpChatPolishSummaryMessageUI then
				v14 = list[v10]
			end

			v13 = summaryMessageRichText.wrapInSummaryMutedStyle(
				summaryMessageRichText.getSummaryIconPrefix(v14) .. " " .. v13,
				v3.Color.Content.Muted.Color3:ToHex(),
				v14
			)
		end

		if string.len(item) > 0 then
			if item2 then
				v13 = "     " .. v13
			end

			v13 = duplicateInvisibleText(item, item3.FontFace, item3.TextSize) .. " " .. v13
		end

		if not (FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite) then
			return v13
		end

		local item4 = list[5]
		local item5 = list[6]

		if not item4 then
			return v13
		end

		local v14

		if item5 then
			v14 = Foundation.Enums.IconName.ChevronLargeUp
		else
			v14 = Foundation.Enums.IconName.ChevronLargeDown
		end

		return `{v13} <font size='{item3.TextSize - 4}' color='#{v3.Color.Content.Muted.Color3:ToHex()}'>{`({v2})`}<font transparency='1'><stroke transparency='1'>_</stroke></font>{`<font weight='600' family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json'>{v14}</font>`}</font>`
	end)

	local mapped5 = mapped3:map(function(p)
		return UDim2.new(0, p - 2, 0, p - 2)
	end)

	local mapped6 = props.originalPrefixText:map(function(value): boolean
		return string.len(value) > 0
	end)

	local propertyFromObjBinding = getPropertyFromObjBinding(props.prefixTextProperties, "UIGradient") -- inferred equivalent call
	local position

	if isChatWindowEnlargeEnabled() and props.effects ~= nil then
		position = React.joinBindings({ props.effects, props.prefixTextProperties }):map(function(list)
			return UDim2.fromOffset(0, getChatWindowPrefixOffset(list[1], list[2].TextSize))
		end)
	end

	local lineHeight

	if
		FFlagExpChatMessageEffectChatWindowEnlargeLineHeight
		and isChatWindowEnlargeEnabled()
		and props.effects ~= nil
	then
		lineHeight = React.joinBindings({ props.effects, mapped3, props.prefixTextProperties }):map(function(list)
			return getChatWindowMessageLineHeight(list[1], list[2], list[3].TextSize)
		end)
	end

	local interactable = nil
	local visible

	if FFlagEnableInExpChatRewrite then
		local wasRewritten = props.wasRewritten

		visible = wasRewritten:map(function(p)
			return p and not FFlagExpChatRewriteInline
		end)

		if FFlagExpChatRewriteInline then
			local chatWindowTransparencyBindable = props.chatWindowTransparencyBindable

			if chatWindowTransparencyBindable == nil then
				interactable = wasRewritten
			elseif typeof(chatWindowTransparencyBindable) == "number" then
				local v13 = chatWindowTransparencyBindable < FIntExpChatWindowTransparencyRewriteInteractableThreshold
				interactable = wasRewritten:map(function(p)
					return p and v13
				end)
			else
				interactable = React.joinBindings({ wasRewritten, chatWindowTransparencyBindable }):map(function(list)
					return list[1] and list[2] < FIntExpChatWindowTransparencyRewriteInteractableThreshold
				end)
			end
		end
	end

	local selectionImageObject = useCursor()
	local v13

	if FFlagExpChatMessageEffectChatWindowEnlargePadding and isChatWindowEnlargeEnabled() and props.effects ~= nil then
		v13 = props.effects:map(function(list)
			return UDim.new(
				0,
				not (list and table.find(list, MessageEffect.ChatWindowEnlarge)) and 0 or FIntExpChatMessageEffectChatWindowEnlargePaddingPixels
			)
		end)
	end

	local createElement = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = props.layoutOrder,
		Visible = props.visible
	}
	local v15 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingRight = props.arButtonPadding,
			PaddingTop = v13,
			PaddingBottom = v13
		}),
		ColumnLayout = 0,
		TextMessage = 0,
		RewriteToggle = 0
	}
	local columnLayout

	if FFlagEnableInExpChatRewrite and not FFlagExpChatRewriteInline then
		columnLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	end

	v15.ColumnLayout = columnLayout

	local createElement2 = React.createElement
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = FFlagEnableInExpChatRewrite and 1 or nil
	}

	local children = {
		PrefixText = React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = getPropertyFromObjBinding(props.prefixTextProperties, "FontFace"), -- inferred equivalent call
			LineHeight = lineHeight,
			Position = position,
			RichText = true,
			Text = mapped,
			TextColor3 = getPropertyFromObjBinding(props.prefixTextProperties, "TextColor3"), -- inferred equivalent call
			TextSize = getPropertyFromObjBinding(props.prefixTextProperties, "TextSize"), -- inferred equivalent call
			TextStrokeColor3 = getPropertyFromObjBinding(props.prefixTextProperties, "TextStrokeColor3"), -- inferred equivalent call
			TextStrokeTransparency = mergeBindableScalar(
				getPropertyFromObjBinding(props.prefixTextProperties, "TextStrokeTransparency"), -- inferred equivalent call
				props.textTransparency
			),
			TextTransparency = mergeBindableScalar(0, props.textTransparency),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Visible = mapped6
		}, {
			UIGradient = React.createElement("UIGradient", {
				Enabled = getPropertyFromObjBinding(propertyFromObjBinding, "Enabled"), -- inferred equivalent call
				Color = getPropertyFromObjBinding(propertyFromObjBinding, "Color"), -- inferred equivalent call
				Offset = getPropertyFromObjBinding(propertyFromObjBinding, "Offset"), -- inferred equivalent call
				Rotation = getPropertyFromObjBinding(propertyFromObjBinding, "Rotation"), -- inferred equivalent call
				Transparency = getPropertyFromObjBinding(propertyFromObjBinding, "Transparency") -- inferred equivalent call
			})
		}),
		BodyText = 0,
		TextMessageButton = 0
	}

	local createElement3 = React.createElement

	local v17 = {
		["AutomaticSize"] = nil,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = getPropertyFromObjBinding(props.bodyTextProperties, "FontFace"), -- inferred equivalent call
		LineHeight = lineHeight,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 0),
		Text = mapped4,
		TextColor3 = getPropertyFromObjBinding(props.bodyTextProperties, "TextColor3"), -- inferred equivalent call
		TextSize = mapped3,
		TextStrokeColor3 = getPropertyFromObjBinding(props.bodyTextProperties, "TextStrokeColor3"), -- inferred equivalent call
		TextStrokeTransparency = mergeBindableScalar(
			getPropertyFromObjBinding(props.bodyTextProperties, "TextStrokeTransparency"), -- inferred equivalent call
			props.textTransparency
		),
		TextTransparency = mergeBindableScalar(0, props.textTransparency),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		[React.Change.Text] = v5
	}
	local activated = React.Event.Activated
	local v18

	if FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite then
		v18 = onActivated
	end

	v17[activated] = v18

	if not (FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite) then
		interactable = nil
	end

	v17.Interactable = interactable
	children.BodyText = createElement3(
		FFlagExpChatRewriteInline and FFlagEnableInExpChatRewrite and "TextButton" or "TextLabel",
		v17
	)

	children.TextMessageButton = React.createElement("Frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = position,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = mapped6
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		TextButton = React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = getPropertyFromObjBinding(props.prefixTextProperties, "FontFace"), -- inferred equivalent call
			LineHeight = lineHeight,
			RichText = true,
			SelectionImageObject = selectionImageObject,
			Size = UDim2.new(0, 0, 0, 0),
			Text = mapped2,
			TextSize = getPropertyFromObjBinding(props.prefixTextProperties, "TextSize"), -- inferred equivalent call
			TextStrokeTransparency = 1,
			TextTransparency = 1,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 1,
			[React.Event.Activated] = v6
		}),
		TranslationButton = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			HoverImage = "rbxasset://textures/translateIconDark.png",
			Image = "rbxasset://textures/translateIcon.png",
			ImageTransparency = mergeBindableScalar(0, props.textTransparency),
			LayoutOrder = 2,
			PressedImage = "rbxasset://textures/translateIconDark.png",
			SelectionImageObject = selectionImageObject,
			Size = mapped5,
			Visible = props.shouldShowTranslationToggle,
			[React.Event.Activated] = v7
		})
	})
	v15.TextMessage = createElement2("Frame", v16, children)
	local rewriteToggle

	if FFlagEnableInExpChatRewrite and not FFlagExpChatRewriteInline then
		rewriteToggle = React.createElement(RewriteToggle, {
			isRewriteMenuOpen = props.isRewriteWindowOpen,
			textTransparency = props.textTransparency,
			onActivated = onActivated,
			LayoutOrder = 2,
			Visible = visible
		})
	end

	v15.RewriteToggle = rewriteToggle
	local element = createElement("Frame", v14, v15)

	if FFlagDebugMessageProfiling then
		debug.profileend()
	end

	return element
end

return React.memo(TranslatedTextMessage)
