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
	Size = UDim2.new(1, 0, 1, 0),
	onActivated = function()
		print("IconWithTextCell onActivated")
	end,
	secondaryIcon = "",
	secondaryIconSize = 24,
	iconCellWidth = 60,
	LayoutOrder = 0,
	style = Cryo.Dictionary.join(testStyle, {
		Tokens = {
			Color = { None = {} }
		}
	}),
	showDivider = true
}

local function IconWithTextCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local style = joined.style
	local theme = style.Theme
	local font = style.Font
	local v6 = useTokens()
	local v7 = joined.primaryIcon == nil

	local createElement = React.createElement
	local v9 = {
		Size = joined.Size,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = style.Tokens.Color.None.Transparency,
		onPressedBackgroundColor3 = theme.BackgroundOnPress.Color,
		onPressedBackgroundTransparency = theme.BackgroundOnPress.Transparency,
		LayoutOrder = joined.LayoutOrder,
		onActivated = joined.onActivated,
		showDivider = joined.showDivider,
		dividerColor3 = theme.Divider.Color,
		dividerTransparency = theme.Divider.Transparency,
		isDisabled = joined.isDisabled,
		avatarCircleCellWidth = joined.iconCellWidth,
		testId = p2.testId
	}

	local createElement2 = React.createElement
	local v11 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, -joined.iconCellWidth, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v12 = {
		leftListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		imageFrame = 0,
		text = 0
	}

	local v13 = if not v7 then React.createElement(
		"Frame",
		{
			Size = UDim2.new(0, joined.iconCellWidth, 0, joined.primaryIconSize),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		},
		{
			primaryIcon = React.createElement(imageSetLabel, {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = joined.primaryIcon,
				BorderSizePixel = 0,
				Size = UDim2.new(0, joined.primaryIconSize, 0, joined.primaryIconSize),
				ImageColor3 = theme.IconEmphasis.Color,
				BackgroundTransparency = 1
			})
		}
	) else nil
	v12.imageFrame = v13

	v12.text = React.createElement("TextLabel", {
		Size = UDim2.new(1, v7 and 0 or -joined.iconCellWidth, 1, 0),
		Text = joined.Text,
		TextSize = font.Header2.RelativeSize * font.BaseSize,
		FontFace = normalizeFontFace(v6.Typography.TitleLarge.Font),
		TextColor3 = theme.TextEmphasis.Color,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	})
	return createElement(BaseCell, v9, {
		leftFrame = createElement2("Frame", v11, v12),
		rightFrame = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.fromOffset(joined.iconCellWidth, joined.iconCellWidth),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, {
			secondaryIcon = joined.secondaryIcon and React.createElement("ImageLabel", {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = joined.secondaryIcon,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(joined.secondaryIconSize, joined.secondaryIconSize)
			})
		})
	})
end

return memo(IconWithTextCell)
