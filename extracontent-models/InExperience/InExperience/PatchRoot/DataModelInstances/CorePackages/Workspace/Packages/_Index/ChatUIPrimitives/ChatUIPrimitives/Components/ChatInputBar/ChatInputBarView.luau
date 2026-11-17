local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local SharedFlags = require(parent.SharedFlags)
local FFlagChatInputBarGuardInvalidUtf8 = SharedFlags.FFlagChatInputBarGuardInvalidUtf8
local FFlagExpChatHidePlaceholderUnderOverlay = require(ChatUIPrimitives.Flags.FFlagExpChatHidePlaceholderUnderOverlay)
local FFlagExpChatComposerKeepTrayEntryMounted = require(ChatUIPrimitives.Flags.FFlagExpChatComposerKeepTrayEntryMounted)

local FFlagExpChatComposerKeepTrayEntryOnDisabledOverlay = require(ChatUIPrimitives.Flags.FFlagExpChatComposerKeepTrayEntryOnDisabledOverlay)

local getTextLengthIfValidUtf8 = require(script.Parent.getTextLengthIfValidUtf8)
local ChannelChip = require(script.Parent.ChannelChip)
require(ChatUIPrimitives.universal.Autocomplete.AutocompleteTypes)
local ChatAutocompleteDropdown = require(script.Parent.Autocomplete.ChatAutocompleteDropdown)
local useChatAutocompleteEngine = require(script.Parent.Autocomplete.useChatAutocompleteEngine)
local useAutocompleteSources = require(ChatUIPrimitives.universal.Autocomplete.useAutocompleteSources)
local ExpressionTrayView = require(ChatUIPrimitives.Components.ExpressionTray.ExpressionTrayView)
local useExpressionTray = require(ChatUIPrimitives.Hooks.useExpressionTray)

local function getPlaceholderText(data)
	if FFlagExpChatHidePlaceholderUnderOverlay and data.centerOverlay ~= nil and data.centerOverlayTextHidden then
		return ""
	end

	return data.placeholderText or ""
end

local function fade(p: number, p2: number) -- 8 equivalent calls inferred from this helper
	return p + p2 * (1 - p)
end

local function deriveTransparency(p: number, transparencyValue) -- 3 equivalent calls inferred from this helper
	if ReactIs.isBinding(transparencyValue) then
		return transparencyValue:map(function(p2: number)
			return fade(p, p2) -- inferred equivalent call
		end)
	end

	return fade(p, transparencyValue) -- inferred equivalent call
end

local function deriveBackgroundStyle(color: Color3, p: number, object)
	if ReactIs.isBinding(object) then
		return object:map(function(p2: number)
			return { Color3 = color, Transparency = fade(p, p2) } -- inferred equivalent call
		end)
	end

	return { Color3 = color, Transparency = fade(p, object) } -- inferred equivalent call
end

local function withVariant(p, variant) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(p)
	clone.variant = variant
	return clone
end

local function renderDropdown(props)
	if props.props.autocomplete == nil and props.props.autocompleteOptions == nil then
		return nil
	end

	local autocomplete = props.autocomplete
	return React.createElement(ChatAutocompleteDropdown, {
		isOpen = autocomplete.isOpen,
		results = autocomplete.results,
		selectedIndex = autocomplete.selectedIndex,
		keyboardIndex = autocomplete.keyboardIndex,
		renderEntry = autocomplete.renderEntry,
		anchorRef = props.barContainerRef,
		onHover = autocomplete.setSelectedIndex,
		onSelect = props.onCommitSelection,
		onDismiss = autocomplete.dismiss
	})
end

local function renderSideChip(props)
	return React.createElement(ChannelChip, {
		transparency = props.transparencyValue,
		sideChipText = props.props.sideChipText,
		showSideChip = props.props.showSideChip,
		onSideChipActivated = props.props.onSideChipActivated,
		onAbsoluteSizeChanged = props.onChannelChipAbsoluteSizeChanged
	})
end

local function renderSendButton(props)
	local createElement = React.createElement
	local iconButton = Foundation.IconButton
	local v = {
		icon = Foundation.Enums.IconName.ArrowMediumUp,
		variant = 0,
		size = 0,
		isCircular = true,
		isDisabled = 0,
		onActivated = 0
	}
	local variant

	if props.isSendDisabled then
		variant = Foundation.Enums.ButtonVariant.Standard
	else
		variant = Foundation.Enums.ButtonVariant.Emphasis
	end

	v.variant = variant

	v.size = Foundation.Enums.InputSize.Small

	v.isDisabled = props.isSendDisabled
	v.onActivated = props.onSendActivated
	return createElement(iconButton, v)
