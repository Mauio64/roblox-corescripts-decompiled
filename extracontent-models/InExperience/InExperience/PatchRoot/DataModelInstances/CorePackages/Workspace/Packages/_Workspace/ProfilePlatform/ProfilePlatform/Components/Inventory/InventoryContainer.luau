local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Constants = require(ProfilePlatform.Common.Constants)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Http = require(parent.Http)
local Url = Http.Url
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)
local AssetsCarousel = require(ProfilePlatform.Components.AssetsCarousel)
require(ProfilePlatform.Common.AssetInfo)

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function InventoryContainer(p)
	local v = useProfileWrapperContext()
	local v2 = useProfileAnalyticsContext()
	local profileId = v.profileId
	local v3 = useDispatch()
	local v4 = useLocalization({ inventory = TextKeys.Inventory })

	local v5 = useMarketplaceAnalyticsContext()

	local openItemDetails = React.useCallback(function(p2: string, p3: string, _: string?, _: string?, p4: number?)
		v.navigateTo.itemDetails(p2)
		local fireAnalyticsEvent = v2.fireAnalyticsEvent
		local catalogItemOpened = EventNames.CatalogItemOpened
		local v6

		if FFlagProfilePlatformUseCatalogItemOpenedNewFields then
			v6 = {
				btnContext = tostring(Enums.Components.Inventory),
				btnUnitId = tostring(p2),
				btnSortPosition = tostring(p4)
			}
		else
			v6 = {
				positionInComponent = tostring(p4),
				component = tostring(Enums.Components.Inventory),
				itemId = tostring(p2)
			}
		end

		fireAnalyticsEvent(catalogItemOpened, v6)

		v.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v5, p2, p3, Enums.Components.Inventory, p4)
	end, { v2, v.navigateTo.itemDetails, v.externalAnalytics.catalogAnalytics })

	local assets = useProfileJsonComponent(Enums.Components.Inventory).assets or {}

	local v6 = useSelector(function(p2)
		return p2[Constants.RODUX_KEY].AssetDetails or {}
	end)

	local assets2 = React.useMemo(function()
		local result = {}

		for _, asset in assets do
			local v7 = v6[tostring(asset.assetId)]

			if not v7 then
				continue
			end

			v7.itemType = asset.itemType
			table.insert(result, v7)
		end

		return result
	end, { assets, v6 })

	local onActivateHeader = React.useCallback(function()
		local v7 = {
			name = AppPage.GenericWebPage,
			detail = string.format("%susers/%s/inventory", Url.BASE_URL, profileId),
			extraProps = { titleKey = TextKeys.Inventory }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v3(NavigateDown(v7))
		end
	end)

	React.useEffect(function()
		v3(NetworkingCatalog.GetItemAndBundleDetails.API(assets))
	end, { assets, v3 })

	if #assets2 > 0 then
		return (React.createElement(AssetsCarousel, {
			title = v4.inventory,
			layoutOrder = p.layoutOrder,
			assets = assets2,
			openItemDetails = openItemDetails,
			onActivateHeader = onActivateHeader
		}))
	end

	return nil
end

return InventoryContainer
