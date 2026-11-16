local AppStoreAgeSignalsManager = script:FindFirstAncestor("AppStoreAgeSignalsManager")
local parent = AppStoreAgeSignalsManager.Parent

local Promise = require(parent.Promise)

local AppAgeSignalsServiceWrapper = require(script.Parent.AppAgeSignalsServiceWrapper)
local AppStoreAgeSignalsProvider = require(AppStoreAgeSignalsManager.Utils.AppStoreAgeSignalsProvider)
local AppAgeSignalsTelemetryConfigs = require(AppStoreAgeSignalsManager.Telemetry.AppAgeSignalsTelemetryConfigs)

return {
	requestAppAgeSignals = function()
		if AppAgeSignalsServiceWrapper.isAvailable() then
			return AppStoreAgeSignalsProvider.checkEligibility():andThen(function(p)
				if p.eligible then
					return AppAgeSignalsServiceWrapper.getAppAgeSignalsAsync():andThen(function(p2)
						return AppStoreAgeSignalsProvider.publishResult(p.signalSource, p2, "Complete")
					end):catch(function(p2)
						AppAgeSignalsTelemetryConfigs.reportError({
							error = tostring(p2),
							signalSource = p.signalSource
						})

						return Promise.reject(p2)
					end)
				end

				return Promise.reject("User is not eligible for app age signals")
			end)
		end

		return Promise.reject("AppAgeSignalsService is not available")
	end
}
