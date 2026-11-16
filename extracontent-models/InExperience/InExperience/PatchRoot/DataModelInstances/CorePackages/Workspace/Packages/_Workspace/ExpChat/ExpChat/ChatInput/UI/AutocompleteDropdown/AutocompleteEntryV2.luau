local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local EmojiList = require(parent.EmojiList)

local UIBlox = require(parent.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor

local Config = require(ExpChat.Config)
local PresetEntryText = require(ExpChat.Autocomplete.PresetEntryText)
local highlightMatchedText = require(ExpChat.Autocomplete.highlightMatchedText)

local function AutocompleteEntryV2(props)
	local v = Foundation.Hooks.useTokens()
	local selectionImageObject = useCursor()
	local chatInputBarSettings = props.chatInputBarSettings
	local v2 = props.layoutOrder == props.selectedIndex
	local size_1000 = v.Size.Size_1000

	local text = highlightMatchedText(
		props.result,
		props.query,
		chatInputBarSettings.TextColor3:Lerp(chatInputBarSettings.BackgroundColor3, 0.3)
	)

	if props.autocompleteType == "presets" then
		text = PresetEntryText.decorate(text, chatInputBarSettings.TextSize)
	end

	local createElement = React.createElement
	local onAutocompleteDropdownHoversByMouseEnter = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, size_1000),
		ZIndex = 2,
		[React.Event.MouseEnter] = props.onAutocompleteDropdownHover
	}

	local createElement2 = React.createElement
	local onAutocompleteSelectedsByActivated = {}
	onAutocompleteSelectedsByActivated.AutomaticSize = Enum.AutomaticSize.Y
	local backgroundColor

	if v2 then
		backgroundColor = Config.AutocompleteSelectedColor
	end

	onAutocompleteSelectedsByActivated.BackgroundColor3 = backgroundColor
	onAutocompleteSelectedsByActivated.BackgroundTransparency = props.setTransparency(
		not v2 and 1 or Config.AutocompleteSelectedTransparency,
		props.transparencyValue
	)

	onAutocompleteSelectedsByActivated.SelectionImageObject = selectionImageObject
	onAutocompleteSelectedsByActivated.Size = UDim2.new(1, 0, 0, size_1000)
	onAutocompleteSelectedsByActivated.Text = ""
	onAutocompleteSelectedsByActivated.ZIndex = 3
	onAutocompleteSelectedsByActivated[React.Event.Activated] = props.onAutocompleteSelected
	local v3 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Padding.Small),
			PaddingRight = UDim.new(0, v.Padding.Small),
			PaddingTop = UDim.new(0, v.Padding.XSmall),
			PaddingBottom = UDim.new(0, v.Padding.XSmall)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v.Gap.Medium),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		EmojiLabel = 0,
		TextLabel = 0
	}
	local emojiLabel

	if props.autocompleteType == "emojis" then
		emojiLabel = React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = chatInputBarSettings.FontFace,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v.Size.Size_600, 0),
			Text = EmojiList[props.result].base,
			TextColor3 = chatInputBarSettings.TextColor3,
			TextSize = chatInputBarSettings.TextSize,
			TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3,
			TextStrokeTransparency = props.setTransparency(
				chatInputBarSettings.TextStrokeTransparency,
				props.transparencyValue
			),
			TextTransparency = props.setTransparency(0, props.transparencyValue),
			ZIndex = 2
		})
	end

	v3.EmojiLabel = emojiLabel

	v3.TextLabel = React.createElement("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		FontFace = chatInputBarSettings.FontFace,
		LayoutOrder = 2,
		RichText = true,
		Size = UDim2.new(),
		Text = text,
		TextColor3 = chatInputBarSettings.TextColor3,
		TextSize = chatInputBarSettings.TextSize,
		TextStrokeColor3 = chatInputBarSettings.TextStrokeColor3,
		TextStrokeTransparency = props.setTransparency(
			chatInputBarSettings.TextStrokeTransparency,
			props.transparencyValue
		),
		TextTransparency = props.setTransparency(0, props.transparencyValue),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2
	}, {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	})
	return createElement("Frame", onAutocompleteDropdownHoversByMouseEnter, {
		TextLabelButton = createElement2("TextButton", onAutocompleteSelectedsByActivated, v3)
	})
end

return AutocompleteEntryV2
