local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useSelector

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local collectionCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews").CollectionCarousel
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useScreenSize
local useScreenSize2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CoreScriptsRoactCommon").useScreenSize
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileFormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileFormFactor")
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FormFactor").Enums.FormFactor

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local useBreakpointX = Responsive.useBreakpointX
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive").useIsSpatial
local usePreferredInput = Responsive.usePreferredInput
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")

local AssetTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AssetsCarousel/AssetTile")
local MarketplaceAssetTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AssetsCarousel/MarketplaceAssetTile")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local fFlagProfilePlatformEnableInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableInventory
local FFlagProfilePlatformEnableVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableVR")

local FFlagProfilePlatformDisableCurrentlyWearingOnConsole = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformDisableCurrentlyWearingOnConsole")
local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddIEMProfilePage

local FFlagProfilePlatformFixResaleLimitedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformFixResaleLimitedPrice")

local fFlagProfilePlatformEnableBundlesInAssetsCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableBundlesInAssetsCarousel
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local fFlagSplitPaneProfileMaxWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSplitPaneProfileMaxWidth
local defineFastFlag = game:DefineFastFlag("SeeMoreCurrentlyWearingCompact", false)
local defineFastFlag2 = game:DefineFastFlag("SeeMoreCurrentlyWearingWide", false)

local defineFastFlag3 = game:DefineFastFlag("ProfilePlatformUseNewLayoutForAssetsCarousel", false)

local useTokens = Foundation.Hooks.useTokens

local v5 = 2

local function AssetsCarousel(props)
	local v6 = fFlagAXEnableProfileTab and props.tileVariant == Enums.ProfileTabVariants.MeTab
	local v7

	if fFlagAXEnableProfileTab then
		v7 = useProfileFormFactor().formFactor == Enums.ProfileFormFactor.Wide
	end

	local source = if fFlagAddIEMProfilePage then useProfileWrapperContext().sourceInfo.source else nil
	local v8 = if defineFastFlag3 then useTokens() else nil
	local v9 = if FFlagProfilePlatformEnableVR then useIsSpatial() else nil

	local v10 = if FFlagProfilePlatformDisableCurrentlyWearingOnConsole then usePreferredInput() == Responsive.Input.Directional else false
	local v11 = FFlagProfilePlatformEnableVR and v9 or FFlagProfilePlatformDisableCurrentlyWearingOnConsole and v10
	local v12 = useScreenSize()
	local v13 = if fFlagAddIEMProfilePage then useScreenSize2() else nil

	if fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
		v12 = v13
	end

	local v14, v15 = useDynamicSizeMargin()
	local state, setState = React.useState(0)
	local v16

	if fFlagProfilePlatformEnableInventory then
		v16 = props.title
	else
		v16 = useLocalization({ currentlyWearing = TextKeys.CurrentlyWearing })
	end

	if defineFastFlag or defineFastFlag2 then
		local v17 = useSelector(function(p2): boolean
			return p2.FormFactor == formFactor.WIDE
		end)

		if defineFastFlag2 and v17 then
			v5 = 4
		elseif defineFastFlag and not v17 then
			v5 = 3
		end
	end

	local v17 = if fFlagAddIEMProfilePage then useBreakpointX() else nil

	if fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile then
		v5 = if v17 == Responsive.Keys.XSmall then 2 elseif v17 == Responsive.Keys.Small then 3 else 5
	end

	local v19 = fFlagAXEnableProfileTab and v6 and v7 and 5 or v5

	local function fn(props2, p2, p3)
		local createElement = React.createElement

		local formatted = `{props2.name}`
		local createElement2 = React.createElement
		local v23 = if v6 then MarketplaceAssetTile else AssetTile
		local v24 = {
			name = props2.name,
			price = props2.price,
			isOffSale = props2.isOffSale and true or nil,
			lowestResalePrice = 0,
			assetId = 0,
			itemType = 0,
			onActivated = 0
		}

		local v25 = if FFlagProfilePlatformFixResaleLimitedPrice then props2.lowestResalePrice else nil
		v24.lowestResalePrice = v25

		v24.assetId = props2.id
		v24.itemType = not fFlagProfilePlatformEnableBundlesInAssetsCarousel and "Asset" or props2.itemType

		function v24.onActivated()
			if v11 then
				return
			end

			props.openItemDetails(props2.id, props2.itemType, nil, nil, p2)
		end

		return
			createElement("Frame", {
				Size = p3,
				BackgroundTransparency = 1,
				LayoutOrder = p2
			}, {
				[formatted] = createElement2(v23, v24)
			}),
			"CW_Tile"
	end

	local v22 = React.useCallback(fn, {
		props.openItemDetails,
		v11,
		if fFlagAXEnableProfileTab then v6 else nil
	})

	local v23 = React.useCallback(function(p2)
		setState(p2)
		return p2 + 42 + (fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile and 16 or 0)
	end, {})

	local v24 = v19 < #props.assets

	local createElement = React.createElement
	local v26 = {
		Size = UDim2.new(
			1,
			0,
			0,
			state + 42 + (fFlagAddIEMProfilePage and source == Enums.Sources.InExperienceProfile and 16 or 0) + (v24 and 0 or 60 + v12.Y * 0.01)
		),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = v15
	}
	local v28

	if fFlagSplitPaneProfileMaxWidth then
		local createElement2 = React.createElement
		local v30 = {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1
		}

		local v31 = {
			MaxWidthConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(850, 1e999)
			}),
			CollectionCarousel = 0
		}

		local createElement3 = React.createElement
		local v33 = {
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
		local v34 = if fFlagProfilePlatformEnableInventory then props.title else v16.currentlyWearing
		v33.title = v34
		v33.items = props.assets
		v33.renderItem = v22
		v33.getItemHeight = v23
		v33.numColumns = if fFlagAXEnableProfileTab then v19 else v5

		v33.columnGap = fFlagAXEnableProfileTab and v6 and v7 and 12
			or not defineFastFlag3 and 8
			or v8.Gap.Medium

		v33.sideMargin = v14
		v33.onActivateHeader = props.onActivateHeader
		v31.CollectionCarousel = createElement3(collectionCarousel, v33)
		v28 = createElement2("Frame", v30, v31)
	end

	local v29

	if not fFlagSplitPaneProfileMaxWidth then
		local createElement2 = React.createElement
		local v31 = {
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
		local v32 = if fFlagProfilePlatformEnableInventory then props.title else v16.currentlyWearing
		v31.title = v32
		v31.items = props.assets
		v31.renderItem = v22
		v31.getItemHeight = v23

		if not fFlagAXEnableProfileTab then
			v19 = v5
		end

		v31.numColumns = v19

		v31.columnGap = fFlagAXEnableProfileTab and v6 and v7 and 12
			or not defineFastFlag3 and 8
			or v8.Gap.Medium

		v31.sideMargin = v14
		v31.onActivateHeader = props.onActivateHeader
		v29 = createElement2(collectionCarousel, v31)
	end

	return createElement("Frame", v26, {
		ConstrainedCarousel = v28,
		CollectionCarousel = v29
	})
end

return AssetsCarousel
