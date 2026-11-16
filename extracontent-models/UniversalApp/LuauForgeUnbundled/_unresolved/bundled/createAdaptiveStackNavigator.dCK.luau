local createNavigator = require("@game/CorePackages/Workspace/Packages/RoactNavigation").createNavigator
require("@luauforge/bundled/dCC")

local module = require("@luauforge/bundled/dCL")
local module2 = require("@luauforge/bundled/dDm")

local function createAdaptiveStackNavigator(p2, p3)
	return createNavigator(module, module2(p2, p3), p3)
end

return createAdaptiveStackNavigator
