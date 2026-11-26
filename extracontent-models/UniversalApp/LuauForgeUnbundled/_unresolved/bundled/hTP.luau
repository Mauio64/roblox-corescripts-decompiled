local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")

if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP2NavigationPrimitives then
	return NavigationRodux.GetLegacyNavigationStore(false)
end

local module2 = require("@luauforge/bundled/dFy")
return NavigationRodux.createLegacyNavigationStore(module2)
