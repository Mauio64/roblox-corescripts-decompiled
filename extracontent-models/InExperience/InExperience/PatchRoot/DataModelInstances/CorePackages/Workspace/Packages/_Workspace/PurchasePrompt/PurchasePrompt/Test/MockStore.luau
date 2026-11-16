local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local Reducer = require(PurchasePrompt.Reducers.Reducer)
local ABTest = require(PurchasePrompt.Services.ABTest)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local PlatformInterface = require(PurchasePrompt.Services.PlatformInterface)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Thunk = require(PurchasePrompt.Thunk)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local MockStore = {}

function MockStore.getMockPurchaseFlow(p)
	return p or PurchaseFlow.Product
end

function MockStore.getMockNativeUpsell(_: string?, _: string?, _: number?)
	return {
		robuxProductId = "testRobuxProductId",
		productId = "testProductId",
		robuxPurchaseAmount = 500
	}
end

function MockStore.getMockRobuxUpsellSuggestions(p)
	return {
		products = p or {
			{
				providerId = "testRobuxProductId",
				productId = "testProductId",
				robuxAmount = 500,
				robuxAmountBeforeBonus = 450,
				price = "4.99"
			}
		},
		selection = 1
	}
end

function MockStore.getMockStore()
	local v = ABTest.new()
	local v2 = Network.new()
	local v3 = Analytics.new()
	local v4 = PlatformInterface.new()
	local v5 = ExternalSettings.new()

	return Rodux.Store.new(Reducer, {}, { Thunk.middleware({
			[ABTest] = v,
			[Network] = v2,
			[Analytics] = v3,
			[PlatformInterface] = v4,
			[ExternalSettings] = v5
		}) })
end

return MockStore
