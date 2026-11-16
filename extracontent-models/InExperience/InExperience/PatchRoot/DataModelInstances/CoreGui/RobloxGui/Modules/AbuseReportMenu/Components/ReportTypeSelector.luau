local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CorePackages = game:GetService("CorePackages")
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)

local React = require(CorePackages.Packages.React)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(AbuseReportMenu.Components.Constants)
local getMenuItemDimensions = require(AbuseReportMenu.Components.getMenuItemDimensions)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
local TextButton = UIBlox.App.Button.TextButton
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

return function(props)
	local size_200 = useStyle().Tokens.Size.Size_200
	local menuItemDimensions = getMenuItemDimensions(props.menuWidth)
	local menuItemSizings = getMenuItemSizings()

	local menuItemHeightTight = Constants.MenuItemHeightTight

	local v = math.max(
		props.menuWidth - Constants.MenuItemDynamicWidthOffset,
		menuItemDimensions.LeftWidth + menuItemDimensions.RightWidth
	)

	local isSmallPortraitViewport = props.isSmallPortraitViewport

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local createElement2 = React.createElement
	local fillDirection

	if isSmallPortraitViewport then
		fillDirection = Enum.FillDirection.Vertical
	else
		fillDirection = Enum.FillDirection.Horizontal
	end

	local v3 = {
		FillDirection = fillDirection,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = 0
	}
	local padding

	if isSmallPortraitViewport then
		padding = UDim.new(0, size_200)
	else
		padding = UDim.new(0, 0)
	end

	v3.Padding = padding
	local children = {
		Layout = createElement2("UIListLayout", v3),
		Label = 0,
		MiddleWidthHolder = 0,
		Container = 0
	}

	local createElement3 = React.createElement
	local v4 = {
		Text = props.label,
		Font = AppFonts.default:getMedium(),
		LayoutOrder = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0,
		TextSize = menuItemDimensions.TextSize,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = 0,
		BackgroundTransparency = 1
	}
	local size

	if isSmallPortraitViewport then
		size = UDim2.fromOffset(v, 0)
	else
		size = UDim2.new(0, menuItemDimensions.LeftWidth, 0, Constants.MenuItemHeight)
	end

	v4.Size = size
	children.Label = createElement3("TextLabel", v4)
	local middleWidthHolder

	if not isSmallPortraitViewport then
		middleWidthHolder = React.createElement("Frame", {
			Size = UDim2.new(
				0,
				math.max(0, props.menuWidth - menuItemDimensions.LeftWidth - menuItemDimensions.RightWidth - 100),
				0,
				Constants.MenuItemHeight
			),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		})
	end

	children.MiddleWidthHolder = middleWidthHolder

	local createElement4 = React.createElement
	local size2

	if isSmallPortraitViewport then
		size2 = UDim2.fromOffset(v, menuItemHeightTight)
	else
		size2 = UDim2.new(0, menuItemDimensions.RightWidth, 1, 0)
	end

	local createElement5 = React.createElement
	local v5 = {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = 0,
		VerticalAlignment = 0
	}
	local horizontalAlignment

	if isSmallPortraitViewport then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	else
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	v5.HorizontalAlignment = horizontalAlignment

	v5.VerticalAlignment = Enum.VerticalAlignment.Center
	local children2 = {
		Layout = createElement5("UIListLayout", v5),
		LeftChevron = 0,
		ButtonContainer = 0,
		RightChevron = 0
	}
	local leftChevron

	if not props.isSelectionDisabled then
		leftChevron = React.createElement(IconButton, {
			size = UDim2.fromOffset(32, 32),
			iconSize = IconSize.Medium,
			icon = Images["icons/actions/cycleLeft"],
			onActivated = props.onClickLeft,
			layoutOrder = 1
		})
	end

	children2.LeftChevron = leftChevron

	children2.ButtonContainer = React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, menuItemDimensions.RightWidth - 64, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, {
		ToggleButton = React.createElement(TextButton, {
			size = UDim2.new(1, 0, 1, 0),
			text = props.abuseType,
			onActivated = props.onClickRight,
			layoutOrder = 2,
			isDisabled = props.isSelectionDisabled,
			fontStyle = menuItemSizings.FontStyle,
			verticalPadding = menuItemSizings.ButtonInsideVerticalPadding
		})
	})
	local rightChevron

	if not props.isSelectionDisabled then
		rightChevron = React.createElement(IconButton, {
			size = UDim2.fromOffset(32, 32),
			iconSize = IconSize.Medium,
			icon = Images["icons/actions/cycleRight"],
			onActivated = props.onClickRight,
			layoutOrder = 3
		})
	end

	children2.RightChevron = rightChevron
	children.Container = createElement4(
		"Frame",
		{ Size = size2, BackgroundTransparency = 1, LayoutOrder = 3 },
		children2
	)
	return createElement("Frame", v2, children)
end
