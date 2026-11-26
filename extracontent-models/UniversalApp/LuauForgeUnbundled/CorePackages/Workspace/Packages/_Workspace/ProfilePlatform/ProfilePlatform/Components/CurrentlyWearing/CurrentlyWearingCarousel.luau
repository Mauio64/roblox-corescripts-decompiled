local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local SortCurrentlyWearing = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CurrentlyWearing/SortCurrentlyWearing")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local NetworkingCurrentlyWearing = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/NetworkingCurrentlyWearing")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useMarketplaceAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useMarketplaceAnalyticsContext")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")
local myUserBlockingNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myUserBlockingNetworking")
local fFlagProfilePlatformEnableInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableInventory
local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableStore

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseCatalogItemOpenedNewFields")
local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddIEMProfilePage
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local FFlagProfileInspectAvatarCWEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAvatarCWEntry")
local GetInspectAvatarTooltipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Stores/GetInspectAvatarTooltipStore")

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagSocialEnableProfileInspectAndBuyAnalyticsV2")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local IXPService = game:GetService("IXPService")
local defineFastString = game:DefineFastString(
	"SocialProfileCurrentlyWearingClickThroughLayer",
	"Social.ProfileCurrentlyWearingClickThrough"
)

local fFlagProfilePlatformEnableBundlesInAssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableBundlesInAssetsCarousel

local AssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AssetsCarousel")

local function CurrentlyWearingCarousel(p2)
	local v5 = useDispatch()
	local v6 = useProfileWrapperContext()
	local v7 = useProfileAnalyticsContext()
	local v8

	if fFlagProfilePlatformEnableInventory then
		v8 = useLocalization({ currentlyWearing = TextKeys.CurrentlyWearing })
	end

	local v9 = useMarketplaceAnalyticsContext()

	local source = if fFlagAddIEMProfilePage then v6.sourceInfo.source else nil

	local v10 = if FFlagProfileInspectAvatarCWEntry then useLocalUserId() else nil

	local v11 = if FFlagProfileInspectAvatarCWEntry then tostring(v6.profileId) == tostring(v10) else nil

	local v12 = FFlagProfileInspectAvatarCWEntry and not v11 and source ~= Enums.Sources.InExperienceProfile

	local v13 = if FFlagProfileInspectAvatarCWEntry then useNavigation() else nil
	local v14

	if FFlagProfileInspectAvatarCWEntry then
		local function fn()
			GetInspectAvatarTooltipStore(false).permanentlyDismiss()

			if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
				v7.fireAnalyticsEvent(EventNames.CurrentlyWearingHeaderButton)
			end

			v13.navigate(Enums.Screens.InspectAvatarSheet)
		end

		v14 = React.useCallback(fn, { v13, if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then v7 else nil })
	end

	local v15 = React.useCallback(function(p3, p4, p5, p6, p7)
		if fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
			v6.navigateTo.inspectAvatar()
			return
		end

		if fFlagProfilePlatformEnableBundlesInAssetsCarousel then
			v6.navigateTo.itemOrBundleDetails(p3, p4)
		else
			v6.navigateTo.itemDetails(p3)
		end

		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)

		if fFlagProfilePlatformEnableStore then
			local fireAnalyticsEvent = v7.fireAnalyticsEvent
			local catalogItemOpened = EventNames.CatalogItemOpened

			local v16 = if FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
				btnContext = tostring(Enums.Components.CurrentlyWearing),
				btnUnitId = tostring(p3),
				btnSortPosition = tostring(p7)
			} else {
				source = tostring(Enums.Components.CurrentlyWearing),
				positionInComponent = tostring(p7),
				component = tostring(Enums.Components.CurrentlyWearing),
				itemId = tostring(p3)
			}
			fireAnalyticsEvent(catalogItemOpened, v16)

			v6.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(
				v9,
				p3,
				p4,
				tostring(Enums.Components.CurrentlyWearing),
				p7
			)
		else
			v7.fireAnalyticsEvent(EventNames.CatalogItemOpened)
			v6.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v9, p3, p4)
		end
	end, {
		v6.navigateTo.itemDetails,
		v6.externalAnalytics.catalogAnalytics,
		v6.navigateTo.tryOnItem,
		v6.navigateTo.inspectAvatar,
		source
	})

	local assets = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}
	local v16 = nil
	local v17 = nil

	if fFlagProfilePlatformEnableBundlesInAssetsCarousel then
		v16 = useSelector((React.useCallback(function(p3)
			local bundleDetails = p3[Constants.RODUX_KEY].BundleDetails or {}
			local assetDetails = p3[Constants.RODUX_KEY].AssetDetails or {}
			local result = {}
			local v19 = 1

			for k, asset in assets do
				local v20

				if asset.itemType == Enums.ItemTypes.Bundle then
					v20 = bundleDetails[tostring(asset.assetId)]
				else
					v20 = assetDetails[tostring(asset.assetId)]
				end

				if not v20 then
					continue
				end

				v20.itemType = asset.itemType
				result[v19] = v20
				v19 += 1
			end

			return result
		end, { assets })))

		React.useEffect(function()
			if #assets > 0 then
				v5(myUserBlockingNetworking.GetItemAndBundleDetails.API(assets))
			end
		end, { assets, v5 })
	else
		local v18 = React.useMemo(function()
			return Cryo.List.map(assets, function(p3)
				return p3.assetId
			end)
		end, { assets })

		useEffectOnMount(function()
			v5(NetworkingCurrentlyWearing.GetItemDetails.API(v18)):andThen(function(p3) end):catch(function(p3) end)
		end)

		local v19 = useSelector(function(p3)
			return p3[Constants.RODUX_KEY].ItemAssets or {}
		end)

		v17 = React.useMemo(function()
			local v20 = {}
			local v21 = 1

			for k, v22 in v18 do
				local v23 = v19[tostring(v22)]

				if not v23 then
					continue
				end

				v20[v21] = v23
				v21 += 1
			end

			return Cryo.List.sort(v20, function(p3, p4)
				return SortCurrentlyWearing(p3, p4)
			end)
		end, { v19, v18 })
	end

	if fFlagProfilePlatformEnableBundlesInAssetsCarousel and not (#v16 > 0) then
		return nil
	end

	local createElement = React.createElement
	local v20 = if fFlagProfilePlatformEnableInventory then v8.currentlyWearing else nil
	local v19 = {
		title = v20,
		layoutOrder = p2.layoutOrder,
		assets = 0,
		openItemDetails = 0,
		onActivateHeader = 0,
		tileVariant = 0
	}

	if fFlagProfilePlatformEnableBundlesInAssetsCarousel then
		v17 = v16
	end

	v19.assets = v17
	v19.openItemDetails = v15

	if not v12 then
		v14 = nil
	end

	v19.onActivateHeader = v14

	local v21 = if fFlagAXEnableProfileTab then v6.currentlyWearingVariant else nil
	v19.tileVariant = v21
	return (createElement(AssetsCarousel, v19))
end

return CurrentlyWearingCarousel
