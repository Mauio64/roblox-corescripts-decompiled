local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)

local parent2 = ExpChat.Parent
local EmojiList = require(parent2.EmojiList)

local UIBlox = require(parent2.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor

local Config = require(ExpChat.Config)
local PresetEntryText = require(ExpChat.Autocomplete.PresetEntryText)

local FFlagExpChatPresetChatAutocompleteEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatAutocompleteEnabled)

return function(props)
	local selectionImageObject = useCursor()
	local createElement = React.createElement
	local onAutocompleteDropdownHoversByMouseEnter = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, Config.AutocompleteEntryDefaultSizeY),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = 2,
		[React.Event.MouseEnter] = props.onAutocompleteDropdownHover
	}

	local createElement2 = React.createElement
	local onAutocompleteSelectedsByActivated = {
		Size = UDim2.new(1, 0, 1, props.isDividerVisible and -1 or 0),
		BackgroundTransparency = props.setTransparency(
			props.layoutOrder == props.selectedIndex and Config.AutocompleteSelectedTransparency or 1,
			props.transparencyValue
		),
		BackgroundColor3 = props.layoutOrder == props.selectedIndex and Config.AutocompleteSelectedColor or nil,
		SelectionImageObject = selectionImageObject,
		Text = "",
		ZIndex = 3,
		[React.Event.Activated] = props.onAutocompleteSelected
	}
	local v = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 15),
			PaddingRight = UDim.new(0, 30),
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		EmojiLabel = 0,
		SpaceLabel = 0,
		TextLabel = 0
	}
	local emojiLabel

	if props.autocompleteType == "emojis" then
		emojiLabel = React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = props.chatInputBarSettings.FontFace,
			RichText = true,
			Size = UDim2.new(0, 0, 0, 0),
			Text = string.format("%s", EmojiList[props.result].base),
			TextColor3 = props.chatInputBarSettings.TextColor3,
			TextSize = props.chatInputBarSettings.TextSize,
			TextStrokeColor3 = props.chatInputBarSettings.TextStrokeColor3,
			TextStrokeTransparency = props.setTransparency(
				props.chatInputBarSettings.TextStrokeTransparency,
				props.transparencyValue
			),
			TextTransparency = props.setTransparency(0, props.transparencyValue),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 1,
			ZIndex = 2
		})
	else
		emojiLabel = false
	end

	v.EmojiLabel = emojiLabel
	local spaceLabel

	if props.autocompleteType == "emojis" then
		spaceLabel = React.createElement("TextLabel", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			FontFace = props.chatInputBarSettings.FontFace,
			RichText = true,
			Size = UDim2.new(0, 0, 0, 0),
			Text = "  ",
			TextColor3 = props.chatInputBarSettings.TextColor3,
			TextSize = 14,
			TextStrokeColor3 = props.chatInputBarSettings.TextStrokeColor3,
			TextStrokeTransparency = props.setTransparency(
				props.chatInputBarSettings.TextStrokeTransparency,
				props.transparencyValue
			),
			TextTransparency = props.setTransparency(0, props.transparencyValue),
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 2,
			ZIndex = 2
		})
	else
		spaceLabel = false
	end

	v.SpaceLabel = spaceLabel

	local createElement3 = React.createElement
	local v2 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = props.chatInputBarSettings.FontFace,
		RichText = true,
		Size = UDim2.new(0, 0, 0, 0),
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextStrokeColor3 = 0,
		TextStrokeTransparency = 0,
		TextTransparency = 0,
		TextWrapped = true,
		TextXAlignment = 0,
		TextYAlignment = 0,
		LayoutOrder = 3,
		ZIndex = 2
	}
	local text

	if FFlagExpChatPresetChatAutocompleteEnabled and props.autocompleteType == "presets" then
		text = PresetEntryText.decorate(props.result, props.chatInputBarSettings.TextSize)
	else
		text = string.format("%s", props.result)
	end

	v2.Text = text

	v2.TextColor3 = props.chatInputBarSettings.TextColor3
	v2.TextSize = props.chatInputBarSettings.TextSize
	v2.TextStrokeColor3 = props.chatInputBarSettings.TextStrokeColor3
	v2.TextStrokeTransparency = props.setTransparency(
		props.chatInputBarSettings.TextStrokeTransparency,
		props.transparencyValue
	)

	v2.TextTransparency = props.setTransparency(0, props.transparencyValue)

	v2.TextXAlignment = Enum.TextXAlignment.Left
	v2.TextYAlignment = Enum.TextYAlignment.Top
	v.TextLabel = createElement3("TextLabel", v2)
	return createElement("Frame", onAutocompleteDropdownHoversByMouseEnter, {
		TextLabelButton = createElement2("TextButton", onAutocompleteSelectedsByActivated, v),
		Divider = props.isDividerVisible and React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = props.setTransparency(
				Config.ChatInputBarBorderTransparency,
				props.transparencyValue
			),
			BackgroundColor3 = Config.ChatInputBarBorderColor3,
			BorderSizePixel = 0,
			ZIndex = 2
		}) or nil
	})
end
