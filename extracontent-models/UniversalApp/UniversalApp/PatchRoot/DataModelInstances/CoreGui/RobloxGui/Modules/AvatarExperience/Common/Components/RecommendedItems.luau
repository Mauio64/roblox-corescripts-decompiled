local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local GetRecommendedItems = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetRecommendedItems)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local ScrollingAppCarousel = require(CorePackages.Workspace.Packages.AppBlox).ScrollingAppCarousel
local RecommendedItemCard = require(Modules.AvatarExperience.AvatarEditor.Components.RecommendedItemCard)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.Catalog.Thunks.SetCategoryAndSubcategory)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local ReducerUtils = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Utils.ReducerUtils
local AXEditorRecommendationCarousel = require(Modules.AvatarExperience.Experiments.AXEditorRecommendationCarousel)
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXLogNilCategoryAndSubcategorySelection = AvatarExperienceFlags.FFlagAXLogNilCategoryAndSubcategorySelection
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local mutedError = require(Modules.LuaApp.mutedError)
local v51 = game:DefineFastFlag("AXYouMayAlsoLikeExposureLogging", false)
local v52 = game:DefineFastFlag("AXHideEmptyRecommendations", false)
local FFlagAXRootSlotBasedEditorFlag = AvatarExperienceFlags.FFlagAXRootSlotBasedEditorFlag
local FFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local v55 = game:DefineFastFlag("AXRecommendedItemsExposureLogging", false)
local FStringAXRecommendedItemsExposureLayer = AvatarExperienceFlags.FStringAXRecommendedItemsExposureLayer
local FFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local t1 = {
	TILE_WIDTH = 100,
	TILE_HEIGHT = 180,
	CAROUSEL_HEIGHT = 240,
	CAROUSEL_ITEM_PADDING = 10,
	WIDGET_LAYOUT_PADDING = 20,
	CAROUSEL_POSITION = {
		leftPosition = 28,
		rightPosition = 15
	}
}
local v59 = Roact.PureComponent:extend("RecommendedItems")

v59.validateProps = t.strictInterface({
	categoryInfo = t.table,
	LayoutOrder = t.optional(t.number),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	baseRef = t.optional(t.table),
	listFrameRef = t.optional(t.table),
	itemDetailsPeekViewRefs = t.table,
	sendShopForMoreAnalytics = t.callback,
	impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else t.optional(t.string),
	screenSize = t.Vector2,
	itemType = t.string,
	dataStatus = t.string,
	items = t.table,
	setCatalogIndicies = t.callback,
	getRecommendedItems = t.callback,
	navigateWithLock = t.callback,
	navigation = t.table,
	avatarRoute = AvatarRoute.Interface,
	catalogAnalytics = t.table,
	networking = t.callback,
	doesMatchingCatalogCategoryExist = if not FFlagAXCatalogCategoriesSDUI then nil else t.optional(t.boolean)
})

function v59.init(p1) -- line: 142
	-- upvalues: Roact (copy), AvatarScreen (copy), GetFFlagAXEnableSlotBasedEditor (copy), Constants (copy), Utils (copy)
	p1.loadableGridViewRef = Roact.createRef()
	p1.shopMoreRef = Roact.createRef()

	function p1.onActivated() -- line: 145
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local catalogAnalytics = p1.props.catalogAnalytics
		local categoryInfo = p1.props.categoryInfo

		p1.props.setCatalogIndicies(categoryInfo, catalogAnalytics)
		p1.props.navigateWithLock(function() -- line: 151
			-- upvalues: p1 (copy), AvatarScreen (copy)
			p1.props.navigation.navigate(AvatarScreen.Catalog)
			p1.props.sendShopForMoreAnalytics()
		end)
	end
	function p1.getRecommendedItems() -- line: 158
		-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), p1 (copy), Constants (copy), Utils (copy)
		if GetFFlagAXEnableSlotBasedEditor() and not p1.props.categoryInfo.RecommendationsType or p1.props.categoryInfo.RecommendationsType == Constants.RecommendationsType.None then
			return
		end

		local networking = p1.props.networking
		local v124 = Utils.getRecommendedAssetTypeIdStringFromCategoryInfo(p1.props.categoryInfo)

		p1.props.getRecommendedItems(networking, v124, p1.props.categoryInfo.RecommendationsType, true)
	end
