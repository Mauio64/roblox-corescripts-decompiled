local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
require(parent.UnifiedLogging)

local FFlagSduiSocialProofTextAnalytics = require(SocialServerDrivenUi.Flags.FFlagSduiSocialProofTextAnalytics)

local buildSocialProofTextEventParams = require(SocialServerDrivenUi.Analytics.SocialProofText.buildSocialProofTextEventParams)

local sendSocialProofTextImpressionEvent = require(SocialServerDrivenUi.Analytics.SocialProofText.sendSocialProofTextImpressionEvent)

local function SduiSocialProofTextImpressionsHandler(p, items, p2, _, _: number?)
	if not FFlagSduiSocialProofTextAnalytics then
		return
	end

	for _, item in items do
		local v = p2[item] or nil
		local v2

		if v then
			v2 = buildSocialProofTextEventParams({
				universeId = v.universeId,
				placeId = v.placeId,
				totalConnections = v.totalConnections,
				users = v.connectionPlayedUsers,
				avatarMax = v.avatarMax,
				page = p.appPage
			})
		end

		if v2 then
			sendSocialProofTextImpressionEvent(v2)
		else
			p.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToLogSocialProofTextImpressions,
				{
					name = "SduiSocialProofTextImpressionsHandler",
					message = `Missing universeId for impression index {item}`
				},
				p.appPage
			)
		end
	end
end

return SduiSocialProofTextImpressionsHandler
