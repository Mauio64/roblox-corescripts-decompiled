local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local t = require(CorePackages.Packages.t)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local ItemViewport = require(Modules.AvatarExperience.Common.Components.ItemViewport.ItemViewport)
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventImpressionsReporter
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local GetCanExpand = UIBlox.Core.Text.ExpandableText.GetCanExpand
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local EmptyState = UIBlox.App.Indicator.EmptyState
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LinkButton = UIBlox.App.Button.LinkButton
local MenuDirection = UIBlox.App.Menu.MenuDirection
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local FitTextLabel = RoactFitComponents.FitTextLabel
local getSafeAreaSize = require(CorePackages.Workspace.Packages.InputUi).getSafeAreaSize
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local NavigateDownToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ItemDescription = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemDescription)
local ItemStatistics = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemStatistics)
local ItemOwnershipButton = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemOwnershipButton)
local ItemInfoList = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.ItemInfoList)
local RecommendedItemsGrid = require(Modules.AvatarExperience.Common.Components.ItemDetails.RecommendedItemsGrid)
local BundleItemsGrid = require(Modules.AvatarExperience.Common.Components.ItemDetails.BundleItemsGrid)
local logItemDetailsIxpLayerExposure = require(Modules.AvatarExperience.Common.Components.ItemDetails.logItemDetailsIxpLayerExposure)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local FriendsOwnedChip = require(CorePackages.Workspace.Packages.SocialProof).Chips.FriendsOwnedChip
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ItemDataValidator = require(Modules.AvatarExperience.Common.Validators.ItemDataValidator)
local FavoritePillContainer = require(Modules.AvatarExperience.Common.Components.ItemDetails.FavoritePill.FavoritePillContainer)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceTimedOptions = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions)
local WearTimeOptionsCarousel = AvatarExperienceTimedOptions.WearTimeOptionsCarousel
local ItemExpirationDisplay = AvatarExperienceTimedOptions.ItemExpirationDisplay
local isDurableItemExpired = AvatarExperienceCommon.Utils.isDurableItemExpired
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local GetFFlagRestrictLimited2ToSoothsayers = require(Modules.AvatarExperience.Flags.GetFFlagRestrictLimited2ToSoothsayers)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local useItemDetailsContainerFocusNavigationBindings = require(Modules.AvatarExperience.Common.Components.ItemDetails.useItemDetailsContainerFocusNavigationBindings)
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions

require(Modules.AvatarExperience.Common.Types)

local GetFFlagAXItemDetailsScrollingEnabledCallback = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local AXItemDetails3DPreviewIXP = require(Modules.AvatarExperience.Experiments.AXItemDetails3DPreviewIXP)
local GetFFlagAXHideRecommendationsOnFetchFailure = require(Modules.AvatarExperience.Flags.GetFFlagAXHideRecommendationsOnFetchFailure)
local GetFFlagAXSupportShoesInItemViewport = require(Modules.AvatarExperience.Flags.GetFFlagAXSupportShoesInItemViewport)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagUpdateNoInternetConnectionText = AvatarExperienceFlags.FFlagUpdateNoInternetConnectionText
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagAXThumbTypeNilCheck = AvatarExperienceFlags.FFlagAXThumbTypeNilCheck
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagEnableSocialProofOnItemDetails = SharedFlags.FFlagEnableSocialProofOnItemDetails
local v88 = game:DefineFastFlag("AXFixItemDetailsContainerGuiInsetType", false)
local v89 = game:DefineFastFlag("AXItemDetailsContainerFixGsub", false)
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXTryOnScreenFixes = AvatarExperienceFlags.FFlagAXTryOnScreenFixes
local FFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local FFlagAXFavoritePillOnItemDetails = AvatarExperienceFlags.FFlagAXFavoritePillOnItemDetails
local v96 = Roact.PureComponent:extend("ItemDetailsContainer")

