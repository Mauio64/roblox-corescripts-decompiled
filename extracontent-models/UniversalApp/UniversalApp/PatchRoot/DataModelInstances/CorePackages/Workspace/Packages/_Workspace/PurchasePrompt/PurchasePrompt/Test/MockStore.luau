local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local Reducer = require(PurchasePrompt.Reducers.Reducer)
local ABTest = require(PurchasePrompt.Services.ABTest)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local PlatformInterface = require(PurchasePrompt.Services.PlatformInterface)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Thunk = require(PurchasePrompt.Thunk)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

return {
	getMockPurchaseFlow = function(p1) -- line: 17
		-- upvalues: PurchaseFlow (copy)
		return p1 or PurchaseFlow.Product
	end,
	getMockNativeUpsell = function(_: string?, _: string?, _: number?) -- line: 21
		return {
			robuxProductId = "testRobuxProductId",
			productId = "testProductId",
			robuxPurchaseAmount = 500
		}
	end,
	getMockRobuxUpsellSuggestions = function(p2) -- line: 29
		return {
			selection = 1,
			products = p2 or {{
				providerId = "testRobuxProductId",
				productId = "testProductId",
				robuxAmount = 500,
				robuxAmountBeforeBonus = 450,
				price = "4.99"
			}}
		}
	end,
	getMockStore = function() -- line: 44
		-- upvalues: ABTest (copy), Network (copy), Analytics (copy), PlatformInterface (copy), ExternalSettings (copy), Rodux (copy), Reducer (copy), Thunk (copy)
		local v17 = ABTest.new()
		local v18 = Network.new()
		local v19 = Analytics.new()
		local v20 = PlatformInterface.new()
		local v21 = ExternalSettings.new()

		return Rodux.Store.new(Reducer, {}, { Thunk.middleware({
			[ABTest] = v17,
			[Network] = v18,
			[Analytics] = v19,
			[PlatformInterface] = v20,
			[ExternalSettings] = v21
		}) })
	end
}
