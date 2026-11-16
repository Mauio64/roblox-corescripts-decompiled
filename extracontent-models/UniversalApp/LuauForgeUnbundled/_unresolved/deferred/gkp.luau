local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dYT")
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local t = require(CorePackages.Packages.t)
local module2 = require("@luauforge/bundled/dMB")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module5 = require("@luauforge/bundled/fsK")
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module6 = require("@luauforge/bundled/eda")
local module7 = require("@luauforge/bundled/dxy")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module8 = require("@luauforge/bundled/fvF")
local module9 = require("@luauforge/deferred/gkq")
local itemViewport = module9.ItemViewport
local itemMediaHeader = module9.ItemMediaHeader

local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector

local useUnifiedEventImpressionsReporter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").useUnifiedEventImpressionsReporter

local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
local getCanExpand = UIBlox.Core.Text.ExpandableText.GetCanExpand
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local emptyState = UIBlox.App.Indicator.EmptyState
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local linkButton = UIBlox.App.Button.LinkButton
local menuDirection = UIBlox.App.Menu.MenuDirection
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local fitTextLabel = roactFitComponents.FitTextLabel

local getSafeAreaSize = require("@luauforge/bundled/fuE").getSafeAreaSize
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local navigateDownToAvatarScreen = AvatarExperienceNavigation.Thunks.NavigateDownToAvatarScreen
local module10 = require("@luauforge/bundled/dTM")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module11 = require("@luauforge/bundled/dRQ")
local module12 = require("@luauforge/bundled/dME")
local module13 = require("@luauforge/bundled/dMx")
local module14 = require("@luauforge/deferred/gkr")
local module15 = require("@luauforge/deferred/gkt")
local module16 = require("@luauforge/deferred/gku")
local module17 = require("@luauforge/deferred/gkv")
local module18 = require("@luauforge/deferred/gkJ")
local module19 = require("@luauforge/deferred/gkT")

local module20 = require("@luauforge/deferred/gkU")
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local module21 = require("@luauforge/bundled/fvZ")
local module22 = require("@luauforge/bundled/fve")

local friendsOwnedChip = require("@luauforge/bundled/cBW").Chips.FriendsOwnedChip

local module23 = require("@luauforge/bundled/fuC")

local module24 = require("@luauforge/deferred/ggy")

local module25 = require("@luauforge/deferred/gkV")

local module26 = require("@luauforge/deferred/gld")
local module27 = require("@luauforge/deferred/glh")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local backgroundHighlight = AvatarExperienceCommon.Components.BackgroundHighlight
local licensingBadge = AvatarExperienceCommon.Components.LicensingBadge
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module29 = require("@luauforge/deferred/fvC")
local wearTimeOptionsCarousel = module29.WearTimeOptionsCarousel
local itemExpirationDisplay = module29.ItemExpirationDisplay
local isDurableItemExpired = AvatarExperienceCommon.Utils.isDurableItemExpired
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module30 = require("@luauforge/deferred/ggK")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local module31 = require("@luauforge/deferred/gli")

local module32 = require("@luauforge/deferred/gks")
local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/cgr").Utils.getRbxthumbWithTypeSizeAndOptions
require("@luauforge/bundled/dMc")

local module33 = require("@luauforge/deferred/glj")
local module34 = require("@luauforge/bundled/dMz")

local module35 = require("@luauforge/deferred/gkS")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXEnableHomeTryOnComplexView = SharedFlags.FFlagAXEnableHomeTryOnComplexView
local fFlagUpdateNoInternetConnectionText = AvatarExperienceFlags.FFlagUpdateNoInternetConnectionText
local fFlagAXItemDetailsIxpExposure = AvatarExperienceFlags.FFlagAXItemDetailsIxpExposure
local fFlagAXItemDetailsMediaHeader = AvatarExperienceFlags.FFlagAXItemDetailsMediaHeader
local fFlagAXItemDetailsDescriptionLinks = AvatarExperienceFlags.FFlagAXItemDetailsDescriptionLinks
local module37 = require("@luauforge/deferred/glk")

local module38 = require("@luauforge/deferred/glT")

local defineFastFlag = game:DefineFastFlag("DebugAXItemDetailsDescription", false)
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXThumbTypeNilCheck = AvatarExperienceFlags.FFlagAXThumbTypeNilCheck
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagEnableSocialProofOnItemDetails = SharedFlags.FFlagEnableSocialProofOnItemDetails
local defineFastFlag2 = game:DefineFastFlag("AXFixItemDetailsContainerGuiInsetType", false)
local fFlagAXTryOnScreenFixes = AvatarExperienceFlags.FFlagAXTryOnScreenFixes
local fFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXFavoritePillOnItemDetails = AvatarExperienceFlags.FFlagAXFavoritePillOnItemDetails
local fFlagAXFavoritesPillExposureLogging = AvatarExperienceFlags.FFlagAXFavoritesPillExposureLogging
local fFlagAXFixItemDetailsDescriptionSpacing = AvatarExperienceFlags.FFlagAXFixItemDetailsDescriptionSpacing
local fFlagAXItemDetailsPartialAssetInfoFix = AvatarExperienceFlags.FFlagAXItemDetailsPartialAssetInfoFix
local fFlagAXBackgroundsEquipTryOnCounters = AvatarExperienceFlags.FFlagAXBackgroundsEquipTryOnCounters
local fFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails

local reportBackgroundUserActionCounter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").reportBackgroundUserActionCounter

local extended = Roact.PureComponent:extend("ItemDetailsContainer")

local strictInterface = t.strictInterface
local v5 = {}

