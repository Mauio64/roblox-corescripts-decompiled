local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Cryo = require(ProfilePlatformParent.Cryo)
local Constants = require(ProfilePlatform.Common.Constants)
local SortCurrentlyWearing = require(ProfilePlatform.Components.CurrentlyWearing.SortCurrentlyWearing)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
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
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization

require(ProfilePlatform.Common.AssetInfo)

local NetworkingCatalog = require(ProfilePlatform.Networking.NetworkingCatalog)
local FFlagProfilePlatformEnableInventory = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableInventory
local FFlagProfilePlatformEnableStore = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagProfilePlatformUseCatalogItemOpenedNewFields = require(ProfilePlatform.Flags.FFlagProfilePlatformUseCatalogItemOpenedNewFields)
local FFlagAddIEMProfilePage = require(ProfilePlatformParent.SharedFlags).FFlagAddIEMProfilePage
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagProfileInspectAvatarCWEntry = require(ProfilePlatform.Flags.FFlagProfileInspectAvatarCWEntry)
local FFlagProfileInspectAndBuyRefactorTooltip = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyRefactorTooltip)
local GetInspectAvatarTooltipStore = require(ProfilePlatform.Stores.GetInspectAvatarTooltipStore)
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local IXPService = game:GetService("IXPService")
local v32 = game:DefineFastString("SocialProfileCurrentlyWearingClickThroughLayer", "Social.ProfileCurrentlyWearingClickThrough")
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableBundlesInAssetsCarousel
local AssetsCarousel = require(ProfilePlatform.Components.AssetsCarousel)

