local AppStoreAgeSignalsManager = script:FindFirstAncestor("AppStoreAgeSignalsManager")
local AppStoreAgeSignalsManagerParent = AppStoreAgeSignalsManager.Parent
local Promise = require(AppStoreAgeSignalsManagerParent.Promise)
local AppAgeSignalsServiceWrapper = require(script.Parent.AppAgeSignalsServiceWrapper)
local AppStoreAgeSignalsProvider = require(AppStoreAgeSignalsManager.Utils.AppStoreAgeSignalsProvider)
local AppAgeSignalsTelemetryConfigs = require(AppStoreAgeSignalsManager.Telemetry.AppAgeSignalsTelemetryConfigs)

return {
	requestAppAgeSignals = function() -- line: 10
		-- upvalues: AppAgeSignalsServiceWrapper (copy), Promise (copy), AppStoreAgeSignalsProvider (copy), AppAgeSignalsTelemetryConfigs (copy)
		if not AppAgeSignalsServiceWrapper.isAvailable() then
			return Promise.reject("AppAgeSignalsService is not available")
		end

		return AppStoreAgeSignalsProvider.checkEligibility():andThen(function(p1) -- line: 15
			-- upvalues: Promise (copy), AppAgeSignalsServiceWrapper (copy), AppStoreAgeSignalsProvider (copy), AppAgeSignalsTelemetryConfigs (copy)
			if not p1.eligible then
				return Promise.reject("User is not eligible for app age signals")
			end

			return AppAgeSignalsServiceWrapper.getAppAgeSignalsAsync():andThen(function(p2) -- line: 21
				-- upvalues: AppStoreAgeSignalsProvider (copy), p1 (copy)
				return AppStoreAgeSignalsProvider.publishResult(p1.signalSource, p2, "Complete")
			end):catch(function(p3) -- line: 24
				-- upvalues: AppAgeSignalsTelemetryConfigs (copy), p1 (copy), Promise (copy)
				AppAgeSignalsTelemetryConfigs.reportError({
					error = tostring(p3),
					signalSource = p1.signalSource
				})

				return Promise.reject(p3)
			end)
		end)
	end
}
