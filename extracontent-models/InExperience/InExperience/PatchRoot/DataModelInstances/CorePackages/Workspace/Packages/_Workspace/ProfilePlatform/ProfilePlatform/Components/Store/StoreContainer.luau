local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Dash = require(ProfilePlatformParent.Dash)
local Constants = require(ProfilePlatform.Common.Constants)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local memoize = require(ProfilePlatformParent.AppCommonLib).memoize
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)

require(ProfilePlatform.Common.AssetInfo)

local FFlagProfilePlatformNavigateToMarketplaceWebView = require(ProfilePlatform.Flags.FFlagProfilePlatformNavigateToMarketplaceWebView)
local Url = require(ProfilePlatformParent.Http).Url
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local GetFIntProfilePlatformMeTabStoreItemLimit = require(ProfilePlatform.Flags.GetFIntProfilePlatformMeTabStoreItemLimit)
local v26 = game:DefineFastInt("ProfilePlatformStoreItemLimit", 3)
local v27 = game:DefineFastFlag("ProfilePlatformHideStoreIfNoAssets", false)
local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v30 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local HttpService = game:GetService("HttpService")
local StoreGrid = require(script.Parent.StoreGrid)
local StoreGridSkeleton = require(script.Parent.StoreGridSkeleton)
local v34 = memoize(function(p1, p2, p3) -- line: 53
	-- upvalues: Enums (copy)
	local t1 = {}
	local n1 = 1

	for _, v42 in p1 do
		local v43 = if v42.itemType ~= Enums.ItemTypes.Bundle then p3[tostring(v42.assetId)] else p2[tostring(v42.assetId)]

		if v43 then
			v43.itemType = v42.itemType
			t1[n1] = v43
			n1 += 1
		end
	end

	return t1
end)