v5.actionBarHeaderRef = t.table
v5.clipDetails = t.optional(t.boolean)
v5.listPadding = t.optional(t.numberPositive)
v5.itemId = t.string
v5.itemType = t.string
v5.onItemInvalid = t.optional(t.callback)
v5.showFullWithNoPeekView = t.optional(t.boolean)
v5.bottomDockedContainerHeight = t.optional(t.number)
v5.resultsListRef = t.optional(t.table)
v5.itemDetailsPeekViewRefs = t.optional(t.table)
v5.NextSelectionDown = t.optional(t.table)
v5.NextSelectionUp = t.optional(t.table)
v5.NextSelectionLeft = t.optional(t.table)
v5.NextSelectionRight = t.optional(t.table)
v5.forwardRef = t.optional(t.table)
local v6 = if module33() then t.optional(t.callback) else nil
v5.setItemDetailsScrollingEnabled = v6

v5.itemSubType = t.optional(t.string)
v5.assetType = t.optional(t.string)
local v7 = if fFlagAXEnableHomeTryOnComplexView or fFlagAXTryOnScreenFixes then t.optional(t.boolean) else nil
v5.simpleView = v7
v5.width = t.number
v5.setWidth = t.callback
local v8 = if fFlagAXItemDetailsIxpExposure then t.table else nil
v5.itemDetailsContainerRef = v8
v5.expandableTextRef = t.table
v5.ownershipButtonRef = t.table
v5.resellerRef = t.table
v5.attributionRef = t.table
v5.recommendedItemsGridRef = t.table
local v9 = if fFlagAXItemDetailsIxpExposure then t.table else nil
v5.tagBasedImpressionsDetectorExtensions = v9
v5.onWearTimeSelection = t.optional(t.callback)
local v10 = if fFlagAXItemDetailsDescriptionLinks then t.optional(t.callback) else nil
v5.openDescriptionLinkItem = v10
local v11 = if fFlagAXItemDetailsDescriptionLinks then t.optional(t.callback) else nil
v5.onDescriptionCanExpandChanged = v11

local strictInterface2 = t.strictInterface
local v13 = if defineFastFlag2 then t.number else t.integer
local v14 = if defineFastFlag2 then t.number else t.integer
local v15 = if defineFastFlag2 then t.number else t.integer
local v16 = if defineFastFlag2 then t.number else t.integer
v5.globalGuiInset = strictInterface2({
	left = v13,
	top = v14,
	right = v15,
	bottom = v16
})

v5.screenSize = t.Vector2
v5.fetchingState = t.string
v5.itemData = t.optional(module24)
v5.peekViewState = t.optional(t.valueOf(peekViewState))
v5.experiences = t.optional(t.table)
v5.collectibleData = t.optional(t.table)
local v17 = if module30() then t.optional(t.boolean) else nil
v5.isCollectiblesEnabled = v17
v5.isLimitedCollectible = t.optional(t.boolean)

local v18 = if fFlagAXItemDetailsIxpExposure then avatarRoute.Interface else nil
v5.avatarRoute = v18

v5.fetchAssetOrBundleInfo = t.callback
v5.navigateDownToAvatarScreen = t.callback
v5.toggleTryOn = t.optional(t.callback)
local v19 = if fFlagAXDurables2Option then t.callback else nil
v5.closeMatchingScreens = v19

v5.navigation = t.table

v5.networking = t.callback
v5.appAnalytics = t.table
v5.catalogAnalytics = t.table

v5.showPremiumContent = t.optional(t.boolean)
v5.enableAggregateLikesFavoritesCount = t.boolean
extended.validateProps = strictInterface(v5)

extended.defaultProps = { clipDetails = false, listPadding = 24 }

function extended:init()
	local v20 = {
		is3DPreviewEnabled = module34.isEnabled() and module2.readTestVariable(module34.EnableItemDetails3DPreview) and true or nil,
		fetchRecommendationsFailed = 0,
		licensingBadgeWidth = 0
	}

	local v21 = if module35() then false else nil
	v20.fetchRecommendationsFailed = v21
	v20.licensingBadgeWidth = fFlagAXMarketplaceLicensingItemDetails and 0 or nil
	self.state = v20

	if fFlagAXItemDetailsIxpExposure then
		self.requestImpressionsSignal = signal.new()
	end

	function self.fetchAssetOrBundleInfo()
		local networking = self.props.networking
		local appAnalytics = self.props.appAnalytics
		local itemId = tostring(self.props.itemId)
		local itemType = self.props.itemType

		return self.props.fetchAssetOrBundleInfo(networking, appAnalytics, itemId, itemType)
	end

	if module34.isEnabled() then
		function self.onItemViewportLoadingFailed()
			self:setState({ is3DPreviewEnabled = false })
		end
	end

	self:updateDurability()

	local binding, v22 = Roact.createBinding(false)
	self.itemHeaderVisibleBinding = binding
	self.updateItemHeaderVisibleBinding = v22

	if fFlagAXMarketplaceLicensingItemDetails then
		self.licensingTooltipDismissRef = React.createRef()

		function self.onLicensingBadgeSizeChanged(p2)
			if self.state.licensingBadgeWidth ~= p2.AbsoluteSize.X then
				self:setState({ licensingBadgeWidth = p2.AbsoluteSize.X })
			end
		end
	end

	function self.onTryOnActivated()
		local v23 = {
			itemId = self.props.itemId,
			itemType = self.props.itemType,
			mountAsFullView = false,
			mountAnimation = false,
			itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
			resultsListRef = self.props.resultsListRef
		}

		local v24 = v23.itemType .. v23.itemId

		if fFlagAXBackgroundsEquipTryOnCounters then
			reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(
				"TryOn",
				self.props.itemType,
				self.props.itemSubType
			)
		end

		v23.itemSubType = self.props.itemSubType

		self.props.navigateDownToAvatarScreen(avatarScreen.TryOnItem, v24, v23)
	end

	if fFlagAXDurables2Option then
		function self.onLevel2ItemDetailsTryOnButtonActivated()
			local itemSubType = module11.GetItemSubType(self.props.itemType, self.props.itemData)

			if fFlagAXBackgroundsEquipTryOnCounters then
				reportBackgroundUserActionCounter.reportIfAvatarBackgroundAsset(
					"TryOn",
					self.props.itemType,
					itemSubType
				)
			end

			self.props.toggleTryOn(
				self.props.networking,
				self.props.catalogAnalytics,
				self.props.itemType,
				itemSubType,
				self.props.itemId,
				true,
				self.props.avatarRoute,
				self.props.navigation
			)

			self.props.closeMatchingScreens(self.props.navigation, {
				avatarScreen.Checkout,
				avatarScreen.ItemDetails
			})
		end
	end

	function self.onItemOwnershipButtonActivated()
		local collectibleItemId = self.props.itemData.collectibleItemId

		self.props.navigation.navigate(avatarScreen.ItemOwnershipPage, {
			itemId = self.props.itemId,
			collectibleItemId = collectibleItemId,
			itemType = self.props.itemType
		})
	end

	function self.onItemHeaderMoved(p2)
		if not self.props.actionBarHeaderRef then
			return
		end

		local current = self.props.actionBarHeaderRef.current

		if not current then
			return
		end

		local v23 = current.AbsolutePosition.Y > p2.AbsolutePosition.Y

		current.Visible = not v23

		local current2 = fFlagAXMarketplaceLicensingItemDetails
			and self.itemHeaderVisibleBinding:getValue()
			and not v23
			and self.licensingTooltipDismissRef.current

		if current2 then
			current2()
		end

		self.updateItemHeaderVisibleBinding(v23)
	end

	self.hasCalledOnItemInvalid = false

	if module35() then
		function self.onFetchRecommendationsFailed()
			self:setState({ fetchRecommendationsFailed = true })
		end
	end
