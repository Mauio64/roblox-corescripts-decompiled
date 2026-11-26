local TelemetryService = game:GetService("TelemetryService")

local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/Loggers").flaggedMutedError
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local v5

if require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppAddSocialLinkClickTelemetryToEdp then
	v5 = game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0)
end

local strictInterface = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_url = t.string,
	social_link_display_type = t.string
})

local v6 = {
	eventName = "socialLinkClickEvent",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = { 25, 12, 9 },
	description = "Event fired from the client every time a social link is clicked",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto"
}

return function(p2)
	local v7, v8 = strictInterface(p2)

	if not v7 then
		flaggedMutedError("SocialLinkClickEventInterface", v8)
	end

	TelemetryService:LogEvent(v6, {
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
