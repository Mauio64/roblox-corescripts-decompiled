local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local t = require(CorePackages.Packages.t)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local ItemViewport = require(Modules.AvatarExperience.Common.Components.ItemViewport.ItemViewport)
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
local AvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarRoute
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local useUnifiedEventImpressionsReporter = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).useUnifiedEventImpressionsReporter
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceTimedOptions = require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions)
local WearTimeOptionsCarousel = AvatarExperienceTimedOptions.WearTimeOptionsCarousel
local ItemExpirationDisplay = AvatarExperienceTimedOptions.ItemExpirationDisplay
local isDurableItemExpired = AvatarExperienceCommon.Utils.isDurableItemExpired
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local FriendsOwnedChip = require(CorePackages.Workspace.Packages.SocialProof).Chips.FriendsOwnedChip
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ItemDataValidator = require(Modules.AvatarExperience.Common.Validators.ItemDataValidator)
local GetFFlagRestrictLimited2ToSoothsayers = require(Modules.AvatarExperience.Flags.GetFFlagRestrictLimited2ToSoothsayers)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GetFFlagL2ControllerSupport = require(Modules.AvatarExperience.Flags.GetFFlagL2ControllerSupport)
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions

require(Modules.AvatarExperience.Common.Types)

local GetFFlagAXItemDetailsScrollingEnabledCallback = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsScrollingEnabledCallback)
local AXItemDetails3DPreviewIXP = require(Modules.AvatarExperience.Experiments.AXItemDetails3DPreviewIXP)
local GetFFlagAXHideRecommendationsOnFetchFailure = require(Modules.AvatarExperience.Flags.GetFFlagAXHideRecommendationsOnFetchFailure)
local GetFFlagAXSupportShoesInItemViewport = require(Modules.AvatarExperience.Flags.GetFFlagAXSupportShoesInItemViewport)
local FFlagEnableSocialProofOnItemDetails = SharedFlags.FFlagEnableSocialProofOnItemDetails
local FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation = SharedFlags.FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local FFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local FFlagAXThumbTypeNilCheck = AvatarExperienceFlags.FFlagAXThumbTypeNilCheck
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXTryOnScreenImprovements = SharedFlags.FFlagAXTryOnScreenImprovements
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXTryOnScreenFixes = AvatarExperienceFlags.FFlagAXTryOnScreenFixes
local FFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local v89 = Roact.PureComponent:extend("ItemDetailsContainer")

v89.validateProps = t.strictInterface({
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
	peekViewFocusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.table else nil,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	forwardRef = t.optional(t.table),
	setItemDetailsScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else t.optional(t.callback),
	onWearTimeSelection = t.optional(t.callback),
	itemSubType = t.optional(t.string),
	assetType = t.optional(t.string),
	simpleView = if not FFlagAXEnableHomeTryOnComplexView and not FFlagAXTryOnScreenFixes then nil else t.optional(t.boolean),
	tagBasedImpressionsDetectorExtensions = if not FFlagAXItemDetailsIxpExposure then nil else t.table,
	globalGuiInset = t.strictInterface({
		left = t.integer,
		top = t.integer,
		right = t.integer,
		bottom = t.integer
	}),
	screenSize = t.Vector2,
	fetchingState = t.string,
	itemData = t.optional(ItemDataValidator),
	peekViewState = t.optional(t.valueOf(PeekViewState)),
	experiences = t.optional(t.table),
	collectibleData = t.optional(t.table),
	isCollectiblesEnabled = if not GetFFlagRestrictLimited2ToSoothsayers() then nil else t.optional(t.boolean),
	isLimitedCollectible = t.optional(t.boolean),
	fetchAssetOrBundleInfo = t.callback,
	navigateDownToAvatarScreen = t.callback,
	toggleTryOn = t.optional(t.callback),
	navigation = t.table,
	avatarRoute = if not FFlagAXItemDetailsIxpExposure then nil else AvatarRoute.Interface,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	showPremiumContent = t.optional(t.boolean),
	enableAggregateLikesFavoritesCount = t.boolean
})
v89.defaultProps = {
	clipDetails = false,
	listPadding = 24
}

