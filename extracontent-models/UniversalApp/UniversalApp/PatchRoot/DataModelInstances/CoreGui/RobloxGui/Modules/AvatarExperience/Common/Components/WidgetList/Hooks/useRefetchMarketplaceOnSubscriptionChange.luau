local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local TryOnLookV2 = require(CoreGui.RobloxGui.Modules.AvatarExperience.Common.Thunks.TryOnLookV2)
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local RobloxSubscriptionPurchaseApp = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local ClearReceivedCatalogData = require(Modules.AvatarExperience.Common.Actions.ClearReceivedCatalogData)
local FFlagAXMarketplaceSessionSubscriptionRefetch = AvatarExperienceFlags.FFlagAXMarketplaceSessionSubscriptionRefetch
local FFlagAXSubscriptionRefetchClearCatalogData = AvatarExperienceFlags.FFlagAXSubscriptionRefetchClearCatalogData
local FFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useMarketplaceResultsFetcher = require(script.Parent.useMarketplaceResultsFetcher)
local useMarketplaceResultsFetcherSdui = require(script.Parent.useMarketplaceResultsFetcherSdui)
local useResultsAreSduiEnabled = require(script.Parent.useResultsAreSduiEnabled)
local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function v30(p1) -- line: 63
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function v31(p2) -- line: 67
	return p2.AvatarExperience.AvatarScene.OutfitTryOn
end
local function useRefetchMarketplaceOnSubscriptionChange() -- line: 71
	-- upvalues: RobloxSubscriptionPurchaseApp (copy), useSignalState (copy), useAvatarRoute (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useSelector (copy), v30 (copy), v31 (copy), React (copy), FetchAssetOrBundleInfo (copy), TryOnLookV2 (copy), GetCatalogCategoriesStore (copy), AvatarScreen (copy), useMarketplaceResultsFetcher (copy), FFlagAXMigrateAllTabToSduiDev (copy), useGetSelectedCategoryAndSubcategoryId (copy), useMarketplaceResultsFetcherSdui (copy), Constants (copy), useResultsAreSduiEnabled (copy), FFlagAXSubscriptionRefetchClearCatalogData (copy), FFlagAXSubscriptionRefetchEvictStores (copy), ClearReceivedCatalogData (copy), FFlagAXMarketplaceSessionSubscriptionRefetch (copy)
	local v35 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()
	local v36 = useSignalState(v35.getHasRobloxSubscription)
	local opaque = useAvatarRoute().opaque
	local v38 = if not opaque then nil else opaque.name
	local v39 = if not opaque or not opaque.params then nil else opaque.params.detail
	local v40 = useDispatch()
	local v41 = useRoactService(RoactNetworking)
	local v42 = useRoactService(Analytics)
	local v43 = useSelector(v30)
	local v44 = useSelector(v31)
	local v45 = React.useCallback(function() -- line: 87
		-- upvalues: v43 (copy), v40 (copy), FetchAssetOrBundleInfo (copy), v41 (copy), v42 (copy), v44 (copy), TryOnLookV2 (copy)
		for _, v60 in v43 do
			v40(FetchAssetOrBundleInfo(v41, v42, v60.itemId, v60.itemType, true))
		end

		if v44.LookId then
			v40(TryOnLookV2(v41, nil, {}, v44.LookId, nil, nil, true))
		end

		if v44.MakeupLookId then
			v40(TryOnLookV2(v41, nil, {}, v44.MakeupLookId, nil, nil, true))
		end
	end, {
		v43,
		v41,
		v42,
		v44
	})
	local v46 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v47 = useSignalState(v46.selectedCategoryId)
	local v48 = useSignalState(v46.selectedSubcategoryId)
	local v49 = React.useMemo(function() -- line: 111
		-- upvalues: v38 (copy), AvatarScreen (copy), v39 (copy), v47 (copy), v48 (copy)
		if v38 ~= AvatarScreen.CatalogSearch then
			return nil
		end

		if typeof(v39) ~= "string" or v39 == "" then
			return nil
		end

		return {
			searchUuid = v39,
			categoryId = v47,
			subcategoryId = v48
		}
	end, {
		v38,
		v39,
		v47,
		v48
	})
	local v50 = useMarketplaceResultsFetcher(v49)
	local fetchMarketplace = v50.fetchMarketplace

	if FFlagAXMigrateAllTabToSduiDev then
		local v52, _ = useGetSelectedCategoryAndSubcategoryId()
		local fetchMarketplace2 = useMarketplaceResultsFetcherSdui({
			categoryId = v52 or Constants.DefaultCatalogCategoryId
		}).fetchMarketplace
		local v55 = useResultsAreSduiEnabled()
		local fetchMarketplace3 = v50.fetchMarketplace

		fetchMarketplace = React.useCallback(function() -- line: 145
			-- upvalues: v55 (copy), fetchMarketplace2 (copy), fetchMarketplace3 (copy)
			if v55 and fetchMarketplace2 then
				fetchMarketplace2({
					forceRefresh = true
				})

				return
			end

			fetchMarketplace3()
		end, {
			v55,
			fetchMarketplace3,
			fetchMarketplace2
		})
	end

	local v57 = if not FFlagAXSubscriptionRefetchClearCatalogData then nil else useDispatch()
	local v58 = React.useRef(nil)

	React.useEffect(function() -- line: 161
		-- upvalues: v58 (copy), v36 (copy), FFlagAXSubscriptionRefetchEvictStores (copy), FFlagAXSubscriptionRefetchClearCatalogData (copy), v57 (copy), ClearReceivedCatalogData (copy), fetchMarketplace (ref), v45 (copy)
		local current = v58.current

		v58.current = v36

		if if not FFlagAXSubscriptionRefetchEvictStores then current == false and v36 == true else current ~= nil and current ~= v36 then
			if FFlagAXSubscriptionRefetchClearCatalogData and v57 then
				v57(ClearReceivedCatalogData())
			end

			fetchMarketplace()
			v45()
		end
	end, {
		v36,
		v45
	})

	if FFlagAXMarketplaceSessionSubscriptionRefetch then
		React.useLayoutEffect(function() -- line: 188
			-- upvalues: v35 (copy), FFlagAXSubscriptionRefetchClearCatalogData (copy), v57 (copy), ClearReceivedCatalogData (copy), fetchMarketplace (ref)
			if v35.getGainedRobloxSubscriptionThisSession() then
				if FFlagAXSubscriptionRefetchClearCatalogData and v57 then
					v57(ClearReceivedCatalogData())
				end

				fetchMarketplace()
			end
		end, {})
	end
end

return useRefetchMarketplaceOnSubscriptionChange
