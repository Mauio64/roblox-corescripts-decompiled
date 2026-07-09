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
local IXPService = game:GetService("IXPService")
local v27 = game:DefineFastString("SocialProfileCurrentlyWearingClickThroughLayer", "Social.ProfileCurrentlyWearingClickThrough")
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableBundlesInAssetsCarousel
local AssetsCarousel = require(ProfilePlatform.Components.AssetsCarousel)

local function CurrentlyWearingCarousel(t1: {[any]: any}) -- line: 47
	-- upvalues: useDispatch (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), FFlagProfilePlatformEnableInventory (copy), useLocalization (copy), TextKeys (copy), useMarketplaceAnalyticsContext (copy), FFlagAddIEMProfilePage (copy), React (copy), Enums (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), IXPService (copy), v27 (copy), FFlagProfilePlatformEnableStore (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), useProfileJsonComponent (copy), Constants (copy), useSelector (copy), NetworkingCatalog (copy), Cryo (copy), useEffectOnMount (copy), NetworkingCurrentlyWearing (copy), SortCurrentlyWearing (copy), AssetsCarousel (copy), FFlagAXEnableProfileTab (copy)
	local v32 = useDispatch()
	local v33 = useProfileWrapperContext()
	local v34 = useProfileAnalyticsContext()
	local v35 = if not FFlagProfilePlatformEnableInventory then nil else useLocalization({
		currentlyWearing = TextKeys.CurrentlyWearing
	})
	local v36 = useMarketplaceAnalyticsContext()
	local v37 = if not FFlagAddIEMProfilePage then nil else v33.sourceInfo.source
	local v38 = React.useCallback(function(s1: string, s2: string, _: string?, _: string?, n1: number?) -- line: 62
		-- upvalues: FFlagAddIEMProfilePage (copy), v37 (copy), Enums (copy), v33 (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), IXPService (copy), v27 (copy), FFlagProfilePlatformEnableStore (copy), v34 (copy), EventNames (copy), FFlagProfilePlatformUseCatalogItemOpenedNewFields (copy), v36 (copy)
		if FFlagAddIEMProfilePage and v37 == Enums.Sources.InExperienceProfile then
			v33.navigateTo.inspectAvatar()

			return
		end

		if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
			v33.navigateTo.itemOrBundleDetails(s1, s2)
		else
			v33.navigateTo.itemDetails(s1)
		end

		IXPService:LogFlagLinkedUserLayerExposure(v27)

		if FFlagProfilePlatformEnableStore then
			v34.fireAnalyticsEvent(EventNames.CatalogItemOpened, if not FFlagProfilePlatformUseCatalogItemOpenedNewFields then {
				source = tostring(Enums.Components.CurrentlyWearing),
				positionInComponent = tostring(n1),
				component = tostring(Enums.Components.CurrentlyWearing),
				itemId = tostring(s1)
			} else {
				btnContext = tostring(Enums.Components.CurrentlyWearing),
				btnUnitId = tostring(s1),
				btnSortPosition = tostring(n1)
			})
			v33.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v36, s1, s2, tostring(Enums.Components.CurrentlyWearing), n1)

			return
		end

		v34.fireAnalyticsEvent(EventNames.CatalogItemOpened)
		v33.externalAnalytics.catalogAnalytics.clickCatalogItemFromProfile(v36, s1, s2)
	end, {
		v33.navigateTo.itemDetails,
		v33.externalAnalytics.catalogAnalytics,
		v33.navigateTo.tryOnItem,
		v33.navigateTo.inspectAvatar,
		v37
	})
	local v39 = useProfileJsonComponent(Enums.Components.CurrentlyWearing).assets or {}
	local v40 = nil
	local v41 = nil

	if FFlagProfilePlatformEnableBundlesInAssetsCarousel then
		local v42 = React.useCallback(function(p1) -- line: 120
			-- upvalues: Constants (copy), v39 (copy), Enums (copy)
			local v51 = p1[Constants.RODUX_KEY].BundleDetails or {}
			local v52 = p1[Constants.RODUX_KEY].AssetDetails or {}
			local t2 = {}
			local n2 = 1

			for _, v56 in v39 do
				local v57 = if v56.itemType ~= Enums.ItemTypes.Bundle then v52[tostring(v56.assetId)] else v51[tostring(v56.assetId)]

				if v57 then
					v57.itemType = v56.itemType
					t2[n2] = v57
					n2 += 1
				end
			end

			return t2
		end, { v39 })

		v40 = useSelector(v42)
		React.useEffect(function() -- line: 143
			-- upvalues: v39 (copy), v32 (copy), NetworkingCatalog (copy)
			if #v39 > 0 then
				v32(NetworkingCatalog.GetItemAndBundleDetails.API(v39))
			end
		end, {
			v39,
			v32
		})
	else
		local v43 = React.useMemo(function() -- line: 149
			-- upvalues: Cryo (copy), v39 (copy)
			return Cryo.List.map(v39, function(p2) -- line: 150
				return p2.assetId
			end)
		end, { v39 })

		useEffectOnMount(function() -- line: 155
			-- upvalues: v32 (copy), NetworkingCurrentlyWearing (copy), v43 (copy)
			v32(NetworkingCurrentlyWearing.GetItemDetails.API(v43)):andThen(function(_) -- line: 157
			end):catch(function(_) -- line: 158
			end)
		end)

		local v44 = useSelector(function(p5) -- line: 163
			-- upvalues: Constants (copy)
			return p5[Constants.RODUX_KEY].ItemAssets or {}
		end)

		v41 = React.useMemo(function() -- line: 167
			-- upvalues: v43 (copy), v44 (copy), Cryo (copy), SortCurrentlyWearing (copy)
			local t3 = {}
			local n3 = 1

			for _, v62 in v43 do
				local v63 = v44[tostring(v62)]

				if v63 then
					t3[n3] = v63
					n3 += 1
				end
			end

			return Cryo.List.sort(t3, function(p6, p7) -- line: 180
				-- upvalues: SortCurrentlyWearing (copy)
				return SortCurrentlyWearing(p6, p7)
			end)
		end, {
			v44,
			v43
		})
	end

	if not FFlagProfilePlatformEnableBundlesInAssetsCarousel or #v40 > 0 then
		return (React.createElement(AssetsCarousel, {
			title = if not FFlagProfilePlatformEnableInventory then nil else v35.currentlyWearing,
			layoutOrder = t1.layoutOrder,
			assets = if not FFlagProfilePlatformEnableBundlesInAssetsCarousel then v41 else v40,
			openItemDetails = v38,
			tileVariant = if not FFlagAXEnableProfileTab then nil else v33.currentlyWearingVariant
		}))
	end

	return nil
end

return CurrentlyWearingCarousel