end

local function renderLegacy(props)
	local tokens = props.tokens
	local props2 = props.props
	local textSize = props2.textSize or tokens.Typography.CaptionMedium.FontSize

	local v = props2.primary ~= nil
	local v2 = not props.shouldReplaceDisabledContent

	if v2 then
		if props.hasLeadingAction then
			v2 = not props.isEmpty and props.canChat and not v
		else
			v2 = not v
		end
	end

	local v3 = props.showLeadingAction and 36 or 0
	local v4 = not (v2 or v) and 0 or props.sendButtonContainerWidth + 6

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = { tag = "auto-y", Size = UDim2.new(1, 0, 0, 0), ref = props.barContainerRef }
	local v6 = { Dropdown = renderDropdown(props), TrayOverlay = props.trayOverlay, Container = 0 }
	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v7 = { tag = "auto-y", Size = UDim2.fromScale(1, 0) }

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v8 = {
		LayoutOrder = 2,
		cornerRadius = UDim.new(0, 20),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		backgroundStyle = deriveBackgroundStyle(props.surfaceColor, 0.2, props.transparencyValue),
		stroke = {
			Color = tokens.Color.Stroke.Default.Color3,
			Transparency = deriveTransparency(tokens.Color.Stroke.Default.Transparency, props.transparencyValue) -- inferred equivalent call
		},
		padding = { right = UDim.new(0, 2) }
	}
	local customDisabledContent

	if props.shouldReplaceDisabledContent then
		customDisabledContent = props2.disabledOverlay
	end

	local leadingActionContainer

	if props.showLeadingAction then
		leadingActionContainer = React.createElement(
			Foundation.View,
			{ tag = "position-top-left", Size = UDim2.new(0, v3, 1, 0) },
			{
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Action = props.leadingAddon
			}
		)
	end

	local textContainer

	if not props.shouldReplaceDisabledContent then
		local createElement4 = React.createElement
		local view4 = Foundation.View
		local v9 = {
			tag = "auto-y",
			Position = UDim2.fromOffset(v3, 0),
			Size = UDim2.new(1, -(v3 + v4), 0, 0),
			padding = {
				top = UDim.new(0, 10),
				bottom = UDim.new(0, 10),
				left = UDim.new(0, 10),
				right = UDim.new(0, 10)
			}
		}

		local v10 = {
			SideChip = renderSideChip(props),
			CenterOverlay = props2.centerOverlay,
			DisabledLabel = 0,
			TextBoxContainer = 0
		}
		local disabledLabel

		if not props.canChat then
			local createElement5 = React.createElement
			local text = Foundation.Text
			local v11 = {
				tag = "position-top-right anchor-top-right auto-y text-caption-medium text-wrap text-align-x-left text-align-y-top content-muted",
				Text = props2.disabledChatPlaceholderText or "",
				Size = props.reserveSize,
				TextTransparency = 0
			}
			local transparencyValue = props.transparencyValue
			local textTransparency

			if ReactIs.isBinding(transparencyValue) then
				local v12
				v12 = 0.5
				textTransparency = transparencyValue:map(function(p: number)
					return fade(v12, p) -- inferred equivalent call
				end)
			else
				textTransparency = transparencyValue * 0.5 + 0.5
			end

			v11.TextTransparency = textTransparency
			disabledLabel = createElement5(text, v11)
		end

		v10.DisabledLabel = disabledLabel
		local textBoxContainer

		if props.canChat then
			local createElement5 = React.createElement
			local view5 = Foundation.View
			local v11 = {
				tag = "position-top-right anchor-top-right auto-y",
				Size = props.reserveSize
			}

			local createElement6 = React.createElement
			local v12 = {}
			v12.AnchorPoint = Vector2.new(0, 0)
			v12.AutomaticSize = Enum.AutomaticSize.XY
			v12.BackgroundTransparency = 1
			v12.ClearTextOnFocus = false
			v12.MaxVisibleGraphemes = props2.maximumCharacterLimit or -1
			v12.FontFace = props2.fontFace or normalizeFontFace(tokens.Typography.CaptionMedium.Font)
			v12.PlaceholderText = FFlagExpChatHidePlaceholderUnderOverlay
				and props2.centerOverlay ~= nil
				and props2.centerOverlayTextHidden
				and ""
				or props2.placeholderText
				or ""

			v12.PlaceholderColor3 = props.placeholderColor
			v12.Size = UDim2.fromScale(1, 0)
			v12.Text = props2.defaultValue or ""
			v12.TextColor3 = props.textColor
			v12.TextSize = textSize
			local textTransparency

			if props2.centerOverlay == nil or not props2.centerOverlayTextHidden then
				local transparencyValue = props.transparencyValue

				if ReactIs.isBinding(transparencyValue) then
					local v13
					v13 = 0
					textTransparency = transparencyValue:map(function(p: number)
						return fade(v13, p) -- inferred equivalent call
					end)
				else
					textTransparency = transparencyValue * 1 + 0
				end
			else
				textTransparency = 1
			end

			v12.TextTransparency = textTransparency

			v12.TextWrapped = true
			v12.TextXAlignment = Enum.TextXAlignment.Left
			v12.TextYAlignment = Enum.TextYAlignment.Top
			v12.TextEditable = props2.enableFocusedWrite ~= false
			v12.ZIndex = 2

			v12[React.Change.Text] = props.onTextChanged
			v12[React.Event.ReturnPressedFromOnScreenKeyboard] = props.onReturnPressedFromOnScreenKeyboard
			v12[React.Event.Focused] = props.onFocused
			v12[React.Event.FocusLost] = props.onFocusLost
			v12.ref = props.textBoxRef
			v12.SelectionImageObject = props2.selectionImageObject
			v12.Selectable = props2.selectionImageObject ~= nil or nil
			textBoxContainer = createElement5(view5, v11, {
				TextBox = createElement6("TextBox", v12)
			})
		end

		v10.TextBoxContainer = textBoxContainer
		textContainer = createElement4(view4, v9, v10)
	end

	local sendButtonContainer

	if v2 or v then
		local createElement4 = React.createElement
		local v9 = {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			GroupTransparency = props.transparencyValue,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, props.sendButtonContainerWidth + 6, 1, 0)
		}
		local v10 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SendButton = 0
		}
		local sendButton

		if v then
			sendButton = props2.primary
		else
			sendButton = renderSendButton(props)
		end

		v10.SendButton = sendButton
		sendButtonContainer = createElement4("CanvasGroup", v9, v10)
	end

	v6.Container = createElement2(view2, v7, {
		InputGroup = createElement3(view3, v8, {
			CustomDisabledContent = customDisabledContent,
			LeadingActionContainer = leadingActionContainer,
			TextContainer = textContainer,
			SendButtonContainer = sendButtonContainer
		})
	})
	return createElement(view, v5, v6)