end

function extended:updateDurability()
	if self.props.itemData and self.props.itemData.timedOptions then
		self.wearTimeOptions = self.props.itemData.timedOptions
	end
end

function extended.didMount(p2)
	p2.fetchAssetOrBundleInfo()
end

function extended:didUpdate(p2)
	self:updateDurability()
	local itemData2 = self.props.itemData

	local fetchingState = self.props.fetchingState
	local onItemInvalid = self.props.onItemInvalid

	local v20 = fetchingState == module7.Done and itemData2 == nil

	local v21 = not self.hasCalledOnItemInvalid

	if onItemInvalid ~= nil and v21 and v20 then
		onItemInvalid()
		self.hasCalledOnItemInvalid = true
	end

	if module35() and (p2.itemType ~= self.props.itemType or p2.itemId ~= self.props.itemId) then
		self:setState({ fetchRecommendationsFailed = false })
	end
end

function extended:shouldShowRecommendedItems(p3): boolean
	if p3 or self.props.assetType and not module11.doesAssetTypeHaveCatalogPage(self.props.assetType) then
		return false
	end

	local itemData2 = self.props.itemData

	if
		itemData2
		and itemData2.receivedRecommendedData
		and (itemData2.recommendedItemSummaries == nil or #itemData2.recommendedItemSummaries == 0)
		or module35() and self.state.fetchRecommendationsFailed
	then
		return false
	end

	return true
end

function extended:renderDetailsWithProviders(data)
	local itemId = tostring(self.props.itemId)
	local itemType = self.props.itemType
	local listPadding = self.props.listPadding
	local itemSubType = self.props.itemSubType
	local itemData2 = self.props.itemData
	local collectibleItemId = if itemData2 then itemData2.collectibleItemId else nil

	local width = self.props.width
	local rbxThumbType = module11.GetRbxThumbType(itemType)
	local v20

	if fFlagAXThumbTypeNilCheck and rbxThumbType then
	end

	v20 = getRbxthumbWithTypeSizeAndOptions(itemId, rbxThumbType, 420)

	local isResellable = module11.IsResellable(itemData2)

	local v21 = itemData2 and itemData2.isOwned and isResellable
	local v22 = self.wearTimeOptions and #self.wearTimeOptions > 0

	if fFlagAXInventoryDurablesSupport then
		local isOwned = itemData2 and itemData2.isOwned
		local expirationTime = itemData2 and itemData2.isOwned and itemData2.expirationTime
		v22 = v22 and (not isOwned or expirationTime)
	end

	local v23

	if fFlagAXRemoveExpiredItemsFromInventory then
		v23 = itemData2 and itemData2.expirationTime and not isDurableItemExpired(itemData2.expirationTime)
	else
		v23 = nil
	end

	local bundleType, items, v24

	if module34.isEnabled() then
		local assetType = itemData2 and itemData2.assetType
		bundleType = itemData2 and itemData2.bundleType
		items = itemData2 and itemData2.items
		v24 = self.state.is3DPreviewEnabled

		if itemType == module13.ItemType.Asset then
			v24 = v24 and module13.ItemViewportAssetTypes[assetType]
		elseif itemType == module13.ItemType.Bundle then
			v24 = v24 and module13.ItemViewportBundleTypes[bundleType]
		end
	else
		v24 = nil
		bundleType = nil
		items = nil
	end

	local v25 = nil
	local v26

	if fFlagAXItemDetailsMediaHeader then
		local v27 = itemType == module13.ItemType.Asset
		local v28 = itemType == module13.ItemType.Bundle
			and bundleType ~= nil
			and items ~= nil
			and #items > 0

		v26 = module34.isEnabled()

		if v26 then
			v26 = v24 == true and (v27 or v28)
		end

		if v26 then
			if v28 then
				v25 = {
					itemType = "Bundle",
					itemId = itemId,
					bundleType = bundleType,
					bundleItems = items
				}
			else
				v25 = { itemType = "Asset", itemId = itemId }
			end
		end
	else
		v26 = false
	end

	if module30() then
		v21 = v21 and self.props.isCollectiblesEnabled
	end

	local v27 = self.props.width * 9 / 16

	local v28 = self.props.showFullWithNoPeekView and self.props.bottomDockedContainerHeight > 0
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local tokens = props.Tokens
		local size_200 = tokens.Size.Size_200

		local v29 = tokens.Size.Size_2400
		local v30 = font.BaseSize * font.Header1.RelativeSize

		local name = if itemData2 then itemData2.name else nil

		local font2 = font.Header1.Font
		local itemLicensingInfo

		if fFlagAXMarketplaceLicensingItemDetails and itemData2 then
			itemLicensingInfo = itemData2.itemLicensingInfo
		end

		local v31, favoriteCount

		if itemData2 then
			v31 = itemData2.description
			favoriteCount = itemData2.favoriteCount
		end

		v31 = defineFastFlag and module38(itemData2) or v31
		local v32

		if fFlagAXDurables2Option then
			v32 = module10.isFirstItemDetailsPage(self.props.navigation)
		end

		local param = self.props.navigation.getParam("fromProfile")
		local simpleView = self.props.simpleView or false

		local v33 = self:shouldShowRecommendedItems(simpleView)

		local tryOn = data.tryOn
		local v34 = font.BaseSize * font.Header2.RelativeSize
		local v35

		if foundationFontFaceMigration then
			v35 = 16 + getTextSize(
				tryOn,
				v34,
				tokens.Typography.TitleLarge.Font,
				Vector2.new(10000, 10000),
				{ addTemporaryPadding = false }
			).X
		else
			v35 = 16 + TextService:GetTextSize(tryOn, v34, font.Header2.Font, Vector2.new(10000, 10000)).X
		end

		local v36 = self.props.collectibleData
			and self.props.collectibleData.unitsAvailableForConsumption == 0

		local enableAggregateLikesFavoritesCount = not simpleView
			and self.props.enableAggregateLikesFavoritesCount
		local v37 = fFlagAXFavoritePillOnItemDetails and enableAggregateLikesFavoritesCount
		local v38 = v37 or fFlagEnableSocialProofOnItemDetails
		local v39

		if self.props.experiences then
			local createElement = Roact.createElement
			local v42

			if
				self.props.experiences
				and #self.props.experiences == 1
				and self.props.experiences[1].name
			then
				v42 = data.inSpecificExperience:gsub("{EXPERIENCE_NAME}", function()
					return self.props.experiences[1].name
				end)
			else
				v42 = data.inMultipleExperiences:gsub("{NUM_EXPERIENCES}", #self.props.experiences)
			end

			v39 = createElement(linkButton, {
				text = v42,
				onActivated = function()
					self.props.navigation.navigate(avatarScreen.ItemExperiencesMenu, {
						collectibleData = self.props.collectibleData,
						isLimited = module11.isLimitedCollectible(itemData2),
						openPositionY = UDim.new(0, 100),
						menuDirection = menuDirection.Down
					})
				end,
				minPaddingX = 0,
				layoutOrder = 1
			})
		end

		local v40 = {
			["width"] = UDim.new(1, 0),
			contentPadding = UDim.new(0, listPadding),
			margin = roactFitComponents.Rect.square(24),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BackgroundTransparency = theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0)
		}
		local ref = Roact.Ref
		local v41 = if fFlagAXItemDetailsIxpExposure then self.props.itemDetailsContainerRef else nil
		v40[ref] = v41

		if itemLicensingInfo and self.state.licensingBadgeWidth > 0 then
			v29 = size_200 + self.state.licensingBadgeWidth
		end

		local v42

		if not isVRAppBuild() then
			if name then
				local createElement = Roact.createElement
				local v45 = if itemLicensingInfo then fitTextLabel.Width.FitToText else UDim.new(1, 0)

				local v46 = if itemLicensingInfo then math.max(self.props.width - 48 - v29, 0) else nil
				v42 = createElement(fitTextLabel, {
					width = v45,
					maximumWidth = v46,
					Visible = self.itemHeaderVisibleBinding,
					BackgroundTransparency = 1,
					Font = font2,
					Text = name,
					TextSize = v30,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextColor3 = theme.TextEmphasis.Color,
					TextWrapped = true
				}, {})
			else
				v42 = Roact.createElement(skeleton, { Size = UDim2.new(1, 0, 0, v30) })
			end
		end

		local createElement = Roact.createElement
		local v44 = {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local createElement2 = Roact.createElement
		local onItemHeaderMovedsByAbsolutePosition = {
			width = UDim.new(1, 0),
			LayoutOrder = 0,
			BackgroundTransparency = 1,
			[Roact.Change.AbsolutePosition] = self.onItemHeaderMoved
		}
		local v47 = if not (itemLicensingInfo and v42) then v42 else nil
		local v48 = if itemLicensingInfo and v42 then Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Visible = self.itemHeaderVisibleBinding,
			BackgroundTransparency = 1,
			LayoutOrder = 0
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, size_200)
			}),
			TextLabel = v42,
			LicensingBadge = Roact.createElement(licensingBadge, {
				itemLicensingInfo = itemLicensingInfo,
				popoverSide = "Bottom",
				dismissTooltipRef = self.licensingTooltipDismissRef,
				onAbsoluteSizeChanged = self.onLicensingBadgeSizeChanged,
				LayoutOrder = 1
			})
		}) else nil
		local children2 = {
			NameLabel = createElement2(fitFrameVertical, onItemHeaderMovedsByAbsolutePosition, {
				TextLabel = v47,
				TitleRow = v48,
				RefUpdater = Roact.createElement("Frame", {
					Size = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					[Roact.Ref] = function(p2)
						if p2 and p2.Parent then
							self.onItemHeaderMoved(p2.Parent)
						end
					end
				})
			}),
			ExperienceLinkDetails = 0,
			ItemImageFrame = 0
		}
		local v50

		if self.props.experiences then
			local createElement4 = Roact.createElement
			local v52 = {
				Size = UDim2.new(1, 0, 0, font.BaseSize * font.Body.RelativeSize),
				BackgroundTransparency = 1,
				LayoutOrder = 0
			}

			local v53 = {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				ExperienceLink = v39,
				DashDivider = 0,
				SoldOutText = 0
			}

			local v54 = if v36 then Roact.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.XY,
				text = "-",
				fontStyle = font.Body,
				colorStyle = theme.TextDefault,
				layoutOrder = 2
			}) else nil
			v53.DashDivider = v54

			local v55 = if v36 then Roact.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.XY,
				text = data.soldOut,
				fontStyle = font.Body,
				colorStyle = theme.TextDefault,
				layoutOrder = 3
			}) else nil
			v53.SoldOutText = v55
			v50 = createElement4("Frame", v52, v53)
		end

		children2.ExperienceLinkDetails = v50

		local createElement4 = Roact.createElement
		local v52 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v27),
			LayoutOrder = 1,
			ZIndex = 0
		}
		local v54

		if fFlagAXOutfitPageRevamp then
			v54 = Roact.createElement(backgroundHighlight, { ZIndex = 0 })
		else
			v54 = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.new(1, 48, 1, 0),
				ZIndex = 0,
				BackgroundColor3 = theme.BackgroundMuted.Color,
				BackgroundTransparency = theme.BackgroundMuted.Transparency,
				BorderSizePixel = 0
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = -90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.4, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		end

		local v55

		if fFlagAXItemDetailsMediaHeader then
			local createElement5 = Roact.createElement
			local v57 = {
				item = v25,
				preferThreeDimensional = v26,
				thumbnail = v20,
				size = UDim2.fromScale(1, 1),
				mediaHorizontalBleed = 24,
				setParentScrollingEnabled = 0
			}

			local v58 = if module33() then self.props.setItemDetailsScrollingEnabled else nil
			v57.setParentScrollingEnabled = v58
			v55 = createElement5(itemMediaHeader, v57)
		end

		local v56

		if not (fFlagAXItemDetailsMediaHeader or not (module34.isEnabled() and v24)) then
			local createElement5 = Roact.createElement
			local v58 = {
				anchorPoint = Vector2.new(0.5, 0),
				position = UDim2.fromScale(0.5, 0),
				size = UDim2.new(1, 48, 1, 0),
				itemId = itemId,
				itemType = itemType,
				bundleType = bundleType,
				bundleItems = items,
				setParentScrollingEnabled = 0,
				onLoadingFailed = 0
			}

			local v59 = if module33() then self.props.setItemDetailsScrollingEnabled else nil
			v58.setParentScrollingEnabled = v59

			v58.onLoadingFailed = self.onItemViewportLoadingFailed
			v56 = createElement5(itemViewport, v58)
		end

		local v57 = if not (fFlagAXItemDetailsMediaHeader or module34.isEnabled() and v24) then Roact.createElement(loadableImage, {
			BackgroundTransparency = 1,
			Image = v20,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(v27, v27),
			useShimmerAnimationWhileLoading = true
		}) else nil

		local v58 = if param then Roact.createElement(
			"Frame",
			{
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			},
			{
				TryOnButton = Roact.createElement(button, {
					buttonType = buttonType.Secondary,
					position = UDim2.new(1, -v35 - 8, 1, -44),
					size = UDim2.fromOffset(v35, 36),
					text = tryOn,
					onActivated = self.onTryOnActivated
				})
			}
		) else nil

		local v59 = if fFlagAXDurables2Option and not param and v32 == false and self.props.navigation.state.routeName ~= avatarScreen.TryOnItem then Roact.createElement(
			Foundation.View,
			{ ZIndex = 2, tag = "size-full", BackgroundTransparency = 1 },
			{
				TryOnButton = Roact.createElement(Foundation.Button, {
					Position = UDim2.new(1, -v35 - 8, 1, -44),
					text = tryOn,
					onActivated = self.onLevel2ItemDetailsTryOnButtonActivated
				})
			}
		) else nil
		children2.ItemImageFrame = createElement4("Frame", v52, {
			ItemBackground = v54,
			MediaHeader = v55,
			ItemViewport = v56,
			Image = v57,
			TryOnButtonFrame = v58,
			RecommendedItemDetailsTryOnButtonFrame = v59
		})
		local children = {
			ItemThumbnail = createElement(fitFrameVertical, v44, children2),
			IncludedItems = 0,
			FavoritePillExposure = 0,
			ExpirationTimeContainer = 0,
			WearTimeOptionsCarousel = 0,
			ItemStatistics = 0,
			ItemOwnershipButton = 0,
			ItemInfoList = 0,
			RecommendedLabel = 0,
			RecommendedItemsGrid = 0,
			BottomContainerPlaceHolder = 0,
			UnifiedImpressionsReporter = 0
		}

		local v60 = if not simpleView and itemType == module13.ItemType.Bundle then Roact.createElement(module19, {
			itemId = itemId,
			itemType = itemType,
			LayoutOrder = 2
		}) else nil
		children.IncludedItems = v60

		local v61 = if fFlagAXFavoritesPillExposureLogging and enableAggregateLikesFavoritesCount then React.createElement(module26) else nil
		children.FavoritePillExposure = v61

		local v62 = if fFlagAXInventoryDurablesSupport and self.props.itemData and self.props.itemData.expirationTime and not fFlagAXRemoveExpiredItemsFromInventory or fFlagAXRemoveExpiredItemsFromInventory and v23 then React.createElement(itemExpirationDisplay, {
			expirationTime = self.props.itemData.expirationTime,
			LayoutOrder = v38 and 5 or 4
		}) else nil
		children.ExpirationTimeContainer = v62

		local v63 = if not (fFlagAXDurables2Option or not v22) then Roact.createElement(wearTimeOptionsCarousel, {
			LayoutOrder = v38 and 6 or 5,
			options = self.wearTimeOptions,
			onOptionActivated = self.props.onWearTimeSelection,
			useWrapping = true
		}) else nil
		children.WearTimeOptionsCarousel = v63

		local v64 = if enableAggregateLikesFavoritesCount and not fFlagAXFavoritePillOnItemDetails then Roact.createElement(module15, {
			favoritesCount = favoriteCount,
			LayoutOrder = (v38 and 1 or (fFlagAXInventoryDurablesSupport and 1 or 0) + 0) + 5,
			listPadding = 10,
			width = width - 48
		}) else nil
		children.ItemStatistics = v64
		local v65

		if v21 then
			local createElement5 = Roact.createElement
			local v67 = {
				size = UDim2.new(1, 0, 0, 0),
				automaticSize = Enum.AutomaticSize.Y,
				layoutOrder = (v38 and 1 or (fFlagAXInventoryDurablesSupport and 1 or 0) + 0) + 6,
				itemId = itemId,
				isLimitedCollectible = self.props.isLimitedCollectible,
				collectibleItemId = collectibleItemId,
				onActivated = self.onItemOwnershipButtonActivated,
				ref = 0
			}
			local v68 = if module32() then self.props.ownershipButtonRef else nil
			v67.ref = v68
			v65 = createElement5(module16, v67)
		end

		children.ItemOwnershipButton = v65

		children.ItemInfoList = not simpleView and Roact.createElement(module17, {
			itemId = itemId,
			itemType = itemType,
			LayoutOrder = 7 + (v38 and 1 or 0) + (fFlagAXInventoryDurablesSupport and 1 or 0),
			resellerRef = self.props.resellerRef,
			attributionRef = self.props.attributionRef
		})

		children.RecommendedLabel = v33 and Roact.createElement(fitTextLabel, {
			width = fitTextLabel.Width.FitToText,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = font.Header1.Font,
			LayoutOrder = v38 and 9 or (fFlagAXInventoryDurablesSupport and 1 or 0) + 8,
			Position = UDim2.new(0, 0, 0, 0),
			Text = data.recommendedLabel,
			TextSize = v30,
			TextColor3 = theme.TextEmphasis.Color
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(math.max(self.props.width - 24, 0), 1e999)
			})
		})

		if v33 then
			local createElement5 = Roact.createElement
			local recommendedItemsGridRefsByRef = {}
			recommendedItemsGridRefsByRef.itemId = itemId
			recommendedItemsGridRefsByRef.itemSubType = itemSubType
			recommendedItemsGridRefsByRef.itemType = itemType
			local v67 = if module35() then self.onFetchRecommendationsFailed else nil
			recommendedItemsGridRefsByRef.onFetchRecommendationsFailed = v67

			recommendedItemsGridRefsByRef.LayoutOrder = v38 and 10
				or 9 + (fFlagAXInventoryDurablesSupport and 1 or 0)

			recommendedItemsGridRefsByRef[Roact.Ref] = self.props.recommendedItemsGridRef

			recommendedItemsGridRefsByRef.itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs
			recommendedItemsGridRefsByRef.resultsListRef = self.props.resultsListRef
			v33 = createElement5(module18, recommendedItemsGridRefsByRef)
		end

		children.RecommendedItemsGrid = v33

		children.BottomContainerPlaceHolder = v28 and Roact.createElement("Frame", {
			LayoutOrder = v38 and 11 or 10,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, self.props.bottomDockedContainerHeight),
			Active = false
		})
		local v66

		if fFlagAXItemDetailsIxpExposure then
			v66 = Roact.createElement(tagBasedImpressionsDetector, {
				parentRef = self.props.itemDetailsContainerRef,
				pageFilter = function(): boolean
					return self.props.navigation.state.key == self.props.avatarRoute.current.key
				end,
				requestImpressionsSignal = self.requestImpressionsSignal,
				extensions = self.props.tagBasedImpressionsDetectorExtensions
			})
		end

		children.UnifiedImpressionsReporter = v66

		if fFlagAXFixItemDetailsDescriptionSpacing and v38 then
			local createElement5 = Roact.createElement
			local v68 = {
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 16),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3
			}
			local v70

			if v37 then
				local createElement6 = React.createElement

				local v73 = {
					FavoritePill = React.createElement(module25, {
						kind = itemType,
						itemId = itemId,
						favoritesCount = favoriteCount,
						LayoutOrder = 1
					}),
					FriendsOwned = 0
				}

				local v74 = if fFlagEnableSocialProofOnItemDetails then React.createElement(friendsOwnedChip, {
					itemId = itemId,
					itemType = itemType,
					fromProfile = param,
					layoutOrder = 2
				}) else nil
				v73.FriendsOwned = v74
				v70 = createElement6(module27, { LayoutOrder = 3 }, v73)
			end

			local v71 = if not (v37 or not fFlagEnableSocialProofOnItemDetails) then Roact.createElement(friendsOwnedChip, {
				itemId = itemId,
				itemType = itemType,
				fromProfile = param,
				layoutOrder = 3
			}) else nil
			local v72

			if fFlagAXItemDetailsDescriptionLinks then
				v72 = Roact.createElement(module37, {
					compactNumberOfLines = 3,
					descriptionText = v31,
					LayoutOrder = 4,
					[Roact.Ref] = self.props.expandableTextRef,
					openItemDetails = self.props.openDescriptionLinkItem,
					itemId = itemId,
					itemType = itemType,
					onCanExpandChanged = self.props.onDescriptionCanExpandChanged
				})
			else
				v72 = Roact.createElement(module14, {
					compactNumberOfLines = 3,
					descriptionText = v31,
					LayoutOrder = 4,
					[Roact.Ref] = self.props.expandableTextRef
				})
			end

			children.ChipsAndDescription = createElement5(fitFrameVertical, v68, {
				ItemChipsRow = v70,
				ItemSocialProof = v71,
				ItemDescription = v72
			})
		else
			local v67

			if v37 then
				local createElement5 = React.createElement

				local v70 = {
					FavoritePill = React.createElement(module25, {
						kind = itemType,
						itemId = itemId,
						favoritesCount = favoriteCount,
						LayoutOrder = 1
					}),
					FriendsOwned = 0
				}

				local v71 = if fFlagEnableSocialProofOnItemDetails then React.createElement(friendsOwnedChip, {
					itemId = itemId,
					itemType = itemType,
					fromProfile = param,
					layoutOrder = 2
				}) else nil
				v70.FriendsOwned = v71
				v67 = createElement5(module27, { LayoutOrder = 3 }, v70)
			end

			children.ItemChipsRow = v67

			local v68 = if not (v37 or not fFlagEnableSocialProofOnItemDetails) then Roact.createElement(friendsOwnedChip, {
				itemId = itemId,
				itemType = itemType,
				fromProfile = param,
				layoutOrder = 3
			}) else nil
			children.ItemSocialProof = v68
			local v69

			if fFlagAXItemDetailsDescriptionLinks then
				v69 = Roact.createElement(module37, {
					compactNumberOfLines = 3,
					descriptionText = v31,
					LayoutOrder = v38 and 4 or 3,
					[Roact.Ref] = self.props.expandableTextRef,
					openItemDetails = self.props.openDescriptionLinkItem,
					itemId = itemId,
					itemType = itemType,
					onCanExpandChanged = self.props.onDescriptionCanExpandChanged
				})
			else
				v69 = Roact.createElement(module14, {
					compactNumberOfLines = 3,
					descriptionText = v31,
					LayoutOrder = v38 and 4 or 3,
					[Roact.Ref] = self.props.expandableTextRef
				})
			end

			children.ItemDescription = v69
		end

		return Roact.createElement(fitFrameVertical, v40, children)
	end)