end
function v59.maybeFetchRecommendedItems(p2) -- line: 174
	-- upvalues: RetrievalStatus (copy)
	if p2.props.dataStatus ~= RetrievalStatus.Fetching then
		p2.getRecommendedItems()
	end
end
function v59.didMount(p3) -- line: 181
	-- upvalues: v51 (copy), IxpUtils (copy), AXEditorRecommendationCarousel (copy), v55 (copy), Constants (copy), FStringAXRecommendedItemsExposureLayer (copy)
	p3:maybeFetchRecommendedItems()

	if v51 then
		IxpUtils.logExperimentExposure(AXEditorRecommendationCarousel)
	end

	if v55 and p3.props.categoryInfo.RecommendationsType ~= Constants.RecommendationsType.All and p3.props.categoryInfo.RecommendationsType ~= Constants.RecommendationsType.None then
		IxpUtils.logLayerExposure(FStringAXRecommendedItemsExposureLayer)
	end
end
function v59.didUpdate(p4, p5) -- line: 196
	-- upvalues: AvatarScreen (copy), Utils (copy)
	if p4.props.avatarRoute.current.name == AvatarScreen.AvatarEditor and Utils.getRecommendedKey(p5.categoryInfo) ~= Utils.getRecommendedKey(p4.props.categoryInfo) then
		p4:maybeFetchRecommendedItems()
	end
