local Moments = script:FindFirstAncestor("Moments")

local Constants = require(Moments.Constants)
require(Moments.Enums.NavigationDestinationType)

local function makeMomentsNavigationFields(data)
	local momentsNavigationFields = {
		client_event_timestamp_ms = data.clientEventTimestampMs,
		feedItemId = data.feedItemId,
		viewId = data.viewId,
		durationSeconds = tostring(data.durationSeconds),
		destinationType = data.destinationType
	}

	if not data.includeRecommendationDetail then
		return momentsNavigationFields
	end

	momentsNavigationFields.impressionType = tostring(1)
	momentsNavigationFields.sourceSurface = Constants.SOURCE_SURFACE
	momentsNavigationFields.itemPosition = tostring(data.itemPosition)
	momentsNavigationFields.tracingId = data.tracingId or ""

	return momentsNavigationFields
end

return makeMomentsNavigationFields
