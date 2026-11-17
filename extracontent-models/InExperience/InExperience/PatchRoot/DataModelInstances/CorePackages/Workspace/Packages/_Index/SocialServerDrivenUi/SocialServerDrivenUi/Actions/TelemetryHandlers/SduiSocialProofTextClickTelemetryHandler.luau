local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local FFlagSduiSocialProofTextAnalytics = require(SocialServerDrivenUi.Flags.FFlagSduiSocialProofTextAnalytics)

local buildSocialProofTextEventParams = require(SocialServerDrivenUi.Analytics.SocialProofText.buildSocialProofTextEventParams)

local sendSocialProofTextClickedEvent = require(SocialServerDrivenUi.Analytics.SocialProofText.sendSocialProofTextClickedEvent)

local function SduiSocialProofTextClickTelemetryHandler(p, p2, p3)
	if not FFlagSduiSocialProofTextAnalytics then
		return
	end

	local socialProofTextEventParams = buildSocialProofTextEventParams({
		universeId = getActionTelemetryFieldValue(p, p2, "universeId"),
		placeId = getActionTelemetryFieldValue(p, p2, "placeId"),
		totalConnections = getActionTelemetryFieldValue(p, p2, "totalConnections"),
		users = p and p.actionParams and p.actionParams.userIds,
		avatarMax = getActionTelemetryFieldValue(p, p2, "avatarMax"),
		page = p3.appPage
	})

	if socialProofTextEventParams == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ message = "SocialProofTextClick telemetry missing `universeId`" },
			p3.appPage
		)
	else
		sendSocialProofTextClickedEvent(socialProofTextEventParams)
	end
end

return SduiSocialProofTextClickTelemetryHandler
