local CorePackages = game:GetService("CorePackages")
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP2NavigationPrimitives then
	return NavigationRodux.GetLegacyNavigationStore(false)
end

local AppNavigation = require(script.Parent.AppNavigation)

return NavigationRodux.createLegacyNavigationStore(AppNavigation)