end

local function renderComposer(props)
	local tokens = props.tokens
	local props2 = props.props
	local fontSize = tokens.Typography.BodyMedium.FontSize
	local v = props2.primary ~= nil
	local v2 = not props.shouldReplaceDisabledContent
	local v3 = props.sendButtonContainerWidth + 6

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = { tag = "size-full-0 auto-y", ref = props.barContainerRef }
	local v5 = { Dropdown = renderDropdown(props), TrayOverlay = props.trayOverlay, Container = 0 }
	local createElement2 = React.createElement
	local view2 = Foundation.View
	local leadingButton

	if FFlagExpChatComposerKeepTrayEntryMounted then
		if props.hasLeadingAction then
			leadingButton = React.createElement(
				Foundation.View,
				{ LayoutOrder = 1, tag = "auto-xy", Visible = props.showLeadingAction },
				{ Action = props.leadingAddon }
			)
		end
	elseif props.showLeadingAction then
		leadingButton = React.createElement(Foundation.View, { LayoutOrder = 1, tag = "auto-xy" }, {
			Action = props.leadingAddon
		})
	end

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v6 = {
		LayoutOrder = 2,
		cornerRadius = UDim.new(0, tokens.Radius.Circle),
		tag = "grow size-0 auto-y",
		backgroundStyle = props.pillBackgroundStyle,
		stroke = props.pillStroke,
		sizeConstraint = { MinSize = Vector2.new(0, 40) },
		padding = { right = UDim.new(0, 4) }
	}
	local customDisabledContent

	if props.shouldReplaceDisabledContent then
		customDisabledContent = props2.disabledOverlay
	end

	local textContainer

	if not props.shouldReplaceDisabledContent then
		local createElement4 = React.createElement
		local view4 = Foundation.View
		local v7 = {
			tag = "auto-y",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			ClipsDescendants = true,
			Size = UDim2.new(1, -v3, 0, 0),
			padding = {
				left = UDim.new(0, 16),
				right = UDim.new(0, 4),
				top = UDim.new(0, 10),
				bottom = UDim.new(0, 10)
			}
		}

		local v8 = {
			SideChip = renderSideChip(props),
			CenterOverlay = props2.centerOverlay,
			DisabledLabel = 0,
			TextBoxContainer = 0
		}
		local disabledLabel

		if not props.canChat then
			local createElement5 = React.createElement
			local text = Foundation.Text
			local v9 = {
				tag = "position-top-right anchor-top-right auto-y text-body-medium text-align-x-left text-truncate-end content-muted",
				Text = props2.disabledChatPlaceholderText or "",
				Size = props.reserveSize,
				TextTransparency = 0
			}
			local transparencyValue = props.transparencyValue
			local textTransparency

			if ReactIs.isBinding(transparencyValue) then
				local v10
				v10 = 0.5
				textTransparency = transparencyValue:map(function(p: number)
					return fade(v10, p) -- inferred equivalent call
				end)
			else
				textTransparency = transparencyValue * 0.5 + 0.5
			end

			v9.TextTransparency = textTransparency
			disabledLabel = createElement5(text, v9)
		end

		v8.DisabledLabel = disabledLabel
		local textBoxContainer

		if props.canChat then
			textBoxContainer = React.createElement(
				Foundation.View,
				{
					tag = "position-top-right anchor-top-right auto-y clip",
					Size = props.reserveSize
				},
				{
					TextBox = React.createElement("TextBox", {
						AnchorPoint = Vector2.new(0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						MaxVisibleGraphemes = props2.maximumCharacterLimit or -1,
						FontFace = props2.fontFace or normalizeFontFace(tokens.Typography.BodyMedium.Font),
						PlaceholderText = FFlagExpChatHidePlaceholderUnderOverlay and props2.centerOverlay ~= nil and props2.centerOverlayTextHidden and "" or props2.placeholderText or "",
						PlaceholderColor3 = props.composerPlaceholderColor,
						Size = UDim2.fromScale(1, 0),
						Text = props2.defaultValue or "",
						TextColor3 = props.textColor,
						TextSize = fontSize,
						TextTransparency = props2.centerOverlay ~= nil and props2.centerOverlayTextHidden and 1 or props.textTransparency,
						TextWrapped = false,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextEditable = props2.enableFocusedWrite ~= false,
						ZIndex = 2,
						[React.Change.Text] = props.onTextChanged,
						[React.Event.ReturnPressedFromOnScreenKeyboard] = props.onReturnPressedFromOnScreenKeyboard,
						[React.Event.Focused] = props.onFocused,
						[React.Event.FocusLost] = props.onFocusLost,
						ref = props.textBoxRef,
						SelectionImageObject = props2.selectionImageObject,
						Selectable = props2.selectionImageObject ~= nil or nil
					})
				}
			)
		end

		v8.TextBoxContainer = textBoxContainer
		textContainer = createElement4(view4, v7, v8)
	end

	local sendButtonContainer

	if v2 then
		local createElement4 = React.createElement
		local v7 = {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			GroupTransparency = props.pillTransparency,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, 0, 1, 0)
		}
		local v8 = {
			Layout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			SendButton = 0
		}
		local sendButton

		if v then
			sendButton = props2.primary
		else
			sendButton = renderSendButton(props)
		end

		v8.SendButton = sendButton
		sendButtonContainer = createElement4("CanvasGroup", v7, v8)
	end

	v5.Container = createElement2(view2, { tag = "row align-y-center gap-small size-full-0 auto-y" }, {
		LeadingButton = leadingButton,
		InputGroup = createElement3(view3, v6, {
			CustomDisabledContent = customDisabledContent,
			TextContainer = textContainer,
			SendButtonContainer = sendButtonContainer
		})
	})
	return createElement(view, v4, v5)