function v89.init(p1) -- line: 204
	-- upvalues: FFlagAXItemDetailsIxpExposure (copy), Signal (copy), Roact (copy), GetFFlagL2ControllerSupport (copy), FFlagEnableSocialProofOnItemDetails (copy), AXItemDetails3DPreviewIXP (copy), IxpUtils (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy)
	if FFlagAXItemDetailsIxpExposure then
		p1.requestImpressionsSignal = Signal.new()
		p1.itemDetailsContainerRef = Roact.createRef()
	end

	p1.expandableTextRef = Roact.createRef()
	p1.ownershipButtonRef = if not GetFFlagL2ControllerSupport() then nil else Roact.createRef()
	p1.resellerRef = Roact.createRef()
	p1.attributionRef = Roact.createRef()
	p1.recommendedItemsGridRef = Roact.createRef()
	p1.socialProofRef = if not FFlagEnableSocialProofOnItemDetails then nil else Roact.createRef()
	p1.state = {
		width = 0,
		is3DPreviewEnabled = AXItemDetails3DPreviewIXP.isEnabled() and not not IxpUtils.readTestVariable(AXItemDetails3DPreviewIXP.EnableItemDetails3DPreview) or nil,
		fetchRecommendationsFailed = not GetFFlagAXHideRecommendationsOnFetchFailure() and nil,
		socialProofChipRendered = not FFlagEnableSocialProofOnItemDetails and nil
	}

	function p1.fetchAssetOrBundleInfo() -- line: 237
		-- upvalues: p1 (copy)
		local networking = p1.props.networking
		local appAnalytics = p1.props.appAnalytics
		local str = tostring(p1.props.itemId)
		local itemType = p1.props.itemType

		return p1.props.fetchAssetOrBundleInfo(networking, appAnalytics, str, itemType)
	end

	if AXItemDetails3DPreviewIXP.isEnabled() then
		function p1.onItemViewportLoadingFailed() -- line: 247
			-- upvalues: p1 (copy)
			p1:setState({
				is3DPreviewEnabled = false
			})
		end
	end

	p1:updateDurability()

	local v95, v96 = Roact.createBinding(false)

	p1.itemHeaderVisibleBinding = v95
	p1.updateItemHeaderVisibleBinding = v96

	function p1.onTryOnActivated() -- line: 257
		-- upvalues: p1 (copy), FFlagAXTryOnScreenImprovements (copy), AvatarScreen (copy)
		local t1 = {
			mountAsFullView = false,
			mountAnimation = false,
			itemId = p1.props.itemId,
			itemType = p1.props.itemType,
			itemDetailsPeekViewRefs = p1.props.itemDetailsPeekViewRefs,
			resultsListRef = p1.props.resultsListRef
		}
		local v178 = t1.itemType .. t1.itemId

		if FFlagAXTryOnScreenImprovements then
			t1.itemSubType = p1.props.itemSubType
		else
			p1.props.toggleTryOn(p1.props.networking, p1.props.catalogAnalytics, p1.props.itemType, p1.props.itemSubType, p1.props.itemId, true, nil, nil)
		end

		p1.props.navigateDownToAvatarScreen(AvatarScreen.TryOnItem, v178, t1)
	end
	function p1.onItemOwnershipButtonActivated() -- line: 286
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local collectibleItemId = p1.props.itemData.collectibleItemId

		p1.props.navigation.navigate(AvatarScreen.ItemOwnershipPage, {
			itemId = p1.props.itemId,
			collectibleItemId = collectibleItemId,
			itemType = p1.props.itemType
		})
	end
	function p1.onItemHeaderMoved(p2) -- line: 296
		-- upvalues: p1 (copy)
		if not p1.props.actionBarHeaderRef then
			return
		end

		local current = p1.props.actionBarHeaderRef.current

		if not current then
			return
		end

		local v182 = current.AbsolutePosition.Y > p2.AbsolutePosition.Y

		current.Visible = not v182
		p1.updateItemHeaderVisibleBinding(v182)
	end

	p1.hasCalledOnItemInvalid = false

	if GetFFlagAXHideRecommendationsOnFetchFailure() then
		function p1.onFetchRecommendationsFailed() -- line: 318
			-- upvalues: p1 (copy)
			p1:setState({
				fetchRecommendationsFailed = true
			})
		end
	end
end
function v89.canItemDescriptionExpand(p3, p4) -- line: 326
	-- upvalues: GetCanExpand (copy)
	local itemData = p3.props.itemData

	if not itemData or not itemData.description then
		return false
	end

	local description = itemData.description
	local v101 = p3.state.width - 48

	return GetCanExpand(p4, v101, description, 3)
end
function v89.updateDurability(p5) -- line: 338
	if p5.props.itemData and p5.props.itemData.timedOptions then
		p5.wearTimeOptions = p5.props.itemData.timedOptions
	end
end
function v89.didMount(p6) -- line: 344
	p6.fetchAssetOrBundleInfo()
end
function v89.didUpdate(p7, p8) -- line: 348
	-- upvalues: RetrievalStatus (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy)
	p7:updateDurability()

	local itemData = p7.props.itemData
	local fetchingState = p7.props.fetchingState
	local onItemInvalid = p7.props.onItemInvalid
	local v109 = fetchingState == RetrievalStatus.Done and itemData == nil
	local hasCalledOnItemInvalid = p7.hasCalledOnItemInvalid

	if onItemInvalid ~= nil and (not hasCalledOnItemInvalid and v109) then
		onItemInvalid()
		p7.hasCalledOnItemInvalid = true
	end

	if GetFFlagAXHideRecommendationsOnFetchFailure() and (p8.itemType ~= p7.props.itemType or p8.itemId ~= p7.props.itemId) then
		p7:setState({
			fetchRecommendationsFailed = false
		})
	end