end
function v59.renderWithProviders(p6, p7, p8) -- line: 207
	-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), Constants (copy), Constants2 (copy), Utils (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Button (copy), Focusable (copy), ButtonType (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), RecommendedItemCard (copy), FitFrameVertical (copy), RoactFitComponents (copy), v52 (copy), LoadableGridView (copy)
	local items = p6.props.items
	local itemType = p6.props.itemType
	local key = p6.props.avatarRoute.current.key
	local v76 = #items == 0
	local propsLayoutOrder = p6.props.LayoutOrder
	local screenSize = p6.props.screenSize
	local p7Font = p7.Font
	local Theme = p7.Theme
	local v81 = if not FFlagAXRootSlotBasedEditorFlag then p7Font.Header2.Font else p7Font.HeadingSmall.Font
	local v82 = p7Font.BaseSize * if not FFlagAXRootSlotBasedEditorFlag then p7Font.Header2.RelativeSize else p7Font.HeadingSmall.RelativeSize
	local v83 = if not FFlagAXAvatarTabLooksYouMayAlsoLike then nil else p6.props.categoryInfo.RecommendationsType == Constants.RecommendationsType.AvatarLooks
	local v84 = if not v83 then if not FFlagAXRootSlotBasedEditorFlag then Constants2.ItemTileType.CatalogItemTile else Constants2.ItemTileType.AvatarEditorTile else Constants2.ItemTileType.LookItemTile
	local v85 = if not FFlagAXAvatarTabLooksYouMayAlsoLike then Utils.GridItemHeightGetter(v84, if not FFlagAXRootSlotBasedEditorFlag then v82 else v82 + if not FFlagRenameDeprecatedUIBloxTokens then p7.Tokens.Global.Space_150 else p7.Tokens.Size.Size_300) else Utils.GridItemHeightGetterWithOptions({
		itemTileType = v84,
		fontHeight = v82 + p7.Tokens.Size.Size_300,
		itemPriceEnabled = v83
	})
	local v86 = Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[Button] else Button, {
		buttonType = ButtonType.Secondary,
		layoutOrder = 3,
		size = UDim2.new(1, 0, 0, 48),
		text = p8.shopForMore,
		onActivated = p6.onActivated,
		[Roact.Ref] = p6.shopMoreRef,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then v76 and p6.props.NextSelectionUp or p6.loadableGridViewRef else nil
	})
	local v87 = if not FFlagAXCatalogCategoriesSDUI then nil else p6.props.doesMatchingCatalogCategoryExist
	local v88 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p6.props.impressionsTag
	local v89 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p6.props.categoryInfo.Name
	local v90 = not GetFFlagAXEnableRecommendationTypeAllInCustomize() and function(p9, p10, p11) -- line: 287
		-- upvalues: Roact (copy), RecommendedItemCard (copy), itemType (copy), p6 (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), v88 (copy), v89 (copy)
		return Roact.createElement(RecommendedItemCard, {
			itemId = p9,
			index = p10,
			itemType = itemType,
			getRecommendedItems = p6.getRecommendedItems,
			itemDetailsPeekViewRefs = p6.props.itemDetailsPeekViewRefs,
			resultsListRef = p6.props.listFrameRef,
			impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v88,
			impressionsCategory = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v89,
			gridInformation = if not p11 then nil else {
				gridPositionRow = p11.row,
				gridPositionColumn = p11.column
			}
		})
	end or function(t2: {[any]: any}, n1: number, p12) -- line: 267
		-- upvalues: Roact (copy), RecommendedItemCard (copy), p6 (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), v88 (copy), v89 (copy)
		return Roact.createElement(RecommendedItemCard, {
			itemId = t2.itemId,
			index = n1,
			itemType = t2.itemType,
			getRecommendedItems = p6.getRecommendedItems,
			itemDetailsPeekViewRefs = p6.props.itemDetailsPeekViewRefs,
			resultsListRef = p6.props.listFrameRef,
			impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v88,
			impressionsCategory = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v89,
			gridInformation = if not p12 then nil else {
				gridPositionRow = p12.row,
				gridPositionColumn = p12.column
			}
		})
	end
	local NumRecommendedItems = Constants2.NumRecommendedItems

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[FitFrameVertical] else FitFrameVertical, {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, 10),
		margin = if not FFlagAXRootSlotBasedEditorFlag then RoactFitComponents.Rect.quad(24, 15, 15, 15) else RoactFitComponents.Rect.quad(24, 0, 15, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
		BackgroundColor3 = Theme.BackgroundUIContrast.Color,
		BorderSizePixel = 0,
		LayoutOrder = propsLayoutOrder,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v76 and p6.shopMoreRef or p6.loadableGridViewRef else nil,
		[Roact.Ref] = p6.props.baseRef
	}, {
		YouMayAlsoLikeTextLabel = if not v52 or not v76 then Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 24),
			Font = v81,
			TextColor3 = Theme.TextEmphasis.Color,
			Text = p8.youMayAlsoLike,
			TextSize = v82,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}) else nil,
		GridView = if not v52 or not v76 then Roact.createElement(LoadableGridView, {
			LayoutOrder = 2,
			items = items,
			totalNumItems = NumRecommendedItems,
			getItemHeight = v85,
			windowHeight = screenSize.Y,
			renderItem = v90,
			[Roact.Ref] = p6.loadableGridViewRef,
			NextSelectionUp = p6.props.NextSelectionUp,
			NextSelectionDown = p6.shopMoreRef,
			NextSelectionRight = key and p6.props.itemDetailsPeekViewRefs[key]
		}) else nil,
		ShopForMoreButton = if not not FFlagAXCatalogCategoriesSDUI and not v87 then nil else v86
	})
