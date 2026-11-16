local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Enums = require(ProfilePlatform.Common.Enums)
local CollectionViews = require(parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local useScreenSize2 = CoreScriptsRoactCommon.useScreenSize
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileFormFactor = require(ProfilePlatform.Hooks.useProfileFormFactor)
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor

local Responsive = require(parent.Responsive)
local useBreakpointX = Responsive.useBreakpointX
local Responsive2 = require(parent.Responsive)
local useIsSpatial = Responsive2.useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local Foundation = require(parent.Foundation)

local AssetTile = require(script.Parent.AssetTile)
local MarketplaceAssetTile = require(script.Parent.MarketplaceAssetTile)
require(ProfilePlatform.Common.AssetInfo)

local TextKeys = require(ProfilePlatform.Common.TextKeys)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableInventory = SharedFlags.FFlagProfilePlatformEnableInventory
local FFlagProfilePlatformEnableVR = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableVR)

local FFlagProfilePlatformDisableCurrentlyWearingOnConsole = require(ProfilePlatform.Flags.FFlagProfilePlatformDisableCurrentlyWearingOnConsole)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags2.FFlagAddIEMProfilePage

local FFlagProfilePlatformFixResaleLimitedPrice = require(ProfilePlatform.Flags.FFlagProfilePlatformFixResaleLimitedPrice)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableBundlesInAssetsCarousel = SharedFlags3.FFlagProfilePlatformEnableBundlesInAssetsCarousel
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags4.FFlagAXEnableProfileTab
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSplitPaneProfileMaxWidth = SharedFlags5.FFlagSplitPaneProfileMaxWidth
local defineFastFlag = game:DefineFastFlag("SeeMoreCurrentlyWearingCompact", false)
local defineFastFlag2 = game:DefineFastFlag("SeeMoreCurrentlyWearingWide", false)

local defineFastFlag3 = game:DefineFastFlag("ProfilePlatformUseNewLayoutForAssetsCarousel", false)

local useTokens = Foundation.Hooks.useTokens

local v = 2