end

local function ChatInputBarView(props)
	local tokens = Foundation.Hooks.useTokens()

	local themedColors = props.themedColors
	local color3

	if themedColors then
		color3 = tokens.Color.Surface.Surface_100.Color3
	else
		color3 = tokens.DarkMode.Surface.Surface_100.Color3
	end

	local color3_2

	if themedColors then
		color3_2 = tokens.Color.Content.Muted.Color3
	else
		color3_2 = tokens.DarkMode.Content.Muted.Color3
	end

	local color3_3

	if themedColors then
		color3_3 = tokens.Color.Content.Emphasis.Color3
	else
		color3_3 = tokens.DarkMode.Content.Emphasis.Color3
	end

	local color3_4

	if themedColors then
		color3_4 = tokens.Color.Content.Default.Color3
	else
		color3_4 = tokens.DarkMode.Content.Default.Color3
	end

	local onChange = props.onChange
	local onSend = props.onSend
	local canLocalUserChat = props.canLocalUserChat
	local transparencyValue = props.transparencyValue or 0
	local maximumCharacterLimit = props.maximumCharacterLimit
	local shouldReplaceDisabledContent = not canLocalUserChat and props.disabledOverlay ~= nil

	local pillStrokeStyle = props.pillStrokeStyle
	local pillTransparency = React.useMemo(function()
		if canLocalUserChat or pillStrokeStyle ~= nil then
			return transparencyValue
		end

		local transparencyValue2 = transparencyValue

		if not ReactIs.isBinding(transparencyValue2) then
			return transparencyValue2 * 0.5 + 0.5
		end

		local v
		v = 0.5
		return (transparencyValue2:map(function(p: number)
			return fade(v, p) -- inferred equivalent call
		end))
	end, { canLocalUserChat, transparencyValue, pillStrokeStyle })
	local pillBackgroundStyle = React.useMemo(function()
		return deriveBackgroundStyle(color3, 0.2, pillTransparency)
	end, { color3, pillTransparency })
	local pillStroke = React.useMemo(function()
		if pillStrokeStyle then
			return {
				Color = pillStrokeStyle.Color3,
				Transparency = deriveTransparency(pillStrokeStyle.Transparency or 0, transparencyValue) -- inferred equivalent call
			}
		end

		return {
			Color = tokens.Color.Stroke.Default.Color3,
			Transparency = deriveTransparency(tokens.Color.Stroke.Default.Transparency, pillTransparency) -- inferred equivalent call
		}
	end, { tokens, pillTransparency, pillStrokeStyle, transparencyValue })
	local textTransparency = React.useMemo(function()
		return deriveTransparency(0, transparencyValue)
	end, { transparencyValue })

	local ref = React.useRef(nil)
	local textBoxRef = props.textBoxRef or ref
	local ref2 = React.useRef(nil)
	local v = useChatAutocompleteEngine(textBoxRef, props.autocomplete)
	local autocomplete = useAutocompleteSources(textBoxRef, props.autocompleteOptions)

	if props.autocompleteOptions == nil then
		autocomplete = v
	end

	local ref3 = React.useRef(props.defaultValue or "")
	local state, setState = React.useState(function(): boolean
		return (props.defaultValue or "") == ""
	end)

	local v2, v3 = React.useBinding(0)

	local onChannelChipAbsoluteSizeChanged = React.useCallback(function(p)
		v3(p.AbsoluteSize.X)
	end, {})

	local size_200 = tokens.Size.Size_200
	local composerLayout = props.composerLayout == true
	local reserveSize = React.useMemo(function()
		if composerLayout then
			return v2:map(function(p: number)
				local v4 = not (p > 0) and 0 or p + size_200
				return UDim2.new(1, -v4, 0, 0)
			end)
		end

		return v2:map(function(p: number)
			return UDim2.new(1, -(p + size_200), 0, 0)
		end)
	end, { v2, size_200, composerLayout })

	local onSendActivated = React.useCallback(function()
		local current = textBoxRef.current
		local v4 = not current and "" or current.Text

		if v4 == "" then
			return
		end

		onSend(v4)

		if current then
			current.Text = ""
		end

		setState(true)
	end, { onSend, textBoxRef })

	local onReturnPressedFromOnScreenKeyboard = React.useCallback(function()
		local current = textBoxRef.current

		if current then
			current:ReleaseFocus(true)
		end
	end, { textBoxRef })

	local onTextChanged = React.useCallback(function(p)
		local text = p.Text

		if maximumCharacterLimit ~= nil then
			if FFlagChatInputBarGuardInvalidUtf8 then
				local textLengthIfValidUtf8 = getTextLengthIfValidUtf8(text)

				if textLengthIfValidUtf8 ~= nil then
					if maximumCharacterLimit < textLengthIfValidUtf8 then
						p.Text = ref3.current
						return
					end

					ref3.current = text
				end
			else
				local v4 = utf8.nfcnormalize(text)

				if maximumCharacterLimit < (utf8.len(v4) or #v4) then
					p.Text = ref3.current
					return
				end

				ref3.current = text
			end
		end

		setState(text == "")

		if onChange then
			onChange(text)
		end

		autocomplete.onTextChanged(text)
	end, { onChange, maximumCharacterLimit, autocomplete.onTextChanged })

	local onFocused = React.useCallback(function()
		if props.onFocusGained then
			props.onFocusGained()
		end
	end, { props.onFocusGained })

	local v4 = React.useCallback(function(p)
		if props.autocompleteOptions ~= nil then
			setState(p.Text == "")
		end
	end, { props.autocompleteOptions })

	local onCommitSelection = React.useCallback(function(p: number)
		autocomplete.commitSelection(p)
		local current = textBoxRef.current

		if current ~= nil then
			v4(current)
		end
	end, { autocomplete.commitSelection, textBoxRef, v4 })

	local onFocusLost = React.useCallback(function(_, flag: boolean)
		local current = textBoxRef.current

		if current and autocomplete.interceptSend(current, flag) then
			v4(current)
		elseif flag then
			onSendActivated()
		end

		if props.onFocusLost then
			props.onFocusLost()
		end
	end, { onSendActivated, props.onFocusLost, textBoxRef, autocomplete.interceptSend, v4 })

	React.useEffect(function()
		if not canLocalUserChat then
			setState(true)
		end
	end, { canLocalUserChat })

	local v5 = useExpressionTray(props.expressionTray)
	local v6, trayOverlay

	if not (v5 == nil or not v5.isVisible) then
		v6 = React.createElement(ExpressionTrayView, withVariant(v5, "entry")) -- inferred equivalent call
		trayOverlay = React.createElement(ExpressionTrayView, withVariant(v5, "overlay")) -- inferred equivalent call
	end

	local leadingAddon = if v6 == nil then props.leftAddon else v6
	local hasLeadingAction = leadingAddon ~= nil
	local showLeadingAction

	if FFlagExpChatComposerKeepTrayEntryOnDisabledOverlay then
		showLeadingAction = hasLeadingAction and state and (v6 ~= nil or not shouldReplaceDisabledContent)
	else
		showLeadingAction = hasLeadingAction and state and not shouldReplaceDisabledContent
	end

	if FFlagExpChatComposerKeepTrayEntryMounted then
		local v7

		if props.composerLayout == true and v5 ~= nil then
			v7 = v5.isOpen and not showLeadingAction
		else
			v7 = false
		end

		local onPressedOutside

		if v5 == nil then
			onPressedOutside = nil
		else
			onPressedOutside = v5.onPressedOutside
		end

		React.useEffect(function()
			if v7 and onPressedOutside ~= nil then
				onPressedOutside()
			end
		end, { v7, onPressedOutside })
	end

	assert(
		props.autocomplete == nil or props.autocompleteOptions == nil,
		"Pass autocomplete or autocompleteOptions, not both"
	)

	local v7 = {
		tokens = tokens,
		props = props,
		leadingAddon = leadingAddon,
		trayOverlay = trayOverlay,
		canChat = canLocalUserChat,
		isEmpty = state,
		isSendDisabled = state or not canLocalUserChat,
		hasLeadingAction = hasLeadingAction,
		showLeadingAction = showLeadingAction,
		shouldReplaceDisabledContent = shouldReplaceDisabledContent,
		transparencyValue = transparencyValue,
		textColor = color3_3,
		surfaceColor = color3,
		placeholderColor = color3_2,
		composerPlaceholderColor = color3_4,
		pillTransparency = pillTransparency,
		pillBackgroundStyle = pillBackgroundStyle,
		pillStroke = pillStroke,
		textTransparency = textTransparency,
		textBoxRef = textBoxRef,
		barContainerRef = ref2,
		reserveSize = reserveSize,
		autocomplete = autocomplete,
		sendButtonContainerWidth = 30,
		onChannelChipAbsoluteSizeChanged = onChannelChipAbsoluteSizeChanged,
		onSendActivated = onSendActivated,
		onCommitSelection = onCommitSelection,
		onReturnPressedFromOnScreenKeyboard = onReturnPressedFromOnScreenKeyboard,
		onTextChanged = onTextChanged,
		onFocused = onFocused,
		onFocusLost = onFocusLost
	}

	if props.composerLayout == true then
		return renderComposer(v7)
	end

	return renderLegacy(v7)
end

return React.memo(ChatInputBarView)