end

if FFlagEnableSocialProofOnItemDetails then
	function v89.setSocialProofChipRendered(p9, p10) -- line: 376
		p9:setState({
			socialProofChipRendered = p10
		})
	end
end

function v89.shouldShowRecommendedItems(p11, p12) -- line: 390
	-- upvalues: CatalogUtils (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy)
	if p12 then
		return false
	end

	if p11.props.assetType and not CatalogUtils.doesAssetTypeHaveCatalogPage(p11.props.assetType) then
		return false
	end

	local itemData = p11.props.itemData

	if itemData and itemData.receivedRecommendedData and (itemData.recommendedItemSummaries == nil or #itemData.recommendedItemSummaries == 0) then
		return false
	end

	if GetFFlagAXHideRecommendationsOnFetchFailure() and p11.state.fetchRecommendationsFailed then
		return false
	end

	return true
end
function v89.renderDetailsWithProviders(p13, p14) -- line: 414
	-- upvalues: CatalogUtils (copy), FFlagAXThumbTypeNilCheck (copy), getRbxthumbWithTypeSizeAndOptions (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXRemoveExpiredItemsFromInventory (copy), isDurableItemExpired (copy), AXItemDetails3DPreviewIXP (copy), Constants (copy), GetFFlagAXSupportShoesInItemViewport (copy), GetFFlagRestrictLimited2ToSoothsayers (copy), withStyle (copy), PeekViewState (copy), GetFFlagL2ControllerSupport (copy), FFlagEnableSocialProofOnItemDetails (copy), FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation (copy), AvatarScreen (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXTryOnScreenImprovements (copy), TextService (copy), Roact (copy), LinkButton (copy), MenuDirection (copy), Focusable (copy), FitFrameVertical (copy), RoactFitComponents (copy), FFlagAXItemDetailsIxpExposure (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), IsVRAppBuild (copy), FitTextLabel (copy), Skeleton (copy), StyledTextLabel (copy), ItemViewport (copy), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), LoadableImage (copy), Button (copy), ButtonType (copy), BundleItemsGrid (copy), FriendsOwnedChip (copy), ItemDescription (copy), React (copy), ItemExpirationDisplay (copy), WearTimeOptionsCarousel (copy), ItemStatistics (copy), ItemOwnershipButton (copy), ItemInfoList (copy), RecommendedItemsGrid (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), TagBasedImpressionsDetector (copy)
	local str = tostring(p13.props.itemId)
	local itemType = p13.props.itemType
	local listPadding = p13.props.listPadding
	local itemSubType = p13.props.itemSubType
	local itemData = p13.props.itemData
	local v123 = if not itemData then nil else itemData.collectibleItemId
	local peekViewState = p13.props.peekViewState
	local width = p13.state.width
	local v126 = CatalogUtils.GetRbxThumbType(itemType)
	local u127 = if not FFlagAXThumbTypeNilCheck or not v126 then getRbxthumbWithTypeSizeAndOptions(str, v126, 420) else getRbxthumbWithTypeSizeAndOptions(str, v126, 420)
	local v128 = CatalogUtils.IsResellable(itemData)
	local v129 = CatalogUtils.HasAttribution(itemData)
	local u130 = itemData and (itemData.isOwned and v128)
	local u131 = p13.wearTimeOptions and #p13.wearTimeOptions > 0

	if FFlagAXInventoryDurablesSupport then
		local v132 = itemData and itemData.isOwned
		local v133 = itemData and (itemData.isOwned and itemData.expirationTime)

		u131 = u131 and (not v132 or v133)
	end

	local v134 = if not FFlagAXRemoveExpiredItemsFromInventory then nil else itemData and (itemData.expirationTime and not isDurableItemExpired(itemData.expirationTime))
	local is3DPreviewEnabled = nil
	local u136 = nil
	local id = nil
	local u138 = nil

	if AXItemDetails3DPreviewIXP.isEnabled() then
		local v139 = itemData and itemData.assetType

		u136 = itemData and itemData.bundleType
		u138 = itemData and itemData.items
		is3DPreviewEnabled = p13.state.is3DPreviewEnabled

		if itemType == Constants.ItemType.Asset then
			local v140 = is3DPreviewEnabled

			if v140 then
				v140 = Constants.ItemViewportAssetTypes[v139]
			end

			is3DPreviewEnabled = v140
		elseif itemType == Constants.ItemType.Bundle then
			is3DPreviewEnabled = is3DPreviewEnabled and Constants.ItemViewportBundleTypes[u136]
		end

		if not GetFFlagAXSupportShoesInItemViewport() and u138 then
			for _, v142 in u138 do
				if v142.type == Constants.ItemType.Outfit then
					id = v142.id

					break
				end
			end
		end
	end

	if GetFFlagRestrictLimited2ToSoothsayers() then
		u130 = u130 and p13.props.isCollectiblesEnabled
	end

	local v143 = p13.state.width * 9 / 16
	local v144 = p13.props.showFullWithNoPeekView and p13.props.bottomDockedContainerHeight > 0

	return withStyle(function(p15) -- line: 488
		-- upvalues: itemData (copy), peekViewState (copy), PeekViewState (copy), p13 (copy), GetFFlagL2ControllerSupport (copy), u130 (ref), v128 (copy), v129 (copy), FFlagEnableSocialProofOnItemDetails (copy), FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation (copy), AvatarScreen (copy), FFlagAXEnableHomeTryOnComplexView (copy), FFlagAXTryOnScreenImprovements (copy), p14 (copy), TextService (copy), Roact (copy), LinkButton (copy), CatalogUtils (copy), MenuDirection (copy), Focusable (copy), FitFrameVertical (copy), listPadding (copy), RoactFitComponents (copy), FFlagAXItemDetailsIxpExposure (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), IsVRAppBuild (copy), FitTextLabel (copy), Skeleton (copy), StyledTextLabel (copy), v143 (copy), AXItemDetails3DPreviewIXP (copy), is3DPreviewEnabled (ref), ItemViewport (copy), str (copy), itemType (copy), u136 (ref), GetFFlagAXSupportShoesInItemViewport (copy), id (ref), u138 (ref), GetFFlagAXItemDetailsScrollingEnabledCallback (copy), LoadableImage (copy), u127 (ref), Button (copy), ButtonType (copy), Constants (copy), BundleItemsGrid (copy), FriendsOwnedChip (copy), ItemDescription (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXRemoveExpiredItemsFromInventory (copy), v134 (copy), React (copy), ItemExpirationDisplay (copy), u131 (ref), WearTimeOptionsCarousel (copy), ItemStatistics (copy), width (copy), ItemOwnershipButton (copy), v123 (copy), ItemInfoList (copy), RecommendedItemsGrid (copy), itemSubType (copy), GetFFlagAXHideRecommendationsOnFetchFailure (copy), v144 (copy), TagBasedImpressionsDetector (copy)
		local Theme = p15.Theme
		local p15Font = p15.Font
		local v186 = p15Font.BaseSize * p15Font.Header1.RelativeSize
		local v187 = if not itemData then nil else itemData.name
		local Header1Font = p15Font.Header1.Font
		local v189 = peekViewState == PeekViewState.Full or peekViewState == PeekViewState.Extended
		local v190 = p13:canItemDescriptionExpand(p15Font)
		local v191 = if not v190 then if not GetFFlagL2ControllerSupport() or not u130 then if not v128 then if not v129 then p13.recommendedItemsGridRef else p13.attributionRef else p13.resellerRef else p13.ownershipButtonRef else p13.expandableTextRef
		local description = nil
		local favoriteCount = nil

		if itemData then
			description = itemData.description
			favoriteCount = itemData.favoriteCount
		end

		local v194 = if not description then nil else v191
		local v195 = if not FFlagEnableSocialProofOnItemDetails or not p13.state.socialProofChipRendered then p13.props.NextSelectionUp else p13.socialProofRef
		local v196 = if not FFlagEnableSocialProofOnItemDetails or not FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation then nil else function(p16) -- line: 523
			-- upvalues: p13 (copy)
			p13:setSocialProofChipRendered(p16)
		end
		local v197 = p13.props.navigation.getParam("fromProfile")
		local v198 = p13.props.navigation.state.routeName == AvatarScreen.TryOnItem

		if FFlagAXEnableHomeTryOnComplexView or FFlagAXTryOnScreenImprovements then
			v198 = p13.props.simpleView or false
		end

		local v199 = p13:shouldShowRecommendedItems(v198)
		local tryOn = p14.tryOn
		local v201 = p15Font.BaseSize * p15Font.Header2.RelativeSize
		local v202 = 16 + TextService:GetTextSize(tryOn, v201, p15Font.Header2.Font, Vector2.new(10000, 10000)).X
		local v203 = p13.props.collectibleData and p13.props.collectibleData.unitsAvailableForConsumption == 0
		local v204 = not v198 and p13.props.enableAggregateLikesFavoritesCount
		local v205 = nil

		if p13.props.experiences then
			v205 = Roact.createElement(LinkButton, {
				minPaddingX = 0,
				layoutOrder = 1,
				text = if not p13.props.experiences or (#p13.props.experiences ~= 1 or not p13.props.experiences[1].name) then p14.inMultipleExperiences else p14.inSpecificExperience,
				onActivated = function() -- line: 559
					-- upvalues: p13 (copy), AvatarScreen (copy), CatalogUtils (copy), itemData (copy), MenuDirection (copy)
					p13.props.navigation.navigate(AvatarScreen.ItemExperiencesMenu, {
						collectibleData = p13.props.collectibleData,
						isLimited = CatalogUtils.isLimitedCollectible(itemData),
						openPositionY = UDim.new(0, 100),
						menuDirection = MenuDirection.Down
					})
				end
			})
		end

		return Roact.createElement(Focusable[FitFrameVertical], {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, listPadding),
			margin = RoactFitComponents.Rect.square(24),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			defaultChild = v194,
			restorePreviousChildFocus = true,
			[Roact.Ref] = if not FFlagAXItemDetailsIxpExposure then nil else p13.itemDetailsContainerRef,
			inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus then {
				MoveToTop = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonL2, function() -- line: 591
					-- upvalues: p13 (copy), v194 (copy)
					p13.props.peekViewFocusController.moveFocusTo(v194)
				end),
				MoveToRecItemsGrid = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonR2, function() -- line: 594
					-- upvalues: p13 (copy)
					p13.props.peekViewFocusController.moveFocusTo(p13.recommendedItemsGridRef)
				end)
			} else nil
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
					[Roact.Change.AbsolutePosition] = p13.onItemHeaderMoved
				}, {
					TextLabel = if not IsVRAppBuild() then if not v187 then Roact.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, v186)
					}) else Roact.createElement(FitTextLabel, {
						BackgroundTransparency = 1,
						TextWrapped = true,
						width = UDim.new(1, 0),
						Visible = p13.itemHeaderVisibleBinding,
						Font = Header1Font,
						Text = v187,
						TextSize = v186,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = Theme.TextEmphasis.Color
					}, {}) else nil,
					RefUpdater = Roact.createElement("Frame", {
						Size = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						[Roact.Ref] = function(p17) -- line: 637
							-- upvalues: p13 (copy)
							if p17 and p17.Parent then
								p13.onItemHeaderMoved(p17.Parent)
							end
						end
					})
				}),
				ExperienceLinkDetails = if not p13.props.experiences then nil else Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, p15Font.BaseSize * p15Font.Body.RelativeSize)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					ExperienceLink = v205,
					DashDivider = if not v203 then nil else Roact.createElement(StyledTextLabel, {
						text = "-",
						layoutOrder = 2,
						automaticSize = Enum.AutomaticSize.XY,
						fontStyle = p15Font.Body,
						colorStyle = Theme.TextDefault
					}),
					SoldOutText = if not v203 then nil else Roact.createElement(StyledTextLabel, {
						layoutOrder = 3,
						automaticSize = Enum.AutomaticSize.XY,
						text = p14.soldOut,
						fontStyle = p15Font.Body,
						colorStyle = Theme.TextDefault
					})
				}),
				ItemImageFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ZIndex = 0,
					Size = UDim2.new(1, 0, 0, v143)
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
						bundleType = u136,
						outfitId = if GetFFlagAXSupportShoesInItemViewport() then nil else id,
						bundleItems = if not GetFFlagAXSupportShoesInItemViewport() then nil else u138,
						setParentScrollingEnabled = if not GetFFlagAXItemDetailsScrollingEnabledCallback() then nil else p13.props.setItemDetailsScrollingEnabled,
						onLoadingFailed = p13.onItemViewportLoadingFailed
					}),
					Image = if not not AXItemDetails3DPreviewIXP.isEnabled() and is3DPreviewEnabled then nil else Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						Image = u127,
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0),
						Size = UDim2.fromOffset(v143, v143)
					}),
					TryOnButtonFrame = if not v197 then nil else Roact.createElement("Frame", {
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1)
					}, {
						TryOnButton = Roact.createElement(Button, {
							buttonType = ButtonType.Secondary,
							position = UDim2.new(1, -v202 - 8, 1, -44),
							size = UDim2.fromOffset(v202, 36),
							text = tryOn,
							onActivated = p13.onTryOnActivated
						})
					})
				})
			}),
			IncludedItems = if v198 or itemType ~= Constants.ItemType.Bundle then nil else Roact.createElement(BundleItemsGrid, {
				LayoutOrder = 2,
				itemId = str,
				itemType = itemType
			}),
			ItemSocialProof = if not FFlagEnableSocialProofOnItemDetails then nil else Roact.createElement(FriendsOwnedChip, {
				layoutOrder = 3,
				itemId = str,
				itemType = itemType,
				fromProfile = v197,
				ref = p13.socialProofRef,
				chipIsRenderedCallback = if not FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation then nil else v196,
				NextSelectionUp = p13.props.NextSelectionUp,
				NextSelectionDown = p13.expandableTextRef
			}),
			ItemDescription = Roact.createElement(ItemDescription, {
				compactNumberOfLines = 3,
				descriptionText = description,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 3 or 4,
				[Roact.Ref] = p13.expandableTextRef,
				NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else if not FFlagEnableSocialProofOnItemDetails then p13.props.NextSelectionUp else v195,
				NextSelectionDown = if not GetFFlagL2ControllerSupport() then if not v189 then nil else if not v128 then if not v129 then p13.recommendedItemsGridRef else p13.attributionRef else p13.resellerRef else if not v189 or not u130 then if not v189 or not v128 then if not v189 or not v129 then if not v189 then p13.props.NextSelectionDown else p13.recommendedItemsGridRef else p13.attributionRef else p13.resellerRef else p13.ownershipButtonRef
			}),
			ExpirationTimeContainer = if not (not not FFlagAXInventoryDurablesSupport and (not not p13.props.itemData and (not not p13.props.itemData.expirationTime and not FFlagAXRemoveExpiredItemsFromInventory))) and (not FFlagAXRemoveExpiredItemsFromInventory or not v134) then nil else React.createElement(ItemExpirationDisplay, {
				expirationTime = p13.props.itemData.expirationTime,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 4 or 5
			}),
			WearTimeOptionsCarousel = if not u131 then nil else Roact.createElement(WearTimeOptionsCarousel, {
				useWrapping = true,
				LayoutOrder = not FFlagEnableSocialProofOnItemDetails and 5 or 6,
				options = p13.wearTimeOptions,
				onOptionActivated = p13.props.onWearTimeSelection
			}),
			ItemStatistics = v204 and Roact.createElement(ItemStatistics, {
				listPadding = 10,
				favoritesCount = favoriteCount,
				LayoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 5,
				width = width - 48
			}),
			ItemOwnershipButton = if not u130 then nil else Roact.createElement(ItemOwnershipButton, {
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				layoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 6,
				itemId = str,
				isLimitedCollectible = p13.props.isLimitedCollectible,
				collectibleItemId = v123,
				onActivated = p13.onItemOwnershipButtonActivated,
				ref = if not GetFFlagL2ControllerSupport() then nil else p13.ownershipButtonRef,
				NextSelectionUp = if not GetFFlagL2ControllerSupport() then nil else if not v189 or not v190 then if not FFlagEnableSocialProofOnItemDetails then p13.props.NextSelectionUp else v195 else p13.expandableTextRef,
				NextSelectionDown = if not GetFFlagL2ControllerSupport() then nil else if not v189 or not v128 then if not v189 or not v129 then if not v189 then p13.props.NextSelectionDown else p13.recommendedItemsGridRef else p13.attributionRef else p13.resellerRef
			}),
			ItemInfoList = not v198 and Roact.createElement(ItemInfoList, {
				itemId = str,
				itemType = itemType,
				LayoutOrder = ((if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 0 else 1)) + 7,
				resellerRef = p13.resellerRef,
				attributionRef = p13.attributionRef,
				NextSelectionUp = if not GetFFlagL2ControllerSupport() then v189 and (not not v190 and p13.expandableTextRef) or nil else if not v189 or not u130 then if not v189 or not v190 then if not FFlagEnableSocialProofOnItemDetails then p13.props.NextSelectionUp else v195 else p13.expandableTextRef else p13.ownershipButtonRef,
				NextSelectionDown = if not GetFFlagL2ControllerSupport() then v189 and p13.recommendedItemsGridRef or nil else if not v189 then p13.props.NextSelectionDown else p13.recommendedItemsGridRef
			}),
			RecommendedLabel = v199 and Roact.createElement(FitTextLabel, {
				TextWrapped = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				width = FitTextLabel.Width.FitToText,
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p15Font.Header1.Font,
				LayoutOrder = if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 8 else 9,
				Position = UDim2.new(0, 0, 0, 0),
				Text = p14.recommendedLabel,
				TextSize = v186,
				TextColor3 = Theme.TextEmphasis.Color
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(math.max(p13.state.width - 24, 0), 1e999)
				})
			}),
			RecommendedItemsGrid = v199 and Roact.createElement(RecommendedItemsGrid, {
				itemId = str,
				itemSubType = itemSubType,
				itemType = itemType,
				onFetchRecommendationsFailed = if not GetFFlagAXHideRecommendationsOnFetchFailure() then nil else p13.onFetchRecommendationsFailed,
				LayoutOrder = if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 9 else 10,
				[Roact.Ref] = p13.recommendedItemsGridRef,
				NextSelectionUp = if not v189 or not v129 then if not GetFFlagL2ControllerSupport() then v128 and p13.resellerRef or (v190 and p13.expandableTextRef or nil) else if not v189 or not v128 then if not v189 or not u130 then if not v189 or not v190 then if not FFlagEnableSocialProofOnItemDetails then p13.props.NextSelectionUp else v195 else p13.expandableTextRef else p13.ownershipButtonRef else p13.resellerRef else p13.attributionRef,
				NextSelectionDown = p13.props.NextSelectionDown,
				itemDetailsPeekViewRefs = p13.props.itemDetailsPeekViewRefs,
				resultsListRef = p13.props.resultsListRef
			}),
			BottomContainerPlaceHolder = v144 and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Active = false,
				LayoutOrder = if not FFlagEnableSocialProofOnItemDetails then (not FFlagAXInventoryDurablesSupport and 0 or 1) + 10 else 11,
				Size = UDim2.new(1, 0, 0, p13.props.bottomDockedContainerHeight)
			}),
			UnifiedImpressionsReporter = if not FFlagAXItemDetailsIxpExposure then nil else Roact.createElement(TagBasedImpressionsDetector, {
				parentRef = p13.itemDetailsContainerRef,
				pageFilter = function() -- line: 940
					-- upvalues: p13 (copy)
					return p13.props.navigation.state.key == p13.props.avatarRoute.current.key
				end,
				requestImpressionsSignal = p13.requestImpressionsSignal,
				extensions = p13.props.tagBasedImpressionsDetectorExtensions
			})
		})
	end)
