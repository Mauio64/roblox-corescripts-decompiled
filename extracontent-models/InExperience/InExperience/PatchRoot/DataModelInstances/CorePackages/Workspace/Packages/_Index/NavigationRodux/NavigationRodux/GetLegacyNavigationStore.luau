local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local NavigationRoduxParent = NavigationRodux.Parent
local Signals = require(NavigationRoduxParent.Signals)
local RobloxAppNavigation = require(NavigationRoduxParent.RobloxAppNavigation)
local createLegacyNavigationStore = require(NavigationRodux.createLegacyNavigationStore)

return Signals.createComputed(function() -- line: 8
	-- upvalues: createLegacyNavigationStore (copy), RobloxAppNavigation (copy)
	return createLegacyNavigationStore(RobloxAppNavigation.AppNavigationRegistry.get())
end)
