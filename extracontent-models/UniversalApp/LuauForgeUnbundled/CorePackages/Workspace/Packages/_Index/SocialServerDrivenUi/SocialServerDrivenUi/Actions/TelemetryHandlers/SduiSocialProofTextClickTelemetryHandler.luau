local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local FFlagSduiSocialProofTextAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiSocialProofTextAnalytics")

local buildSocialProofTextEventParams = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/buildSocialProofTextEventParams")

local sendSocialProofTextClickedEvent = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/sendSocialProofTextClickedEvent")

local function SduiSocialProofTextClickTelemetryHandler(p2, p3, p4)
	if not FFlagSduiSocialProofTextAnalytics then
		return
	end

	local v5 = buildSocialProofTextEventParams({
		universeId = getActionTelemetryFieldValue(p2, p3, "universeId"),
		placeId = getActionTelemetryFieldValue(p2, p3, "placeId"),
		totalConnections = getActionTelemetryFieldValue(p2, p3, "totalConnections"),
		users = p2 and p2.actionParams and p2.actionParams.userIds,
		avatarMax = getActionTelemetryFieldValue(p2, p3, "avatarMax"),
		page = p4.appPage
	})

	if v5 == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ message = "SocialProofTextClick telemetry missing `universeId`" },
			p4.appPage
		)
	else
		sendSocialProofTextClickedEvent(v5)
	end
end

return SduiSocialProofTextClickTelemetryHandler
