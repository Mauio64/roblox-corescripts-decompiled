local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local myUserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myUserBlockingNetworking")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useMarketplaceAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useMarketplaceAnalyticsContext")
local AssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AssetsCarousel")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseCatalogItemOpenedNewFields")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local function InventoryContainer(p2)
	local v5 = useProfileWrapperContext()
	local v6 = useProfileAnalyticsContext()
	local profileId = v5.profileId
	local v7 = useDispatch()
	local v8 = useLocalization({ inventory = TextKeys.Inventory })

	local v9 = useMarketplaceAnalyticsContext()

	local v10 = React.useCallback(function(p3, p4, p5, p6, p7)
		v5.navigateTo.itemDetails(p3)
		local fireAnalyticsEvent = v6.fireAnalyticsEvent
		local catalogItemOpened = EventNames.CatalogItemOpened

		local v11 = if FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
			btnContext = tostring(Enums.Components.Inventory),
			btnUnitId = tostring(p3),
			btnSortPosition = tostring(p7)
		} else {
			positionInComponent = tostring(p7),
			component = tostring(Enums.Components.Inventory),
			itemId = tostring(p3)
		}
		fireAnalyticsEvent(catalogItemOpened, v11)

		v5.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(
			v9,
			p3,
			p4,
			Enums.Components.Inventory,
			p7
		)
	end, { v6, v5.navigateTo.itemDetails, v5.externalAnalytics.catalogAnalytics })

	local assets = useProfileJsonComponent(Enums.Components.Inventory).assets or {}

	local v11 = useSelector(function(p3)
		return p3[Constants.RODUX_KEY].AssetDetails or {}
	end)

	local v12 = React.useMemo(function()
		local result = {}

		for k, asset in assets do
			local v13 = v11[tostring(asset.assetId)]

			if not v13 then
				continue
			end

			v13.itemType = asset.itemType
			table.insert(result, v13)
		end

		return result
	end, { assets, v11 })

	local v13 = React.useCallback(function()
		local v14 = {
			name = appPage.GenericWebPage,
			detail = string.format("%susers/%s/inventory", url.BASE_URL, profileId),
			extraProps = { titleKey = TextKeys.Inventory }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v7(navigateDown(v14))
		end
	end)

	React.useEffect(function()
		v7(myUserBlockingNetworking.GetItemAndBundleDetails.API(assets))
	end, { assets, v7 })

	if #v12 > 0 then
		return (React.createElement(AssetsCarousel, {
			title = v8.inventory,
			layoutOrder = p2.layoutOrder,
			assets = v12,
			openItemDetails = v10,
			onActivateHeader = v13
		}))
	end

	return nil
end

return InventoryContainer