local function AssetsCarousel(props)
	local v2 = FFlagAXEnableProfileTab and props.tileVariant == Enums.ProfileTabVariants.MeTab
	local v3

	if FFlagAXEnableProfileTab then
		v3 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	end

	local source

	if FFlagAddIEMProfilePage then
		source = useProfileWrapperContext().sourceInfo.source
	else
		source = nil
	end

	local v4

	if defineFastFlag3 then
		v4 = useTokens()
	end

	local v5

	if FFlagProfilePlatformEnableVR then
		v5 = useIsSpatial()
	end

	local v6

	if FFlagProfilePlatformDisableCurrentlyWearingOnConsole then
		v6 = usePreferredInput() == Responsive.Input.Directional
	else
		v6 = false
	end

	local v7 = FFlagProfilePlatformEnableVR and v5 or FFlagProfilePlatformDisableCurrentlyWearingOnConsole and v6
	local v8 = useScreenSize()
	local v9

	if FFlagAddIEMProfilePage then
		v9 = useScreenSize2()
	end

	if FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
		v8 = v9
	end

	local sideMargin, v10 = useDynamicSizeMargin()
	local state, setState = React.useState(0)
	local v11

	if FFlagProfilePlatformEnableInventory then
		v11 = props.title
	else
		v11 = useLocalization({ currentlyWearing = TextKeys.CurrentlyWearing })
	end

	if defineFastFlag or defineFastFlag2 then
		local v12 = useSelector(function(p): boolean
			return p.FormFactor == formFactor.WIDE
		end)

		if defineFastFlag2 and v12 then
			v = 4
		elseif defineFastFlag and not v12 then
			v = 3
		end
	end

	local v12

	if FFlagAddIEMProfilePage then
		v12 = useBreakpointX()
	end

	if FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
		if v12 == Responsive.Keys.XSmall then
			v = 2
		else
			v = if v12 == Responsive.Keys.Small then 3 else 5
		end
	end

	local numColumns = FFlagAXEnableProfileTab and v2 and v3 and 5 or v
	local useCallback = React.useCallback
	local function fn(props2, layoutOrder, size)
		local createElement = React.createElement

		local formatted = `{props2.name}`
		local createElement2 = React.createElement
		local v13 = if v2 then MarketplaceAssetTile else AssetTile
		local v14 = {
			name = props2.name,
			price = props2.price,
			isOffSale = props2.isOffSale and true or nil,
			lowestResalePrice = 0,
			assetId = 0,
			itemType = 0,
			onActivated = 0
		}
		local lowestResalePrice

		if FFlagProfilePlatformFixResaleLimitedPrice then
			lowestResalePrice = props2.lowestResalePrice
		end

		v14.lowestResalePrice = lowestResalePrice

		v14.assetId = props2.id
		v14.itemType = not FFlagProfilePlatformEnableBundlesInAssetsCarousel and "Asset" or props2.itemType

		function v14.onActivated()
			if v7 then
				return
			end

			props.openItemDetails(props2.id, props2.itemType, nil, nil, layoutOrder)
		end

		return
			createElement("Frame", {
				Size = size,
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			}, {
				[formatted] = createElement2(v13, v14)
			}),
			"CW_Tile"
	end

	local openItemDetails = props.openItemDetails
	local v13

	if FFlagAXEnableProfileTab then
		v13 = v2
	end

	local renderItem = useCallback(fn, { openItemDetails, v7, v13 })

	local getItemHeight = React.useCallback(function(p: number)
		setState(p)
		return p + 42 + (FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile and 16 or 0)
	end, {})

	local v14 = numColumns < #props.assets

	local createElement = React.createElement
	local v15 = {
		Size = UDim2.new(
			1,
			0,
			0,
			state + 42 + (FFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile and 16 or 0) + (v14 and 0 or 60 + v8.Y * 0.01)
		),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = v10
	}
	local constrainedCarousel

	if FFlagSplitPaneProfileMaxWidth then
		local createElement2 = React.createElement
		local v16 = {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1
		}

		local v17 = {
			MaxWidthConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(850, 1e999)
			}),
			CollectionCarousel = 0
		}

		local createElement3 = React.createElement
		local v18 = {
			LayoutOrder = props.layoutOrder,
			title = 0,
			items = 0,
			renderItem = 0,
			getItemHeight = 0,
			numColumns = 0,
			fractionalItemAmount = 0.8,
			columnGap = 0,
			sideMargin = 0,
			onActivateHeader = 0
		}
		local title

		if FFlagProfilePlatformEnableInventory then
			title = props.title
		else
			title = v11.currentlyWearing
		end

		v18.title = title
		v18.items = props.assets
		v18.renderItem = renderItem
		v18.getItemHeight = getItemHeight
		local numColumns2

		if FFlagAXEnableProfileTab then
			numColumns2 = numColumns
		else
			numColumns2 = v
		end

		v18.numColumns = numColumns2

		v18.columnGap = FFlagAXEnableProfileTab and v2 and v3 and 12 or not defineFastFlag3 and 8 or v4.Gap.Medium

		v18.sideMargin = sideMargin
		v18.onActivateHeader = props.onActivateHeader
		v17.CollectionCarousel = createElement3(CollectionCarousel, v18)
		constrainedCarousel = createElement2("Frame", v16, v17)
	end

	local collectionCarousel

	if not FFlagSplitPaneProfileMaxWidth then
		local createElement2 = React.createElement
		local v16 = {
			LayoutOrder = props.layoutOrder,
			title = 0,
			items = 0,
			renderItem = 0,
			getItemHeight = 0,
			numColumns = 0,
			fractionalItemAmount = 0.8,
			columnGap = 0,
			sideMargin = 0,
			onActivateHeader = 0
		}
		local title

		if FFlagProfilePlatformEnableInventory then
			title = props.title
		else
			title = v11.currentlyWearing
		end

		v16.title = title
		v16.items = props.assets
		v16.renderItem = renderItem
		v16.getItemHeight = getItemHeight

		if not FFlagAXEnableProfileTab then
			numColumns = v
		end

		v16.numColumns = numColumns

		v16.columnGap = FFlagAXEnableProfileTab and v2 and v3 and 12 or not defineFastFlag3 and 8 or v4.Gap.Medium

		v16.sideMargin = sideMargin
		v16.onActivateHeader = props.onActivateHeader
		collectionCarousel = createElement2(CollectionCarousel, v16)
	end

	return createElement("Frame", v15, {
		ConstrainedCarousel = constrainedCarousel,
		CollectionCarousel = collectionCarousel
	})
end

return AssetsCarousel
