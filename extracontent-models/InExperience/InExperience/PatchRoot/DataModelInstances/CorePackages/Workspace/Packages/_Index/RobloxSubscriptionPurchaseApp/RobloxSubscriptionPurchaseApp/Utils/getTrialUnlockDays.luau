local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local FIntRobloxPlusTrialDiscountBaseDays = require(RobloxSubscriptionPurchaseApp.Flags.FIntRobloxPlusTrialDiscountBaseDays)

local v = { week = 7, month = 30, year = 365 }

local function periodToDays(p: number, value: string?)
	return p * (v[string.lower(value or "")] or 30)
end

local function getTrialUnlockDays(p, p2: number?, value: string?)
	local v2

	if p2 == nil then
		v2 = FIntRobloxPlusTrialDiscountBaseDays
	else
		v2 = p2 * (v[string.lower(value or "")] or v.month)
	end

	local v3

	if p == nil then
		v3 = 0
	else
		local duration = p.Duration
		local periodType = p.PeriodType
		v3 = duration * (v[string.lower(periodType or "")] or v.month)
	end

	return v2 + v3
end

return getTrialUnlockDays
