local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local FFlagEnableShopDebugLogging = require(InExperienceShop.Flags.FFlagEnableShopDebugLogging)
local ShopDebugLogger = {}

function ShopDebugLogger.log(p: string)
	if FFlagEnableShopDebugLogging then
		print("[ShopDebug]", p)
	end
end

function ShopDebugLogger.logLazy(callback)
	if FFlagEnableShopDebugLogging then
		print("[ShopDebug]", callback())
	end
end

function ShopDebugLogger.startTimer()
	if FFlagEnableShopDebugLogging then
		return os.clock()
	end

	return nil
end

function ShopDebugLogger.logElapsed(p: string, p2: number?)
	if FFlagEnableShopDebugLogging and p2 ~= nil then
		print("[ShopDebug]", p, string.format("(%.3fs)", os.clock() - p2))
	end
end

function ShopDebugLogger.logElapsedLazy(callback, p: number?)
	if FFlagEnableShopDebugLogging and p ~= nil then
		print("[ShopDebug]", callback(), string.format("(%.3fs)", os.clock() - p))
	end
end

function ShopDebugLogger.tracePromise(object, p)
	if not FFlagEnableShopDebugLogging then
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

return ShopDebugLogger
