local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local useTokens = require(AvatarExperienceCatalogParent.Foundation).Hooks.useTokens
local AvatarExperienceUIKit = require(AvatarExperienceCatalogParent.AvatarExperienceUIKit)
local Impressions = require(AvatarExperienceCatalogParent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector

require(AvatarExperienceCatalogParent.AppCommonLib)

local ScrollingAppCarousel = require(AvatarExperienceCatalogParent.AppBlox).ScrollingAppCarousel
local FFlagAXCatalogItemInformationPopover = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogItemInformationPopover
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local WidgetListItem = AvatarExperienceUIKit.WidgetComponents.WidgetListItem
local v15 = game:DefineFastInt("WidgetPaddingSizing", 32)

local function resolveBottomPaddingPx(p1) -- line: 49
	-- upvalues: v15 (copy)
	local XXLarge = p1.Padding.XXLarge

	return ({
		[32] = XXLarge,
		[24] = p1.Padding.XXLarge,
		[20] = p1.Padding.XLarge,
		[16] = p1.Padding.Large
	})[v15] or XXLarge
end
local function CatalogItemCarouselSortView(t1: {[any]: any}, p2) -- line: 100
	-- upvalues: useImpressionsTagger (copy), WidgetConstants (copy), useTokens (copy), React (copy), WidgetListItem (copy), v15 (copy), WidgetLayout (copy), WidgetHeader (copy), FFlagAXCatalogItemInformationPopover (copy), ScrollingAppCarousel (copy), ScreenSizeImpressionsDetector (copy)
	useImpressionsTagger(t1.containerRef, WidgetConstants.WidgetExposureMetadata.TagName, t1.widgetRow)

	local v22 = useTokens()
	local v23 = t1.headerText ~= nil and t1.headerText ~= "" or (t1.headerDescription ~= nil and t1.headerDescription ~= "" or t1.seeAllCallback ~= nil)
	local t2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, t1.itemGap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	for _, v26 in t1.visibleItems do
		t2[`item-{ v26.absoluteIndex }`] = t1.renderTile({
			id = v26.id,
			type = v26.type,
			gridInformation = v26.gridInformation
		}, v26.absoluteIndex)
	end

	local createElement = React.createElement
	local v28 = WidgetListItem
	local t3 = {
		ref = p2
	}
	local t4 = {}
	local new = UDim.new
	local XXLarge = v22.Padding.XXLarge

	t4.bottom = new(0, ({
		[32] = XXLarge,
		[24] = v22.Padding.XXLarge,
		[20] = v22.Padding.XLarge,
		[16] = v22.Padding.Large
	})[v15] or XXLarge)
	t3.padding = t4
	t3.horizontalMargin = t1.horizontalMargin

	return createElement(v28, t3, {
		Widget = React.createElement(WidgetLayout, {
			headerSlot = if not v23 then nil else React.createElement(WidgetHeader, {
				LayoutOrder = 1,
				titleText = t1.headerText,
				descriptionText = t1.headerDescription,
				informationPopoverText = if not FFlagAXCatalogItemInformationPopover then nil else t1.informationPopoverText,
				onInformationIconActivated = if not FFlagAXCatalogItemInformationPopover then nil else t1.onInformationIconActivated,
				seeAllCallback = t1.seeAllCallback
			}),
			contentSlot = React.createElement(React.Fragment, nil, {
				["Widget_" .. t1.widgetId] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = t1.containerRef,
					[React.Tag] = "data-testid=CatalogItemCarouselSortView"
				}, React.createElement(ScrollingAppCarousel, {
					carouselHeight = 0,
					shouldExpandToFitContentHeight = true,
					items = t2,
					index = math.max(1, (math.min(t1.carouselIndex, (math.max(1, t1.carouselItemCount))))),
					styleProps = t1.carouselArrowStyleProps,
					itemCount = t1.carouselItemCount,
					itemWidth = math.max(1, t1.itemWidth),
					itemPadding = t1.itemGap,
					carouselMargin = t1.carouselMargin,
					canvasWidth = math.max(1, t1.canvasWidth),
					onChangeCanvasPosition = t1.onScrollChanged,
					onRefCallback = t1.onScrollChanged
				})),
				ImpressionsDetector = React.createElement(ScreenSizeImpressionsDetector, {
					onRequestImpressionsSignal = t1.onItemsUpdatedSignal,
					onImpressionsDetected = t1.onImpressionsDetected,
					filterImpressionFunc = t1.filterImpressionFunc,
					impressionsTag = t1.impressionsKey
				})
			})
		})
	})
end

return React.forwardRef(CatalogItemCarouselSortView)
