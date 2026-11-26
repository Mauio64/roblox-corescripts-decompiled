require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local FIntRobloxPlusTrialDiscountBaseDays = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FIntRobloxPlusTrialDiscountBaseDays")

local v5 = { week = 7, month = 30, year = 365 }

local function periodToDays(p2, value)
	return p2 * (v5[string.lower(value or "")] or 30)
end

local function getTrialUnlockDays(p2, p3, value)
	local v6 = if p3 == nil then FIntRobloxPlusTrialDiscountBaseDays else p3 * (v5[string.lower(value or "")] or v5.month)
	local v7

	if p2 == nil then
		v7 = 0
	else
		local duration = p2.Duration
		local periodType = p2.PeriodType
		v7 = duration * (v5[string.lower(periodType or "")] or v5.month)
	end

	return v6 + v7
end

return getTrialUnlockDays
