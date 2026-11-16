local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local imageSetLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.ImageSet.ImageSetLabel
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
	local v6 = if foundationFontFaceMigration then useTokens() else nil

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
		titleText = 0,
		subTitleText = 0
	}

	local createElement4 = React.createElement
	local v19 = {
		Size = UDim2.new(1, v7 and 0 or -union.iconCellWidth, 0, 0),
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
	local v20 = if not foundationFontFaceMigration then font.Header2.Font else nil
	v19.Font = v20

	local v21 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.TitleLarge.Font) else nil
	v19.FontFace = v21

	v19.TextColor3 = theme.TextEmphasis.Color
	v19.TextXAlignment = Enum.TextXAlignment.Left
	v19.TextTruncate = Enum.TextTruncate.AtEnd
	v17.titleText = createElement4("TextLabel", v19)
	local v22

	if union.SubTitleText then
		local createElement5 = React.createElement
		local v24 = {
			Size = UDim2.new(1, v7 and 0 or -union.iconCellWidth, 0, 0),
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
		local v25 = if not foundationFontFaceMigration then font.BodySmall.Font else nil
		v24.Font = v25

		local v26 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v24.FontFace = v26

		v24.TextColor3 = theme.TextDefault.Color
		v24.TextXAlignment = Enum.TextXAlignment.Left
		v22 = createElement5("TextLabel", v24)
	end

	v17.subTitleText = v22
	v13.textFrame = createElement3("Frame", v16, v17)
	local v10 = {
		leftFrame = createElement2("Frame", v12, v13),
		rightFrame = 0
	}

	local v23 = if union.secondaryIcon then React.createElement(
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
	v10.rightFrame = v23
	return createElement(BaseCell, v9, v10)
end

return memo(FlexIconWithTextCell)
