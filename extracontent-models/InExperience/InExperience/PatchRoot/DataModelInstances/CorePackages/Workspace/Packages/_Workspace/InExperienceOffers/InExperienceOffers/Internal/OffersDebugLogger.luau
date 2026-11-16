local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local Promise = require(parent.Promise)
local FFlagEnableOffersDebugLogging = require(InExperienceOffers.Flags.FFlagEnableOffersDebugLogging)
local OffersDebugLogger = {}

function OffersDebugLogger.log(p: string)
	if FFlagEnableOffersDebugLogging then
		print("[OffersDebug]", p)
	end
end

function OffersDebugLogger.logLazy(callback)
	if FFlagEnableOffersDebugLogging then
		print("[OffersDebug]", callback())
	end
end

function OffersDebugLogger.startTimer()
	if FFlagEnableOffersDebugLogging then
		return os.clock()
	end

	return nil
end

function OffersDebugLogger.logElapsed(p: string, p2: number?)
	if FFlagEnableOffersDebugLogging and p2 ~= nil then
		print("[OffersDebug]", p, string.format("(%.3fs)", os.clock() - p2))
	end
end

function OffersDebugLogger.logElapsedLazy(callback, p: number?)
	if FFlagEnableOffersDebugLogging and p ~= nil then
		print("[OffersDebug]", callback(), string.format("(%.3fs)", os.clock() - p))
	end
end

function OffersDebugLogger.tracePromise(object, p)
	if not FFlagEnableOffersDebugLogging then
		return object
	end

	if p.onSuccess then
		local onSuccess = p.onSuccess
		object = object:andThen(function(p2)
			onSuccess(p2)
			return p2
		end)
	end

	if p.onError then
		local onError = p.onError
		object = object:catch(function(p2)
			onError(p2)
			return Promise.reject(p2)
		end)
	end

	return object
end

return OffersDebugLogger
