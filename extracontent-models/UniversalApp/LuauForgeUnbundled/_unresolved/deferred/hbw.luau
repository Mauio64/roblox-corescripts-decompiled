local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
require("@luauforge/bundled/dKT")

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")

local module2 = require("@luauforge/bundled/fCe")
local recommendationsType = require("@luauforge/bundled/dPt").Enums.RecommendationsType
local module3 = require("@luauforge/deferred/gPt")
local widgetHeader = module3.WidgetComponents.WidgetHeader
local widgetLayout = module3.WidgetComponents.WidgetLayout

local widgetPanelContainer = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Components.WidgetPanelContainer

local module4 = require("@luauforge/deferred/hbx")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local avatarRoute = AvatarExperienceNavigation.AvatarRoute.AvatarRoute
local module6 = require("@luauforge/bundled/fDf")
local module7 = require("@luauforge/bundled/fAe")
local module8 = require("@luauforge/deferred/hcn")
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module9 = require("@luauforge/bundled/dAB")

local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local scrollingAppCarousel = require("@game/CorePackages/Workspace/Packages/AppBlox").ScrollingAppCarousel
local module11 = require("@luauforge/deferred/hcp")
local module12 = require("@luauforge/bundled/dPN")
local module13 = require("@luauforge/deferred/fCX")
local module14 = require("@luauforge/bundled/dPR")
local reducerUtils = require("@luauforge/bundled/dKU").Utils.ReducerUtils

local module15 = require("@luauforge/deferred/hco")

local module16 = require("@luauforge/bundled/dRI")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module18 = require("@luauforge/bundled/dRs")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXLogNilCategoryAndSubcategorySelection = AvatarExperienceFlags.FFlagAXLogNilCategoryAndSubcategorySelection
local fFlagAXAvatarTabWidgetRecommendation = AvatarExperienceFlags.FFlagAXAvatarTabWidgetRecommendation

local module19 = require("@luauforge/bundled/dSW")
local module20 = require("@luauforge/bundled/dFs")
local module21 = require("@luauforge/bundled/eie")
local useNavigateToCatalogCategory = require("@luauforge/deferred/hcq").useNavigateToCatalogCategory

local defineFastFlag = game:DefineFastFlag("AXYouMayAlsoLikeExposureLogging", false)
local defineFastFlag2 = game:DefineFastFlag("AXHideEmptyRecommendations", false)
local fFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike

local defineFastFlag3 = game:DefineFastFlag("AXRecommendedItemsExposureLogging", false)
local fStringAXRecommendedItemsExposureLayer = AvatarExperienceFlags.FStringAXRecommendedItemsExposureLayer

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions

local v5 = {
	TILE_WIDTH = 100,
	TILE_HEIGHT = 180,
	CAROUSEL_POSITION = { leftPosition = 28, rightPosition = 15 },
	CAROUSEL_HEIGHT = 240,
	CAROUSEL_ITEM_PADDING = 10,
	WIDGET_LAYOUT_PADDING = 20
}

local extended = Roact.PureComponent:extend("RecommendedItems")

local strictInterface = t.strictInterface
local v6 = {
	categoryInfo = t.table,
	LayoutOrder = t.optional(t.number),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	baseRef = t.optional(t.table),
	listFrameRef = t.optional(t.table),
	itemDetailsPeekViewRefs = t.table,
	sendShopForMoreAnalytics = t.callback,
	impressionsTag = 0,
	enableUnifiedImpressions = 0,
	screenSize = 0,
	itemType = 0,
	dataStatus = 0,
	items = 0,
	setCatalogIndicies = 0,
	getRecommendedItems = 0,
	navigateWithLock = 0,
	navigation = 0,
	avatarRoute = 0,
	catalogAnalytics = 0,
	networking = 0,
	doesMatchingCatalogCategoryExist = 0,
	onShopForMore = 0
}
local v7 = if fFlagAXRecommendedItemsImpressionExposureLogging then t.optional(t.string) else nil
v6.impressionsTag = v7
local v8 = if fFlagAXEditorRecommendedItemsUnifiedImpressions then t.optional(t.boolean) else nil
v6.enableUnifiedImpressions = v8

v6.screenSize = t.Vector2
v6.itemType = t.string
v6.dataStatus = t.string
v6.items = t.table

v6.setCatalogIndicies = t.callback
v6.getRecommendedItems = t.callback
v6.navigateWithLock = t.callback

v6.navigation = t.table

