local v5 = {
	eventName = "followSuccess",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 11, 5 },
	description = "Fires after a user successfully follows another user"
}

local function createFollowAttributionReporter(callback)
	return function(p2)
		callback(v5, {
			eventContext = "SocialFollow",
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = {
				surface = p2.surface,
				source = p2.source or p2.surface
			}
		})
	end
end

return createFollowAttributionReporter
