local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/gdC")
local module2 = require("@luauforge/bundled/gdA")
local module3 = require("@luauforge/bundled/gdD")
local module4 = require("@luauforge/bundled/gdE")
require("@luauforge/bundled/gdF")
local module5 = require("@luauforge/bundled/fwo")
local module6 = require("@luauforge/bundled/gdI")
local module7 = require("@luauforge/bundled/gdJ")

local function hasPackage(items, p2): boolean
	for k, item in pairs(items) do
		if item.mobileProductId == p2 then
			return true
		end
	end

	return false
end

return function(p2, p3, p4, p5)
	return function(object)
		local state = object:getState()
		local localUserId = state.LocalUserId
		local v5 = state.UserRobux[state.LocalUserId]
		local nativePurchase = state.NativePurchase
		local v6 = if module7 then p5 else nil

		if p4 == module2.Failed or p4 == module2.Pending then
			return object:dispatch(module4(p3, module2.Failed, nil, v6))
		end

		if nativePurchase.productType == module.Subscription then
			return object:dispatch(module4(p3, module2.Success, nil, v6))
		end

		local subscriptions = state.IAPProducts.Subscriptions
		local v7 = p3
		local flag = true
		local flag2

		for k, subscription in pairs(subscriptions) do
			if subscription.mobileProductId == v7 then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			object:dispatch(module3(localUserId, Enum.MembershipType.Premium))
			return object:dispatch(module4(p3, module2.Success, nil, v6))
		end

		object:dispatch(module4(p3, module2.Polling))

		if RunService:IsStudio() then
			return object:dispatch(module4(p3, module2.Success, nil, v6))
		end

		local v8 = module2.Failed

		if module6() and p4 == module2.Success then
			v8 = module2.RobuxPollingFailedAfterNativePurchase
		end

		return object:dispatch(module5(p2, tostring(localUserId), v5, function(p6)
			local success = p6 ~= v5 and module2.Success or v8

			local v13 = if success == module2.Success then v6 else nil
			return object:dispatch(module4(p3, success, nil, v13))
		end)):catch(function()
			return object:dispatch(module4(p3, v8))
		end)
	end
end
