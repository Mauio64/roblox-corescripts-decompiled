local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")

local module4 = require("@luauforge/bundled/dHL")
local module5 = require("@luauforge/bundled/eda")
local module6 = require("@luauforge/bundled/fvF")
local removeFromTryOn = module4.Actions.RemoveFromTryOn
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local module7 = require("@luauforge/deferred/ggD")
local module8 = require("@luauforge/bundled/fuX")
local module9 = require("@luauforge/bundled/fuC")
require("@luauforge/bundled/dMc")
local module10 = require("@luauforge/bundled/ggp")
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface

local fFlagAXFixClickItemDetailsSurfaceLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixClickItemDetailsSurfaceLogging

local checkoutPageContainer = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.Checkout.CheckoutPageContainer

local function selectRobuxFetchInfo(p2)
	local localUserId = p2.LocalUserId
	local v5 = p2.UserRobux[localUserId]
	return { localUserId = p2.LocalUserId, userRobux = v5 }
end

local function CheckoutScreen()
	local v5 = useRoactService(module5)
	local v6 = useRoactService(module6)

	local v7 = useDispatch()
	local v8 = useNavigation()
	local v9 = useAvatarRoute()
	local v10 = useSelector(selectRobuxFetchInfo, getUseSelectorDeepEquals())

	local v11 = React.useCallback(function(p2, p3)
		v7(removeFromTryOn(p2, p3))
	end, { v7, v5, v6 })

	local v12 = React.useCallback(function(p2, p3, p4)
		local v13 = nil

		if p3 == "Asset" then
			v13 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
		elseif p3 == "Bundle" then
			v13 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
		end

		local v15 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			elementName = "CLICK_ITEM_DETAILS",
			itemId = p2,
			itemType = v13,
			surface = 0
		}

		local v16 = if fFlagAXFixClickItemDetailsSurfaceLogging then getUnifiedLoggingSurface(v9) else nil
		v15.surface = v16
		sendUnifiedEventForDeferredAction(v15)

		v7(module7({
			itemId = p2,
			itemType = p3,
			itemSubType = p4,
			catalogAnalytics = v6,
			avatarRoute = v9,
			navigation = v8,
			showFullWithNoPeekView = true
		}))
	end, { v7 })

	local v13 = React.useCallback(function()
		v7(module8(v5, v10.localUserId, true))
	end, { v7, v5, v10 })

	local v14 = React.useCallback(function(p2, p3)
		v7(module9(v5, v6, p2, p3, true))
	end, { v7, v5, v6 })

	return React.createElement(checkoutPageContainer, {
		onRemoveItem = v11,
		onOpenItemDetailsPage = v12,
		fetchUserRobux = v13,
		fetchItemData = v14,
		getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn = module10.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
		getBundleOutfitInfoFromProvidedTryOns = module10.getBundleOutfitInfoFromProvidedTryOns
	})
end

return require("@luauforge/deferred/gmV")(CheckoutScreen)
