local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local FlyoutSidePanel = require(Modules.LuaApp.Components.FlyoutSidePanel.FlyoutSidePanel)
local useDrawerShouldMount = require(CorePackages.Workspace.Packages.Drawer).Hooks.useDrawerShouldMount

local function FlyoutSidePanelWrapper(t1: {[any]: any}) -- line: 11
	-- upvalues: useDrawerShouldMount (copy), React (copy), FlyoutSidePanel (copy)
	if useDrawerShouldMount() then
		return React.createElement(FlyoutSidePanel, t1)
	end

	return nil
end

return React.memo(FlyoutSidePanelWrapper)