v96.validateProps = t.strictInterface({
	actionBarHeaderRef = t.table,
	clipDetails = t.optional(t.boolean),
	listPadding = t.optional(t.numberPositive),
	itemId = t.string,
	itemType = t.string,
	onItemInvalid = t.optional(t.callback),
	showFullWithNoPeekView = t.optional(t.boolean),
	bottomDockedContainerHeight = t.optional(t.number),
	resultsListRef = t.optional(t.table),
	itemDetailsPeekViewRefs = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	forwardRef = t.optional(t.table),
	setItemDetailsScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else t.optional(t.callback),
	itemSubType = t.optional(t.string),
	assetType = t.optional(t.string),
	simpleView = if not FFlagAXEnableHomeTryOnComplexView and not FFlagAXTryOnScreenFixes then nil else t.optional(t.boolean),
	width = t.number,
	setWidth = t.callback,
	itemDetailsContainerRef = if not FFlagAXItemDetailsIxpExposure then nil else t.table,
	expandableTextRef = t.table,
	ownershipButtonRef = t.table,
	resellerRef = t.table,
	attributionRef = t.table,
	recommendedItemsGridRef = t.table,
	tagBasedImpressionsDetectorExtensions = if not FFlagAXItemDetailsIxpExposure then nil else t.table,
	onWearTimeSelection = t.optional(t.callback),
	globalGuiInset = t.strictInterface({
		left = if not v88 then t.integer else t.number,
		top = if not v88 then t.integer else t.number,
		right = if not v88 then t.integer else t.number,
		bottom = if not v88 then t.integer else t.number
	}),
	screenSize = t.Vector2,
	fetchingState = t.string,
	itemData = t.optional(ItemDataValidator),
	peekViewState = t.optional(t.valueOf(PeekViewState)),
	experiences = t.optional(t.table),
	collectibleData = t.optional(t.table),
	isCollectiblesEnabled = if not GetFFlagRestrictLimited2ToSoothsayers() then nil else t.optional(t.boolean),
	isLimitedCollectible = t.optional(t.boolean),
	avatarRoute = if not FFlagAXItemDetailsIxpExposure then nil else AvatarRoute.Interface,
	fetchAssetOrBundleInfo = t.callback,
	navigateDownToAvatarScreen = t.callback,
	toggleTryOn = t.optional(t.callback),
	navigation = t.table,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	showPremiumContent = t.optional(t.boolean),
	enableAggregateLikesFavoritesCount = t.boolean
})
v96.defaultProps = {
	clipDetails = false,
	listPadding = 24
}

function v96.init(p1) -- line: 222
	-- upvalues: AXItemDetails3DPreviewIXP (copy), IxpUtils (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), FFlagAXItemDetailsIxpExposure (copy), Signal (copy), Roact (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy)
	p1.state = {
		is3DPreviewEnabled = AXItemDetails3DPreviewIXP.isEnabled() and not not IxpUtils.readTestVariable(AXItemDetails3DPreviewIXP.EnableItemDetails3DPreview) or nil,
		fetchRecommendationsFailed = not GetFFlagAXHideRecommendationsOnFetchFailure() and nil
	}

	if FFlagAXItemDetailsIxpExposure then
		p1.requestImpressionsSignal = Signal.new()
	end

	function p1.fetchAssetOrBundleInfo() -- line: 235
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local appAnalytics = p1.props.appAnalytics
		local str = tostring(p1.props.itemId)
		local itemType = p1.props.itemType

		return p1.props.fetchAssetOrBundleInfo(networking, appAnalytics, str, itemType)
	end

	if AXItemDetails3DPreviewIXP.isEnabled() then
		function p1.onItemViewportLoadingFailed() -- line: 245
			-- upvalues: p1 (copy)
			p1:setState({
				is3DPreviewEnabled = false
			})
		end
	end

	p1:updateDurability()

	local v102, v103 = Roact.createBinding(false)

	p1.itemHeaderVisibleBinding = v102
	p1.updateItemHeaderVisibleBinding = v103

	function p1.onTryOnActivated() -- line: 255
		-- upvalues: p1 (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy)
		local t1 = {
			mountAsFullView = false,
			mountAnimation = false,
			itemId = p1.props.itemId,
			itemType = p1.props.itemType,
			itemDetailsPeekViewRefs = p1.props.itemDetailsPeekViewRefs,
			resultsListRef = p1.props.resultsListRef
		}
		local v203 = t1.itemType .. t1.itemId

		if FFlagAXTryOnScreenImprovements then
			t1.itemSubType = p1.props.itemSubType
		else
			p1.props.toggleTryOn(p1.props.networking, p1.props.catalogAnalytics, p1.props.itemType, p1.props.itemSubType, p1.props.itemId, true, nil, nil)
		end

		p1.props.navigateDownToAvatarScreen(AvatarScreen.TryOnItem, v203, t1)
	end
	function p1.onItemOwnershipButtonActivated() -- line: 284
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local collectibleItemId = p1.props.itemData.collectibleItemId

		p1.props.navigation.navigate(AvatarScreen.ItemOwnershipPage, {
			itemId = p1.props.itemId,
			collectibleItemId = collectibleItemId,
			itemType = p1.props.itemType
		})
	end
	function p1.onItemHeaderMoved(p2) -- line: 294
		-- upvalues: p1 (copy)
		if not p1.props.actionBarHeaderRef then
			return
		end

		local current = p1.props.actionBarHeaderRef.current

		if not current then
			return
		end

		local v207 = current.AbsolutePosition.Y > p2.AbsolutePosition.Y

		current.Visible = not v207
		p1.updateItemHeaderVisibleBinding(v207)
	end

	p1.hasCalledOnItemInvalid = false

	if GetFFlagAXHideRecommendationsOnFetchFailure() then
		function p1.onFetchRecommendationsFailed() -- line: 316
			-- upvalues: p1 (copy)
			p1:setState({
				fetchRecommendationsFailed = true
			})
		end
	end
