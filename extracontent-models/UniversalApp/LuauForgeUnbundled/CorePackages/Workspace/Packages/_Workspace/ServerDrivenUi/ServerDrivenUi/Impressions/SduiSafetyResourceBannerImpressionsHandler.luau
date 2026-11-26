local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local safetyResourceBannerAction = DiscoveryAnalytics.Constants.SafetyResourceBannerAction
local sendSafetyResourceBannerEvent = DiscoveryAnalytics.Events.sendSafetyResourceBannerEvent

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local function SduiSafetyResourceBannerImpressionsHandler(p2, items, p3, p4, p5)
	for k, item in items do
		local v5 = p3 and p3[item] or {}

		sendSafetyResourceBannerEvent({
			action = safetyResourceBannerAction.Impression,
			moderationCategory = v5.moderationCategory,
			url = v5.url,
			surface = v5.surface,
			textFilterRequestId = v5.textFilterRequestId
		})
	end
end

return SduiSafetyResourceBannerImpressionsHandler