end
function v89.renderDetails(p18) -- line: 954
	-- upvalues: withLocalization (copy)
	return withLocalization({
		recommendedLabel = "Feature.Catalog.Label.Recommendations",
		resellLabel = "Feature.Catalog.Heading.Sellers",
		tryOn = "Feature.Avatar.Action.TryOn",
		soldOut = "Feature.Catalog.Label.SoldOut",
		inMultipleExperiences = {
			"Feature.Catalog.Label.InMultipleExperiences",
			NUM_EXPERIENCES = not p18.props.experiences and 0 or #p18.props.experiences
		},
		inSpecificExperience = {
			"Feature.Catalog.Label.InSpecificExperience",
			EXPERIENCE_NAME = not p18.props.experiences and "" or p18.props.experiences[1].name
		}
	})(function(p19) -- line: 968
		-- upvalues: p18 (copy)
		return p18:renderDetailsWithProviders(p19)
	end)
end
function v89.renderOnFailed(p20) -- line: 973
	-- upvalues: getSafeAreaSize (copy), CatalogConstants (copy), withLocalization (copy), Roact (copy), EmptyState (copy)
	local fetchAssetOrBundleInfo = p20.fetchAssetOrBundleInfo
	local globalGuiInset = p20.props.globalGuiInset
	local screenSize = p20.props.screenSize
	local v150 = getSafeAreaSize(screenSize, globalGuiInset)
	local v151 = CatalogConstants.ActionBar.ActionBarHeight + CatalogConstants.ActionBar.ActionBarGradientHeight
	local v152 = withLocalization({
		emptyText = "Feature.EmptyStatePage.Message.NoInternet"
	})(function(p21) -- line: 984
		-- upvalues: Roact (copy), EmptyState (copy), fetchAssetOrBundleInfo (copy)
		return Roact.createElement(EmptyState, {
			onActivated = fetchAssetOrBundleInfo,
			text = p21.emptyText
		})
	end)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, v150.Y.Scale, v150.Y.Offset - v151)
	}, {
		EmptyStatePage = v152
	})