end

function extended:renderDetails()
	return withLocalization({
		recommendedLabel = "Feature.Catalog.Label.Recommendations",
		resellLabel = "Feature.Catalog.Heading.Sellers",
		tryOn = "Feature.Avatar.Action.TryOn",
		inMultipleExperiences = "Feature.Catalog.Label.InMultipleExperiences",
		inSpecificExperience = "Feature.Catalog.Label.InSpecificExperience",
		soldOut = "Feature.Catalog.Label.SoldOut"
	})(function(p2)
		return self:renderDetailsWithProviders(p2)
	end)
end

function extended.renderOnFailed(p2)
	local fetchAssetOrBundleInfo = p2.fetchAssetOrBundleInfo
	local globalGuiInset = p2.props.globalGuiInset
	local safeAreaSize = getSafeAreaSize(p2.props.screenSize, globalGuiInset)
	local v20 = module12.ActionBar.ActionBarHeight + module12.ActionBar.ActionBarGradientHeight

	local v21 = withLocalization({
		emptyText = fFlagUpdateNoInternetConnectionText and "Feature.DisplayName.ErrorMessage.SomethingWentWrong" or "Feature.EmptyStatePage.Message.NoInternet"
	})(function(p3)
		return Roact.createElement(emptyState, {
			onActivated = fetchAssetOrBundleInfo,
			text = p3.emptyText
		})
	end)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, safeAreaSize.Y.Scale, safeAreaSize.Y.Offset - v20)
	}, { EmptyStatePage = v21 })
