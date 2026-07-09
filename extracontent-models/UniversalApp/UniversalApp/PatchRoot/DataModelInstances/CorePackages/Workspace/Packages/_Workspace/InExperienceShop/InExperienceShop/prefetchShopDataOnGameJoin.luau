local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Signals = require(InExperienceShopParent.Signals)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local FFlagEnableShopPrefetch = require(InExperienceShop.Flags.FFlagEnableShopPrefetch)
local FFlagEnableShopProductInfoRefresh = require(InExperienceShop.Flags.FFlagEnableShopProductInfoRefresh)
local FFlagShopPrefetchProductInfo = require(InExperienceShop.Flags.FFlagShopPrefetchProductInfo)
local FIntShopPrefetchMaxRetries = require(InExperienceShop.Flags.FIntShopPrefetchMaxRetries)
local FIntShopPrefetchRetryBackoffMs = require(InExperienceShop.Flags.FIntShopPrefetchRetryBackoffMs)
local FIntShopPrefetchDelayMs = require(InExperienceShop.Flags.FIntShopPrefetchDelayMs)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local whenJoinSettles = require(InExperienceShop.Internal.whenJoinSettles)
local schedulePrefetchDelay = require(InExperienceShop.Internal.schedulePrefetchDelay)
local scheduleRetry = require(InExperienceShop.Internal.scheduleRetry)
local logCounter = require(InExperienceShop.Internal.logCounter)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local PrefetchOnJoinFiredFallbackPathCounter = require(InExperienceShop.Events.PrefetchOnJoinFiredFallbackPathCounter)
local PrefetchOnJoinFiredPrimaryPathCounter = require(InExperienceShop.Events.PrefetchOnJoinFiredPrimaryPathCounter)
local PrefetchOnJoinRetriedCounter = require(InExperienceShop.Events.PrefetchOnJoinRetriedCounter)

local function hasNonSyntheticCategory(t1: {[any]: any}) -- line: 31
	-- upvalues: Constants (copy)
	for _, v26 in t1 do
		if v26.id ~= Constants.HOME_CATEGORY_ID then
			return true
		end
	end

	return false
end
local function awaitPrefetchOutcome(p1: ((...any) -> ...any)) -- line: 46
	-- upvalues: getInExperienceShopStore (copy), Signals (copy)
	local v28 = getInExperienceShopStore(false)
	local u29 = false
	local u30 = nil

	u30 = Signals.createEffect(function(p2) -- line: 50
		-- upvalues: u29 (ref), v28 (copy), p1 (copy), u30 (ref)
		if u29 then
			return
		end

		if v28.getLoading(p2) then
			return
		end

		local v41 = v28.getCategories(p2)
		local v42 = v28.getError(p2)

		u29 = true
		task.spawn(function() -- line: 61
			-- upvalues: p1 (copy), v42 (copy), v41 (copy)
			p1(v42, v41)
		end)
		task.defer(function() -- line: 64
			-- upvalues: u30 (ref)
			if u30 then
				u30()
			end
		end)
	end)