v6.avatarRoute = avatarRoute.Interface

v6.catalogAnalytics = t.table
v6.networking = t.callback

local v9 = if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then t.optional(t.boolean) else nil
v6.doesMatchingCatalogCategoryExist = v9

local v10 = if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then t.optional(t.callback) else nil
v6.onShopForMore = v10
extended.validateProps = strictInterface(v6)

function extended:init()
	self.loadableGridViewRef = Roact.createRef()
	self.shopMoreRef = Roact.createRef()

	function self.onActivated()
		if fFlagAXMigrateAllTabToSduiDev then
			self.props.onShopForMore()
			return
		end

		local catalogAnalytics = self.props.catalogAnalytics
		local categoryInfo = self.props.categoryInfo

		self.props.setCatalogIndicies(categoryInfo, catalogAnalytics)

		local function fn()
			self.props.navigation.navigate(avatarScreen.Catalog)
			self.props.sendShopForMoreAnalytics()
		end
		self.props.navigateWithLock(fn)
	end

	function self.getRecommendedItems()
		if
			fFlagAXAvatarTabWidgetRecommendation
			and self.props.categoryInfo.RecommendationsType == recommendationsType.Widget
			or (module18() and not self.props.categoryInfo.RecommendationsType or self.props.categoryInfo.RecommendationsType == recommendationsType.None)
		then
			return
		end

		local networking = self.props.networking

		local recommendedAssetTypeIdStringFromCategoryInfo = module2.getRecommendedAssetTypeIdStringFromCategoryInfo(self.props.categoryInfo)
		self.props.getRecommendedItems(
			networking,
			recommendedAssetTypeIdStringFromCategoryInfo,
			self.props.categoryInfo.RecommendationsType,
			true
		)
	end
end

function extended:maybeFetchRecommendedItems()
	if self.props.dataStatus ~= module9.Fetching then
		self.getRecommendedItems()
	end
end

function extended:didMount()
	self:maybeFetchRecommendedItems()

	if defineFastFlag then
		module14.logExperimentExposure(module15)
	end

	if
		defineFastFlag3
		and self.props.categoryInfo.RecommendationsType ~= recommendationsType.All
		and self.props.categoryInfo.RecommendationsType ~= recommendationsType.None
		and (not fFlagAXAvatarTabWidgetRecommendation or self.props.categoryInfo.RecommendationsType ~= recommendationsType.Widget)
	then
		module14.logLayerExposure(fStringAXRecommendedItemsExposureLayer)
	end
end

function extended:didUpdate(p2)
	if
		self.props.avatarRoute.current.name == avatarScreen.AvatarEditor
		and module2.getRecommendedKey(p2.categoryInfo) ~= module2.getRecommendedKey(self.props.categoryInfo)
	then
		self:maybeFetchRecommendedItems()
	end
end

