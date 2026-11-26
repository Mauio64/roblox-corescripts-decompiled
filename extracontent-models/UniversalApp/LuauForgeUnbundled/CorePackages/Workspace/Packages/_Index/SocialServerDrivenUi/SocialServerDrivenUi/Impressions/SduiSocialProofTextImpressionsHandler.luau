local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").SduiErrors
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/UnifiedLogging")

local FFlagSduiSocialProofTextAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiSocialProofTextAnalytics")

local buildSocialProofTextEventParams = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/buildSocialProofTextEventParams")

local sendSocialProofTextImpressionEvent = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/SocialProofText/sendSocialProofTextImpressionEvent")

local function SduiSocialProofTextImpressionsHandler(p2, items, p3, p4, p5)
	if not FFlagSduiSocialProofTextAnalytics then
		return
	end

	for k, item in items do
		local v5 = p3[item] or nil
		local v6

		if v5 then
			v6 = buildSocialProofTextEventParams({
				universeId = v5.universeId,
				placeId = v5.placeId,
				totalConnections = v5.totalConnections,
				users = v5.connectionPlayedUsers,
				avatarMax = v5.avatarMax,
				page = p2.appPage
			})
		end

		if v6 then
			sendSocialProofTextImpressionEvent(v6)
		else
			p2.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToLogSocialProofTextImpressions,
				{
					name = "SduiSocialProofTextImpressionsHandler",
					message = `Missing universeId for impression index {item}`
				},
				p2.appPage
			)
		end
	end
end

return SduiSocialProofTextImpressionsHandler