end
function v59.renderCarouselWithProviders(p13, _, p15) -- line: 369
	-- upvalues: FFlagAXRecommendedItemsImpressionExposureLogging (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), Roact (copy), RecommendedItemCard (copy), t1 (copy), v52 (copy), WidgetHeader (copy), ScrollingAppCarousel (copy), Button (copy), ButtonType (copy), WidgetLayout (copy)
	local items = p13.props.items
	local itemType = p13.props.itemType
	local v97 = #items == 0
	local v98 = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else p13.props.impressionsTag
	local v99 = not GetFFlagAXEnableRecommendationTypeAllInCustomize() and function(p16, p17) -- line: 387
		-- upvalues: Roact (copy), RecommendedItemCard (copy), itemType (copy), p13 (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), v98 (copy)
		return Roact.createElement(RecommendedItemCard, {
			itemId = p16,
			index = p17,
			itemType = itemType,
			getRecommendedItems = p13.getRecommendedItems,
			itemDetailsPeekViewRefs = p13.props.itemDetailsPeekViewRefs,
			resultsListRef = p13.props.listFrameRef,
			impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v98
		})
	end or function(t3: {[any]: any}, n2: number) -- line: 376
		-- upvalues: Roact (copy), RecommendedItemCard (copy), p13 (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy), v98 (copy)
		return Roact.createElement(RecommendedItemCard, {
			itemId = t3.itemId,
			index = n2,
			itemType = t3.itemType,
			getRecommendedItems = p13.getRecommendedItems,
			itemDetailsPeekViewRefs = p13.props.itemDetailsPeekViewRefs,
			resultsListRef = p13.props.listFrameRef,
			impressionsTag = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else v98
		})
	end
	local t4 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, t1.CAROUSEL_ITEM_PADDING),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}

	for i = 1, #items do
		local v102 = items[i]

		table.insert(t4, Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = i,
			Size = UDim2.new(0, t1.TILE_WIDTH, 0, t1.TILE_HEIGHT)
		}, v99(v102, i)))
	end

	local v103 = if not v52 or not v97 then Roact.createElement(WidgetHeader, {
		LayoutOrder = 1,
		titleText = p15.youMayAlsoLike
	}) else nil
	local t5 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	if not v52 or not v97 then
		t5.carousel = Roact.createElement(ScrollingAppCarousel, {
			index = 1,
			carouselMargin = 0,
			items = t4,
			styleProps = t1.CAROUSEL_POSITION,
			itemCount = #t4,
			itemWidth = t1.TILE_WIDTH,
			itemPadding = t1.CAROUSEL_ITEM_PADDING,
			carouselHeight = t1.CAROUSEL_HEIGHT,
			canvasWidth = (t1.TILE_WIDTH + t1.CAROUSEL_ITEM_PADDING) * #t4 - t1.CAROUSEL_ITEM_PADDING,
			onChangeCanvasPosition = function() -- line: 446
			end
		})
	end

	t5.shopMore = Roact.createElement(Button, {
		layoutOrder = 3,
		buttonType = ButtonType.Secondary,
		size = UDim2.new(1, 0, 0, 48),
		text = p15.shopForMore,
		onActivated = p13.onActivated,
		[Roact.Ref] = p13.shopMoreRef,
		NextSelectionUp = v97 and p13.props.NextSelectionUp or p13.loadableGridViewRef
	})

	return Roact.createElement(WidgetLayout, {
		LayoutOrder = p13.props.LayoutOrder,
		padding = {
			left = UDim.new(0, t1.WIDGET_LAYOUT_PADDING),
			right = UDim.new(0, t1.WIDGET_LAYOUT_PADDING)
		},
		headerSlot = v103,
		contentSlot = t5
	})
end
function v59.render(p18) -- line: 471
	-- upvalues: AXEditorRecommendationCarousel (copy), IxpUtils (copy), withStyle (copy), withLocalization (copy)
	local v106 = if not AXEditorRecommendationCarousel.isEnabled() then nil else IxpUtils.readTestVariable(AXEditorRecommendationCarousel.EnableAvatarEditorRecommendationCarousel)

	return withStyle(function(p19) -- line: 476
		-- upvalues: withLocalization (copy), v106 (copy), p18 (copy)
		return withLocalization({
			shopForMore = "Feature.Avatar.Action.ShopForMore",
			youMayAlsoLike = "Feature.Catalog.Label.Recommendations"
		})(function(p20) -- line: 480
			-- upvalues: v106 (copy), p18 (copy), p19 (copy)
			if v106 then
				return p18:renderCarouselWithProviders(p19, p20)
			end

			return p18:renderWithProviders(p19, p20)
		end)
	end)
end

local function mapStateToProps(p21, p22) -- line: 495
	-- upvalues: Utils (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), Constants (copy), Constants2 (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), ReducerUtils (copy), PerformFetch (copy)
	local v109 = Utils.getRecommendedKey(p22.categoryInfo)
	local v110 = if not FFlagAXAvatarTabLooksYouMayAlsoLike or v109 ~= Constants.RecommendationsType.AvatarLooks then if v109 ~= Constants.RecommendationsType.BodyParts and (v109 ~= Constants.RecommendationsType.AvatarAnimations and (v109 ~= Constants.RecommendationsType.Shoes and v109 ~= Constants.RecommendationsType.DynamicHeads)) then Constants2.ItemType.Asset else Constants2.ItemType.Bundle else Constants2.ItemType.Look

	if GetFFlagAXEnableRecommendationTypeAllInCustomize() then
		v109 = ReducerUtils.generateRecommendedItemsKey(v109, p22.categoryInfo.RecommendationsType)
	end

	local v111 = p21.AvatarExperience.AvatarEditor.RecommendedItems[v109] or {}

	return {
		dataStatus = PerformFetch.GetStatus(p21, Constants2.RecommendedItemsKey .. tostring(v109)),
		screenSize = p21.ScreenSize,
		itemType = v110,
		items = v111
	}
