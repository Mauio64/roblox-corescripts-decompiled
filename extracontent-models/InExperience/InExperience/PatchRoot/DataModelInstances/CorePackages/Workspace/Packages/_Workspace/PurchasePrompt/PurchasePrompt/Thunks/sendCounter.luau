local parent = script.Parent.Parent

local Counter = require(parent.Enums.Counter)
local PurchaseFlow = require(parent.Enums.PurchaseFlow)
local PaymentPlatform = require(parent.Enums.PaymentPlatform)

local Analytics = require(parent.Services.Analytics)
local ExternalSettings = require(parent.Services.ExternalSettings)

local getPaymentPlatform = require(parent.Utils.getPaymentPlatform)
local getCounterCombinations = require(parent.Utils.getCounterCombinations)
local SelectedRobuxPackage = require(parent.Utils.SelectedRobuxPackage)

local Thunk = require(parent.Thunk)

local v = { Analytics, ExternalSettings }

local function sendCounter(p)
	return Thunk.new(script.Name, v, function(object, p2)
		local v2 = p2[Analytics]
		local v3 = p2[ExternalSettings]

		local rawValue = Counter.toRawValue(p)

		local state = object:getState()

		local purchaseFlow = state.purchaseFlow
		local v4

		if purchaseFlow ~= nil then
			v4 = PurchaseFlow.toRawValue(purchaseFlow)
		end

		local robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(state)

		local paymentPlatform = getPaymentPlatform((v3.getPlatform()))
		local counterCombinations = getCounterCombinations(
			"PurchasePrompt",
			rawValue,
			PaymentPlatform.toRawValue(paymentPlatform),
			v4,
			robuxPurchaseAmount
		)

		for _, counterCombination in counterCombinations do
			v2.sendCounter(counterCombination)
		end
	end)
end

return sendCounter
