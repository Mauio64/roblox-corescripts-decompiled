local ParentParent = script.Parent.Parent
local Counter = require(ParentParent.Enums.Counter)
local PurchaseFlow = require(ParentParent.Enums.PurchaseFlow)
local PaymentPlatform = require(ParentParent.Enums.PaymentPlatform)
local Analytics = require(ParentParent.Services.Analytics)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local getPaymentPlatform = require(ParentParent.Utils.getPaymentPlatform)
local getCounterCombinations = require(ParentParent.Utils.getCounterCombinations)
local SelectedRobuxPackage = require(ParentParent.Utils.SelectedRobuxPackage)
local Thunk = require(ParentParent.Thunk)
local t1 = {
	Analytics,
	ExternalSettings
}

local function sendCounter(p1) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), ExternalSettings (copy), Counter (copy), PurchaseFlow (copy), SelectedRobuxPackage (copy), getPaymentPlatform (copy), PaymentPlatform (copy), getCounterCombinations (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 24
		-- upvalues: Analytics (copy), ExternalSettings (copy), Counter (copy), p1 (copy), PurchaseFlow (copy), SelectedRobuxPackage (copy), getPaymentPlatform (copy), PaymentPlatform (copy), getCounterCombinations (copy)
		local v16 = p3[Analytics]
		local v17 = p3[ExternalSettings]
		local v18 = Counter.toRawValue(p1)
		local v19 = p2:getState()
		local purchaseFlow = v19.purchaseFlow
		local v21 = if purchaseFlow == nil then nil else PurchaseFlow.toRawValue(purchaseFlow)
		local v22 = SelectedRobuxPackage.getRobuxPurchaseAmount(v19)
		local v23 = v17.getPlatform()
		local v24 = getPaymentPlatform(v23)
		local v25 = PaymentPlatform.toRawValue(v24)

		for _, v27 in (getCounterCombinations("PurchasePrompt", v18, v25, v21, v22)) do
			v16.sendCounter(v27)
		end
	end)
end

return sendCounter