function extended:renderWithProviders(props2, p2)
	local items = self.props.items
	local itemType = self.props.itemType
	local key = self.props.avatarRoute.current.key
	local v11 = #items == 0
	local v12

	if fFlagAXAvatarTabWidgetRecommendation then
		v12 = self.props.categoryInfo.RecommendationsType == recommendationsType.Widget
	end

	local layoutOrder = self.props.LayoutOrder
	local screenSize = self.props.screenSize
	local font = props2.Font
	local theme = props2.Theme

	local font2 = font.HeadingSmall.Font
	local v13 = font.BaseSize * font.HeadingSmall.RelativeSize
	local v14

	if fFlagAXAvatarTabLooksYouMayAlsoLike then
		v14 = self.props.categoryInfo.RecommendationsType == recommendationsType.AvatarLooks
	end

	local v15 = if v14 then module12.ItemTileType.LookItemTile else module12.ItemTileType.AvatarEditorTile
	local v16

	if fFlagAXAvatarTabLooksYouMayAlsoLike then
		v16 = module2.GridItemHeightGetterWithOptions({
			itemTileType = v15,
			fontHeight = v13 + props2.Tokens.Size.Size_300,
			itemPriceEnabled = v14
		})
	else
		v16 = module2.GridItemHeightGetter(v15, v13 + props2.Tokens.Size.Size_300)
	end

	local element = Roact.createElement(button, {
		buttonType = buttonType.Secondary,
		layoutOrder = 3,
		size = UDim2.new(1, 0, 0, 48),
		text = p2.shopForMore,
		onActivated = self.onActivated,
		[Roact.Ref] = self.shopMoreRef
	})
	local doesMatchingCatalogCategoryExist

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		doesMatchingCatalogCategoryExist = self.props.doesMatchingCatalogCategoryExist
	end

	local impressionsTag

	if fFlagAXRecommendedItemsImpressionExposureLogging then
		impressionsTag = self.props.impressionsTag
	else
		impressionsTag = nil
	end

	local enableUnifiedImpressions

	if fFlagAXEditorRecommendedItemsUnifiedImpressions then
		enableUnifiedImpressions = self.props.enableUnifiedImpressions
	else
		enableUnifiedImpressions = nil
	end

	local name

	if
		fFlagAXRecommendedItemsImpressionExposureLogging
		or fFlagAXEditorRecommendedItemsUnifiedImpressions and enableUnifiedImpressions
	then
		name = self.props.categoryInfo.Name
	else
		name = nil
	end

	local fn

	if module16() then
		fn = function(p3, p4, p5)
			local createElement2 = Roact.createElement
			local v19 = {
				itemId = p3.itemId,
				index = p4,
				itemType = p3.itemType,
				getRecommendedItems = self.getRecommendedItems,
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
				resultsListRef = self.props.listFrameRef,
				impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then impressionsTag else nil,
				impressionsCategory = 0,
				enableUnifiedImpressions = 0,
				gridInformation = 0
			}
			local v21 = if fFlagAXRecommendedItemsImpressionExposureLogging or fFlagAXEditorRecommendedItemsUnifiedImpressions then name else nil
			v19.impressionsCategory = v21

			v19.enableUnifiedImpressions = if fFlagAXEditorRecommendedItemsUnifiedImpressions then enableUnifiedImpressions else nil

			v19.gridInformation = p5 and {
				gridPositionRow = p5.row,
				gridPositionColumn = p5.column
			} or nil
			return createElement2(module11, v19)
		end
	else
		fn = function(p3, p4, p5)
			local createElement2 = Roact.createElement
			local v19 = {
				itemId = p3,
				index = p4,
				itemType = itemType,
				getRecommendedItems = self.getRecommendedItems,
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
				resultsListRef = self.props.listFrameRef,
				impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then impressionsTag else nil,
				impressionsCategory = 0,
				enableUnifiedImpressions = 0,
				gridInformation = 0
			}
			local v21 = if fFlagAXRecommendedItemsImpressionExposureLogging or fFlagAXEditorRecommendedItemsUnifiedImpressions then name else nil
			v19.impressionsCategory = v21

			v19.enableUnifiedImpressions = if fFlagAXEditorRecommendedItemsUnifiedImpressions then enableUnifiedImpressions else nil

			v19.gridInformation = p5 and {
				gridPositionRow = p5.row,
				gridPositionColumn = p5.column
			} or nil
			return createElement2(module11, v19)
		end
	end

	local numRecommendedItems = module12.NumRecommendedItems

	local createElement2 = Roact.createElement
	local baseRefsByRef = {
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, 10),
		margin = roactFitComponents.Rect.quad(24, 0, 15, 0),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = theme.BackgroundUIContrast.Transparency,
		BackgroundColor3 = theme.BackgroundUIContrast.Color,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = self.props.baseRef
	}

	local v20 = if not (defineFastFlag2 and v11) then Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		Font = font2,
		TextColor3 = theme.TextEmphasis.Color,
		Text = p2.youMayAlsoLike,
		TextSize = v13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		LayoutOrder = 1
	}) else nil
	local v21

	if fFlagAXAvatarTabWidgetRecommendation and v12 then
		v21 = Roact.createElement(module4, {}, {
			WidgetPanel = Roact.createElement(widgetPanelContainer, {
				LayoutOrder = 2,
				context = self.props.categoryInfo.RecommendationWidgetContext,
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs
			})
		})
	elseif not (defineFastFlag2 and v11) then
		v21 = Roact.createElement(DefaultMetricsGridView, {
			LayoutOrder = 2,
			items = items,
			totalNumItems = numRecommendedItems,
			getItemHeight = v16,
			windowHeight = screenSize.Y,
			renderItem = fn,
			[Roact.Ref] = self.loadableGridViewRef,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.shopMoreRef,
			NextSelectionRight = key and self.props.itemDetailsPeekViewRefs[key]
		})
	end

	if
		(fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev)
		and not doesMatchingCatalogCategoryExist
	then
		element = nil
	end

	return createElement2(fitFrameVertical, baseRefsByRef, {
		YouMayAlsoLikeTextLabel = v20,
		GridView = v21,
		ShopForMoreButton = element
	})
