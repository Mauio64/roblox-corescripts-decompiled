local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local SafetyResourceBannerAction = DiscoveryAnalytics.Constants.SafetyResourceBannerAction
local sendSafetyResourceBannerEvent = DiscoveryAnalytics.Events.sendSafetyResourceBannerEvent

require(parent.SduiCoreSystem)

local function SduiSafetyResourceBannerImpressionsHandler(_, items, p, _, _: number?)
	for _, item in items do
		local v = p and p[item] or {}

		sendSafetyResourceBannerEvent({
			action = SafetyResourceBannerAction.Impression,
			moderationCategory = v.moderationCategory,
			url = v.url,
			surface = v.surface,
			textFilterRequestId = v.textFilterRequestId
		})
	end
end

return SduiSafetyResourceBannerImpressionsHandler