end

function extended:render()
	local clipDetails = self.props.clipDetails
	local fetchingState = self.props.fetchingState

	return withStyle(function(p2)
		local theme = p2.Theme

		local createElement = Roact.createElement
		local v21 = {
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			["ClipsDescendants"] = nil,
			ClipsDescendants = clipDetails
		}

		local v22 = if clipDetails then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 1, 0)
		v21.Size = v22
		local v23 = if not clipDetails then Enum.AutomaticSize.Y else nil
		v21.AutomaticSize = v23

		v21.BackgroundColor3 = theme.BackgroundDefault.Color
		v21.BackgroundTransparency = theme.BackgroundDefault.Transparency
		v21.BorderSizePixel = 0
		v21.Position = UDim2.new(0, 0, 0, 0)
		v21[Roact.Ref] = self.props.forwardRef

		v21[Roact.Change.AbsoluteSize] = function(p3)
			if self.props.width ~= p3.AbsoluteSize.X then
				self.props.setWidth(p3.AbsoluteSize.X)
			end
		end

		v21[Roact.Change.AbsolutePosition] = fFlagAXItemDetailsIxpExposure and function(p3)
			self.requestImpressionsSignal:fire()
		end or nil
		return createElement("Frame", v21, {
			LoadingState = Roact.createElement(loadingStateContainer, {
				dataStatus = retrievalStatus.fromRawValue(fetchingState),
				renderOnLoading = function()
					return self:renderDetails()
				end,
				renderOnLoaded = function()
					return self:renderDetails()
				end,
				renderOnFailed = function()
					return self:renderOnFailed()
				end
			})
		})
	end)
