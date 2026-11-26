local appPage = require("@luauforge/bundled/hHo").AppPage
local module = require("@luauforge/bundled/hId")

local module2 = require("@luauforge/bundled/hIg")
require("@luauforge/bundled/hIi")

local function getBuyRobuxPurchaseFlowTracker(p2)
	local dependencies = module.getSduiServiceDependenciesStore().getDependencies(appPage.BuyRobux)
	return module2.get(p2, dependencies and dependencies.eventIngest)
end

return getBuyRobuxPurchaseFlowTracker
