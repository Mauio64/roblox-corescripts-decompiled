local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppCommonLib").memoize

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local myUserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myUserBlockingNetworking")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useMarketplaceAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useMarketplaceAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")

local FFlagProfilePlatformNavigateToMarketplaceWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformNavigateToMarketplaceWebView")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseCatalogItemOpenedNewFields")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab

local GetFIntProfilePlatformMeTabStoreItemLimit = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/GetFIntProfilePlatformMeTabStoreItemLimit")
local defineFastInt = game:DefineFastInt("ProfilePlatformStoreItemLimit", 3)

local defineFastFlag = game:DefineFastFlag("ProfilePlatformHideStoreIfNoAssets", false)

local FFlagEnableCommunityProfileLoadingSkeletons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityProfileLoadingSkeletons")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local HttpService = game:GetService("HttpService")

local StoreGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Store/StoreGrid")
local StoreGridSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Store/StoreGridSkeleton")
local v5 = memoize(function(items, p2, p3)
	local result = {}
	local v6 = 1

	for k, item in items do
		local v7

		if item.itemType == Enums.ItemTypes.Bundle then
			v7 = p2[tostring(item.assetId)]
		else
			v7 = p3[tostring(item.assetId)]
		end

		if not v7 then
			continue
		end

		v7.itemType = item.itemType
		result[v6] = v7
		v6 += 1
	end

	return result
end)

local function StoreContainer(p2)
	local v6 = useProfileWrapperContext()
	local v7 = useProfileAnalyticsContext()
	local v8 = useDispatch()
	local state, setState = React.useState(FFlagEnableCommunityProfileLoadingSkeletons and true or false)

	local v9 = useMarketplaceAnalyticsContext()

	local v10 = React.useCallback(function(p3, p4, p5)
		v6.navigateTo.itemOrBundleDetails(p3, p4)
		local fireAnalyticsEvent = v7.fireAnalyticsEvent
		local catalogItemOpened = EventNames.CatalogItemOpened

		local v11 = if FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
			btnContext = tostring(Enums.Components.Store),
			btnUnitId = tostring(p3),
			btnSortPosition = tostring(p5)
		} else {
			source = tostring(Enums.Components.Store),
			positionInComponent = tostring(p5),
			component = tostring(Enums.Components.Store),
			itemId = tostring(p3)
		}
		fireAnalyticsEvent(catalogItemOpened, v11)

		v6.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(
			v9,
			p3,
			p4,
			tostring(Enums.Components.Store),
			p5
		)
	end, { v7, v6.navigateTo.itemOrBundleDetails, v6.externalAnalytics.catalogAnalytics })

	local assets = useProfileJsonComponent(Enums.Components.Store).assets or {}

	local v12 = useSelector((React.useCallback(function(p3)
		local bundleDetails = p3[Constants.RODUX_KEY].BundleDetails or {}
		local assetDetails = p3[Constants.RODUX_KEY].AssetDetails or {}
		return v5(assets, bundleDetails, assetDetails)
	end, { assets })))

	local v13 = if fFlagAXEnableProfileTab then useProfileFormFactor() else nil

	local v14 = if fFlagAXEnableProfileTab then v6.forceFullView == true else nil

	local v15 = if fFlagAXEnableProfileTab then v13.formFactor == Enums.ProfileFormFactor.Wide else nil

	local v16 = if fFlagAXEnableProfileTab and v14 and v15 then GetFIntProfilePlatformMeTabStoreItemLimit() else defineFastInt
	local v17 = fFlagAXEnableProfileTab and v14 and v15 and 6 or 3
	local name = useProfileJsonComponent(Enums.Components.Store).name

	local profileType = v6.profileType
	local profileId = v6.profileId
	local v18

	if profileType == Enums.ProfileTypes.Community then
		v18 = HttpService:UrlEncode(name)
	else
		v18 = name
	end

	local v19

	if FFlagProfilePlatformNavigateToMarketplaceWebView then
		v19 = React.useCallback(function()
			v7.fireAnalyticsEvent(EventNames.StoreHeaderButton)

			local v20 = if profileType == Enums.ProfileTypes.Community then string.format(
				"%scommunities/%s/CommunityName/#!/store",
				url.BASE_URL,
				profileId
			) else string.format("%scatalog?CreatorName=%s", url.BASE_URL, v18)

			local v21 = {
				name = appPage.GenericWebPage,
				detail = v20,
				extraProps = { titleKey = TextKeys.Store }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v21))
			else
				v8(navigateDown(v21))
			end
		end, { v7, name, profileType, profileId })
	end

	local v20 = React.useCallback(function()
		v7.fireAnalyticsEvent(EventNames.StoreHeaderButton)

		v6.navigateTo.catalogSearch(name)
	end, { v6.navigateTo.catalogSearch, name, v7 })

	React.useEffect(function()
		v8(myUserBlockingNetworking.GetItemAndBundleDetails.API(assets)):catch(function(p3) end):finally(function()
			if FFlagEnableCommunityProfileLoadingSkeletons then
				setState(false)
			end
		end)
	end, { assets, v8 })

	if FFlagEnableCommunityProfileLoadingSkeletons and state then
		return React.createElement(StoreGridSkeleton, {
			layoutOrder = p2.layoutOrder,
			numSkeletons = #assets,
			numColumns = not fFlagAXEnableProfileTab and 3 or v17
		})
	end

	if defineFastFlag and #v12 == 0 then
		return nil
	end

	local createElement = React.createElement
	local v22 = {
		layoutOrder = p2.layoutOrder,
		assets = Dash.slice(v12, 1, v16),
		numColumns = not fFlagAXEnableProfileTab and 3 or v17,
		openItemDetails = v10,
		navigateToCatalogSearch = 0
	}

	if not FFlagProfilePlatformNavigateToMarketplaceWebView then
		v19 = v20
	end

	v22.navigateToCatalogSearch = v19
	return createElement(StoreGrid, v22)
end

return StoreContainer
