local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/gog")

return function(props)
	local v5 = useStyle()

	local layoutOrderMain = props.layoutOrderMain
	local navHeightMain = props.navHeightMain
	local tabs = props.tabs
	local selectedTabIndex = props.selectedTabIndex
	local selectTab = props.selectTab

	local ref = React.useRef(nil)

	return React.createElement(
		focusable.Frame,
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = layoutOrderMain
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v5.Tokens.Size.Size_300)
			}),
			TabBarUnderlinedMainNavigation = React.createElement(module, {
				layoutOrder = layoutOrderMain,
				navHeight = navHeightMain,
				zIndex = 1,
				tabs = tabs,
				selectedTabIndex = selectedTabIndex,
				selectTab = selectTab,
				mainNavigationRef = ref,
				NextSelectionDown = props.NextSelectionDown,
				NextSelectionUp = props.NextSelectionUp
			})
		}
	)
end