end

function extended:renderCarouselWithProviders(p2, p3)
	local items = self.props.items
	local itemType = self.props.itemType
	local v11 = #items == 0
	local impressionsTag

	if fFlagAXRecommendedItemsImpressionExposureLogging then
		impressionsTag = self.props.impressionsTag
	else
		impressionsTag = nil
	end

	local enableUnifiedImpressions

	if fFlagAXEditorRecommendedItemsUnifiedImpressions then
		enableUnifiedImpressions = self.props.enableUnifiedImpressions
	else
		enableUnifiedImpressions = nil
	end

	local name

	if fFlagAXEditorRecommendedItemsUnifiedImpressions and enableUnifiedImpressions then
		name = self.props.categoryInfo.Name
	else
		name = nil
	end

	local fn

	if module16() then
		fn = function(p4, p5)
			return Roact.createElement(module11, {
				itemId = p4.itemId,
				index = p5,
				itemType = p4.itemType,
				getRecommendedItems = self.getRecommendedItems,
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
				resultsListRef = self.props.listFrameRef,
				impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then impressionsTag else nil,
				impressionsCategory = if fFlagAXEditorRecommendedItemsUnifiedImpressions then name else nil,
				enableUnifiedImpressions = if fFlagAXEditorRecommendedItemsUnifiedImpressions then enableUnifiedImpressions else nil
			})
		end
	else
		fn = function(p4, p5)
			return Roact.createElement(module11, {
				itemId = p4,
				index = p5,
				itemType = itemType,
				getRecommendedItems = self.getRecommendedItems,
				itemDetailsPeekViewRefs = self.props.itemDetailsPeekViewRefs,
				resultsListRef = self.props.listFrameRef,
				impressionsTag = if fFlagAXRecommendedItemsImpressionExposureLogging then impressionsTag else nil,
				impressionsCategory = if fFlagAXEditorRecommendedItemsUnifiedImpressions then name else nil,
				enableUnifiedImpressions = if fFlagAXEditorRecommendedItemsUnifiedImpressions then enableUnifiedImpressions else nil
			})
		end
	end

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v5.CAROUSEL_ITEM_PADDING),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}

	for i = 1, #items do
		local item = items[i]
		table.insert(
			children,
			Roact.createElement(
				"Frame",
				{
					LayoutOrder = i,
					Size = UDim2.new(0, v5.TILE_WIDTH, 0, v5.TILE_HEIGHT),
					BackgroundTransparency = 1
				},
				fn(item, i)
			)
		)
	end

	local v12

	if not (defineFastFlag2 and v11) then
		v12 = Roact.createElement(widgetHeader, {
			LayoutOrder = 1,
			titleText = p3.youMayAlsoLike
		})
	end

	local children2 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	if not (defineFastFlag2 and v11) then
		children2.carousel = Roact.createElement(scrollingAppCarousel, {
			items = children,
			index = 1,
			styleProps = v5.CAROUSEL_POSITION,
			itemCount = #children,
			itemWidth = v5.TILE_WIDTH,
			itemPadding = v5.CAROUSEL_ITEM_PADDING,
			carouselMargin = 0,
			carouselHeight = v5.CAROUSEL_HEIGHT,
			canvasWidth = (v5.TILE_WIDTH + v5.CAROUSEL_ITEM_PADDING) * #children - v5.CAROUSEL_ITEM_PADDING,
			onChangeCanvasPosition = function() end
		})
	end

	children2.shopMore = Roact.createElement(button, {
		layoutOrder = 3,
		buttonType = buttonType.Secondary,
		size = UDim2.new(1, 0, 0, 48),
		text = p3.shopForMore,
		onActivated = self.onActivated,
		[Roact.Ref] = self.shopMoreRef,
		NextSelectionUp = v11 and self.props.NextSelectionUp or self.loadableGridViewRef
	})

	return Roact.createElement(widgetLayout, {
		LayoutOrder = self.props.LayoutOrder,
		padding = {
			left = UDim.new(0, v5.WIDGET_LAYOUT_PADDING),
			right = UDim.new(0, v5.WIDGET_LAYOUT_PADDING)
		},
		headerSlot = v12,
		contentSlot = children2
	})
end

