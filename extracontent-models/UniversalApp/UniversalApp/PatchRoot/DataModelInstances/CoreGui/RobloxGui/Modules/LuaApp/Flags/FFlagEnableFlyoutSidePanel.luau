if not game:DefineFastFlag("EnableFlyoutSidePanel15", false) then
	return false
end

local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