end
local function triggerPrefetch(p3, p4: ((...any) -> ...any)?) -- line: 72
	-- upvalues: ShopDebugLogger (copy), logCounter (copy), PrefetchOnJoinFiredPrimaryPathCounter (copy), PrefetchOnJoinFiredFallbackPathCounter (copy), getInExperienceShopStore (copy), FFlagEnableShopProductInfoRefresh (copy), FFlagShopPrefetchProductInfo (copy), FIntShopPrefetchMaxRetries (copy), FIntShopPrefetchRetryBackoffMs (copy), Constants (copy), PrefetchOnJoinRetriedCounter (copy), scheduleRetry (copy), Signals (copy)
	ShopDebugLogger.logLazy(function() -- line: 73
		-- upvalues: p3 (copy)
		return "prefetchShopDataOnGameJoin: triggerPrefetch path=" .. p3
	end)

	if p3 == "primary" then
		logCounter(PrefetchOnJoinFiredPrimaryPathCounter)
	else
		logCounter(PrefetchOnJoinFiredFallbackPathCounter)
	end

	local v33 = getInExperienceShopStore(false)
	local v34 = ShopDebugLogger.startTimer()

	if not p4 then
		if FFlagEnableShopProductInfoRefresh and not FFlagShopPrefetchProductInfo then
			ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting prefetchWidgetsOnly")
			v33.prefetchWidgetsOnly()

			return
		end

		ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting fetchAllShopData")
		v33.fetchAllShopData()

		return
	end

	local v35 = FIntShopPrefetchMaxRetries
	local v36 = FIntShopPrefetchRetryBackoffMs / 1000
	local u37 = v35

	local function tryFetch() -- line: 108
		-- upvalues: ShopDebugLogger (copy), v35 (copy), u37 (ref), FFlagEnableShopProductInfoRefresh (copy), FFlagShopPrefetchProductInfo (copy), v33 (copy), Constants (copy), v36 (copy), logCounter (copy), PrefetchOnJoinRetriedCounter (copy), scheduleRetry (copy), tryFetch (copy), v34 (copy), p4 (copy), getInExperienceShopStore (copy), Signals (copy)
		ShopDebugLogger.logLazy(function() -- line: 109
			-- upvalues: v35 (copy), u37 (ref)
			return "prefetchShopDataOnGameJoin: attempt=" .. v35 - u37 + 1 .. " of " .. v35 + 1
		end)

		if FFlagEnableShopProductInfoRefresh and not FFlagShopPrefetchProductInfo then
			ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting prefetchWidgetsOnly")
			v33.prefetchWidgetsOnly()
		else
			ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting fetchAllShopData")
			v33.fetchAllShopData()
		end

		local function v43(p5, t2: {[any]: any}) -- line: 117
			-- upvalues: Constants (copy), u37 (ref), ShopDebugLogger (copy), v36 (copy), logCounter (copy), PrefetchOnJoinRetriedCounter (copy), scheduleRetry (copy), tryFetch (copy), v34 (copy), p4 (copy)
			local v51 = false
			local g54

			if p5 == nil then
				g54 = nil

				for _, v53 in t2 do
					if v53.id ~= Constants.HOME_CATEGORY_ID then
						v51 = true
						g54 = true
					end

					if g54 then
						break
					end
				end

				if not g54 then
					v51 = false
				end
			end

			g54 = false

			local v55 = v51

			if p5 ~= nil and u37 > 0 then
				u37 -= 1
				ShopDebugLogger.logLazy(function() -- line: 124
					-- upvalues: u37 (ref), v36 (copy)
					return "prefetchShopDataOnGameJoin: error, retrying attemptsRemaining=" .. u37 .. " backoffSeconds=" .. v36
				end)
				logCounter(PrefetchOnJoinRetriedCounter)
				scheduleRetry(v36, tryFetch)

				return
			end

			ShopDebugLogger.logElapsedLazy(function() -- line: 135
				-- upvalues: v55 (copy)
				return "prefetchShopDataOnGameJoin: settled hasItems=" .. tostring(v55)
			end, v34)
			p4(v55)
		end

		local v44 = getInExperienceShopStore(false)
		local u45 = false
		local u46 = nil

		u46 = Signals.createEffect(function(p6) -- line: 50
			-- upvalues: u45 (ref), v44 (copy), v43 (copy), u46 (ref)
			if u45 then
				return
			end

			if v44.getLoading(p6) then
				return
			end

			local v57 = v44.getCategories(p6)
			local v58 = v44.getError(p6)

			u45 = true
			task.spawn(function() -- line: 61
				-- upvalues: v43 (copy), v58 (copy), v57 (copy)
				v43(v58, v57)
			end)
			task.defer(function() -- line: 64
				-- upvalues: u46 (ref)
				if u46 then
					u46()
				end
			end)
		end)
	end

	tryFetch()
end
local function prefetchShopDataOnGameJoin(p7: ((...any) -> ...any)?) -- line: 160
	-- upvalues: FFlagEnableShopPrefetch (copy), ShopDebugLogger (copy), whenJoinSettles (copy), FIntShopPrefetchDelayMs (copy), triggerPrefetch (copy), schedulePrefetchDelay (copy)
	if not FFlagEnableShopPrefetch then
		return
	end

	ShopDebugLogger.log("prefetchShopDataOnGameJoin: waiting for join to settle")
	whenJoinSettles(function(p8) -- line: 165
		-- upvalues: ShopDebugLogger (copy), FIntShopPrefetchDelayMs (copy), triggerPrefetch (copy), p7 (copy), schedulePrefetchDelay (copy)
		ShopDebugLogger.logLazy(function() -- line: 166
			-- upvalues: p8 (copy)
			return "prefetchShopDataOnGameJoin: join settled path=" .. p8
		end)

		local v48 = FIntShopPrefetchDelayMs

		if v48 <= 0 then
			triggerPrefetch(p8, p7)

			return
		end

		schedulePrefetchDelay(v48 / 1000, function() -- line: 174
			-- upvalues: triggerPrefetch (copy), p8 (copy), p7 (copy)
			triggerPrefetch(p8, p7)
		end)
	end)
end

return prefetchShopDataOnGameJoin
