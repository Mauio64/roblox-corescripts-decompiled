local v = {
	month = {
		singular = "Feature.RobloxSubscription.Label.month",
		plural = "Feature.RobloxSubscription.Label.months"
	},
	year = {
		singular = "Feature.RobloxSubscription.Label.year",
		plural = "Feature.RobloxSubscription.Label.years"
	},
	week = {
		singular = "Feature.RobloxSubscription.label.week",
		plural = "Feature.RobloxSubscription.label.weeks"
	}
}

local v2 = {
	singular = "Feature.RobloxSubscription.Label.month",
	plural = "Feature.RobloxSubscription.Label.months"
}

local function getPeriodTypeDisplayLabel(value: string, flag: boolean)
	local v3 = v[string.lower(value)] or v2

	return if flag then v3.plural else v3.singular
end

return getPeriodTypeDisplayLabel
