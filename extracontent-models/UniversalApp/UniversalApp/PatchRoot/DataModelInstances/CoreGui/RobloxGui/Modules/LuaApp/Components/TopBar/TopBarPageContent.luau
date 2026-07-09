local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withGridConfig_DEPRECATED = require(CorePackages.Packages.UIBlox).Core.Layout.Grid.withGridConfig_DEPRECATED
local LayoutConfig = require(CorePackages.Workspace.Packages.RobloxAppEnums).LayoutConfig
local TopBarContentFrame = require(script.Parent.TopBarContentFrame)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local FFlagAppIaScrollAway = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaScrollAway

local function TopBarPageContentWithProviders(p1, _) -- line: 37
	-- upvalues: FFlagAppIaScrollAway (copy), AppNavBar (copy), React (copy), TopBarContentFrame (copy)
	local topBarHeight = p1.topBarHeight
	local v15 = table.clone(p1)

	v15.heightOffset = if not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled() then topBarHeight else 0
	v15.topBarHeight = nil

	return React.createElement(TopBarContentFrame, v15)
end
local function TopBarPageContent(p3) -- line: 47
	-- upvalues: withGridConfig_DEPRECATED (copy), LayoutConfig (copy), TopBarPageContentWithProviders (copy)
	return withGridConfig_DEPRECATED({
		[LayoutConfig.Keys.PaddingVertical] = 0
	}, LayoutConfig.Kind)(function(p4) -- line: 50
		-- upvalues: TopBarPageContentWithProviders (copy), p3 (copy)
		return TopBarPageContentWithProviders(p3, p4)
	end)
end
local function mapStateToProps(p5, _) -- line: 55
	return {
		topBarHeight = p5.TopBar.topBarHeight
	}
end

return (RoactRodux.connect(mapStateToProps, nil)(TopBarPageContent))
