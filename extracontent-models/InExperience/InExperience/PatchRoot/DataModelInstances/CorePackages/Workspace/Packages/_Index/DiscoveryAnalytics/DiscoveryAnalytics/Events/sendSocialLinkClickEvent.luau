local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local throttlingPercentage

if SharedFlags.FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
	throttlingPercentage = game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0)
end

local strictInterface = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_url = t.string,
	social_link_display_type = t.string
})

local v = {
	eventName = "socialLinkClickEvent",
	backends = { "EventIngest" },
	throttlingPercentage = throttlingPercentage,
	lastUpdated = { 25, 12, 9 },
	description = "Event fired from the client every time a social link is clicked",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto"
}

return function(customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		flaggedMutedError("SocialLinkClickEventInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
