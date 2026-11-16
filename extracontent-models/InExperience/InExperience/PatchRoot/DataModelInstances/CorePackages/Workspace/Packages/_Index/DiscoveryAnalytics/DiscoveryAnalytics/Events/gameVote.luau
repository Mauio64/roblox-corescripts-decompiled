local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameVoteThrottleHundrethsPercent", 0)

local strictInterface = t.strictInterface
local v = {
	placeId = t.string,
	vote = t.union(t.literal("UpVoted"), t.literal("DownVoted"), t.literal("NotVoted")),
	prevVote = t.union(t.literal("UpVoted"), t.literal("DownVoted"), t.literal("NotVoted")),
	uid = t.string,
	targetId = 0
}
local targetId

if FFlagLuaAppAddUniverseIdToEngagementEvents then
	targetId = t.optional(t.string)
end

v.targetId = targetId
local v2 = strictInterface(v)

return function(customFields, eventContext: string)
	local v3, v4 = v2(customFields)

	if not v3 then
		DiscoveryEventErrorLogger.reportError("GameVoteInvalidInterface", v4)
	end

	TelemetryService:LogEvent({
		eventName = "vote",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has voted on a game"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