end
local function mapDispatchToProps(p23) -- line: 523
	-- upvalues: GetRecommendedItems (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXLogNilCategoryAndSubcategorySelection (copy), mutedError (copy), SetCategoryAndSubcategory (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), Utils (copy), NavigateWithLock (copy)
	return {
		getRecommendedItems = function(p24, p25, p26) -- line: 525
			-- upvalues: p23 (copy), GetRecommendedItems (copy)
			p23(GetRecommendedItems(p24, p25, p26))
		end,
		setCatalogIndicies = function(p27, p28) -- line: 528
			-- upvalues: FFlagAXCatalogCategoriesSDUI (copy), FFlagAXLogNilCategoryAndSubcategorySelection (copy), mutedError (copy), p23 (copy), SetCategoryAndSubcategory (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), Utils (copy)
			if FFlagAXCatalogCategoriesSDUI then
				local CategoryId = p27.MatchingCatalogPageIds.CategoryId
				local SubcategoryId = p27.MatchingCatalogPageIds.SubcategoryId

				if FFlagAXLogNilCategoryAndSubcategorySelection then
					mutedError("Navigating to missing catalog category for", p27.Name)
				end

				p23(SetCategoryAndSubcategory(CategoryId, SubcategoryId, p28))

				return
			end

			local CategoryKey = p27.MatchingCatalogPage.CategoryKey
			local SubcategoryKey = p27.MatchingCatalogPage.SubcategoryKey

			if FFlagAXRemoveCatalogCategoryNavKey then
				local v145 = CategoryKey:rawValue()
				local v146 = if not SubcategoryKey then nil else SubcategoryKey:rawValue()

				if FFlagAXLogNilCategoryAndSubcategorySelection then
					mutedError("Navigating to missing catalog category for", p27.Name)
				end

				p23(SetCategoryAndSubcategory(v145, v146, p28))

				return
			end

			local v147, v148 = Utils.GetCategoryIdsFromNavKey(CategoryKey, SubcategoryKey)

			if FFlagAXLogNilCategoryAndSubcategorySelection then
				mutedError("Navigating to missing catalog category for", p27.Name)
			end

			p23(SetCategoryAndSubcategory(v147, v148, p28))
		end,
		navigateWithLock = function(p29) -- line: 556
			-- upvalues: p23 (copy), NavigateWithLock (copy)
			p23(NavigateWithLock(p29))
		end
	}
end

local v62 = withAvatarRoute((withNavigation((RoactServices.connect({
	catalogAnalytics = Analytics,
	networking = RoactNetworking
})(v59)))))

if FFlagAXCatalogCategoriesSDUI then
	local u63 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v62)

	local function RecommendedItemsWrapper(p30) -- line: 568
		-- upvalues: GetCatalogCategoriesStore (copy), React (copy), u63 (ref)
		local v114 = GetCatalogCategoriesStore.getCatalogCategoriesStore()
		local v115 = p30.categoryInfo and p30.categoryInfo.MatchingCatalogPageIds
		local v116 = v115 and v115.CategoryId
		local v117 = v115 and v115.SubcategoryId
		local useDoesCatalogCategoryExist = GetCatalogCategoriesStore.useDoesCatalogCategoryExist

		assert(useDoesCatalogCategoryExist, "useDoesCatalogCategoryExist should be defined when FFlagAXCatalogCategoriesSDUI is enabled")

		local v119 = useDoesCatalogCategoryExist(v114, v116, v117)
		local v120 = table.clone(p30)

		v120.doesMatchingCatalogCategoryExist = v119

		return React.createElement(u63, v120)
	end

	return RecommendedItemsWrapper
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v62)
