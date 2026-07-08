local TelemetryService = game:GetService("TelemetryService")
local IXPService = game:GetService("IXPService")
local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local EdpStoreAnalyticsParent = EdpStoreAnalytics.Parent
local React = require(EdpStoreAnalyticsParent.React)
local AppCommonLib = require(EdpStoreAnalyticsParent.AppCommonLib)
local AppUserLayers = require(EdpStoreAnalyticsParent.ExperimentLayers).AppUserLayers
local Constants = require(EdpStoreAnalytics.Constants)
local EdpStoreAnalyticsLogger = require(EdpStoreAnalytics.EdpStoreAnalyticsLogger)
local Signal = AppCommonLib.Signal
local ScreenSizeImpressionsDetector = require(EdpStoreAnalyticsParent.Impressions).ScreenSizeImpressionsDetector
local FFlagSduiEdpStoreImpressionsLogging = require(EdpStoreAnalyticsParent.SharedFlags).FFlagSduiEdpStoreImpressionsLogging
local u13 = nil

if not FFlagSduiEdpStoreImpressionsLogging then
	u13 = game:DefineFastInt("EdpStoreImpressionsDetectorThrottlingHundredthsPercent", 0)
end

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), Signal (copy), FFlagSduiEdpStoreImpressionsLogging (copy), Constants (copy), EdpStoreAnalyticsLogger (copy), u13 (ref), TelemetryService (copy), IXPService (copy), AppUserLayers (copy), ScreenSizeImpressionsDetector (copy)
	local v15 = React.useRef(Signal.new())
	local v16 = React.useRef(false)

	React.useEffect(function() -- line: 37
		-- upvalues: t1 (copy), v15 (copy)
		if t1.scrollViewPositionChangedSignal.current then
			t1.scrollViewPositionChangedSignal.current:connect(function() -- line: 39
				-- upvalues: v15 (copy)
				v15.current:fire()
			end)
		end
	end, { t1.scrollViewPositionChangedSignal })

	local v17 = React.useCallback(function(t2: {[any]: any}) -- line: 45
		-- upvalues: v16 (copy), t1 (copy), FFlagSduiEdpStoreImpressionsLogging (copy), Constants (copy), EdpStoreAnalyticsLogger (copy), u13 (ref), TelemetryService (copy), IXPService (copy), AppUserLayers (copy)
		if #t2 == 0 or v16.current then
			return
		end

		if t1.parameters == nil then
			return
		end

		v16.current = true

		local v19 = t2[1]

		if FFlagSduiEdpStoreImpressionsLogging then
			local t3 = {
				universeId = tonumber(t1.parameters.universeId),
				productType = t1.parameters.productType,
				actionType = Constants.StoreEnums.ActionType.Impression,
				locationType = t1.parameters.locationType,
				layoutOrder = tonumber(v19)
			}

			EdpStoreAnalyticsLogger.logImpression(t3)
			EdpStoreAnalyticsLogger.logExperienceStoreExposure()

			return
		end

		local t4 = {
			description = "Event fired from the lua app for every impression on the EDP store or preview",
			eventName = Constants.ExperienceStoreEventName,
			backends = { "EventIngest" },
			throttlingPercentage = u13,
			lastUpdated = {
				25,
				10,
				23
			}
		}
		local t5 = {
			universeId = tonumber(t1.parameters.universeId),
			productType = t1.parameters.productType,
			actionType = Constants.StoreEnums.ActionType.Impression,
			locationType = t1.parameters.locationType,
			layoutOrder = tonumber(v19)
		}

		TelemetryService:LogEvent(t4, {
			customFields = t5
		})
		IXPService:LogUserLayerExposure(AppUserLayers.EconomyDeveloperMonetizationEdpVirtualProductsRanking)
	end, { t1.parameters })

	return React.createElement(ScreenSizeImpressionsDetector, {
		parentRef = t1.parentRef,
		onRequestImpressionsSignal = v15.current,
		onImpressionsDetected = v17,
		impressionsTag = t1.impressionsTag
	})
end
