local DefaultAnalytics = {}

function DefaultAnalytics.fireAnalyticsEvent(p, p2)
	return p, p2
end

function DefaultAnalytics.updateInfoForAllEvents(p)
	return p
end

function DefaultAnalytics.getInfoForAllEvents()
	return { analyticsTag = "DefaultAnalytics" }
end

return DefaultAnalytics
