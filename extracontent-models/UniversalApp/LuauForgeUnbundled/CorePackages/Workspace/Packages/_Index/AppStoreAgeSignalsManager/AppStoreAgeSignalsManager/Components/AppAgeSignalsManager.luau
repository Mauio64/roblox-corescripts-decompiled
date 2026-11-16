local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStoreAgeSignalsManager/Promise")

local AppAgeSignalsServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Index/AppStoreAgeSignalsManager/AppStoreAgeSignalsManager/Components/AppAgeSignalsServiceWrapper")
local AppStoreAgeSignalsProvider = require("@game/CorePackages/Workspace/Packages/_Index/AppStoreAgeSignalsManager/AppStoreAgeSignalsManager/Utils/AppStoreAgeSignalsProvider")
local AppAgeSignalsTelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Index/AppStoreAgeSignalsManager/AppStoreAgeSignalsManager/Telemetry/AppAgeSignalsTelemetryConfigs")

return {
	requestAppAgeSignals = function()
		if AppAgeSignalsServiceWrapper.isAvailable() then
			return AppStoreAgeSignalsProvider.checkEligibility():andThen(function(p2)
				if p2.eligible then
					return AppAgeSignalsServiceWrapper.getAppAgeSignalsAsync():andThen(function(p3)
						return AppStoreAgeSignalsProvider.publishResult(p2.signalSource, p3, "Complete")
					end):catch(function(p3)
						AppAgeSignalsTelemetryConfigs.reportError({
							error = tostring(p3),
							signalSource = p2.signalSource
						})

						return Promise.reject(p3)
					end)
				end

				return Promise.reject("User is not eligible for app age signals")
			end)
		end

		return Promise.reject("AppAgeSignalsService is not available")
	end
}
