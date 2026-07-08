local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
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

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useStyle (copy), getMenuItemDimensions (copy), getMenuItemSizings (copy), Constants (copy), React (copy), AppFonts (copy), IconButton (copy), IconSize (copy), Images (copy), TextButton (copy)
	local Size_200 = useStyle().Tokens.Size.Size_200
	local v16 = getMenuItemDimensions(t1.menuWidth)
	local v17 = getMenuItemSizings()
	local MenuItemHeightTight = Constants.MenuItemHeightTight
	local v19 = math.max(t1.menuWidth - Constants.MenuItemDynamicWidthOffset, v16.LeftWidth + v16.RightWidth)
	local isSmallPortraitViewport = t1.isSmallPortraitViewport

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = if not isSmallPortraitViewport then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = if not isSmallPortraitViewport then UDim.new(0, 0) else UDim.new(0, Size_200)
		}),
		Label = React.createElement("TextLabel", {
			LayoutOrder = 1,
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Text = t1.label,
			Font = AppFonts.default:getMedium(),
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = v16.TextSize,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = if not isSmallPortraitViewport then UDim2.new(0, v16.LeftWidth, 0, Constants.MenuItemHeight) else UDim2.fromOffset(v19, 0)
		}),
		MiddleWidthHolder = if not isSmallPortraitViewport then React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, math.max(0, t1.menuWidth - v16.LeftWidth - v16.RightWidth - 100), 0, Constants.MenuItemHeight)
		}) else nil,
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = if not isSmallPortraitViewport then UDim2.new(0, v16.RightWidth, 1, 0) else UDim2.fromOffset(v19, MenuItemHeightTight)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = if not isSmallPortraitViewport then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			LeftChevron = if not t1.isSelectionDisabled then React.createElement(IconButton, {
				layoutOrder = 1,
				size = UDim2.fromOffset(32, 32),
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/cycleLeft"],
				onActivated = t1.onClickLeft
			}) else nil,
			ButtonContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, v16.RightWidth - 64, 0, 0)
			}, {
				ToggleButton = React.createElement(TextButton, {
					layoutOrder = 2,
					size = UDim2.new(1, 0, 1, 0),
					text = t1.abuseType,
					onActivated = t1.onClickRight,
					isDisabled = t1.isSelectionDisabled,
					fontStyle = v17.FontStyle,
					verticalPadding = v17.ButtonInsideVerticalPadding
				})
			}),
			RightChevron = if not t1.isSelectionDisabled then React.createElement(IconButton, {
				layoutOrder = 3,
				size = UDim2.fromOffset(32, 32),
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/cycleRight"],
				onActivated = t1.onClickRight
			}) else nil
		})
	})
end
