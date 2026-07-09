local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FlyoutLeftHeader = require(CorePackages.Workspace.Packages.FlyoutSidePanel).Components.FlyoutLeftHeader
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP

local function MeTabFlyoutLeftItem() -- line: 7
	-- upvalues: React (copy), FlyoutLeftHeader (copy), FlyoutSidePanelIXP (copy)
	return React.createElement(FlyoutLeftHeader, {
		isFlyoutEntrypointEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
		isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
	})
end

return MeTabFlyoutLeftItem
