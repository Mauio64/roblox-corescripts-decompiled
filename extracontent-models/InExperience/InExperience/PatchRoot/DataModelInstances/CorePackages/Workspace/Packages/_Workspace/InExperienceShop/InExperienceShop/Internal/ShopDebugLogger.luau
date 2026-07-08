local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local FFlagEnableShopDebugLogging = require(InExperienceShop.Flags.FFlagEnableShopDebugLogging)

return {
	log = function(s1: string) -- line: 9
		-- upvalues: FFlagEnableShopDebugLogging (copy)
		if FFlagEnableShopDebugLogging then
			print("[ShopDebug]", s1)
		end
	end,
	logLazy = function(p1: ((...any) -> ...any)) -- line: 17
		-- upvalues: FFlagEnableShopDebugLogging (copy)
		if FFlagEnableShopDebugLogging then
			print("[ShopDebug]", p1())
		end
	end,
	startTimer = function() -- line: 26
		-- upvalues: FFlagEnableShopDebugLogging (copy)
		if FFlagEnableShopDebugLogging then
			return os.clock()
		end

		return nil
	end,
	logElapsed = function(s2: string, n1: number?) -- line: 33
		-- upvalues: FFlagEnableShopDebugLogging (copy)
		if FFlagEnableShopDebugLogging and n1 ~= nil then
			print("[ShopDebug]", s2, string.format("(%.3fs)", os.clock() - n1))
		end
	end,
	logElapsedLazy = function(p2: ((...any) -> ...any), n2: number?) -- line: 39
		-- upvalues: FFlagEnableShopDebugLogging (copy)
		if FFlagEnableShopDebugLogging and n2 ~= nil then
			print("[ShopDebug]", p2(), string.format("(%.3fs)", os.clock() - n2))
		end
	end,
	tracePromise = function(p3, t1: {[any]: any}) -- line: 52
		-- upvalues: FFlagEnableShopDebugLogging (copy), Promise (copy)
		if not FFlagEnableShopDebugLogging then
			return p3
		end

		if t1.onSuccess then
			local onSuccess = t1.onSuccess

			p3 = p3:andThen(function(p4) -- line: 60
				-- upvalues: onSuccess (copy)
				onSuccess(p4)

				return p4
			end)
		end

		if t1.onError then
			local onError = t1.onError

			p3 = p3:catch(function(p5) -- line: 67
				-- upvalues: onError (copy), Promise (copy)
				onError(p5)

				return Promise.reject(p5)
			end)
		end

		return p3
	end
}
