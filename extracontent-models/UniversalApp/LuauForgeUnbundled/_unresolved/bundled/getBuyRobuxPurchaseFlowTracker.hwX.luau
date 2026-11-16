local appPage = require("@luauforge/bundled/hwj").AppPage
local module = require("@luauforge/bundled/hwV")

local module2 = require("@luauforge/bundled/hwY")
require("@luauforge/bundled/hxa")

local function getBuyRobuxPurchaseFlowTracker(p2)
	local dependencies = module.getSduiServiceDependenciesStore().getDependencies(appPage.BuyRobux)
	return module2.get(p2, dependencies and dependencies.eventIngest)
end

return getBuyRobuxPurchaseFlowTracker
