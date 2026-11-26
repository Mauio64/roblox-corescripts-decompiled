local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withGridConfig_DEPRECATED = UIBlox.Core.Layout.Grid.withGridConfig_DEPRECATED

local layoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").LayoutConfig
local module = require("@luauforge/bundled/fAo")
local module2 = require("@luauforge/bundled/dKz")

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway

local function TopBarPageContentWithProviders(p2, p3)
	local topBarHeight = p2.topBarHeight
	local clone = table.clone(p2)
	clone.heightOffset = fFlagAppIaScrollAway and module2.getScrollAwayEnabled() and 0 or topBarHeight

	clone.topBarHeight = nil
	return React.createElement(module, clone)
end

local function TopBarPageContent(p2)
	return withGridConfig_DEPRECATED({ [layoutConfig.Keys.PaddingVertical] = 0 }, layoutConfig.Kind)(function(p3)
		return TopBarPageContentWithProviders(p2, p3)
	end)
end

local function mapStateToProps(p2, p3)
	return { topBarHeight = p2.TopBar.topBarHeight }
end

return (RoactRodux.connect(mapStateToProps, nil)(TopBarPageContent))
