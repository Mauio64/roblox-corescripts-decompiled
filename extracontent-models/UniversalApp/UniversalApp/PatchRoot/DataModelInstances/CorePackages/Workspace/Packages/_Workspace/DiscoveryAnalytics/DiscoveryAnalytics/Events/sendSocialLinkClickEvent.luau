local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local flaggedMutedError = require(Parent.Loggers).flaggedMutedError
local t = require(Parent.t)
local v5 = if not require(Parent.SharedFlags).FFlagLuaAppAddSocialLinkClickTelemetryToEdp then nil else game:DefineFastInt("SocialLinkClickTelemetryThrottlePermyriad", 0)
local v6 = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_url = t.string,
	social_link_display_type = t.string
})
local t1 = {
	eventName = "socialLinkClickEvent",
	description = "Event fired from the client every time a social link is clicked",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/usercommunities/social_link_click_event.proto",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		12,
		9
	}
}

return function(p1) -- line: 32
	-- upvalues: v6 (copy), flaggedMutedError (copy), TelemetryService (copy), t1 (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		flaggedMutedError("SocialLinkClickEventInterface", v10)
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
