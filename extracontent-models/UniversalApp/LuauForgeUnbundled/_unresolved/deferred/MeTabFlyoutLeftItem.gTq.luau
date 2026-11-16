local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local flyoutLeftHeader = require("@luauforge/bundled/fsS").Components.FlyoutLeftHeader
local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP

local function MeTabFlyoutLeftItem()
	return React.createElement(flyoutLeftHeader, {
		isFlyoutEntrypointEnabled = flyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
		isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end

return MeTabFlyoutLeftItem
