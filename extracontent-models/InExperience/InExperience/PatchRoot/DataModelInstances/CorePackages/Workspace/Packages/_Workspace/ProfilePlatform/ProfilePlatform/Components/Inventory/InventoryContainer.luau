local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Constants = require(ProfilePlatform.Common.Constants)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local Url = require(ProfilePlatformParent.Http).Url
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)
local AssetsCarousel = require(ProfilePlatform.Components.AssetsCarousel)

require(ProfilePlatform.Common.AssetInfo)

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function InventoryContainer(t1: {[any]: any}) -- line: 38
	-- upvalues: useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useDispatch (copy), useLocalization (copy), TextKeys (copy), useMarketplaceAnalyticsContext (copy), React (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), Enums (copy), useProfileJsonComponent (copy), useSelector (copy), Constants (copy), AppPage (copy), Url (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy), NetworkingCatalog (copy), AssetsCarousel (copy)
	local v26 = useProfileWrapperContext()
	local v27 = useProfileAnalyticsContext()
	local profileId = v26.profileId
	local v29 = useDispatch()
	local v30 = useLocalization({
		inventory = TextKeys.Inventory
	})
	local v31 = useMarketplaceAnalyticsContext()
	local v32 = React.useCallback(function(s1: string, s2: string, _: string?, _: string?, n1: number?) -- line: 50
		-- upvalues: v26 (copy), v27 (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), Enums (copy), v31 (copy)
		v26.navigateTo.itemDetails(s1)
		v27.fireAnalyticsEvent(EventNames.CatalogItemOpened, if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
			positionInComponent = tostring(n1),
			component = tostring(Enums.Components.Inventory),
			itemId = tostring(s1)
		} else {
			btnContext = tostring(Enums.Components.Inventory),
			btnUnitId = tostring(s1),
			btnSortPosition = tostring(n1)
		})
		v26.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v31, s1, s2, Enums.Components.Inventory, n1)
	end, {
		v27,
		v26.navigateTo.itemDetails,
		v26.externalAnalytics.catalogAnalytics
	})
	local v33 = useProfileJsonComponent(Enums.Components.Inventory).assets or {}
	local v34 = useSelector(function(p1) -- line: 83
		-- upvalues: Constants (copy)
		return p1[Constants.RODUX_KEY].AssetDetails or {}
	end)
	local v35 = React.useMemo(function() -- line: 87
		-- upvalues: v33 (copy), v34 (copy)
		local t2 = {}

		for _, v45 in v33 do
			local v46 = v34[tostring(v45.assetId)]

			if v46 then
				v46.itemType = v45.itemType
				table.insert(t2, v46)
			end
		end

		return t2
	end, {
		v33,
		v34
	})
	local v36 = React.useCallback(function() -- line: 100
		-- upvalues: AppPage (copy), Url (copy), profileId (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), v29 (copy), NavigateDown (copy)
		local t3 = {
			name = AppPage.GenericWebPage,
			detail = string.format("%susers/%s/inventory", Url.BASE_URL, profileId),
			extraProps = {
				titleKey = TextKeys.Inventory
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v23.down(v23.fromLegacyPage(t3))

			return
		end

		v29(NavigateDown(t3))
	end)

	React.useEffect(function() -- line: 115
		-- upvalues: v29 (copy), NetworkingCatalog (copy), v33 (copy)
		v29(NetworkingCatalog.GetItemAndBundleDetails.API(v33))
	end, {
		v33,
		v29
	})

	if #v35 > 0 then
		return (React.createElement(AssetsCarousel, {
			title = v30.inventory,
			layoutOrder = t1.layoutOrder,
			assets = v35,
			openItemDetails = v32,
			onActivateHeader = v36
		}))
	end

	return nil
end

return InventoryContainer
