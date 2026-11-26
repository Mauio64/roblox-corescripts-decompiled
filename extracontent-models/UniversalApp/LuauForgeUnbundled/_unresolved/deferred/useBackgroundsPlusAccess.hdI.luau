local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hdJ")
local module3 = require("@luauforge/deferred/hdK")
local useAppPolicy = require("@luauforge/deferred/hdL").useAppPolicy
local module4 = require("@luauforge/deferred/hdM")
local module5 = require("@luauforge/deferred/hdO")
local module6 = require("@luauforge/deferred/hdT")
local module7 = require("@luauforge/deferred/hcQ")
local fFlagAXBackgroundGenerationAnalytics = module7.FFlagAXBackgroundGenerationAnalytics
local fFlagAXPlusExclusiveBackgroundTryOn = module7.FFlagAXPlusExclusiveBackgroundTryOn

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = module7.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled

local fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement = module7.FFlagAXBackgroundsHideCreateTileWithoutAiEntitlement

local function getBackgroundsPlusVariants(p2, p3, p4)
	local v5 = fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled and p3 and not p2
	local v6 = fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement and p2 and not p4
	return {
		inventoryCreateTileEnabled = p2 and not v6,
		showInventoryCreateTile = not v6,
		showInventorySubscribeCta = not (p2 or v5),
		showExclusiveWithPlusSection = not v5,
		showMarketplaceExclusiveSection = not (p2 or v5)
	}
end

local function useBackgroundsPlusAccess()
	local v5 = module2.RobloxSubscriptionSignals.get()
	local v6 = module3.useSignalState(v5.getHasRobloxSubscription)
	local v7

	if fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		v7 = useAppPolicy(function(p2)
			return p2.getDisableBlackbirdEntrypoints()
		end)
	else
		v7 = false
	end

	local v8

	if fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then
		v8 = module3.useSignalState(module5(false).getIsEntitled)
		module6()
	else
		v8 = false
	end

	local function fn()
		local v12 = if fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then v8 else nil
		return getBackgroundsPlusVariants(v6, v7, v12)
	end

	local v11 = module.useMemo(fn, {
		v6,
		v7,
		if fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then v8 else nil
	})

	local ref = module.useRef(true)
	module.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v12 = module.useCallback(function(callback, callback2)
		local v13 = typeof(callback) == "function"

		local v14 = fFlagAXPlusExclusiveBackgroundTryOn and typeof(callback2) == "function"

		if v13 or v14 then
			return {
				onFlowComplete = function(p2)
					if
						ref.current
						and v13
						and p2 == module2.RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded
					then
						callback()
					end

					if v14 then
						callback2()
					end
				end
			}
		end

		return nil
	end, {})

	local v13 = module.useCallback(function(p2, p3)
		module2.initiateRobloxSubscriptionPurchase(
			nil,
			v12(p2, p3),
			nil,
			module2.SurfaceName.AvatarBackgrounds,
			module2.SurfaceContext.InApp
		)
	end, { v12 })
	local v14

	if fFlagAXBackgroundGenerationAnalytics then
		v14 = module.useCallback(function(p2, p3, p4, p5)
			local guid = HttpService:GenerateGUID(false)
			module4.sendUpsellClick(p2, p3, guid)
			module2.initiateRobloxSubscriptionPurchase(
				nil,
				v12(p4, p5),
				nil,
				module2.SurfaceName.AvatarBackgrounds,
				module2.SurfaceContext.InApp,
				nil,
				{
					clientSessionId = {
						clientSessionIdType = module2.PurchaseClientSessionIdType.PurchaseFlowUUID,
						clientSessionId = guid
					}
				}
			)
		end, { v12 })
	else
		v14 = nil
	end

	local function fn2()
		return {
			hasActiveSubscription = v6,
			backgroundVariants = v11,
			openSubscriptionPurchase = v13,
			openUpsellSubscriptionPurchase = if fFlagAXBackgroundGenerationAnalytics then v14 else nil
		}
	end

	return module.useMemo(fn2, {
		v6,
		v11,
		v13,
		if fFlagAXBackgroundGenerationAnalytics then v14 else nil
	})
end

return useBackgroundsPlusAccess
