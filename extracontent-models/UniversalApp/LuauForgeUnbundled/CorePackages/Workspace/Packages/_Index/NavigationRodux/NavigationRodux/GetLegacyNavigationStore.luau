local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/Signals")
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/NavigationRodux/RobloxAppNavigation")
local createLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Index/NavigationRodux/NavigationRodux/createLegacyNavigationStore")

return Signals.createComputed(function()
	return createLegacyNavigationStore(RobloxAppNavigation.AppNavigationRegistry.get())
end)
