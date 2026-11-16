local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gRD")
local module3 = require("@luauforge/deferred/gRE")
local useAppPolicy = require("@luauforge/deferred/gRF").useAppPolicy
local module4 = require("@luauforge/deferred/gRG")
local module5 = require("@luauforge/deferred/gQK")
local fFlagAXBackgroundGenerationAnalytics = module5.FFlagAXBackgroundGenerationAnalytics
local fFlagAXPlusExclusiveBackgroundTryOn = module5.FFlagAXPlusExclusiveBackgroundTryOn

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = module5.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled

local function getBackgroundsPlusVariants(p2, p3)
	local v5 = fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled and p3 and not p2
	return {
		inventoryCreateTileEnabled = p2,
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

	local v8 = module.useMemo(function()
		local v11 = fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled and v7 and not v6
		return {
			inventoryCreateTileEnabled = v6,
			showInventorySubscribeCta = not (v6 or v11),
			showExclusiveWithPlusSection = not v11,
			showMarketplaceExclusiveSection = not (v6 or v11)
		}
	end, { v6, v7 })

	local ref = module.useRef(true)
	module.useEffect(function()
		ref.current = true
		return function()
			ref.current = false
		end
	end, {})

	local v9 = module.useCallback(function(callback, callback2)
		local v10 = typeof(callback) == "function"

		local v11 = fFlagAXPlusExclusiveBackgroundTryOn and typeof(callback2) == "function"

		if v10 or v11 then
			return {
				onFlowComplete = function(p2)
					if
						ref.current
						and v10
						and p2 == module2.RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded
					then
						callback()
					end

					if v11 then
						callback2()
					end
				end
			}
		end

		return nil
	end, {})

	local v10 = module.useCallback(function(p2, p3)
		module2.initiateRobloxSubscriptionPurchase(
			nil,
			v9(p2, p3),
			nil,
			module2.SurfaceName.AvatarBackgrounds,
			module2.SurfaceContext.InApp
		)
	end, { v9 })
	local v11

	if fFlagAXBackgroundGenerationAnalytics then
		v11 = module.useCallback(function(p2, p3, p4, p5)
			local guid = HttpService:GenerateGUID(false)
			module4.sendUpsellClick(p2, p3, guid)
			module2.initiateRobloxSubscriptionPurchase(
				nil,
				v9(p4, p5),
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
		end, { v9 })
	else
		v11 = nil
	end

	local function fn()
		return {
			hasActiveSubscription = v6,
			backgroundVariants = v8,
			openSubscriptionPurchase = v10,
			openUpsellSubscriptionPurchase = if fFlagAXBackgroundGenerationAnalytics then v11 else nil
		}
	end

	return module.useMemo(fn, {
		v6,
		v8,
		v10,
		if fFlagAXBackgroundGenerationAnalytics then v11 else nil
	})
end

return useBackgroundsPlusAccess
