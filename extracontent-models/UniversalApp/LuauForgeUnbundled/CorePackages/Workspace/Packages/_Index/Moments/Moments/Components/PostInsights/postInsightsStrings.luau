local frozen = table.freeze({ analytics = "Feature.Moments.Action.Analytics" })

local frozen2 = table.freeze({
	title = frozen.analytics,
	overview = "Feature.Moments.Label.Overview",
	engagement = "Feature.Moments.Label.Engagement",
	totalViews = "Feature.Moments.Label.TotalViews",
	averageWatchTime = "Feature.Moments.Label.AverageWatchTime",
	averageCompletion = "Feature.Moments.Label.AverageCompletion",
	gameJoinConversion = "Feature.Moments.Label.GameJoinConversion",
	totalReactions = "Feature.Moments.Label.TotalReactions"
})

local frozen3 = table.freeze({
	title = "Feature.Moments.Tooltip.PostInsightsTitle",
	text = "Feature.Moments.Tooltip.PostInsightsBody"
})

return table.freeze({
	MENU_KEYS = frozen,
	PAGE_KEYS = frozen2,
	TOOLTIP_KEYS = frozen3,
	DURATION_SECONDS_KEY = "Feature.Moments.Label.DurationSeconds",
	PERCENT_KEY = "Feature.Build.Analytics.Percent"
})