end
function v96.updateDurability(p3) -- line: 324
	if p3.props.itemData and p3.props.itemData.timedOptions then
		p3.wearTimeOptions = p3.props.itemData.timedOptions
	end
end
function v96.didMount(p4) -- line: 330
	p4.fetchAssetOrBundleInfo()
end
function v96.didUpdate(p5, p6) -- line: 334
	-- upvalues: RetrievalStatus (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy)
	p5:updateDurability()

	local itemData = p5.props.itemData
	local fetchingState = p5.props.fetchingState
	local onItemInvalid = p5.props.onItemInvalid
	local v111 = fetchingState == RetrievalStatus.Done and itemData == nil
	local hasCalledOnItemInvalid = p5.hasCalledOnItemInvalid

	if onItemInvalid ~= nil and (not hasCalledOnItemInvalid and v111) then
		onItemInvalid()
		p5.hasCalledOnItemInvalid = true
	end

	if GetFFlagAXHideRecommendationsOnFetchFailure() and (p6.itemType ~= p5.props.itemType or p6.itemId ~= p5.props.itemId) then
		p5:setState({
			fetchRecommendationsFailed = false
		})
	end
end
function v96.shouldShowRecommendedItems(p7, p8) -- line: 368
	-- upvalues: CatalogUtils (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy)
	if p8 then
		return false
	end

	if p7.props.assetType and not CatalogUtils.doesAssetTypeHaveCatalogPage(p7.props.assetType) then
		return false
	end

	local itemData = p7.props.itemData

	if itemData and itemData.receivedRecommendedData and (itemData.recommendedItemSummaries == nil or #itemData.recommendedItemSummaries == 0) then
		return false
	end

	if GetFFlagAXHideRecommendationsOnFetchFailure() and p7.state.fetchRecommendationsFailed then
		return false
	end

	return true
end
function v96.renderDetailsWithProviders(p9, p10) -- line: 392
	-- upvalues: CatalogUtils (copy), FFlagAXThumbTypeNilCheck (copy), getRbxthumbWithTypeSizeAndOptions (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXRemoveExpiredItemsFromInventory (copy), isDurableItemExpired (copy), AXItemDetails3DPreviewIXP (copy), Constants (copy), GetFFlagAXSupportShoesInItemViewport (copy), GetFFlagRestrictLimited2ToSoothsayers (copy), withStyle (copy), AvatarScreen (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXTryOnScreenImprovements (copy), TextService (copy), Roact (copy), LinkButton (copy), v89 (copy), MenuDirection (copy), FitFrameVertical (copy), RoactFitComponents (copy), FFlagAXItemDetailsIxpExposure (copy), IsVRAppBuild (copy), FitTextLabel (copy), Skeleton (copy), StyledTextLabel (copy), ItemViewport (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), LoadableImage (copy), Button (copy), ButtonType (copy), BundleItemsGrid (copy), FFlagEnableSocialProofOnItemDetails (copy), FriendsOwnedChip (copy), ItemDescription (copy), React (copy), ItemExpirationDisplay (copy), FFlagAXDurables2Option (copy), WearTimeOptionsCarousel (copy), FFlagAXFavoritePillOnItemDetails (copy), FavoritePillContainer (copy), ItemStatistics (copy), ItemOwnershipButton (copy), GetFFlagL2ControllerSupport (copy), ItemInfoList (copy), RecommendedItemsGrid (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), TagBasedImpressionsDetector (copy)
	local str = tostring(p9.props.itemId)
	local itemType = p9.props.itemType
	local listPadding = p9.props.listPadding
	local itemSubType = p9.props.itemSubType
	local itemData = p9.props.itemData
	local v123 = if not itemData then nil else itemData.collectibleItemId
	local width = p9.props.width
	local v125 = CatalogUtils.GetRbxThumbType(itemType)
	local u126 = if not FFlagAXThumbTypeNilCheck or not v125 then getRbxthumbWithTypeSizeAndOptions(str, v125, 420) else getRbxthumbWithTypeSizeAndOptions(str, v125, 420)
	local v127 = CatalogUtils.IsResellable(itemData)
	local u128 = itemData and (itemData.isOwned and v127)
	local u129 = p9.wearTimeOptions and #p9.wearTimeOptions > 0

	if FFlagAXInventoryDurablesSupport then
		local v130 = itemData and itemData.isOwned
		local v131 = itemData and (itemData.isOwned and itemData.expirationTime)

		u129 = u129 and (not v130 or v131)
	end

	local v132 = if not FFlagAXRemoveExpiredItemsFromInventory then nil else itemData and (itemData.expirationTime and not isDurableItemExpired(itemData.expirationTime))
	local is3DPreviewEnabled = nil
	local u134 = nil
	local id = nil
	local u136 = nil

	if AXItemDetails3DPreviewIXP.isEnabled() then
		local v137 = itemData and itemData.assetType

		u134 = itemData and itemData.bundleType
		u136 = itemData and itemData.items
		is3DPreviewEnabled = p9.state.is3DPreviewEnabled

		if itemType == Constants.ItemType.Asset then
			local v138 = is3DPreviewEnabled

			if v138 then
				v138 = Constants.ItemViewportAssetTypes[v137]
			end

			is3DPreviewEnabled = v138
		elseif itemType == Constants.ItemType.Bundle then
			is3DPreviewEnabled = is3DPreviewEnabled and Constants.ItemViewportBundleTypes[u134]
		end

		if not GetFFlagAXSupportShoesInItemViewport() and u136 then
			for _, v140 in u136 do
				if v140.type == Constants.ItemType.Outfit then
					id = v140.id

					break
				end
			end
		end
	end

	if GetFFlagRestrictLimited2ToSoothsayers() then
		u128 = u128 and p9.props.isCollectiblesEnabled
	end

	local v141 = p9.props.width * 9 / 16
	local v142 = p9.props.showFullWithNoPeekView and p9.props.bottomDockedContainerHeight > 0

	return withStyle(function(p11) -- line: 461
		-- upvalues: itemData (copy), p9 (copy), AvatarScreen (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXTryOnScreenImprovements (copy), p10 (copy), TextService (copy), Roact (copy), LinkButton (copy), v89 (copy), CatalogUtils (copy), MenuDirection (copy), FitFrameVertical (copy), listPadding (copy), RoactFitComponents (copy), FFlagAXItemDetailsIxpExposure (copy), IsVRAppBuild (copy), FitTextLabel (copy), Skeleton (copy), StyledTextLabel (copy), v141 (copy), AXItemDetails3DPreviewIXP (copy), is3DPreviewEnabled (ref), ItemViewport (copy), str (copy), itemType (copy), u134 (ref), GetFFlagAXSupportShoesInItemViewport (copy), id (ref), u136 (ref), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), LoadableImage (copy), u126 (ref), Button (copy), ButtonType (copy), Constants (copy), BundleItemsGrid (copy), FFlagEnableSocialProofOnItemDetails (copy), FriendsOwnedChip (copy), ItemDescription (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXRemoveExpiredItemsFromInventory (copy), v132 (copy), React (copy), ItemExpirationDisplay (copy), FFlagAXDurables2Option (copy), u129 (ref), WearTimeOptionsCarousel (copy), FFlagAXFavoritePillOnItemDetails (copy), FavoritePillContainer (copy), ItemStatistics (copy), width (copy), u128 (ref), ItemOwnershipButton (copy), v123 (copy), GetFFlagL2ControllerSupport (copy), ItemInfoList (copy), RecommendedItemsGrid (copy), itemSubType (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), v142 (copy), TagBasedImpressionsDetector (copy)
		local Theme = p11.Theme
		local p11Font = p11.Font
		local v211 = p11Font.BaseSize * p11Font.Header1.RelativeSize
		local v212 = if not itemData then nil else itemData.name
		local Header1Font = p11Font.Header1.Font
		local description = nil
		local favoriteCount = nil

		if itemData then
			description = itemData.description
			favoriteCount = itemData.favoriteCount
		end

		local v216 = p9.props.navigation.getParam("fromProfile")
		local v217 = p9.props.navigation.state.routeName == AvatarScreen.TryOnItem

		if FFlagAXEnableHomeTryOnComplexView or FFlagAXTryOnScreenImprovements then
			v217 = p9.props.simpleView or false
		end

		local v218 = p9:shouldShowRecommendedItems(v217)
		local tryOn = p10.tryOn
		local v220 = p11Font.BaseSize * p11Font.Header2.RelativeSize
		local v221 = 16 + TextService:GetTextSize(tryOn, v220, p11Font.Header2.Font, Vector2.new(10000, 10000)).X
		local v222 = p9.props.collectibleData and p9.props.collectibleData.unitsAvailableForConsumption == 0
		local v223 = not v217 and p9.props.enableAggregateLikesFavoritesCount
		local v224 = nil

		if p9.props.experiences then
			v224 = Roact.createElement(LinkButton, {
				minPaddingX = 0,
				layoutOrder = 1,
				text = if not p9.props.experiences or (#p9.props.experiences ~= 1 or not p9.props.experiences[1].name) then p10.inMultipleExperiences:gsub("{NUM_EXPERIENCES}", #p9.props.experiences) else p10.inSpecificExperience:gsub("{EXPERIENCE_NAME}", if not v89 then p9.props.experiences[1].name else function() -- line: 511
					-- upvalues: p9 (copy)
					return p9.props.experiences[1].name
				end),
				onActivated = function() -- line: 517
					-- upvalues: p9 (copy), AvatarScreen (copy), CatalogUtils (copy), itemData (copy), MenuDirection (copy)
					p9.props.navigation.navigate(AvatarScreen.ItemExperiencesMenu, {
						collectibleData = p9.props.collectibleData,
						isLimited = CatalogUtils.isLimitedCollectible(itemData),
						openPositionY = UDim.new(0, 100),
						menuDirection = MenuDirection.Down
					})
				end
			})
		end

		return Roact.createElement(FitFrameVertical, {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, listPadding),
			margin = RoactFitComponents.Rect.square(24),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			[Roact.Ref] = if not FFlagAXItemDetailsIxpExposure then nil else p9.props.itemDetailsContainerRef
		}, {
			ItemThumbnail = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}, {
				NameLabel = Roact.createElement(FitFrameVertical, {
					width = UDim.new(1, 0),
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					[Roact.Change.AbsolutePosition] = p9.onItemHeaderMoved
				}, {
					TextLabel = if not IsVRAppBuild() then if not v212 then Roact.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, v211)
					}) else Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = UDim.new(1, 0),
						Visible = p9.itemHeaderVisibleBinding,
						Font = Header1Font,
						Text = v212,
						TextSize = v211,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Theme.TextEmphasis.Color
					}, {}) else nil,
					RefUpdater = Roact.createElement("Frame", {
						Size = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						[Roact.Ref] = function(p12) -- line: 582
							-- upvalues: p9 (copy)
							if p12 and p12.Parent then
								p9.onItemHeaderMoved(p12.Parent)
							end
						end
					})
				}),
				ExperienceLinkDetails = if not p9.props.experiences then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, p11Font.BaseSize * p11Font.Body.RelativeSize)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					ExperienceLink = v224,
					DashDivider = if not v222 then nil else Roact.createElement(StyledTextLabel, {
						text = "-",
						layoutOrder = 2,
						automaticSize = Enum.AutomaticSize.XY,
						fontStyle = p11Font.Body,
						colorStyle = Theme.TextDefault
					}),
					SoldOutText = if not v222 then nil else Roact.createElement(StyledTextLabel, {
						layoutOrder = 3,
						automaticSize = Enum.AutomaticSize.XY,
						text = p10.soldOut,
						fontStyle = p11Font.Body,
						colorStyle = Theme.TextDefault
					})
				}),
				ItemImageFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ZIndex = 0,
					Size = UDim2.new(1, 0, 0, v141)
				}, {
					ItemBackground = Roact.createElement("Frame", {
						ZIndex = 0,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0),
						Size = UDim2.new(1, 48, 1, 0),
						BackgroundColor3 = Theme.BackgroundMuted.Color,
						BackgroundTransparency = Theme.BackgroundMuted.Transparency
					}, {
						UIGradient = Roact.createElement("UIGradient", {
							Rotation = -90,
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(0.4, 0),
								NumberSequenceKeypoint.new(1, 1)
							})
						})
					}),
					ItemViewport = if not AXItemDetails3DPreviewIXP.isEnabled() or not is3DPreviewEnabled then nil else Roact.createElement(ItemViewport, {
						anchorPoint = Vector2.new(0.5, 0),
						position = UDim2.fromScale(0.5, 0),
						size = UDim2.new(1, 48, 1, 0),
						itemId = str,
						itemType = itemType,
						bundleType = u134,
						outfitId = if GetFFlagAXSupportShoesInItemViewport() then nil else id,
						bundleItems = if not GetFFlagAXSupportShoesInItemViewport() then nil else u136,
						setParentScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p9.props.setItemDetailsScrollingEnabled,
						onLoadingFailed = p9.onItemViewportLoadingFailed
					}),
					Image = if not not AXItemDetails3DPreviewIXP.isEnabled() and is3DPreviewEnabled then nil else Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						Image = u126,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0),
						Size = UDim2.fromOffset(v141, v141)
					}),
					TryOnButtonFrame = if not v216 then nil else Roact.createElement("Frame", {
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1)
					}, {
						TryOnButton = Roact.createElement(Button, {
							buttonType = ButtonType.Secondary,
							position = UDim2.new(1, -v221 - 8, 1, -44),
							size = UDim2.fromOffset(v221, 36),
							text = tryOn,
							onActivated = p9.onTryOnActivated
						})
					})
				})
			}),
			IncludedItems = if v217 or itemType ~= Constants.ItemType.Bundle then nil else Roact.createElement(BundleItemsGrid, {
				LayoutOrder = 2,
				itemId = str,
				itemType = itemType
			}),
			ItemSocialProof = if not FFlagEnableSocialProofOnItemDetails then nil else Roact.createElement(FriendsOwnedChip, {
				layoutOrder = 3,
				itemId = str,
				itemType = itemType,
				fromProfile = v216
			}),
			ItemDescription = Roact.createElement(ItemDescription, {
				compactNumberOfLines = 3,
				descriptionText = description,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 3 or 4,
				[Roact.Ref] = p9.props.expandableTextRef
			}),
			ExpirationTimeContainer = if not (not not FFlagAXInventoryDurablesSupport and (not not p9.props.itemData and (not not p9.props.itemData.expirationTime and not FFlagAXRemoveExpiredItemsFromInventory))) and (not FFlagAXRemoveExpiredItemsFromInventory or not v132) then nil else React.createElement(ItemExpirationDisplay, {
				expirationTime = p9.props.itemData.expirationTime,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 4 or 5
			}),
			WearTimeOptionsCarousel = if FFlagAXDurables2Option or not u129 then nil else Roact.createElement(WearTimeOptionsCarousel, {
				useWrapping = true,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 5 or 6,
				options = p9.wearTimeOptions,
				onOptionActivated = p9.props.onWearTimeSelection
			}),
			ItemStatistics = v223 and if not FFlagAXFavoritePillOnItemDetails then Roact.createElement(ItemStatistics, {
				listPadding = 10,
				favoritesCount = favoriteCount,
				LayoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 5,
				width = width - 48
			}) else React.createElement(FavoritePillContainer, {
				kind = itemType,
				itemId = str,
				favoritesCount = favoriteCount,
				LayoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 5
			}),
			ItemOwnershipButton = if not u128 then nil else Roact.createElement(ItemOwnershipButton, {
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				layoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 6,
				itemId = str,
				isLimitedCollectible = p9.props.isLimitedCollectible,
				collectibleItemId = v123,
				onActivated = p9.onItemOwnershipButtonActivated,
				ref = if not GetFFlagL2ControllerSupport() then nil else p9.props.ownershipButtonRef
			}),
			ItemInfoList = not v217 and Roact.createElement(ItemInfoList, {
				itemId = str,
				itemType = itemType,
				LayoutOrder = (not FFlagEnableSocialProofOnItemDetails and 0 or 1) + 7 + (not FFlagAXInventoryDurablesSupport and 0 or 1),
				resellerRef = p9.props.resellerRef,
				attributionRef = p9.props.attributionRef
			}),
			RecommendedLabel = v218 and Roact.createElement(FitTextLabel, {
				TextWrapped = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				width = FitTextLabel.Width.FitToText,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p11Font.Header1.Font,
				LayoutOrder = if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 8 else 9,
				Position = UDim2.new(0, 0, 0, 0),
				Text = p10.recommendedLabel,
				TextSize = v211,
				TextColor3 = Theme.TextEmphasis.Color
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(math.max(p9.props.width - 24, 0), 1e999)
				})
			}),
			RecommendedItemsGrid = v218 and Roact.createElement(RecommendedItemsGrid, {
				itemId = str,
				itemSubType = itemSubType,
				itemType = itemType,
				onFetchRecommendationsFailed = if not GetFFlagAXHideRecommendationsOnFetchFailure() then nil else p9.onFetchRecommendationsFailed,
				LayoutOrder = if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 9 else 10,
				[Roact.Ref] = p9.props.recommendedItemsGridRef,
				itemDetailsPeekViewRefs = p9.props.itemDetailsPeekViewRefs,
				resultsListRef = p9.props.resultsListRef
			}),
			BottomContainerPlaceHolder = v142 and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Active = false,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 10 or 11,
				Size = UDim2.new(1, 0, 0, p9.props.bottomDockedContainerHeight)
			}),
			UnifiedImpressionsReporter = if not FFlagAXItemDetailsIxpExposure then nil else Roact.createElement(TagBasedImpressionsDetector, {
				parentRef = p9.props.itemDetailsContainerRef,
				pageFilter = function() -- line: 832
					-- upvalues: p9 (copy)
					return p9.props.navigation.state.key == p9.props.avatarRoute.current.key
				end,
				requestImpressionsSignal = p9.requestImpressionsSignal,
				extensions = p9.props.tagBasedImpressionsDetectorExtensions
			})
		})
	end)
