local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Signals = require(parent.Signals)

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

local function hasNonSyntheticCategory(items): boolean
	for _, item in items do
		if item.id ~= Constants.HOME_CATEGORY_ID then
			return true
		end
	end

	return false
end

local function awaitPrefetchOutcome(fn) -- 1 equivalent call inferred from this helper
	local v = getInExperienceShopStore(false)
	local flag = false
	local v2 = nil
	v2 = Signals.createEffect(function(p)
		if flag or v.getLoading(p) then
			return
		end

		local categories = v.getCategories(p)
		local err = v.getError(p)
		flag = true
		task.spawn(function()
			fn(err, categories)
		end)
		task.defer(function()
			if v2 then
				v2()
			end
		end)
	end)
end

local function triggerPrefetch(p, callback)
	ShopDebugLogger.logLazy(function()
		return "prefetchShopDataOnGameJoin: triggerPrefetch path=" .. p
	end)

	if p == "primary" then
		logCounter(PrefetchOnJoinFiredPrimaryPathCounter)
	else
		logCounter(PrefetchOnJoinFiredFallbackPathCounter)
	end

	local v = getInExperienceShopStore(false)
	local v2 = ShopDebugLogger.startTimer()

	local function fn() -- 2 equivalent calls inferred from this helper
		if FFlagEnableShopProductInfoRefresh and not FFlagShopPrefetchProductInfo then
			ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting prefetchWidgetsOnly")
			v.prefetchWidgetsOnly()
		else
			ShopDebugLogger.log("prefetchShopDataOnGameJoin: starting fetchAllShopData")
			v.fetchAllShopData()
		end
	end

	if callback then
		local v3 = FIntShopPrefetchMaxRetries
		local v4 = FIntShopPrefetchRetryBackoffMs / 1000
		local v5 = v3
		local function tryFetch()
			ShopDebugLogger.logLazy(function()
				return "prefetchShopDataOnGameJoin: attempt=" .. v3 - v5 + 1 .. " of " .. v3 + 1
			end)
			fn() -- inferred equivalent call

			local function fn2(p2, items)
				local v6

				if p2 == nil then
					local flag = true

					for _, item in items do
						if item.id ~= Constants.HOME_CATEGORY_ID then
							v6 = true
							flag = false
							break
						end
					end

					if flag then
						v6 = false
					end
				else
					v6 = false
				end

				if p2 ~= nil and v5 > 0 then
					v5 -= 1
					ShopDebugLogger.logLazy(function()
						return "prefetchShopDataOnGameJoin: error, retrying attemptsRemaining=" .. v5 .. " backoffSeconds=" .. v4
					end)

					logCounter(PrefetchOnJoinRetriedCounter)
					scheduleRetry(v4, tryFetch)
				else
					ShopDebugLogger.logElapsedLazy(function()
						return "prefetchShopDataOnGameJoin: settled hasItems=" .. tostring(v6)
					end, v2)

					callback(v6)
				end
			end

			awaitPrefetchOutcome(fn2) -- inferred equivalent call
		end

		tryFetch()
	else
		fn() -- inferred equivalent call
	end
end

local function prefetchShopDataOnGameJoin(callback)
	if not FFlagEnableShopPrefetch then
		return
	end

	ShopDebugLogger.log("prefetchShopDataOnGameJoin: waiting for join to settle")
	whenJoinSettles(function(p)
		ShopDebugLogger.logLazy(function()
			return "prefetchShopDataOnGameJoin: join settled path=" .. p
		end)

		local v = FIntShopPrefetchDelayMs

		if v <= 0 then
			triggerPrefetch(p, callback)
		else
			schedulePrefetchDelay(v / 1000, function()
				triggerPrefetch(p, callback)
			end)
		end
	end)
end

return prefetchShopDataOnGameJoin
