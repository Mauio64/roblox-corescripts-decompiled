local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ExpChatShared = require(parent.ExpChatShared)

local Config = require(ExpChat.Config)
local ChannelChip = require(script.Parent.ChannelChip)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatInputBarV2CustomSendButton = require(ExpChat.Flags.FFlagExpChatInputBarV2CustomSendButton)

local FFlagExpChatInputBarV2CornerAndTruncationFix = require(ExpChat.Flags.FFlagExpChatInputBarV2CornerAndTruncationFix)
local FFlagExpChatComposerInputBarFigmaParity = require(ExpChat.Flags.FFlagExpChatComposerInputBarFigmaParity)

local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatFixBackspaceNilTargetChannel = ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)

local function renderCustomSendButton(props, p, hasEmptyInputText: boolean?, onSendActivated)
	local v

	if hasEmptyInputText then
		v = p.Color.ActionStandard
	else
		v = p.Color.ActionEmphasis
	end

	local size_800 = p.Size.Size_800

	local createElement = React.createElement
	local v2 = {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		GroupTransparency = 0,
		Position = 0,
		Size = 0
	}
	local groupTransparency

	if hasEmptyInputText then
		groupTransparency = props.setTransparency(0.5, props.transparencyValue)
	else
		groupTransparency = props.transparencyValue
	end

	v2.GroupTransparency = groupTransparency

	v2.Position = UDim2.fromScale(1, 0)

	v2.Size = UDim2.new(0, props.sendButtonContainerWidth + 6, 1, 0)
	local v3 = {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SendButton = 0
	}

	local createElement2 = React.createElement
	local v4 = {}
	v4.AutoButtonColor = false
	v4.BackgroundColor3 = v.Background.Color3
	v4.BackgroundTransparency = v.Background.Transparency
	v4.BorderSizePixel = 0
	local selectable

	if hasEmptyInputText then
		selectable = false
	elseif not FFlagExpChatPresetChatGamepadEnabled then
		selectable = false
	end

	v4.Selectable = selectable
	v4.Size = UDim2.fromOffset(size_800, size_800)
	v4.Text = ""
	local activated = React.Event.Activated

	if hasEmptyInputText then
		onSendActivated = nil
	end

	v4[activated] = onSendActivated
	v3.SendButton = createElement2("TextButton", v4, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		IconLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.ArrowMediumUp,
			size = Foundation.Enums.IconSize.Small,
			style = v.Foreground
		})
	})
	return createElement("CanvasGroup", v2, v3)
end

