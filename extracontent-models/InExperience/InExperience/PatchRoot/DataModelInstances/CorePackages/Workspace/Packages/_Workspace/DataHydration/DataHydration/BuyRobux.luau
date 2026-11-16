local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

require(script.BuyRobuxStoreTypes)
local createBuyRobuxStore = require(script.createBuyRobuxStore)

local function createOneTimeProductStore()
	return createBuyRobuxStore()
end

local function createSubscriptionProductStore()
	return createBuyRobuxStore()
end

local function createPendingTransferStore()
	return createBuyRobuxStore()
end

local function createBonusItemStore()
	return createBuyRobuxStore()
end

return {
	createBuyRobuxStore = createBuyRobuxStore,
	getOneTimeProductStore = Signals.createComputed(createOneTimeProductStore),
	getSubscriptionProductStore = Signals.createComputed(createSubscriptionProductStore),
	getPendingTransferStore = Signals.createComputed(createPendingTransferStore),
	getBonusItemStore = Signals.createComputed(createBonusItemStore)
}
