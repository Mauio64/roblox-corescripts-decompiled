local NavigationRodux = script:FindFirstAncestor("NavigationRodux")
local parent = NavigationRodux.Parent

local Signals = require(parent.Signals)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local createLegacyNavigationStore = require(NavigationRodux.createLegacyNavigationStore)

return Signals.createComputed(function()
	return createLegacyNavigationStore(RobloxAppNavigation.AppNavigationRegistry.get())
end)
