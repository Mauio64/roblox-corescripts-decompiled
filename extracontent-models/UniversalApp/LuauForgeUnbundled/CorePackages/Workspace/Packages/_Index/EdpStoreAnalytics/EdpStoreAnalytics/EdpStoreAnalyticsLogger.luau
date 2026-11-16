local TelemetryService = game:GetService("TelemetryService")
local IXPService = game:GetService("IXPService")

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/ExperimentLayers").AppUserLayers
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/Constants")

local FFlagEnableDynamicEdpStorePreviewExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/Flags/FFlagEnableDynamicEdpStorePreviewExposureLogging")
local FStringEdpStorePreviewIXPLayersCommaSeparated = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/Flags/FStringEdpStorePreviewIXPLayersCommaSeparated")

local defineFastInt = game:DefineFastInt("EdpStoreClicksDetectorThrottlingHundredthsPercent", 0)

local defineFastInt2 = game:DefineFastInt("EdpStoreImpressionsDetectorThrottlingHundredthsPercent", 0)

local function sendLogEvent(p2)
	TelemetryService:LogEvent({
		eventName = "experienceStoreProducts",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 10, 23 },
		description = "Event fired from the lua app for click events on the EDP store"
	}, { customFields = p2 })
end

local function sendImpressionLogEvent(p2)
	TelemetryService:LogEvent({
		eventName = Constants.ExperienceStoreEventName,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt2,
		lastUpdated = { 25, 10, 23 },
		description = "Event fired from the lua app for every impression on the EDP store or preview"
	}, { customFields = p2 })
end

return {
	logEvent = function(p2, p3, p4, p5, p6, p7, p8)
		sendLogEvent({
			actionType = p2,
			productType = p3,
			locationType = p4,
			universeId = p5,
			productId = p6,
			itemId = p7
		})
	end,
	logImpression = function(p2)
		sendImpressionLogEvent(p2)
	end,
	logExperienceStoreExposure = function()
		if not FFlagEnableDynamicEdpStorePreviewExposureLogging then
			IXPService:LogUserLayerExposure(appUserLayers.EconomyDeveloperMonetizationEdpVirtualProductsRanking)
			return
		end

		for k, v6 in string.split(FStringEdpStorePreviewIXPLayersCommaSeparated, ",") do
			local v7 = string.match(v6, "^%s*(.-)%s*$")

			if v7 ~= nil and v7 ~= "" then
				IXPService:LogUserLayerExposure(v7)
			end
		end
	end
}
