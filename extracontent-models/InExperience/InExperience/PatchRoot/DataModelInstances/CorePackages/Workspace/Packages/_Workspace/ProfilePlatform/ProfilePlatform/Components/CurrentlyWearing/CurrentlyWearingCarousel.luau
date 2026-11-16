local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local Constants = require(ProfilePlatform.Common.Constants)
local SortCurrentlyWearing = require(ProfilePlatform.Components.CurrentlyWearing.SortCurrentlyWearing)
local RoactUtils = require(parent.RoactUtils)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local Enums = require(ProfilePlatform.Common.Enums)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local NetworkingCurrentlyWearing = require(ProfilePlatform.Networking.NetworkingCurrentlyWearing)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useMarketplaceAnalyticsContext = require(ProfilePlatform.Hooks.useMarketplaceAnalyticsContext)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(ProfilePlatform.Common.AssetInfo)
local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableInventory = SharedFlags.FFlagProfilePlatformEnableInventory
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableStore = SharedFlags2.FFlagProfilePlatformEnableStore

local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags3.FFlagAddIEMProfilePage
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags4.FFlagAXEnableProfileTab
local FFlagProfileInspectAvatarCWEntry = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarCWEntry)
local GetInspectAvatarTooltipStore = require(ProfilePlatform.Stores.GetInspectAvatarTooltipStore)

local FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 = require(ProfilePlatform.Flags.FFlagSocialEnableProfileInspectAndBuyAnalyticsV2)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local IXPService = game:GetService("IXPService")
local defineFastString = game:DefineFastString(
	"SocialProfileCurrentlyWearingClickThroughLayer",
	"Social.ProfileCurrentlyWearingClickThrough"
)

local SharedFlags5 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = SharedFlags5.FFlagProfilePlatformEnableBundlesInAssetsCarousel

local AssetsCarousel = require(ProfilePlatform.Components.AssetsCarousel)