end
function v96.renderDetails(p13) -- line: 846
	-- upvalues: withLocalization (copy)
	return withLocalization({
		recommendedLabel = "Feature.Catalog.Label.Recommendations",
		resellLabel = "Feature.Catalog.Heading.Sellers",
		tryOn = "Feature.Avatar.Action.TryOn",
		inMultipleExperiences = "Feature.Catalog.Label.InMultipleExperiences",
		inSpecificExperience = "Feature.Catalog.Label.InSpecificExperience",
		soldOut = "Feature.Catalog.Label.SoldOut"
	})(function(p14) -- line: 854
		-- upvalues: p13 (copy)
		return p13:renderDetailsWithProviders(p14)
	end)
end
function v96.renderOnFailed(p15) -- line: 859
	-- upvalues: getSafeAreaSize (copy), CatalogConstants (copy), withLocalization (copy), FFlagUpdateNoInternetConnectionText (copy), Roact (copy), EmptyState (copy)
	local fetchAssetOrBundleInfo = p15.fetchAssetOrBundleInfo
	local globalGuiInset = p15.props.globalGuiInset
	local screenSize = p15.props.screenSize
	local v148 = getSafeAreaSize(screenSize, globalGuiInset)
	local v149 = CatalogConstants.ActionBar.ActionBarHeight + CatalogConstants.ActionBar.ActionBarGradientHeight
	local v150 = withLocalization({
		emptyText = not FFlagUpdateNoInternetConnectionText and "Feature.EmptyStatePage.Message.NoInternet" or "Feature.DisplayName.ErrorMessage.SomethingWentWrong"
	})(function(p16) -- line: 872
		-- upvalues: Roact (copy), EmptyState (copy), fetchAssetOrBundleInfo (copy)
		return Roact.createElement(EmptyState, {
			onActivated = fetchAssetOrBundleInfo,
			text = p16.emptyText
		})
	end)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, v148.Y.Scale, v148.Y.Offset - v149)
	}, {
		EmptyStatePage = v150
	})
