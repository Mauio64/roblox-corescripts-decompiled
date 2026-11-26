local Counter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/Counter")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")

local getPaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPaymentPlatform")
local getCounterCombinations = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getCounterCombinations")
local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")

local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local v5 = { Analytics, ExternalSettings }

local function sendCounter(p2)
	return Thunk.new("sendCounter", v5, function(object, p3)
		local v6 = p3[Analytics]
		local v7 = p3[ExternalSettings]

		local rawValue = Counter.toRawValue(p2)

		local state = object:getState()

		local purchaseFlow = state.purchaseFlow
		local v8 = if purchaseFlow ~= nil then PurchaseFlow.toRawValue(purchaseFlow) else nil

		local robuxPurchaseAmount = SelectedRobuxPackage.getRobuxPurchaseAmount(state)

		local v9 = getPaymentPlatform((v7.getPlatform()))
		local v10 = getCounterCombinations("PurchasePrompt", rawValue, PaymentPlatform.toRawValue(v9), v8, robuxPurchaseAmount)

		for k, v11 in v10 do
			v6.sendCounter(v11)
		end
	end)
end

return sendCounter
