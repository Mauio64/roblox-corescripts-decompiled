local v5 = {
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

local v6 = {
	singular = "Feature.RobloxSubscription.Label.month",
	plural = "Feature.RobloxSubscription.Label.months"
}

local function getPeriodTypeDisplayLabel(value, p2)
	local v8 = v5[string.lower(value)] or v6

	if p2 then
		return v8.plural
	end

	return v8.singular
end

return getPeriodTypeDisplayLabel