end
function v96.render(p17) -- line: 887
	-- upvalues: FitFrameVertical (copy), FFlagAXCustomizeMakeupSupport (copy), Roact (copy), FFlagAXItemDetailsIxpExposure (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), withStyle (copy)
	local clipDetails = p17.props.clipDetails
	local fetchingState = p17.props.fetchingState

	return withStyle(function(p18) -- line: 891
		-- upvalues: clipDetails (copy), FitFrameVertical (copy), FFlagAXCustomizeMakeupSupport (copy), Roact (copy), p17 (copy), FFlagAXItemDetailsIxpExposure (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), fetchingState (copy)
		local Theme = p18.Theme
		local v229 = if not clipDetails then FitFrameVertical else "Frame"

		if FFlagAXCustomizeMakeupSupport then
			v229 = "Frame"
		end

		return Roact.createElement(v229, {
			width = if clipDetails or FFlagAXCustomizeMakeupSupport then nil else UDim.new(1, 0),
			ClipsDescendants = clipDetails,
			Size = if not clipDetails then if not FFlagAXCustomizeMakeupSupport then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0),
			AutomaticSize = if not FFlagAXCustomizeMakeupSupport then nil else if not clipDetails then Enum.AutomaticSize.Y else nil,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			[Roact.Ref] = p17.props.forwardRef,
			[Roact.Change.AbsoluteSize] = function(p19) -- line: 917
				-- upvalues: p17 (copy)
				if p17.props.width ~= p19.AbsoluteSize.X then
					p17.props.setWidth(p19.AbsoluteSize.X)
				end
			end,
			[Roact.Change.AbsolutePosition] = if not FFlagAXItemDetailsIxpExposure then nil else function(_) -- line: 924
				-- upvalues: p17 (copy)
				p17.requestImpressionsSignal:fire()
			end
		}, {
			LoadingState = Roact.createElement(LoadingStateContainer, {
				dataStatus = RetrievalStatus2.fromRawValue(fetchingState),
				renderOnLoading = function() -- line: 931
					-- upvalues: p17 (copy)
					return p17:renderDetails()
				end,
				renderOnLoaded = function() -- line: 934
					-- upvalues: p17 (copy)
					return p17:renderDetails()
				end,
				renderOnFailed = function() -- line: 937
					-- upvalues: p17 (copy)
					return p17:renderOnFailed()
				end
			})
		})
	end)