end
function v89.render(p22) -- line: 999
	-- upvalues: FitFrameVertical (copy), FFlagAXCustomizeMakeupSupport (copy), Roact (copy), FFlagAXItemDetailsIxpExposure (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), withStyle (copy)
	local clipDetails = p22.props.clipDetails
	local fetchingState = p22.props.fetchingState

	return withStyle(function(p23) -- line: 1003
		-- upvalues: clipDetails (copy), FitFrameVertical (copy), FFlagAXCustomizeMakeupSupport (copy), Roact (copy), p22 (copy), FFlagAXItemDetailsIxpExposure (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), fetchingState (copy)
		local Theme = p23.Theme
		local v210 = if not clipDetails then FitFrameVertical else "Frame"

		if FFlagAXCustomizeMakeupSupport then
			v210 = "Frame"
		end

		return Roact.createElement(v210, {
			width = if clipDetails or FFlagAXCustomizeMakeupSupport then nil else UDim.new(1, 0),
			ClipsDescendants = clipDetails,
			Size = if not clipDetails then if not FFlagAXCustomizeMakeupSupport then nil else UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0),
			AutomaticSize = if not FFlagAXCustomizeMakeupSupport then nil else if not clipDetails then Enum.AutomaticSize.Y else nil,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			[Roact.Ref] = p22.props.forwardRef,
			[Roact.Change.AbsoluteSize] = function(p24) -- line: 1029
				-- upvalues: p22 (copy)
				if p22.state.width ~= p24.AbsoluteSize.X then
					p22:setState({
						width = p24.AbsoluteSize.X
					})
				end
			end,
			[Roact.Change.AbsolutePosition] = if not FFlagAXItemDetailsIxpExposure then nil else function(_) -- line: 1038
				-- upvalues: p22 (copy)
				p22.requestImpressionsSignal:fire()
			end
		}, {
			LoadingState = Roact.createElement(LoadingStateContainer, {
				dataStatus = RetrievalStatus2.fromRawValue(fetchingState),
				renderOnLoading = function() -- line: 1045
					-- upvalues: p22 (copy)
					return p22:renderDetails()
				end,
				renderOnLoaded = function() -- line: 1048
					-- upvalues: p22 (copy)
					return p22:renderDetails()
				end,
				renderOnFailed = function() -- line: 1051
					-- upvalues: p22 (copy)
					return p22:renderOnFailed()
				end
			})
		})
	end)
