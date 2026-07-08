local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local sendSocialLinkClickEvent = require(Parent.DiscoveryAnalytics).Events.sendSocialLinkClickEvent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local t1 = {
	"profileId",
	"profileType",
	"socialLinkType",
	"socialLinkUrl",
	"socialLinkDisplayType"
}

return function(p1, p2, p3) -- line: 17
	-- upvalues: t1 (copy), getActionTelemetryFieldValue (copy), SduiErrorType (copy), sendSocialLinkClickEvent (copy)
	local t2 = {}

	for _, v12 in t1 do
		if getActionTelemetryFieldValue(p1, p2, v12) == nil then
			table.insert(t2, v12)
		end
	end

	if #t2 > 0 then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SocialLinkClickTelemetryHandler",
			message = `Missing telemetry fields: { table.concat(t2, ", ") }`
		}, p3.appPage)
	end

	sendSocialLinkClickEvent({
		assignment_id = tonumber(getActionTelemetryFieldValue(p1, p2, "profileId", 0)) or 0,
		assignment_type = getActionTelemetryFieldValue(p1, p2, "profileType", ""),
		social_link_type = getActionTelemetryFieldValue(p1, p2, "socialLinkType", ""),
		social_link_url = getActionTelemetryFieldValue(p1, p2, "socialLinkUrl", ""),
		social_link_display_type = getActionTelemetryFieldValue(p1, p2, "socialLinkDisplayType", "")
	})
end
