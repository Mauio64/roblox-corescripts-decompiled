local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useSelector = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useSelector
local Enums = require(ProfilePlatform.Common.Enums)
local CollectionCarousel = require(ProfilePlatformParent.CollectionViews).CollectionCarousel
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useScreenSize = require(ProfilePlatformParent.RobloxAppHooks).useScreenSize
local useScreenSize2 = require(ProfilePlatformParent.CoreScriptsRoactCommon).useScreenSize
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local FormFactor = require(ProfilePlatformParent.FormFactor).Enums.FormFactor
local Responsive = require(ProfilePlatformParent.Responsive)
local useBreakpointX = Responsive.useBreakpointX
local useIsSpatial = require(ProfilePlatformParent.Responsive).useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local Foundation = require(ProfilePlatformParent.Foundation)
local AssetTile = require(script.Parent.AssetTile)
local MarketplaceAssetTile = require(script.Parent.MarketplaceAssetTile)

require(ProfilePlatform.Common.AssetInfo)

local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagProfilePlatformEnableInventory = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableInventory
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)
local FFlagProfilePlatformDisableCurrentlyWearingOnConsole = require(ProfilePlatform.Flags.FFlagProfilePlatformDisableCurrentlyWearingOnConsole)
local FFlagAddIEMProfilePage = require(ProfilePlatformParent.SharedFlags).FFlagAddIEMProfilePage
local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableBundlesInAssetsCarousel
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local FFlagAssetsCarouselPassActivateHeaderProp = require(ProfilePlatform.Flags.FFlagAssetsCarouselPassActivateHeaderProp)
local v30 = game:DefineFastFlag("SeeMoreCurrentlyWearingCompact", false)
local v31 = game:DefineFastFlag("SeeMoreCurrentlyWearingWide", false)
local v32 = game:DefineFastFlag("ProfilePlatformUseNewLayoutForAssetsCarousel", false)
local useTokens = Foundation.Hooks.useTokens
local n1 = 2

local function AssetsCarousel(t1: {[any]: any}) -- line: 78
	-- upvalues: FFlagAXEnableProfileTab (copy), Enums (copy), useProfileFormFactor (copy), FFlagAddIEMProfilePage (copy), useProfileWrapperContext (copy), v32 (copy), useTokens (copy), FFlagProfilePlatformEnableVR (copy), useIsSpatial (copy), FFlagProfilePlatformDisableCurrentlyWearingOnConsole (copy), usePreferredInput (copy), Responsive (copy), useScreenSize (copy), useScreenSize2 (copy), useDynamicSizeMargin (copy), React (copy), FFlagProfilePlatformEnableInventory (copy), useLocalization (copy), TextKeys (copy), v30 (copy), v31 (copy), useSelector (copy), FormFactor (copy), n1 (ref), useBreakpointX (copy), MarketplaceAssetTile (copy), AssetTile (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), CollectionCarousel (copy), FFlagAssetsCarouselPassActivateHeaderProp (copy)
	local v37 = FFlagAXEnableProfileTab and t1.tileVariant == Enums.ProfileTabVariants.MeTab
	local v38 = if not FFlagAXEnableProfileTab then nil else useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v39 = if not FFlagAddIEMProfilePage then nil else useProfileWrapperContext().sourceInfo.source
	local v40 = if not v32 then nil else useTokens()
	local v41 = if not FFlagProfilePlatformEnableVR then nil else useIsSpatial()
	local v42 = not not FFlagProfilePlatformDisableCurrentlyWearingOnConsole and usePreferredInput() == Responsive.Input.Directional
	local v43 = FFlagProfilePlatformEnableVR and v41 or FFlagProfilePlatformDisableCurrentlyWearingOnConsole and v42
	local v44 = useScreenSize()
	local v45 = if not FFlagAddIEMProfilePage then nil else useScreenSize2()

	if FFlagAddIEMProfilePage and v39 == Enums.Sources.InExperienceProfile then
		v44 = v45
	end

	local v46, v47 = useDynamicSizeMargin()
	local v48, v49 = React.useState(0)
	local v50 = if not FFlagProfilePlatformEnableInventory then useLocalization({
		currentlyWearing = TextKeys.CurrentlyWearing
	}) else t1.title

	if v30 or v31 then
		local v51 = useSelector(function(p1) -- line: 107
			-- upvalues: FormFactor (copy)
			return p1.FormFactor == FormFactor.WIDE
		end)

		if v31 and v51 then
			n1 = 4
		elseif v30 and not v51 then
			n1 = 3
		end
	end

	local v52 = if not FFlagAddIEMProfilePage then nil else useBreakpointX()

	if FFlagAddIEMProfilePage and v39 == Enums.Sources.InExperienceProfile then
		if v52 == Responsive.Keys.XSmall then
			n1 = 2
		elseif v52 == Responsive.Keys.Small then
			n1 = 3
		else
			n1 = 5
		end
	end

	local v53 = n1

	if FFlagAXEnableProfileTab and v37 and v38 then
		v53 = 5
	end

	local v54 = React.useCallback(function(p2, p3, p4) -- line: 139
		-- upvalues: React (copy), v37 (copy), MarketplaceAssetTile (copy), AssetTile (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), v43 (copy), t1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p4,
			LayoutOrder = p3
		}, {
			[`{ p2.name }`] = React.createElement(if not v37 then AssetTile else MarketplaceAssetTile, {
				name = p2.name,
				price = p2.price,
				isOffSale = not not p2.isOffSale or nil,
				lowestResalePrice = if not FFlagProfilePlatformFixResaleLimitedPrice then nil else p2.lowestResalePrice,
				assetId = p2.id,
				itemType = not FFlagProfilePlatformEnableBundlesInAssetsCarousel and "Asset" or p2.itemType,
				onActivated = function() -- line: 161
					-- upvalues: v43 (copy), t1 (copy), p2 (copy), p3 (copy)
					if v43 then
						return
					end

					t1.openItemDetails(p2.id, p2.itemType, nil, nil, p3)
				end
			})
		}), "CW_Tile"
	end, {
		t1.openItemDetails,
		v43,
		if not FFlagAXEnableProfileTab then nil else v37
	})
	local v55 = React.useCallback(function(n2: number) -- line: 176
		-- upvalues: v49 (copy), FFlagAddIEMProfilePage (copy), v39 (copy), Enums (copy)
		v49(n2)

		return n2 + 42 + ((not FFlagAddIEMProfilePage or v39 ~= Enums.Sources.InExperienceProfile) and 0 or 16)
	end, {})
	local v56 = v53 < #t1.assets

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v48 + 42 + ((not FFlagAddIEMProfilePage or v39 ~= Enums.Sources.InExperienceProfile) and 0 or 16) + if not v56 then 60 + v44.Y * 0.01 else 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		[React.Change.AbsoluteSize] = v47
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			fractionalItemAmount = 0.8,
			LayoutOrder = t1.layoutOrder,
			title = if not FFlagProfilePlatformEnableInventory then v50.currentlyWearing else t1.title,
			items = t1.assets,
			renderItem = v54,
			getItemHeight = v55,
			numColumns = if not FFlagAXEnableProfileTab then n1 else v53,
			columnGap = if not FFlagAXEnableProfileTab or (not v37 or not v38) then not v32 and 8 or v40.Gap.Medium else 12,
			sideMargin = v46,
			onActivateHeader = if not FFlagAssetsCarouselPassActivateHeaderProp then if not FFlagProfilePlatformEnableInventory or v43 then nil else t1.onActivateHeader else t1.onActivateHeader
		})
	})
end

return AssetsCarousel
