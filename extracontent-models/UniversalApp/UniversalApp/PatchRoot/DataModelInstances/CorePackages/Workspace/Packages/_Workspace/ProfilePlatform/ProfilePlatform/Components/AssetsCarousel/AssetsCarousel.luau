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
local v29 = game:DefineFastFlag("SeeMoreCurrentlyWearingCompact", false)
local v30 = game:DefineFastFlag("SeeMoreCurrentlyWearingWide", false)
local v31 = game:DefineFastFlag("ProfilePlatformUseNewLayoutForAssetsCarousel", false)
local useTokens = Foundation.Hooks.useTokens
local n1 = 2

local function AssetsCarousel(t1: {[any]: any}) -- line: 76
	-- upvalues: FFlagAXEnableProfileTab (copy), Enums (copy), useProfileFormFactor (copy), FFlagAddIEMProfilePage (copy), useProfileWrapperContext (copy), v31 (copy), useTokens (copy), FFlagProfilePlatformEnableVR (copy), useIsSpatial (copy), FFlagProfilePlatformDisableCurrentlyWearingOnConsole (copy), usePreferredInput (copy), Responsive (copy), useScreenSize (copy), useScreenSize2 (copy), useDynamicSizeMargin (copy), React (copy), FFlagProfilePlatformEnableInventory (copy), useLocalization (copy), TextKeys (copy), v29 (copy), v30 (copy), useSelector (copy), FormFactor (copy), n1 (ref), useBreakpointX (copy), MarketplaceAssetTile (copy), AssetTile (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), CollectionCarousel (copy)
	local v36 = FFlagAXEnableProfileTab and t1.tileVariant == Enums.ProfileTabVariants.MeTab
	local v37 = if not FFlagAXEnableProfileTab then nil else useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	local v38 = if not FFlagAddIEMProfilePage then nil else useProfileWrapperContext().sourceInfo.source
	local v39 = if not v31 then nil else useTokens()
	local v40 = if not FFlagProfilePlatformEnableVR then nil else useIsSpatial()
	local v41 = not not FFlagProfilePlatformDisableCurrentlyWearingOnConsole and usePreferredInput() == Responsive.Input.Directional
	local v42 = FFlagProfilePlatformEnableVR and v40 or FFlagProfilePlatformDisableCurrentlyWearingOnConsole and v41
	local v43 = useScreenSize()
	local v44 = if not FFlagAddIEMProfilePage then nil else useScreenSize2()

	if FFlagAddIEMProfilePage and v38 == Enums.Sources.InExperienceProfile then
		v43 = v44
	end

	local v45, v46 = useDynamicSizeMargin()
	local v47, v48 = React.useState(0)
	local v49 = if not FFlagProfilePlatformEnableInventory then useLocalization({
		currentlyWearing = TextKeys.CurrentlyWearing
	}) else t1.title

	if v29 or v30 then
		local v50 = useSelector(function(p1) -- line: 105
			-- upvalues: FormFactor (copy)
			return p1.FormFactor == FormFactor.WIDE
		end)

		if v30 and v50 then
			n1 = 4
		elseif v29 and not v50 then
			n1 = 3
		end
	end

	local v51 = if not FFlagAddIEMProfilePage then nil else useBreakpointX()

	if FFlagAddIEMProfilePage and v38 == Enums.Sources.InExperienceProfile then
		if v51 == Responsive.Keys.XSmall then
			n1 = 2
		elseif v51 == Responsive.Keys.Small then
			n1 = 3
		else
			n1 = 5
		end
	end

	local v52 = n1

	if FFlagAXEnableProfileTab and v36 and v37 then
		v52 = 5
	end

	local v53 = React.useCallback(function(p2, p3, p4) -- line: 137
		-- upvalues: React (copy), v36 (copy), MarketplaceAssetTile (copy), AssetTile (copy), FFlagProfilePlatformFixResaleLimitedPrice (copy), FFlagProfilePlatformEnableBundlesInAssetsCarousel (copy), v42 (copy), t1 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p4,
			LayoutOrder = p3
		}, {
			[`{ p2.name }`] = React.createElement(if not v36 then AssetTile else MarketplaceAssetTile, {
				name = p2.name,
				price = p2.price,
				isOffSale = not not p2.isOffSale or nil,
				lowestResalePrice = if not FFlagProfilePlatformFixResaleLimitedPrice then nil else p2.lowestResalePrice,
				assetId = p2.id,
				itemType = not FFlagProfilePlatformEnableBundlesInAssetsCarousel and "Asset" or p2.itemType,
				onActivated = function() -- line: 159
					-- upvalues: v42 (copy), t1 (copy), p2 (copy), p3 (copy)
					if v42 then
						return
					end

					t1.openItemDetails(p2.id, p2.itemType, nil, nil, p3)
				end
			})
		}), "CW_Tile"
	end, {
		t1.openItemDetails,
		v42,
		if not FFlagAXEnableProfileTab then nil else v36
	})
	local v54 = React.useCallback(function(n2: number) -- line: 174
		-- upvalues: v48 (copy), FFlagAddIEMProfilePage (copy), v38 (copy), Enums (copy)
		v48(n2)

		return n2 + 42 + ((not FFlagAddIEMProfilePage or v38 ~= Enums.Sources.InExperienceProfile) and 0 or 16)
	end, {})
	local v55 = v52 < #t1.assets

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v47 + 42 + ((not FFlagAddIEMProfilePage or v38 ~= Enums.Sources.InExperienceProfile) and 0 or 16) + if not v55 then 60 + v43.Y * 0.01 else 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		[React.Change.AbsoluteSize] = v46
	}, {
		CollectionCarousel = React.createElement(CollectionCarousel, {
			fractionalItemAmount = 0.8,
			LayoutOrder = t1.layoutOrder,
			title = if not FFlagProfilePlatformEnableInventory then v49.currentlyWearing else t1.title,
			items = t1.assets,
			renderItem = v53,
			getItemHeight = v54,
			numColumns = if not FFlagAXEnableProfileTab then n1 else v52,
			columnGap = if not FFlagAXEnableProfileTab or (not v36 or not v37) then not v31 and 8 or v39.Gap.Medium else 12,
			sideMargin = v45,
			onActivateHeader = if not FFlagProfilePlatformEnableInventory or v42 then nil else t1.onActivateHeader
		})
	})
end

return AssetsCarousel
