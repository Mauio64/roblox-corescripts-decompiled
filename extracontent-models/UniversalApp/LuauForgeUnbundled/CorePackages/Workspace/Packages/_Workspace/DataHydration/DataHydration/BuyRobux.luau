local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/BuyRobux/BuyRobuxStoreTypes")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/BuyRobux/createBuyRobuxStore")

local function createOneTimeProductStore()
	return module2()
end

local function createSubscriptionProductStore()
	return module2()
end

local function createPendingTransferStore()
	return module2()
end

local function createBonusItemStore()
	return module2()
end

return {
	createBuyRobuxStore = module2,
	getOneTimeProductStore = Signals.createComputed(createOneTimeProductStore),
	getSubscriptionProductStore = Signals.createComputed(createSubscriptionProductStore),
	getPendingTransferStore = Signals.createComputed(createPendingTransferStore),
	getBonusItemStore = Signals.createComputed(createBonusItemStore)
}
