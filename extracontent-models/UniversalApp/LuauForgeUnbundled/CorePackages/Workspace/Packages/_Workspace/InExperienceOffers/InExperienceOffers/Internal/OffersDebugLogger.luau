local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/Promise")
local FFlagEnableOffersDebugLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Flags/FFlagEnableOffersDebugLogging")

return {
	log = function(p2)
		if FFlagEnableOffersDebugLogging then
			print("[OffersDebug]", p2)
		end
	end,
	logLazy = function(callback)
		if FFlagEnableOffersDebugLogging then
			print("[OffersDebug]", callback())
		end
	end,
	startTimer = function()
		if FFlagEnableOffersDebugLogging then
			return os.clock()
		end

		return nil
	end,
	logElapsed = function(p2, p3)
		if FFlagEnableOffersDebugLogging and p3 ~= nil then
			print("[OffersDebug]", p2, string.format("(%.3fs)", os.clock() - p3))
		end
	end,
	logElapsedLazy = function(callback, p2)
		if FFlagEnableOffersDebugLogging and p2 ~= nil then
			print("[OffersDebug]", callback(), string.format("(%.3fs)", os.clock() - p2))
		end
	end,
	tracePromise = function(object, p2)
		if not FFlagEnableOffersDebugLogging then
			return object
		end

		if p2.onSuccess then
			local onSuccess = p2.onSuccess
			object = object:andThen(function(p3)
				onSuccess(p3)
				return p3
			end)
		end

		if p2.onError then
			local onError = p2.onError
			object = object:catch(function(p3)
				onError(p3)
				return Promise.reject(p3)
			end)
		end

		return object
	end
}