local function CurrentlyWearingCarousel(p)
	local v = useDispatch()
	local v2 = useProfileWrapperContext()
	local v3 = useProfileAnalyticsContext()
	local v4

	if FFlagProfilePlatformEnableInventory then
		v4 = useLocalization({ currentlyWearing = TextKeys.CurrentlyWearing })
	end

	local v5 = useMarketplaceAnalyticsContext()
	local source

	if FFlagAddIEMProfilePage then
		source = v2.sourceInfo.source
	else
		source = nil
	end

	local v6

	if FFlagProfileInspectAvatarCWEntry then
		v6 = useLocalUserId()
	end

	local v7

	if FFlagProfileInspectAvatarCWEntry then
		v7 = tostring(v2.profileId) == tostring(v6)
	end

	local v8 = FFlagProfileInspectAvatarCWEntry and not v7 and source ~= Enums.Sources.InExperienceProfile
	local v9

	if FFlagProfileInspectAvatarCWEntry then
		v9 = useNavigation()
	else
		v9 = nil
	end

	local onActivateHeader

	if FFlagProfileInspectAvatarCWEntry then
		local useCallback = React.useCallback
		local function fn()
			GetInspectAvatarTooltipStore(false).permanentlyDismiss()

			if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
				v3.fireAnalyticsEvent(EventNames.CurrentlyWearingHeaderButton)
			end

			v9.navigate(Enums.Screens.InspectAvatarSheet)
		end

		local v10

		if FFlagSocialEnableProfileInspectAndBuyAnalyticsV2 then
			v10 = v3
		end

		onActivateHeader = useCallback(fn, { v9, v10 })
	end

	local openItemDetails = React.useCallback(function(p2: string, p3: string, _: string?, _: string?, p4: number?)
		if FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
			v2.navigateTo.inspectAvatar()
			return
		end

		if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
			v2.navigateTo.itemOrBundleDetails(p2, p3)
		else
			v2.navigateTo.itemDetails(p2)
		end

		IXPService:LogFlagLinkedUserLayerExposure(defineFastString)

		if FFlagProfilePlatformEnableStore then
			local fireAnalyticsEvent = v3.fireAnalyticsEvent
			local catalogItemOpened = EventNames.CatalogItemOpened
			local v10

			if FFlagProfilePlatformUseCatalogItemOpenedNewFields then
				v10 = {
					btnContext = tostring(Enums.Components.CurrentlyWearing),
					btnUnitId = tostring(p2),
					btnSortPosition = tostring(p4)
				}
			else
				v10 = {
					source = tostring(Enums.Components.CurrentlyWearing),
					positionInComponent = tostring(p4),
					component = tostring(Enums.Components.CurrentlyWearing),
					itemId = tostring(p2)
				}
			end

			fireAnalyticsEvent(catalogItemOpened, v10)

			v2.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(
				v5,
				p2,
				p3,
				tostring(Enums.Components.CurrentlyWearing),
				p4
			)
		else
			v3.fireAnalyticsEvent(EventNames.CatalogItemOpened)
			v2.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v5, p2, p3)
		end
	end, {
		v2.navigateTo.itemDetails,
		v2.externalAnalytics.catalogAnalytics,
		v2.navigateTo.tryOnItem,
		v2.navigateTo.inspectAvatar,
		source
	})

	local assets = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}
	local v10 = nil
	local assets2 = nil

	if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
		v10 = useSelector((React.useCallback(function(p2)
			local bundleDetails = p2[Constants.RODUX_KEY].BundleDetails or {}
			local assetDetails = p2[Constants.RODUX_KEY].AssetDetails or {}
			local result = {}
			local v11 = 1

			for _, asset in assets do
				local v12

				if asset.itemType == Enums.ItemTypes.Bundle then
					v12 = bundleDetails[tostring(asset.assetId)]
				else
					v12 = assetDetails[tostring(asset.assetId)]
				end

				if not v12 then
					continue
				end

				v12.itemType = asset.itemType
				result[v11] = v12
				v11 += 1
			end

			return result
		end, { assets })))

		React.useEffect(function()
			if #assets > 0 then
				v(NetworkingCatalog.GetItemAndBundleDetails.API(assets))
			end
		end, { assets, v })
	else
		local v11 = React.useMemo(function()
			return Cryo.List.map(assets, function(p2)
				return p2.assetId
			end)
		end, { assets })

		useEffectOnMount(function()
			v(NetworkingCurrentlyWearing.GetItemDetails.API(v11)):andThen(function(_) end):catch(function(_) end)
		end)

		local v12 = useSelector(function(p2)
			return p2[Constants.RODUX_KEY].ItemAssets or {}
		end)

		assets2 = React.useMemo(function()
			local v13 = {}
			local v14 = 1

			for _, v15 in v11 do
				local v16 = v12[tostring(v15)]

				if not v16 then
					continue
				end

				v13[v14] = v16
				v14 += 1
			end

			return Cryo.List.sort(v13, function(p2, p3)
				return SortCurrentlyWearing(p2, p3)
			end)
		end, { v12, v11 })
	end

	if FFlagProfilePlatformEnableBundlesInAssetsCarousel and not (#v10 > 0) then
		return nil
	end

	local createElement = React.createElement
	local title

	if FFlagProfilePlatformEnableInventory then
		title = v4.currentlyWearing
	end

	local v11 = {
		title = title,
		layoutOrder = p.layoutOrder,
		assets = 0,
		openItemDetails = 0,
		onActivateHeader = 0,
		tileVariant = 0
	}

	if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
		assets2 = v10
	end

	v11.assets = assets2
	v11.openItemDetails = openItemDetails

	if not v8 then
		onActivateHeader = nil
	end

	v11.onActivateHeader = onActivateHeader
	local tileVariant

	if FFlagAXEnableProfileTab then
		tileVariant = v2.currentlyWearingVariant
	end

	v11.tileVariant = tileVariant
	return (createElement(AssetsCarousel, v11))
end

return CurrentlyWearingCarousel
