local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local imageSetLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.ImageSet.ImageSetLabel
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local BaseCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/BaseCell")

local testStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Components.TestStyle

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local v5 = {
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
	style = testStyle,
	BackgroundTransparency = nil,
	showDivider = true
}

local function FlexIconWithTextCell(p2)
	local union = Cryo.Dictionary.union(v5, p2)
	local style = union.style
	local theme = style.Theme
	local font = style.Font
	local v6 = useTokens()
	local v7 = union.primaryIcon == nil

	local createElement = React.createElement
	local v9 = {
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
	local v12 = {
		Size = UDim2.new(1, -union.iconCellWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v13 = {
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

	local v14 = if not v7 then React.createElement(
		"Frame",
		{
			Size = UDim2.new(0, union.iconCellWidth, 0, union.primaryIconSize),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		},
		{
			primaryIcon = React.createElement(imageSetLabel, {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = union.primaryIcon,
				BorderSizePixel = 0,
				Size = UDim2.new(0, union.primaryIconSize, 0, union.primaryIconSize),
				ImageColor3 = theme.IconEmphasis.Color,
				BackgroundTransparency = 1
			})
		}
	) else nil
	v13.imageFrame = v14

	local createElement3 = React.createElement
	local v16 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v17 = {
		uiListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		titleText = React.createElement("TextLabel", {
			Size = UDim2.new(1, v7 and 0 or -union.iconCellWidth, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = union.Text,
			TextSize = font.Header2.RelativeSize * font.BaseSize,
			FontFace = normalizeFontFace(v6.Typography.TitleLarge.Font),
			TextColor3 = theme.TextEmphasis.Color,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}),
		subTitleText = 0
	}

	local v18 = if union.SubTitleText then React.createElement("TextLabel", {
		Size = UDim2.new(1, v7 and 0 or -union.iconCellWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = union.SubTitleText,
		TextSize = font.BodySmall.RelativeSize * font.BaseSize,
		FontFace = normalizeFontFace(v6.Typography.BodySmall.Font),
		TextColor3 = theme.TextDefault.Color,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}) else nil
	v17.subTitleText = v18
	v13.textFrame = createElement3("Frame", v16, v17)
	local v10 = {
		leftFrame = createElement2("Frame", v12, v13),
		rightFrame = 0
	}

	local v19 = if union.secondaryIcon then React.createElement(
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
	) else nil
	v10.rightFrame = v19
	return createElement(BaseCell, v9, v10)
end

return memo(FlexIconWithTextCell)