local function CurrentlyWearingCarousel(t1: {[any]: any}) -- line: 52
	-- upvalues: useDispatch (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformEnableInventory (copy), useLocalization (copy), TextKeys (copy), useMarketplaceAnalyticsContext (copy), FFlagAddIEMProfilePage (copy), FFlagProfileInspectAvatarCWEntry (copy), useLocalUserId (copy), Enums (copy), useNavigation (copy), React (copy), FFlagProfileInspectAndBuyRefactorTooltip (copy), GetInspectAvatarTooltipStore (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), IXPService (copy), v32 (copy), FFlagProfilePlatformEnableStore (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), useProfileJsonComponent (copy), Constants (copy), useSelector (copy), NetworkingCatalog (copy), Cryo (copy), useEffectOnMount (copy), NetworkingCurrentlyWearing (copy), SortCurrentlyWearing (copy), AssetsCarousel (copy), FFlagAXEnableProfileTab (copy)
	local v37 = useDispatch()
	local v38 = useProfileWrapperContext()
	local v39 = useProfileAnalyticsContext()
	local v40 = if not FFlagProfilePlatformEnableInventory then nil else useLocalization({
		currentlyWearing = TextKeys.CurrentlyWearing
	})
	local v41 = useMarketplaceAnalyticsContext()
	local v42 = if not FFlagAddIEMProfilePage then nil else v38.sourceInfo.source
	local v43 = if not FFlagProfileInspectAvatarCWEntry then nil else useLocalUserId()
	local v44 = if not FFlagProfileInspectAvatarCWEntry then nil else tostring(v38.profileId) == tostring(v43)
	local v45 = FFlagProfileInspectAvatarCWEntry and (not v44 and v42 ~= Enums.Sources.InExperienceProfile)
	local v46 = if not FFlagProfileInspectAvatarCWEntry then nil else useNavigation()
	local v47 = if not FFlagProfileInspectAvatarCWEntry then nil else React.useCallback(function() -- line: 76
		-- upvalues: FFlagProfileInspectAndBuyRefactorTooltip (copy), GetInspectAvatarTooltipStore (copy), v46 (copy), Enums (copy)
		if FFlagProfileInspectAndBuyRefactorTooltip then
			GetInspectAvatarTooltipStore(false).permanentlyDismiss()
		end

		v46.navigate(Enums.Screens.InspectAvatarSheet)
	end, { v46 })
	local v48 = React.useCallback(function(s1: string, s2: string, _: string?, _: string?, n1: number?) -- line: 85
		-- upvalues: FFlagAddIEMProfilePage (copy), v42 (copy), Enums (copy), v38 (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), IXPService (copy), v32 (copy), FFlagProfilePlatformEnableStore (copy), v39 (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), v41 (copy)
		if FFlagAddIEMProfilePage and v42 == Enums.Sources.InExperienceProfile then
			v38.navigateTo.inspectAvatar()

			return
		end

		if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
			v38.navigateTo.itemOrBundleDetails(s1, s2)
		else
			v38.navigateTo.itemDetails(s1)
		end

		IXPService:LogFlagLinkedUserLayerExposure(v32)

		if FFlagProfilePlatformEnableStore then
			v39.fireAnalyticsEvent(EventNames.CatalogItemOpened, if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
				source = tostring(Enums.Components.CurrentlyWearing),
				positionInComponent = tostring(n1),
				component = tostring(Enums.Components.CurrentlyWearing),
				itemId = tostring(s1)
			} else {
				btnContext = tostring(Enums.Components.CurrentlyWearing),
				btnUnitId = tostring(s1),
				btnSortPosition = tostring(n1)
			})
			v38.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v41, s1, s2, tostring(Enums.Components.CurrentlyWearing), n1)

			return
		end

		v39.fireAnalyticsEvent(EventNames.CatalogItemOpened)
		v38.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v41, s1, s2)
	end, {
		v38.navigateTo.itemDetails,
		v38.externalAnalytics.catalogAnalytics,
		v38.navigateTo.tryOnItem,
		v38.navigateTo.inspectAvatar,
		v42
	})
	local v49 = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}
	local v50 = nil
	local v51 = nil

	if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
		local v52 = React.useCallback(function(p1) -- line: 143
			-- upvalues: Constants (copy), v49 (copy), Enums (copy)
			local v61 = p1[Constants.RODUX_KEY].BundleDetails or {}
			local v62 = p1[Constants.RODUX_KEY].AssetDetails or {}
			local t2 = {}
			local n2 = 1

			for _, v66 in v49 do
				local v67 = if v66.itemType ~= Enums.ItemTypes.Bundle then v62[tostring(v66.assetId)] else v61[tostring(v66.assetId)]

				if v67 then
					v67.itemType = v66.itemType
					t2[n2] = v67
					n2 += 1
				end
			end

			return t2
		end, { v49 })

		v50 = useSelector(v52)
		React.useEffect(function() -- line: 166
			-- upvalues: v49 (copy), v37 (copy), NetworkingCatalog (copy)
			if #v49 > 0 then
				v37(NetworkingCatalog.GetItemAndBundleDetails.API(v49))
			end
		end, {
			v49,
			v37
		})
	else
		local v53 = React.useMemo(function() -- line: 172
			-- upvalues: Cryo (copy), v49 (copy)
			return Cryo.List.map(v49, function(p2) -- line: 173
				return p2.assetId
			end)
		end, { v49 })

		useEffectOnMount(function() -- line: 178
			-- upvalues: v37 (copy), NetworkingCurrentlyWearing (copy), v53 (copy)
			v37(NetworkingCurrentlyWearing.GetItemDetails.API(v53)):andThen(function(_) -- line: 180
			end):catch(function(_) -- line: 181
			end)
		end)

		local v54 = useSelector(function(p5) -- line: 186
			-- upvalues: Constants (copy)
			return p5[Constants.RODUX_KEY].ItemAssets or {}
		end)

		v51 = React.useMemo(function() -- line: 190
			-- upvalues: v53 (copy), v54 (copy), Cryo (copy), SortCurrentlyWearing (copy)
			local t3 = {}
			local n3 = 1

			for _, v72 in v53 do
				local v73 = v54[tostring(v72)]

				if v73 then
					t3[n3] = v73
					n3 += 1
				end
			end

			return Cryo.List.sort(t3, function(p6, p7) -- line: 203
				-- upvalues: SortCurrentlyWearing (copy)
				return SortCurrentlyWearing(p6, p7)
			end)
		end, {
			v54,
			v53
		})
	end

	if not FFlagProfilePlatformEnableBundlesInAssetsCarousel or #v50 > 0 then
		return (React.createElement(AssetsCarousel, {
			title = if not FFlagProfilePlatformEnableInventory then nil else v40.currentlyWearing,
			layoutOrder = t1.layoutOrder,
			assets = if not FFlagProfilePlatformEnableBundlesInAssetsCarousel then v51 else v50,
			openItemDetails = v48,
			onActivateHeader = if not v45 then nil else v47,
			tileVariant = if not FFlagAXEnableProfileTab then nil else v38.currentlyWearingVariant
		}))
	end

	return nil
end

return CurrentlyWearingCarousel