end

local v90 = RoactRodux.connect(function(p26, p27) -- line: 1060
	-- upvalues: PerformFetch (copy), CatalogUtils (copy), RetrievalStatus (copy), ItemData (copy), AvatarScreen (copy), GetFFlagRestrictLimited2ToSoothsayers (copy)
	local v158 = PerformFetch.GetStatus(p26, CatalogUtils.GetItemDetailsKey(p27.itemId, p27.itemType))
	local v159 = nil

	if v158 ~= RetrievalStatus.NotStarted then
		v159 = ItemData(p26.AvatarExperience.Common, p27.itemId, p27.itemType)
	end

	if p27.navigation.state.routeName == AvatarScreen.TryOnItem and v159 ~= nil and v159.name == nil then
		v159 = nil
	end

	local experiences = nil
	local isCollectiblesEnabled = nil
	local v162 = if not (if not v159 then nil else v159.collectibleItemId) or not v159 then nil else p26.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v159.collectibleItemId]
	local v163 = CatalogUtils.GetItemSubType(p27.itemType, v159)

	if v162 ~= nil then
		experiences = v162.experiences
	end

	if GetFFlagRestrictLimited2ToSoothsayers() then
		isCollectiblesEnabled = p26.AvatarExperience.Catalog.Metadata.isCollectiblesEnabled
	end

	local v164 = CatalogUtils.isLimitedCollectible(v159)

	return {
		globalGuiInset = p26.GlobalGuiInset,
		screenSize = p26.ScreenSize,
		fetchingState = v158,
		itemData = v159,
		itemSubType = v163,
		peekViewState = p26.AvatarExperience.Common.ItemDetailsPeekView.viewState,
		experiences = experiences,
		collectibleData = v162,
		isCollectiblesEnabled = isCollectiblesEnabled,
		isLimitedCollectible = v164
	}
