local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local TabBarMainNavigation = require(Modules.AvatarExperience.Common.Components.NavBar.TabBar.TabBarMainNavigation)

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: useStyle (copy), React (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), TabBarMainNavigation (copy)
	local v11 = useStyle()
	local layoutOrderMain = t1.layoutOrderMain
	local navHeightMain = t1.navHeightMain
	local tabs = t1.tabs
	local selectedTabIndex = t1.selectedTabIndex
	local selectTab = t1.selectTab
	local v17 = React.useRef(nil)

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = layoutOrderMain
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v11.Tokens.Global.Space_150 else v11.Tokens.Size.Size_300)
		}),
		TabBarUnderlinedMainNavigation = React.createElement(TabBarMainNavigation, {
			zIndex = 1,
			layoutOrder = layoutOrderMain,
			navHeight = navHeightMain,
			tabs = tabs,
			selectedTabIndex = selectedTabIndex,
			selectTab = selectTab,
			mainNavigationRef = v17,
			NextSelectionDown = t1.NextSelectionDown,
			NextSelectionUp = t1.NextSelectionUp
		})
	})
end
