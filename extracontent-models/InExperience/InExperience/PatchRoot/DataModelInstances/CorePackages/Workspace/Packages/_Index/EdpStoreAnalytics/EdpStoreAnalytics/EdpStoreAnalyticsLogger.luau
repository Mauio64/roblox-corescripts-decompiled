local TelemetryService = game:GetService("TelemetryService")
local IXPService = game:GetService("IXPService")

local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local parent = EdpStoreAnalytics.Parent

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local Constants = require(EdpStoreAnalytics.Constants)

local FFlagEnableDynamicEdpStorePreviewExposureLogging = require(EdpStoreAnalytics.Flags.FFlagEnableDynamicEdpStorePreviewExposureLogging)
local FStringEdpStorePreviewIXPLayersCommaSeparated = require(EdpStoreAnalytics.Flags.FStringEdpStorePreviewIXPLayersCommaSeparated)

local defineFastInt = game:DefineFastInt("EdpStoreClicksDetectorThrottlingHundredthsPercent", 0)

local defineFastInt2 = game:DefineFastInt("EdpStoreImpressionsDetectorThrottlingHundredthsPercent", 0)

local function sendLogEvent(customFields)
	TelemetryService:LogEvent({
		eventName = "experienceStoreProducts",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 10, 23 },
		description = "Event fired from the lua app for click events on the EDP store"
	}, { customFields = customFields })
end

local function sendImpressionLogEvent(customFields)
	TelemetryService:LogEvent({
		eventName = Constants.ExperienceStoreEventName,
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt2,
		lastUpdated = { 25, 10, 23 },
		description = "Event fired from the lua app for every impression on the EDP store or preview"
	}, { customFields = customFields })
end

local EdpStoreAnalyticsLogger = {}

function EdpStoreAnalyticsLogger.logEvent(actionType: string, productType: string, locationType: string?, universeId: number?, productId: number?, itemId: string?, _)
	sendLogEvent({
		actionType = actionType,
		productType = productType,
		locationType = locationType,
		universeId = universeId,
		productId = productId,
		itemId = itemId
	})
end

function EdpStoreAnalyticsLogger.logImpression(customFields)
	sendImpressionLogEvent(customFields)
end

function EdpStoreAnalyticsLogger.logExperienceStoreExposure()
	if not FFlagEnableDynamicEdpStorePreviewExposureLogging then
		IXPService:LogUserLayerExposure(AppUserLayers.EconomyDeveloperMonetizationEdpVirtualProductsRanking)
		return
	end

	for _, v in string.split(FStringEdpStorePreviewIXPLayersCommaSeparated, ",") do
		local v2 = string.match(v, "^%s*(.-)%s*$")

		if v2 ~= nil and v2 ~= "" then
			IXPService:LogUserLayerExposure(v2)
		end
	end
end

return EdpStoreAnalyticsLogger
