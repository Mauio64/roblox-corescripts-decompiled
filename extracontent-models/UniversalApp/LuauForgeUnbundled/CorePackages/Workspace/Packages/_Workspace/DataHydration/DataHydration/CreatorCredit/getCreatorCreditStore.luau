local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCreatorCreditStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/createCreatorCreditStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorCredit/types")

local function createDefaultStore()
	return createCreatorCreditStore()
end

return Signals.createComputed(createDefaultStore)