end

local v97 = RoactRodux.connect(function(p21, p22) -- line: 946
	-- upvalues: PerformFetch (copy), CatalogUtils (copy), RetrievalStatus (copy), ItemData (copy), AvatarScreen (copy), GetFFlagRestrictLimited2ToSoothsayers (copy)
	local v156 = PerformFetch.GetStatus(p21, CatalogUtils.GetItemDetailsKey(p22.itemId, p22.itemType))
	local v157 = nil

	if v156 ~= RetrievalStatus.NotStarted then
		v157 = ItemData(p21.AvatarExperience.Common, p22.itemId, p22.itemType)
	end

	if p22.navigation.state.routeName == AvatarScreen.TryOnItem and v157 ~= nil and v157.name == nil then
		v157 = nil
	end

	local experiences = nil
	local isCollectiblesEnabled = nil
	local v160 = if not (if not v157 then nil else v157.collectibleItemId) or not v157 then nil else p21.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v157.collectibleItemId]
	local v161 = CatalogUtils.GetItemSubType(p22.itemType, v157)

	if v160 ~= nil then
		experiences = v160.experiences
	end

	if GetFFlagRestrictLimited2ToSoothsayers() then
		isCollectiblesEnabled = p21.AvatarExperience.Catalog.Metadata.isCollectiblesEnabled
	end

	local v162 = CatalogUtils.isLimitedCollectible(v157)

	return {
		globalGuiInset = p21.GlobalGuiInset,
		screenSize = p21.ScreenSize,
		fetchingState = v156,
		itemData = v157,
		itemSubType = v161,
		peekViewState = p21.AvatarExperience.Common.ItemDetailsPeekView.viewState,
		experiences = experiences,
		collectibleData = v160,
		isCollectiblesEnabled = isCollectiblesEnabled,
		isLimitedCollectible = v162
	}