end, function(p28, _) -- line: 1105
	-- upvalues: FetchAssetOrBundleInfo (copy), NavigateDownToAvatarScreen (copy), ToggleTryOnThunk (copy)
	return {
		fetchAssetOrBundleInfo = function(p30, p31, p32, p33) -- line: 1107
			-- upvalues: p28 (copy), FetchAssetOrBundleInfo (copy)
			return p28(FetchAssetOrBundleInfo(p30, p31, p32, p33))
		end,
		navigateDownToAvatarScreen = function(p34, p35, p36) -- line: 1110
			-- upvalues: p28 (copy), NavigateDownToAvatarScreen (copy)
			return p28(NavigateDownToAvatarScreen(p34, p35, p36))
		end,
		toggleTryOn = function(p37, p38, p39, p40, p41, p42, p43, p44) -- line: 1113
			-- upvalues: p28 (copy), ToggleTryOnThunk (copy)
			p28(ToggleTryOnThunk(p37, p38, p39, p40, p41, p42, p43, p44))
		end
	}
end)(v89)
local v91 = RoactAppPolicy.connect(function(p45, _) -- line: 1141
	return {
		enableAggregateLikesFavoritesCount = p45.getEnableAggregateLikesFavoritesCount()
	}
end)(v90)
local v92 = RoactNavigation.withNavigation(v91)

if FFlagAXItemDetailsIxpExposure then
	v92 = withAvatarRoute(v92)
end

local u93 = RoactServices.connect({
	appAnalytics = RoactAnalytics,
	catalogAnalytics = Analytics,
	networking = RoactNetworking
})(v92)

return Roact.forwardRef(function(p47, p48) -- line: 1159
	-- upvalues: FFlagAXItemDetailsIxpExposure (copy), useUnifiedEventImpressionsReporter (copy), React (copy), logItemDetailsIxpLayerExposure (copy), Roact (copy), u93 (ref), Cryo (copy)
	local v171 = nil

	if FFlagAXItemDetailsIxpExposure then
		local v172 = useUnifiedEventImpressionsReporter()

		v171 = React.useMemo(function() -- line: 1163
			-- upvalues: v172 (copy), logItemDetailsIxpLayerExposure (copy)
			return {
				v172,
				logItemDetailsIxpLayerExposure
			}
		end, {
			v172,
			logItemDetailsIxpLayerExposure
		})
	end

	return Roact.createElement(u93, Cryo.Dictionary.join(p47, {
		forwardRef = p48,
		tagBasedImpressionsDetectorExtensions = v171
	}))
end)
