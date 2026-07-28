local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameVoteThrottleHundrethsPercent", 0)
local v6 = t.strictInterface({
	placeId = t.string,
	vote = t.union(t.literal("UpVoted"), t.literal("DownVoted"), t.literal("NotVoted")),
	prevVote = t.union(t.literal("UpVoted"), t.literal("DownVoted"), t.literal("NotVoted")),
	uid = t.string
})

return function(p1, s1: string) -- line: 17
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), v5 (copy), TelemetryService (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("GameVoteInvalidInterface", v10)
	end

	local t1 = {
		eventName = "vote",
		description = "User has voted on a game",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			25,
			11,
			11
		}
	}

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