end, function(p23, _) -- line: 991
	-- upvalues: FetchAssetOrBundleInfo (copy), NavigateDownToAvatarScreen (copy), ToggleTryOnThunk (copy)
	return {
		fetchAssetOrBundleInfo = function(p25, p26, p27, p28) -- line: 993
			-- upvalues: p23 (copy), FetchAssetOrBundleInfo (copy)
			return p23(FetchAssetOrBundleInfo(p25, p26, p27, p28))
		end,
		navigateDownToAvatarScreen = function(p29, p30, p31) -- line: 996
			-- upvalues: p23 (copy), NavigateDownToAvatarScreen (copy)
			return p23(NavigateDownToAvatarScreen(p29, p30, p31))
		end,
		toggleTryOn = function(p32, p33, p34, p35, p36, p37, p38, p39) -- line: 999
			-- upvalues: p23 (copy), ToggleTryOnThunk (copy)
			p23(ToggleTryOnThunk(p32, p33, p34, p35, p36, p37, p38, p39))
		end
	}
end)(v96)
local v98 = RoactAppPolicy.connect(function(p40, _) -- line: 1027
	return {
		enableAggregateLikesFavoritesCount = p40.getEnableAggregateLikesFavoritesCount()
	}
end)(v97)
local v99 = RoactNavigation.withNavigation(v98)

