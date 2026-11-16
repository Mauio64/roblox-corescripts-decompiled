local module = require("@luauforge/deferred/elg")

local module2 = require("@luauforge/deferred/elh")

local defineFastInt = game:DefineFastInt("FriendsActivityFeedAnalyticsThrottleHundredthsPercent", 10000)

local function counterConfig(p2, p3)
	return {
		eventName = p2,
		backends = { module.TelemetryBackends.Counter },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 7, 16 },
		description = p3,
		links = ""
	}
end

local function eventIngestConfig(p2, p3)
	return {
		eventName = p2,
		backends = { module.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 7, 16 },
		description = p3,
		links = ""
	}
end

return {
	Ctx = "friendsActivityFeed",
	Events = {
		[module2.FriendsActivityTileImpression] = {
			counter = counterConfig(
				module2.FriendsActivityTileImpression,
				"Funnel step 1 (counter): a Friends Activity tile became visible; `activityType` is the per-type denominator for tap-through rate."
			),
			eventIngest = eventIngestConfig(
				module2.FriendsActivityTileImpression,
				"Funnel step 1: a Friends Activity tile became visible. `activityType` is the per-type denominator for tap-through rate; `absolutePosition`/`universeId` locate the tile (ctx friendsActivityFeed)."
			)
		},
		[module2.FriendsActivityTileTap] = {
			counter = counterConfig(
				module2.FriendsActivityTileTap,
				"Funnel step 2 (counter): a user tapped a Friends Activity tile; `activityType` enables tap-through rate by type."
			),
			eventIngest = eventIngestConfig(
				module2.FriendsActivityTileTap,
				"Funnel step 2: a user tapped a Friends Activity tile. `activityType` enables tap-through rate by type; `universeId`/`absolutePosition` locate the tapped row (ctx friendsActivityFeed)."
			)
		}
	},
	buildTileFields = function(data, p2)
		local clone = table.clone(p2)
		clone.activityType = data.activityType
		clone.absolutePosition = math.floor(data.absolutePosition)

		if data.universeId ~= nil then
			clone.universeId = data.universeId
		end

		return clone
	end
}
