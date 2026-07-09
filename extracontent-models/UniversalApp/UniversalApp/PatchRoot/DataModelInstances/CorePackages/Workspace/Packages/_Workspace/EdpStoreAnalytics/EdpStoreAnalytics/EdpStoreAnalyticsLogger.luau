local TelemetryService = game:GetService("TelemetryService")
local IXPService = game:GetService("IXPService")
local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local EdpStoreAnalyticsParent = EdpStoreAnalytics.Parent
local AppUserLayers = require(EdpStoreAnalyticsParent.ExperimentLayers).AppUserLayers
local Constants = require(EdpStoreAnalytics.Constants)
local v7 = game:DefineFastInt("EdpStoreClicksDetectorThrottlingHundredthsPercent", 0)
local v8 = game:DefineFastInt("EdpStoreImpressionsDetectorThrottlingHundredthsPercent", 0)
local t1 = {}

local function sendLogEvent(t2: {[any]: any}) -- line: 17
	-- upvalues: v7 (copy), TelemetryService (copy)
	local t3 = {
		eventName = "experienceStoreProducts",
		description = "Event fired from the lua app for click events on the EDP store",
		backends = { "EventIngest" },
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			10,
			23
		}
	}

	TelemetryService:LogEvent(t3, {
		customFields = t2
	})
end
local function sendImpressionLogEvent(t4: {[any]: any}) -- line: 32
	-- upvalues: Constants (copy), v8 (copy), TelemetryService (copy)
	local t5 = {
		description = "Event fired from the lua app for every impression on the EDP store or preview",
		eventName = Constants.ExperienceStoreEventName,
		backends = { "EventIngest" },
		throttlingPercentage = v8,
		lastUpdated = {
			25,
			10,
			23
		}
	}

	TelemetryService:LogEvent(t5, {
		customFields = t4
	})
end

function t1.logEvent(s1: string, s2: string, s3: string?, n1: number?, n2: number?, s4: string?, _: {[any]: any}?) -- line: 45
	-- upvalues: sendLogEvent (copy)
	local t7 = {
		actionType = s1,
		productType = s2,
		locationType = s3,
		universeId = n1,
		productId = n2,
		itemId = s4
	}

	sendLogEvent(t7)
end
function t1.logImpression(t8: {[any]: any}) -- line: 69
	-- upvalues: sendImpressionLogEvent (copy)
	sendImpressionLogEvent(t8)
end
function t1.logExperienceStoreExposure() -- line: 75
	-- upvalues: IXPService (copy), AppUserLayers (copy)
	IXPService:LogUserLayerExposure(AppUserLayers.EconomyDeveloperMonetizationEdpVirtualProductsRanking)
end

return t1
