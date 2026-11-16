local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local BaseCell = require(script.Parent.BaseCell)

local SocialLibraries = require(AppChat.SocialLibraries)
local TestStyle = SocialLibraries.Components.TestStyle

require(AppChat.types)

local v = {
	Text = "titleText",
	primaryIconSize = 32,
	isDisabled = false,
	topPadding = 8,
	bottomPadding = 8,
	widthScale = 1,
	widthOffset = 0,
	onActivated = function()
		print("FlexIconWithTextCell onActivated")
	end,
	secondaryIcon = "",
	secondaryIconSize = 24,
	iconCellWidth = 60,
	LayoutOrder = 0,
	style = TestStyle,
	BackgroundTransparency = nil,
	showDivider = true
}

local function FlexIconWithTextCell(p)
	local union = Cryo.Dictionary.union(v, p)
	local style = union.style
	local theme = style.Theme
	local font = style.Font
	local v2

	if FoundationFontFaceMigration then
		v2 = useTokens()
	end

	local v3 = union.primaryIcon == nil

	local createElement = React.createElement
	local v4 = {
		Size = UDim2.new(1, union.widthOffset, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = union.BackgroundTransparency or theme.BackgroundDefault.Transparency,
		onPressedBackgroundColor3 = theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = theme.BackgroundOnPress.Transparency,
		LayoutOrder = union.LayoutOrder,
		onActivated = union.onActivated,
		showDivider = union.showDivider,
		dividerColor3 = theme.Divider.Color,
		dividerTransparency = theme.Divider.Transparency,
		isDisabled = union.isDisabled,
		avatarCircleCellWidth = union.iconCellWidth
	}

	local createElement2 = React.createElement
	local v6 = {
		Size = UDim2.new(1, -union.iconCellWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v7 = {
		leftListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		leftFramePadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, union.topPadding),
			PaddingBottom = UDim.new(0, union.bottomPadding)
		}),
		imageFrame = 0,
		textFrame = 0
	}
	local imageFrame

	if not v3 then
		imageFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.new(0, union.iconCellWidth, 0, union.primaryIconSize),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				primaryIcon = React.createElement(ImageSetLabel, {
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = union.primaryIcon,
					BorderSizePixel = 0,
					Size = UDim2.new(0, union.primaryIconSize, 0, union.primaryIconSize),
					ImageColor3 = theme.IconEmphasis.Color,
					BackgroundTransparency = 1
				})
			}
		)
	end

	v7.imageFrame = imageFrame

	local createElement3 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v9 = {
		uiListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		titleText = 0,
		subTitleText = 0
	}

	local createElement4 = React.createElement
	local v10 = {
		Size = UDim2.new(1, v3 and 0 or -union.iconCellWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = union.Text,
		TextSize = font.Header2.RelativeSize * font.BaseSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		TextTruncate = 0,
		TextWrapped = true,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Header2.Font
	end

	v10.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v2.Typography.TitleLarge.Font)
	end

	v10.FontFace = fontFace

	v10.TextColor3 = theme.TextEmphasis.Color
	v10.TextXAlignment = Enum.TextXAlignment.Left
	v10.TextTruncate = Enum.TextTruncate.AtEnd
	v9.titleText = createElement4("TextLabel", v10)
	local subTitleText

	if union.SubTitleText then
		local createElement5 = React.createElement
		local v5 = {
			Size = UDim2.new(1, v3 and 0 or -union.iconCellWidth, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = union.SubTitleText,
			TextSize = font.BodySmall.RelativeSize * font.BaseSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font.BodySmall.Font
		end

		v5.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v2.Typography.BodySmall.Font)
		end

		v5.FontFace = fontFace2

		v5.TextColor3 = theme.TextDefault.Color
		v5.TextXAlignment = Enum.TextXAlignment.Left
		subTitleText = createElement5("TextLabel", v5)
	end

	v9.subTitleText = subTitleText
	v7.textFrame = createElement3("Frame", v8, v9)
	local v5 = {
		leftFrame = createElement2("Frame", v6, v7),
		rightFrame = 0
	}
	local rightFrame

	if union.secondaryIcon then
		rightFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromOffset(union.iconCellWidth, union.iconCellWidth),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				secondaryIcon = React.createElement("ImageLabel", {
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = union.secondaryIcon,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(union.secondaryIconSize, union.secondaryIconSize)
				})
			}
		)
	end

	v5.rightFrame = rightFrame
	return createElement(BaseCell, v4, v5)
end

return memo(FlexIconWithTextCell)