function extended:render()
	local v11

	if module15.isEnabled() then
		v11 = module14.readTestVariable(module15.EnableAvatarEditorRecommendationCarousel)
	else
		v11 = nil
	end

	return withStyle(function(p2)
		return withLocalization({
			shopForMore = "Feature.Avatar.Action.ShopForMore",
			youMayAlsoLike = "Feature.Catalog.Label.Recommendations"
		})(function(p3)
			if v11 then
				return self:renderCarouselWithProviders(p2, p3)
			end

			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local function mapStateToProps(p2, p3)
	local recommendedKey = module2.getRecommendedKey(p3.categoryInfo)
	local v11

	if fFlagAXAvatarTabLooksYouMayAlsoLike and recommendedKey == recommendationsType.AvatarLooks then
		v11 = module12.ItemType.Look
	elseif
		recommendedKey == recommendationsType.BodyParts
		or recommendedKey == recommendationsType.AvatarAnimations
		or recommendedKey == recommendationsType.Shoes
		or recommendedKey == recommendationsType.DynamicHeads
	then
		v11 = module12.ItemType.Bundle
	else
		v11 = module12.ItemType.Asset
	end

	if module16() then
		recommendedKey = reducerUtils.generateRecommendedItemsKey(
			recommendedKey,
			p3.categoryInfo.RecommendationsType
		)
	end

	local v12 = p2.AvatarExperience.AvatarEditor.RecommendedItems[recommendedKey] or {}

	return {
		dataStatus = performFetch.GetStatus(p2, module12.RecommendedItemsKey .. tostring(recommendedKey)),
		screenSize = p2.ScreenSize,
		itemType = v11,
		items = v12
	}
end

local function mapDispatchToProps(callback)
	return {
		getRecommendedItems = function(p2, p3, p4)
			callback(module8(p2, p3, p4))
		end,
		setCatalogIndicies = function(data, p2)
			if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
				local categoryId = data.MatchingCatalogPageIds.CategoryId
				local subcategoryId = data.MatchingCatalogPageIds.SubcategoryId

				if fFlagAXLogNilCategoryAndSubcategorySelection then
					module20("Navigating to missing catalog category for", data.Name)
				end

				callback(module13(categoryId, subcategoryId, p2))
			else
				local categoryKey = data.MatchingCatalogPage.CategoryKey
				local subcategoryKey = data.MatchingCatalogPage.SubcategoryKey
				local rawValue = categoryKey:rawValue()
				local v11 = if subcategoryKey then subcategoryKey:rawValue() else nil

				if fFlagAXLogNilCategoryAndSubcategorySelection then
					module20("Navigating to missing catalog category for", data.Name)
				end

				callback(module13(rawValue, v11, p2))
			end
		end,
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end
	}
end

local v11 = module7((withNavigation((roactServices.connect({
	catalogAnalytics = module6,
	networking = module
})(extended)))))

if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
	local v12 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v11)

	local function RecommendedItemsWrapper(p2)
		local catalogCategoriesStore = module19.getCatalogCategoriesStore()

		local matchingCatalogPageIds = p2.categoryInfo and p2.categoryInfo.MatchingCatalogPageIds
		local categoryId = matchingCatalogPageIds and matchingCatalogPageIds.CategoryId
		local subcategoryId = matchingCatalogPageIds and matchingCatalogPageIds.SubcategoryId

		local useDoesCatalogCategoryExist = module19.useDoesCatalogCategoryExist
		assert(
			useDoesCatalogCategoryExist,
			"useDoesCatalogCategoryExist should be defined when FFlagAXCatalogCategoriesSDUI or FFlagAXMigrateAllTabToSduiDev is enabled"
		)

		local v13 = useDoesCatalogCategoryExist(catalogCategoriesStore, categoryId, subcategoryId)
		local v14

		if fFlagAXMigrateAllTabToSduiDev then
			local v15 = module21(module6)
			local v16 = useNavigateToCatalogCategory()
			local sendShopForMoreAnalytics = p2.sendShopForMoreAnalytics
			v14 = React.useCallback(function()
				v16(matchingCatalogPageIds, {
					analytics = v15,
					onAfterNavigate = sendShopForMoreAnalytics
				})
			end, { v16, matchingCatalogPageIds, v15, sendShopForMoreAnalytics })
		end

		local clone = table.clone(p2)
		clone.doesMatchingCatalogCategoryExist = v13
		clone.onShopForMore = v14

		return React.createElement(v12, clone)
	end

	return RecommendedItemsWrapper
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v11)
