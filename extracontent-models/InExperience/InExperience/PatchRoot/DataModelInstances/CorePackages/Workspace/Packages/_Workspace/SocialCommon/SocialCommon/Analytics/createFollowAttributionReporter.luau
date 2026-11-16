local v = {
	eventName = "followSuccess",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 11, 5 },
	description = "Fires after a user successfully follows another user"
}

local function createFollowAttributionReporter(callback)
	return function(p)
		callback(v, {
			eventContext = "SocialFollow",
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = {
				surface = p.surface,
				source = p.source or p.surface
			}
		})
	end
end

return createFollowAttributionReporter
