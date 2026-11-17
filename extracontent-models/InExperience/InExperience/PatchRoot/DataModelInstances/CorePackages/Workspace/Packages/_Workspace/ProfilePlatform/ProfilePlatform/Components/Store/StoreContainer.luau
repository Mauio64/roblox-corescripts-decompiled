local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Dash = require(parent.Dash)
local Constants = require(ProfilePlatform.Common.Constants)
local RoactUtils = require(parent.RoactUtils)
local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize

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
local Http = require(parent.Http)
local Url = Http.Url
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

local GetFIntProfilePlatformMeTabStoreItemLimit = require(ProfilePlatform.Flags.GetFIntProfilePlatformMeTabStoreItemLimit)
local defineFastInt = game:DefineFastInt("ProfilePlatformStoreItemLimit", 3)

local defineFastFlag = game:DefineFastFlag("ProfilePlatformHideStoreIfNoAssets", false)

local FFlagEnableCommunityProfileLoadingSkeletons = require(ProfilePlatform.Flags.FFlagEnableCommunityProfileLoadingSkeletons)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local HttpService = game:GetService("HttpService")

local StoreGrid = require(script.Parent.StoreGrid)
local StoreGridSkeleton = require(script.Parent.StoreGridSkeleton)
local v = memoize(function(items, p, p2)
	local result = {}
	local v = 1

	for _, item in items do
		local v2

		if item.itemType == Enums.ItemTypes.Bundle then
			v2 = p[tostring(item.assetId)]
		else
			v2 = p2[tostring(item.assetId)]
		end

		if not v2 then
			continue
		end

		v2.itemType = item.itemType
		result[v] = v2
		v += 1
	end

	return result
end)

local function StoreContainer(p)
	local v2 = useProfileWrapperContext()
	local v3 = useProfileAnalyticsContext()
	local v4 = useDispatch()
	local state, setState = React.useState(FFlagEnableCommunityProfileLoadingSkeletons and true or false)

	local v5 = useMarketplaceAnalyticsContext()

	local openItemDetails = React.useCallback(function(p2: string, p3: string, p4: number?)
		v2.navigateTo.itemOrBundleDetails(p2, p3)
		local fireAnalyticsEvent = v3.fireAnalyticsEvent
		local catalogItemOpened = EventNames.CatalogItemOpened
		local v6

		if FFlagProfilePlatformUseCatalogItemOpenedNewFields then
			v6 = {
				btnContext = tostring(Enums.Components.Store),
				btnUnitId = tostring(p2),
				btnSortPosition = tostring(p4)
			}
		else
			v6 = {
				source = tostring(Enums.Components.Store),
				positionInComponent = tostring(p4),
				component = tostring(Enums.Components.Store),
				itemId = tostring(p2)
			}
		end

		fireAnalyticsEvent(catalogItemOpened, v6)

		v2.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(
			v5,
			p2,
			p3,
			tostring(Enums.Components.Store),
			p4
		)
	end, { v3, v2.navigateTo.itemOrBundleDetails, v2.externalAnalytics.catalogAnalytics })

	local assets = useProfileJsonComponent(Enums.Components.Store).assets or {}

	local v6 = useSelector((React.useCallback(function(p2)
		local bundleDetails = p2[Constants.RODUX_KEY].BundleDetails or {}
		local assetDetails = p2[Constants.RODUX_KEY].AssetDetails or {}
		return v(assets, bundleDetails, assetDetails)
	end, { assets })))
	local v7

	if FFlagAXEnableProfileTab then
		v7 = useProfileFormFactor()
	end

	local v8

	if FFlagAXEnableProfileTab then
		v8 = v2.forceFullView == true
	end

	local v9

	if FFlagAXEnableProfileTab then
		v9 = v7.formFactor == Enums.ProfileFormFactor.Wide
	end

	local v10

	if FFlagAXEnableProfileTab and v8 and v9 then
		v10 = GetFIntProfilePlatformMeTabStoreItemLimit()
	else
		v10 = defineFastInt
	end

	local v11 = FFlagAXEnableProfileTab and v8 and v9 and 6 or 3
	local name = useProfileJsonComponent(Enums.Components.Store).name

	local profileType = v2.profileType
	local profileId = v2.profileId
	local v12

	if profileType == Enums.ProfileTypes.Community then
		v12 = HttpService:UrlEncode(name)
	else
		v12 = name
	end

	local navigateToCatalogSearch

	if FFlagProfilePlatformNavigateToMarketplaceWebView then
		navigateToCatalogSearch = React.useCallback(function()
			v3.fireAnalyticsEvent(EventNames.StoreHeaderButton)
			local detail

			if profileType == Enums.ProfileTypes.Community then
				detail = string.format("%scommunities/%s/CommunityName/#!/store", Url.BASE_URL, profileId)
			else
				detail = string.format("%scatalog?CreatorName=%s", Url.BASE_URL, v12)
			end

			local v13 = {
				name = AppPage.GenericWebPage,
				detail = detail,
				extraProps = { titleKey = TextKeys.Store }
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v13))
			else
				v4(NavigateDown(v13))
			end
		end, { v3, name, profileType, profileId })
	end

	local v13 = React.useCallback(function()
		v3.fireAnalyticsEvent(EventNames.StoreHeaderButton)

		v2.navigateTo.catalogSearch(name)
	end, { v2.navigateTo.catalogSearch, name, v3 })

	React.useEffect(function()
		v4(NetworkingCatalog.GetItemAndBundleDetails.API(assets)):catch(function(_) end):finally(function()
			if FFlagEnableCommunityProfileLoadingSkeletons then
				setState(false)
			end
		end)
	end, { assets, v4 })

	if FFlagEnableCommunityProfileLoadingSkeletons and state then
		return React.createElement(StoreGridSkeleton, {
			layoutOrder = p.layoutOrder,
			numSkeletons = #assets,
			numColumns = not FFlagAXEnableProfileTab and 3 or v11
		})
	end

	if defineFastFlag and #v6 == 0 then
		return nil
	end

	local createElement = React.createElement
	local v14 = {
		layoutOrder = p.layoutOrder,
		assets = Dash.slice(v6, 1, v10),
		numColumns = not FFlagAXEnableProfileTab and 3 or v11,
		openItemDetails = openItemDetails,
		navigateToCatalogSearch = 0
	}

	if not FFlagProfilePlatformNavigateToMarketplaceWebView then
		navigateToCatalogSearch = v13
	end

	v14.navigateToCatalogSearch = navigateToCatalogSearch
	return createElement(StoreGrid, v14)
end

return StoreContainer
