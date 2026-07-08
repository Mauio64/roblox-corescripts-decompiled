local t1 = {
	month = {
		singular = "Feature.RobloxSubscription.Label.month",
		plural = "Feature.RobloxSubscription.Label.months"
	},
	year = {
		singular = "Feature.RobloxSubscription.Label.year",
		plural = "Feature.RobloxSubscription.Label.years"
	},
	week = {
		singular = "Feature.RobloxSubscription.Label.week",
		plural = "Feature.RobloxSubscription.Label.weeks"
	}
}
local t2 = {
	singular = "Feature.RobloxSubscription.Label.month",
	plural = "Feature.RobloxSubscription.Label.months"
}

local function getPeriodTypeDisplayLabel(s1: string, b1: boolean) -- line: 35
	-- upvalues: t1 (copy), t2 (copy)
	local v6 = t1[string.lower(s1)] or t2

	if b1 then
		return v6.plural
	end

	return v6.singular
end

return getPeriodTypeDisplayLabel
