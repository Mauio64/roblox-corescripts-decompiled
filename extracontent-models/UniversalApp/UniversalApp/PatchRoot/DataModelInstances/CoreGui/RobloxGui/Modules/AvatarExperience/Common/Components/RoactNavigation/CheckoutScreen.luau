local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RemoveFromTryOn = AvatarExperienceRodux.Actions.RemoveFromTryOn
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)

require(Modules.AvatarExperience.Common.Types)

local CharacterManagerUtils = require(Modules.AvatarExperience.Common.Util.CharacterManagerUtils)
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.getUnifiedLoggingSurface
local FFlagAXFixClickItemDetailsSurfaceLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXFixClickItemDetailsSurfaceLogging
local CheckoutPageContainer = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Components.Checkout.CheckoutPageContainer

local function selectRobuxFetchInfo(p1) -- line: 39
	local LocalUserId = p1.LocalUserId
	local v31 = p1.UserRobux[LocalUserId]

	return {
		localUserId = p1.LocalUserId,
		userRobux = v31
	}
end
local function CheckoutScreen() -- line: 45
	-- upvalues: useRoactService (copy), RoactNetworking (copy), Analytics (copy), useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useSelector (copy), selectRobuxFetchInfo (copy), getUseSelectorDeepEquals (copy), React (copy), RemoveFromTryOn (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), getUnifiedLoggingSurface (copy), OpenItemDetails (copy), ApiFetchEconomyCurrency (copy), FetchAssetOrBundleInfo (copy), CheckoutPageContainer (copy), CharacterManagerUtils (copy)
	local v32 = useRoactService(RoactNetworking)
	local v33 = useRoactService(Analytics)
	local v34 = useDispatch()
	local v35 = useNavigation()
	local v36 = useAvatarRoute()
	local v37 = useSelector(selectRobuxFetchInfo, getUseSelectorDeepEquals())
	local v38 = React.useCallback(function(s1: string, s2: string) -- line: 54
		-- upvalues: v34 (copy), RemoveFromTryOn (copy)
		v34(RemoveFromTryOn(s1, s2))
	end, {
		v34,
		v32,
		v33
	})
	local v39 = React.useCallback(function(s3: string, s4: string, s5: string) -- line: 58
		-- upvalues: UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), FFlagAXFixClickItemDetailsSurfaceLogging (copy), getUnifiedLoggingSurface (copy), v36 (copy), v34 (copy), OpenItemDetails (copy), v33 (copy), v35 (copy)
		local ASSET = nil

		if s4 == "Asset" then
			ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
		elseif s4 == "Bundle" then
			ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
		end

		sendUnifiedEventForDeferredAction({
			elementName = "CLICK_ITEM_DETAILS",
			action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
			itemId = s3,
			itemType = ASSET,
			surface = if not FFlagAXFixClickItemDetailsSurfaceLogging then nil else getUnifiedLoggingSurface(v36)
		})
		v34(OpenItemDetails({
			showFullWithNoPeekView = true,
			itemId = s3,
			itemType = s4,
			itemSubType = s5,
			catalogAnalytics = v33,
			avatarRoute = v36,
			navigation = v35
		}))
	end, { v34 })
	local v40 = React.useCallback(function() -- line: 85
		-- upvalues: v34 (copy), ApiFetchEconomyCurrency (copy), v32 (copy), v37 (copy)
		v34(ApiFetchEconomyCurrency(v32, v37.localUserId, true))
	end, {
		v34,
		v32,
		v37
	})
	local v41 = React.useCallback(function(s6: string, s7: string) -- line: 89
		-- upvalues: v34 (copy), FetchAssetOrBundleInfo (copy), v32 (copy), v33 (copy)
		v34(FetchAssetOrBundleInfo(v32, v33, s6, s7, true))
	end, {
		v34,
		v32,
		v33
	})

	return React.createElement(CheckoutPageContainer, {
		onRemoveItem = v38,
		onOpenItemDetailsPage = v39,
		fetchUserRobux = v40,
		fetchItemData = v41,
		getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn = CharacterManagerUtils.getCombinedHumanoidDescriptionFromEquippedAndOutfitTryOn,
		getBundleOutfitInfoFromProvidedTryOns = CharacterManagerUtils.getBundleOutfitInfoFromProvidedTryOns
	})
end

return require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)(CheckoutScreen)