end

local v20 = RoactRodux.connect(function(data, data2)
	local status = performFetch.GetStatus(data, module11.GetItemDetailsKey(data2.itemId, data2.itemType))
	local v21

	if status ~= module7.NotStarted then
		v21 = itemData(data.AvatarExperience.Common, data2.itemId, data2.itemType)
	end

	if
		(data2.navigation.state.routeName == avatarScreen.TryOnItem or fFlagAXItemDetailsPartialAssetInfoFix)
		and v21 ~= nil
		and v21.name == nil
	then
		v21 = nil
	end

	local experiences = nil
	local isCollectiblesEnabled = nil
	local collectibleItemId = if v21 then v21.collectibleItemId else nil
	local v22

	if collectibleItemId and v21 then
		v22 = data.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v21.collectibleItemId]
	end

	local itemSubType = module11.GetItemSubType(data2.itemType, v21)

	if v22 ~= nil then
		experiences = v22.experiences
	end

	if module30() then
		isCollectiblesEnabled = data.AvatarExperience.Catalog.Metadata.isCollectiblesEnabled
	end

	local limitedCollectible = module11.isLimitedCollectible(v21)

	return {
		globalGuiInset = data.GlobalGuiInset,
		screenSize = data.ScreenSize,
		fetchingState = status,
		itemData = v21,
		itemSubType = itemSubType,
		peekViewState = data.AvatarExperience.Common.ItemDetailsPeekView.viewState,
		experiences = experiences,
		collectibleData = v22,
		isCollectiblesEnabled = isCollectiblesEnabled,
		isLimitedCollectible = limitedCollectible
	}
