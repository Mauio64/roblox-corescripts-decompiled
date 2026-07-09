local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local ExpChatParent2 = ExpChat.Parent
local EmojiList = require(ExpChatParent2.EmojiList)
local useCursor = require(ExpChatParent2.UIBlox).App.SelectionCursor.useCursor
local Config = require(ExpChat.Config)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)

return function(p1) -- line: 14
	-- upvalues: FFlagExpChatEnableFocusNavigation (copy), useCursor (copy), React (copy), Config (copy), EmojiList (copy)
	local v10 = if not FFlagExpChatEnableFocusNavigation then nil else useCursor()

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, Config.AutocompleteEntryDefaultSizeY),
		BackgroundTransparency = 1,
		LayoutOrder = p1.layoutOrder,
		ZIndex = 2,
		[React.Event.MouseEnter] = p1.onAutocompleteDropdownHover
	}, {
		TextLabelButton = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, not p1.isDividerVisible and 0 or -1),
			BackgroundTransparency = p1.setTransparency(p1.layoutOrder == p1.selectedIndex and Config.AutocompleteSelectedTransparency or 1, p1.transparencyValue),
			BackgroundColor3 = p1.layoutOrder == p1.selectedIndex and Config.AutocompleteSelectedColor or nil,
			SelectionImageObject = v10,
			Text = "",
			ZIndex = 3,
			[React.Event.Activated] = p1.onAutocompleteSelected
		}, {
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
			EmojiLabel = p1.autocompleteType == "emojis" and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				RichText = true,
				TextWrapped = true,
				LayoutOrder = 1,
				ZIndex = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				FontFace = p1.chatInputBarSettings.FontFace,
				Size = UDim2.new(0, 0, 0, 0),
				Text = string.format("%s", EmojiList[p1.result].base),
				TextColor3 = p1.chatInputBarSettings.TextColor3,
				TextSize = p1.chatInputBarSettings.TextSize,
				TextStrokeColor3 = p1.chatInputBarSettings.TextStrokeColor3,
				TextStrokeTransparency = p1.setTransparency(p1.chatInputBarSettings.TextStrokeTransparency, p1.transparencyValue),
				TextTransparency = p1.setTransparency(0, p1.transparencyValue),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			SpaceLabel = p1.autocompleteType == "emojis" and React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				RichText = true,
				Text = "  ",
				TextSize = 14,
				TextWrapped = true,
				LayoutOrder = 2,
				ZIndex = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				FontFace = p1.chatInputBarSettings.FontFace,
				Size = UDim2.new(0, 0, 0, 0),
				TextColor3 = p1.chatInputBarSettings.TextColor3,
				TextStrokeColor3 = p1.chatInputBarSettings.TextStrokeColor3,
				TextStrokeTransparency = p1.setTransparency(p1.chatInputBarSettings.TextStrokeTransparency, p1.transparencyValue),
				TextTransparency = p1.setTransparency(0, p1.transparencyValue),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			}),
			TextLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				RichText = true,
				TextWrapped = true,
				LayoutOrder = 3,
				ZIndex = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				FontFace = p1.chatInputBarSettings.FontFace,
				Size = UDim2.new(0, 0, 0, 0),
				Text = string.format("%s", p1.result),
				TextColor3 = p1.chatInputBarSettings.TextColor3,
				TextSize = p1.chatInputBarSettings.TextSize,
				TextStrokeColor3 = p1.chatInputBarSettings.TextStrokeColor3,
				TextStrokeTransparency = p1.setTransparency(p1.chatInputBarSettings.TextStrokeTransparency, p1.transparencyValue),
				TextTransparency = p1.setTransparency(0, p1.transparencyValue),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		}),
		Divider = p1.isDividerVisible and React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = p1.setTransparency(Config.ChatInputBarBorderTransparency, p1.transparencyValue),
			BackgroundColor3 = Config.ChatInputBarBorderColor3
		}) or nil
	})
end