local function StoreContainer(t2: {[any]: any}) -- line: 76
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useDispatch (copy), React (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), useMarketplaceAnalyticsContext (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), Enums (copy), useProfileJsonComponent (copy), Constants (copy), v34 (copy), useSelector (copy), FFlagAXEnableProfileTab (copy), useProfileFormFactor (copy), GetFIntProfilePlatformMeTabStoreItemLimit (copy), v26 (copy), HttpService (copy), FFlagProfilePlatformNavigateToMarketplaceWebView (copy), Url (copy), AppPage (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v30 (copy), NavigateDown (copy), NetworkingCatalog (copy), StoreGridSkeleton (copy), v27 (copy), StoreGrid (copy), Dash (copy)
	local v45 = useProfileWrapperContext()
	local v46 = useProfileAnalyticsContext()
	local v47 = useDispatch()
	local v48, v49 = React.useState(not not FFlagEnableCommunityProfileLoadingSkeletons)
	local v50 = useMarketplaceAnalyticsContext()
	local v51 = React.useCallback(function(s1: string, s2: string, n2: number?) -- line: 85
		-- upvalues: v45 (copy), v46 (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), Enums (copy), v50 (copy)
		v45.navigateTo.itemOrBundleDetails(s1, s2)
		v46.fireAnalyticsEvent(EventNames.CatalogItemOpened, if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
			source = tostring(Enums.Components.Store),
			positionInComponent = tostring(n2),
			component = tostring(Enums.Components.Store),
			itemId = tostring(s1)
		} else {
			btnContext = tostring(Enums.Components.Store),
			btnUnitId = tostring(s1),
			btnSortPosition = tostring(n2)
		})
		v45.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v50, s1, s2, tostring(Enums.Components.Store), n2)
	end, {
		v46,
		v45.navigateTo.itemOrBundleDetails,
		v45.externalAnalytics.catalogAnalytics
	})
	local v52 = useProfileJsonComponent(Enums.Components.Store).assets or {}
	local v53 = React.useCallback(function(p4) -- line: 119
		-- upvalues: Constants (copy), v34 (copy), v52 (copy)
		local v70 = p4[Constants.RODUX_KEY].BundleDetails or {}
		local v71 = p4[Constants.RODUX_KEY].AssetDetails or {}

		return v34(v52, v70, v71)
	end, { v52 })
	local v54 = useSelector(v53)
	local v55 = if not FFlagAXEnableProfileTab then nil else useProfileFormFactor()
	local v56 = if not FFlagAXEnableProfileTab then nil else v45.forceFullView == true
	local v57 = if not FFlagAXEnableProfileTab then nil else v55.formFactor == Enums.ProfileFormFactor.Wide
	local v58 = if not FFlagAXEnableProfileTab or (not v56 or not v57) then v26 else GetFIntProfilePlatformMeTabStoreItemLimit()
	local v59 = (not FFlagAXEnableProfileTab or (not v56 or not v57)) and 3 or 6
	local name = useProfileJsonComponent(Enums.Components.Store).name
	local profileType = v45.profileType
	local profileId = v45.profileId
	local v63 = if profileType ~= Enums.ProfileTypes.Community then name else HttpService:UrlEncode(name)
	local v64 = if not FFlagProfilePlatformNavigateToMarketplaceWebView then nil else React.useCallback(function() -- line: 160
		-- upvalues: v46 (copy), EventNames (copy), profileType (copy), Enums (copy), Url (copy), profileId (copy), v63 (copy), AppPage (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v30 (copy), v47 (copy), NavigateDown (copy)
		v46.fireAnalyticsEvent(EventNames.StoreHeaderButton)

		local v72 = if profileType ~= Enums.ProfileTypes.Community then string.format("%scatalog?CreatorName=%s", Url.BASE_URL, v63) else string.format("%scommunities/%s/CommunityName/#!/store", Url.BASE_URL, profileId)
		local t3 = {
			name = AppPage.GenericWebPage,
			detail = v72,
			extraProps = {
				titleKey = TextKeys.Store
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v30.down(v30.fromLegacyPage(t3))

			return
		end

		v47(NavigateDown(t3))
	end, {
		v46,
		name,
		profileType,
		profileId
	})
	local v65 = React.useCallback(function() -- line: 186
		-- upvalues: v46 (copy), EventNames (copy), v45 (copy), name (copy)
		v46.fireAnalyticsEvent(EventNames.StoreHeaderButton)
		v45.navigateTo.catalogSearch(name)
	end, {
		v45.navigateTo.catalogSearch,
		name,
		v46
	})

	React.useEffect(function() -- line: 198
		-- upvalues: v47 (copy), NetworkingCatalog (copy), v52 (copy), FFlagEnableCommunityProfileLoadingSkeletons (copy), v49 (copy)
		v47(NetworkingCatalog.GetItemAndBundleDetails.API(v52)):catch(function(_) -- line: 199
		end):finally(function() -- line: 199
			-- upvalues: FFlagEnableCommunityProfileLoadingSkeletons (copy), v49 (copy)
			if FFlagEnableCommunityProfileLoadingSkeletons then
				v49(false)
			end
		end)
	end, {
		v52,
		v47
	})

	if FFlagEnableCommunityProfileLoadingSkeletons and v48 then
		return React.createElement(StoreGridSkeleton, {
			layoutOrder = t2.layoutOrder,
			numSkeletons = #v52,
			numColumns = not FFlagAXEnableProfileTab and 3 or v59
		})
	end

	if v27 and #v54 == 0 then
		return nil
	end

	return React.createElement(StoreGrid, {
		layoutOrder = t2.layoutOrder,
		assets = Dash.slice(v54, 1, v58),
		numColumns = not FFlagAXEnableProfileTab and 3 or v59,
		openItemDetails = v51,
		navigateToCatalogSearch = if not FFlagProfilePlatformNavigateToMarketplaceWebView then v65 else v64
	})
end

return StoreContainer