if FFlagAXItemDetailsIxpExposure then
	v99 = withAvatarRoute(v99)
end

local u100 = RoactServices.connect({
	appAnalytics = RoactAnalytics,
	catalogAnalytics = Analytics,
	networking = RoactNetworking
})(v99)

function checkCanItemDescriptionExpand(p42, p43, n1: number) -- line: 1045
	-- upvalues: GetCanExpand (copy)
	if not p42 or not p42.description then
		return false
	end

	local description = p42.description
	local v171 = n1 - 48

	return GetCanExpand(p43, v171, description, 3)
end

return React.forwardRef(function(p44, p45) -- line: 1056
	-- upvalues: React (copy), useStyle (copy), FFlagAXItemDetailsIxpExposure (copy), useSelector (copy), ItemData (copy), CatalogUtils (copy), GetFFlagL2ControllerSupport (copy), useFocusGuiObject (copy), useItemDetailsContainerFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), useUnifiedEventImpressionsReporter (copy), logItemDetailsIxpLayerExposure (copy), u100 (ref), Cryo (copy)
	local v174, v175 = React.useState(0)
	local v176 = useStyle()
	local v177 = nil

	if FFlagAXItemDetailsIxpExposure then
		v177 = React.useRef(nil)
	end

	local v178 = React.useRef(nil)
	local v179 = React.useRef(nil)
	local v180 = React.useRef(nil)
	local v181 = React.useRef(nil)
	local v182 = React.useRef(nil)
	local v183 = useSelector(function(p46) -- line: 1081
		-- upvalues: ItemData (copy), p44 (copy)
		return ItemData(p46.AvatarExperience.Common, p44.itemId, p44.itemType)
	end)
	local v184 = CatalogUtils.IsResellable(v183)
	local v185 = CatalogUtils.HasAttribution(v183)
	local v186 = v183 and (v183.isOwned and v184)
	local v187 = checkCanItemDescriptionExpand(v183, v176.Font, v174)
	local v188 = if not v183 or not v183.description then nil else v183.description
	local v189 = if not v187 then if not GetFFlagL2ControllerSupport() or not v186 then if not v184 then if not v185 then v182 else v181 else v180 else v179 else v178
	local v190 = if not v188 then nil else v189
	local v191 = useFocusGuiObject()
	local v192 = React.useCallback(function() -- line: 1102
		-- upvalues: v191 (copy), v190 (copy)
		if v191 and (v190 and v190.current) then
			v191(v190.current)
		end
	end, {
		v190,
		v191
	})
	local v193 = React.useCallback(function() -- line: 1108
		-- upvalues: v191 (copy), v182 (copy)
		if v191 and (v182 and v182.current) then
			v191(v182.current)
		end
	end, { v191 })
	local v194 = useItemDetailsContainerFocusNavigationBindings(p45, {
		onMoveToTop = v192,
		onMoveToRecItems = v193
	})
	local v195 = useTableWrappedCallbackRef(v194)
	local v196 = nil

	if FFlagAXItemDetailsIxpExposure then
		local v197 = useUnifiedEventImpressionsReporter()

		v196 = React.useMemo(function() -- line: 1124
			-- upvalues: v197 (copy), logItemDetailsIxpLayerExposure (copy)
			return {
				v197,
				logItemDetailsIxpLayerExposure
			}
		end, {
			v197,
			logItemDetailsIxpLayerExposure
		})
	end

	return React.createElement(u100, Cryo.Dictionary.join(p44, {
		width = v174,
		setWidth = v175,
		itemDetailsContainerRef = v177,
		expandableTextRef = v178,
		ownershipButtonRef = v179,
		resellerRef = v180,
		attributionRef = v181,
		recommendedItemsGridRef = v182,
		forwardRef = v195,
		tagBasedImpressionsDetectorExtensions = v196
	}))
end)