end, function(callback, p2)
	return {
		fetchAssetOrBundleInfo = function(p3, p4, p5, p6)
			return callback(module23(p3, p4, p5, p6))
		end,
		navigateDownToAvatarScreen = function(p3, p4, p5)
			return callback(navigateDownToAvatarScreen(p3, p4, p5))
		end,
		toggleTryOn = function(p3, p4, p5, p6, p7, p8, p9, p10)
			callback(module21(p3, p4, p5, p6, p7, p8, p9, p10))
		end,
		closeMatchingScreens = fFlagAXDurables2Option and function(p3, p4)
			callback(module22(p3, p4))
		end or nil
	}
end)(extended)

local v21 = roactAppPolicy.connect(function(p2, p3)
	return {
		enableAggregateLikesFavoritesCount = p2.getEnableAggregateLikesFavoritesCount()
	}
end)(v20)

local v22 = RoactNavigation.withNavigation(v21)

if fFlagAXItemDetailsIxpExposure then
	v22 = module5(v22)
end

local v23 = roactServices.connect({
	appAnalytics = module,
	catalogAnalytics = module8,
	networking = module6
})(v22)

function LUAUFORGE_MODULE_GLOBALS_gkp_checkCanItemDescriptionExpand(p2, p3, p4)
	if not (p2 and p2.description) then
		return false
	end

	local v24 = p2.description

	v24 = defineFastFlag and module38(p2) or v24

	return getCanExpand(p3, p4 - 48, v24, 3)