local function ChatInputBarV2(props)
	local v = Foundation.Hooks.useTokens()
	local setTransparency = props.setTransparency
	local chatInputBarSettings = props.chatInputBarSettings
	local chatInputBarBackgroundTransparency = props.chatInputBarBackgroundTransparency
	local isSpatialUIEnabled = props.isSpatialUIEnabled
	local v2 = props.canLocalUserChatDerived
	local targetChannelWidth = props.targetChannelWidth
	local showPlaceholderText = props.showPlaceholderText
	local hasEmptyInputText = props.hasEmptyInputText
	local cursor = props.cursor
	local placeholderRef = props.placeholderRef
	local ref = props.textBoxRef
	local customTextBoxRef = props.customTextBoxRef
	local onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	local onFocused = props.onFocused
	local onFocusLost = props.onFocusLost
	local onTextChanged = props.onTextChanged
	local onReturnPressedFromOnScreenKeyboard = props.onReturnPressedFromOnScreenKeyboard
	local onSendActivated = props.onSendActivated

	local createElement = React.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement2 = React.createElement
	local v4 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local createElement3 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = chatInputBarSettings.BackgroundColor3,
		BackgroundTransparency = setTransparency(chatInputBarBackgroundTransparency, props.transparencyValue),
		LayoutOrder = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 0)
	}

	local createElement4 = React.createElement
	local cornerRadius

	if FFlagExpChatInputBarV2CornerAndTruncationFix then
		cornerRadius = UDim.new(0, 20)
	else
		cornerRadius = UDim.new(1, 0)
	end

	local children = {
		UICorner = createElement4("UICorner", { CornerRadius = cornerRadius }),
		UIStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v.Color.Stroke.Default.Color3,
			Transparency = setTransparency(v.Color.Stroke.Default.Transparency, props.transparencyValue)
		}),
		UIPadding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, 2) }),
		TextContainer = 0,
		SendButtonContainer = 0
	}

	local createElement5 = React.createElement
	local v6 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.new(1, -(props.sendButtonContainerWidth + 6), 0, 0)
	}
	local v7 = {
		TargetChannelChip = React.createElement(ChannelChip, {
			transparency = setTransparency(0, props.transparencyValue),
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			onChannelChipActivated = FFlagExpChatFixBackspaceNilTargetChannel and function()
				props.resetTargetChannel(props.isGlobalChatTabActive)
			end or props.resetTargetChannel,
			targetTextChannelDisplayName = props.targetTextChannelDisplayName or "",
			isChannelBarVisible = props.isChannelBarVisible,
			developerChannelTabsEnabled = props.developerChannelTabsEnabled
		}),
		DisabledPlaceholderLabel = 0,
		TextBoxContainer = 0,
		UIPadding = 0
	}

	local disabledPlaceholderLabel = not v2

	if disabledPlaceholderLabel then
		local createElement6 = React.createElement
		local v8 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Config.ChatInputBarFont,
			Text = props.disabledChatPlaceholderText,
			Position = UDim2.fromScale(1, 0),
			Size = targetChannelWidth:map(function(p: number)
				return UDim2.new(1, -(p + 8), 0, 0)
			end),
			TextColor3 = showPlaceholderText and chatInputBarSettings.PlaceholderColor3 or chatInputBarSettings.TextColor3,
			TextSize = 0,
			TextTransparency = 0,
			Selectable = true,
			SelectionImageObject = 0,
			TextWrapped = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ref = 0
		}
		local textSize

		if isSpatialUIEnabled then
			textSize = chatInputBarSettings.SpatialPanelTextSize
		else
			textSize = chatInputBarSettings.TextSize
		end

		v8.TextSize = textSize

		v8.TextTransparency = setTransparency(showPlaceholderText and 0.5 or 0, props.transparencyValue)

		v8.SelectionImageObject = cursor
		local textWrapped

		if FFlagExpChatInputBarV2CornerAndTruncationFix then
			textWrapped = not showPlaceholderText
		else
			local shouldTruncatePlaceholder = FFlagExpChatPresetChatEnabled
				and showPlaceholderText
				and props.shouldTruncatePlaceholder
			textWrapped = not shouldTruncatePlaceholder
		end

		v8.TextWrapped = textWrapped
		local atEnd

		if FFlagExpChatInputBarV2CornerAndTruncationFix and showPlaceholderText then
			atEnd = Enum.TextTruncate.AtEnd
		elseif FFlagExpChatPresetChatEnabled and showPlaceholderText then
			atEnd = Enum.TextTruncate.AtEnd
		end

		v8.TextTruncate = atEnd

		v8.TextXAlignment = Enum.TextXAlignment.Left
		v8.TextYAlignment = Enum.TextYAlignment.Top
		v8.ref = placeholderRef
		disabledPlaceholderLabel = createElement6("TextLabel", v8)
	end

	v7.DisabledPlaceholderLabel = disabledPlaceholderLabel

	if v2 then
		local createElement6 = React.createElement
		local v8 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = targetChannelWidth:map(function(p: number)
				return UDim2.new(1, -(p + 8), 0, 0)
			end)
		}

		if v2 then
			local createElement7 = React.createElement
			local v9 = {}
			v9.AnchorPoint = Vector2.new(0, 0)
			v9.AutomaticSize = Enum.AutomaticSize.XY
			v9.BackgroundTransparency = 1
			v9.ClearTextOnFocus = false
			v9.FontFace = chatInputBarSettings.FontFace
			v9.PlaceholderText = showPlaceholderText and props.placeholderText or ""
			v9.Selectable = FFlagEnableConsoleExpControls and true or nil
			v9.SelectionImageObject = cursor
			v9.Size = UDim2.fromScale(1, 0)
			v9.Text = ""
			local placeholderColor

			if
				FFlagExpChatComposerInputBarFigmaParity
				and chatInputBarSettings.PlaceholderColor3 == Config.ChatInputBarPlaceholderColor
			then
				placeholderColor = v.DarkMode.Content.Default.Color3
			else
				placeholderColor = chatInputBarSettings.PlaceholderColor3
			end

			v9.PlaceholderColor3 = placeholderColor

			v9.TextColor3 = chatInputBarSettings.TextColor3
			local textSize

			if isSpatialUIEnabled then
				textSize = chatInputBarSettings.SpatialPanelTextSize
			else
				textSize = chatInputBarSettings.TextSize
			end

			v9.TextSize = textSize

			v9.TextTransparency = setTransparency(
				showPlaceholderText and not FFlagExpChatComposerInputBarFigmaParity and 0.5 or 0,
				props.transparencyValue
			)

			v9.TextStrokeTransparency = setTransparency(
				chatInputBarSettings.TextStrokeTransparency,
				props.transparencyValue
			)

			v9.TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3
			local textWrapped

			if FFlagExpChatInputBarV2CornerAndTruncationFix then
				textWrapped = not showPlaceholderText
			else
				local shouldTruncatePlaceholder = FFlagExpChatPresetChatEnabled
					and showPlaceholderText
					and props.shouldTruncatePlaceholder
				textWrapped = not shouldTruncatePlaceholder
			end

			v9.TextWrapped = textWrapped
			local atEnd

			if FFlagExpChatInputBarV2CornerAndTruncationFix and showPlaceholderText then
				atEnd = Enum.TextTruncate.AtEnd
			elseif FFlagExpChatPresetChatEnabled and showPlaceholderText then
				atEnd = Enum.TextTruncate.AtEnd
			end

			v9.TextTruncate = atEnd

			v9.TextXAlignment = Enum.TextXAlignment.Left
			v9.TextYAlignment = Enum.TextYAlignment.Top
			v9.ZIndex = 2

			v9[React.Event.Focused] = onFocused
			v9[React.Event.FocusLost] = onFocusLost
			v9[React.Change.Text] = onTextChanged
			v9[React.Event.ReturnPressedFromOnScreenKeyboard] = onReturnPressedFromOnScreenKeyboard

			if chatInputBarSettings.TextBox then
				ref = customTextBoxRef
			end

			v9.ref = ref
			v2 = createElement7("TextBox", v9)
		end

		v2 = createElement6("Frame", v8, { TextBox = v2 })
	end

	v7.TextBoxContainer = v2

	v7.UIPadding = React.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 10),
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10)
	})
	children.TextContainer = createElement5("Frame", v6, v7)
	local sendButtonContainer

	if FFlagExpChatInputBarV2CustomSendButton then
		sendButtonContainer = renderCustomSendButton(props, v, hasEmptyInputText, onSendActivated)
	else
		local createElement6 = React.createElement
		local v8 = {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			GroupTransparency = props.transparencyValue,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, props.sendButtonContainerWidth + 6, 1, 0)
		}
		local v9 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SendButton = 0
		}

		local createElement7 = React.createElement
		local iconButton = Foundation.IconButton
		local v10 = {
			icon = Foundation.Enums.IconName.ArrowMediumUp,
			variant = 0,
			size = 0,
			isCircular = true,
			isDisabled = 0,
			Selectable = 0,
			onActivated = 0
		}
		local variant

		if hasEmptyInputText then
			variant = Foundation.Enums.ButtonVariant.Standard
		else
			variant = Foundation.Enums.ButtonVariant.Emphasis
		end

		v10.variant = variant

		v10.size = Foundation.Enums.InputSize.Small

		v10.isDisabled = hasEmptyInputText
		local selectable

		if not FFlagExpChatPresetChatGamepadEnabled then
			selectable = false
		end

		v10.Selectable = selectable
		v10.onActivated = onSendActivated
		v9.SendButton = createElement7(iconButton, v10)
		sendButtonContainer = createElement6("CanvasGroup", v8, v9)
	end

	children.SendButtonContainer = sendButtonContainer
	return createElement("Frame", v3, {
		Container = createElement2("Frame", v4, {
			InputGroup = createElement3("Frame", v5, children)
		})
	})
end

return React.memo(ChatInputBarV2)