end

return React.forwardRef(function(p2, p3)
	local state, setState = React.useState(0)
	local v24 = useStyle()

	local ref = if fFlagAXItemDetailsIxpExposure then React.useRef(nil) else nil

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)

	local v25 = useSelector(function(p4)
		return itemData(p4.AvatarExperience.Common, p2.itemId, p2.itemType)
	end)

	local isResellable = module11.IsResellable(v25)
	local hasAttribution = module11.HasAttribution(v25)
	local v26 = v25 and v25.isOwned and isResellable
	local state2 = LUAUFORGE_MODULE_GLOBALS_gkp_checkCanItemDescriptionExpand(v25, v24.Font, state)
	local setState2

	if fFlagAXItemDetailsDescriptionLinks then
		state2, setState2 = React.useState(false)
	end

	local v27 = if v25 and v25.description then v25.description else nil

	v27 = defineFastFlag and module38(v25) or v27
	local v28

	if state2 then
		v28 = ref2
	elseif module32() and v26 then
		v28 = ref3
	else
		v28 = if isResellable then ref4 elseif hasAttribution then ref5 else ref6
	end

	if not v27 then
		v28 = nil
	end

	local v29 = useFocusGuiObject()

	local v30 = useTableWrappedCallbackRef((module31(p3, {
		onMoveToTop = React.useCallback(function()
			if v29 and v28 and v28.current then
				v29(v28.current)
			end
		end, { v28, v29 }),
		onMoveToRecItems = React.useCallback(function()
			if v29 and ref6 and ref6.current then
				v29(ref6.current)
			end
		end, { v29 })
	})))
	local v31

	if fFlagAXItemDetailsIxpExposure then
		local v32

		if fFlagAXUnifiedImpressionsOnThumbnail then
			v32 = useUnifiedEventImpressionsReporter(useAvatarRoute().current.name)
		else
			v32 = useUnifiedEventImpressionsReporter()
		end

		v31 = React.useMemo(function()
			return { v32, module20 }
		end, { v32, module20 })
	end

	return React.createElement(v23, Cryo.Dictionary.join(p2, {
		width = state,
		setWidth = setState,
		itemDetailsContainerRef = ref,
		expandableTextRef = ref2,
		ownershipButtonRef = ref3,
		resellerRef = ref4,
		attributionRef = ref5,
		recommendedItemsGridRef = ref6,
		forwardRef = v30,
		tagBasedImpressionsDetectorExtensions = v31,
		onDescriptionCanExpandChanged = setState2
	}))
end)
