local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local Impressions = require(parent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
require(parent.AppCommonLib)
local AppBlox = require(parent.AppBlox)
local ScrollingAppCarousel = AppBlox.ScrollingAppCarousel

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local FFlagAXCatalogUseFixedWidgetPadding = AvatarExperienceFlags.FFlagAXCatalogUseFixedWidgetPadding
local FFlagAXSduiSeeAllClickLogging = AvatarExperienceFlags.FFlagAXSduiSeeAllClickLogging
local FFlagAXSduiSortLegacyBottomPadding = AvatarExperienceFlags.FFlagAXSduiSortLegacyBottomPadding

local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local resolveWidgetListItemBottomPaddingPx = require(AvatarExperienceCatalog.Utils.resolveWidgetListItemBottomPaddingPx)

local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local WidgetListItem = AvatarExperienceUIKit.WidgetComponents.WidgetListItem

local function CatalogItemCarouselSortView(props, ref)
	useImpressionsTagger(props.containerRef, WidgetConstants.WidgetExposureMetadata.TagName, props.widgetRow)
	local v = useTokens()
	local v2 = props.headerText ~= nil and props.headerText ~= ""
		or props.headerDescription ~= nil and props.headerDescription ~= ""
		or props.seeAllCallback ~= nil

	local items = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, props.itemGap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	}

	for _, visibleItem in props.visibleItems do
		items[`item-{visibleItem.absoluteIndex}`] = props.renderTile(
			{
				id = visibleItem.id,
				type = visibleItem.type,
				gridInformation = visibleItem.gridInformation
			},
			visibleItem.absoluteIndex
		)
	end

	local createElement = React.createElement
	local v3

	if FFlagAXSduiSortLegacyBottomPadding then
		v3 = v.Size.Size_600
	elseif FFlagAXCatalogUseFixedWidgetPadding then
		v3 = v.Size.Size_800
	else
		v3 = resolveWidgetListItemBottomPaddingPx(v)
	end

	local v4 = {
		ref = ref,
		padding = { bottom = UDim.new(0, v3) },
		horizontalMargin = props.horizontalMargin
	}

	local createElement2 = React.createElement
	local headerSlot

	if v2 then
		local createElement3 = React.createElement
		local v5 = {
			titleText = props.headerText,
			descriptionText = props.headerDescription,
			informationPopoverText = 0,
			onInformationIconActivated = 0,
			seeAllCallback = 0,
			seeAllRef = 0,
			LayoutOrder = 1
		}
		local informationPopoverText

		if FFlagAXCatalogItemInformationPopover then
			informationPopoverText = props.informationPopoverText
		end

		v5.informationPopoverText = informationPopoverText
		local onInformationIconActivated

		if FFlagAXCatalogItemInformationPopover then
			onInformationIconActivated = props.onInformationIconActivated
		end

		v5.onInformationIconActivated = onInformationIconActivated

		v5.seeAllCallback = props.seeAllCallback
		local seeAllRef

		if FFlagAXSduiSeeAllClickLogging then
			seeAllRef = props.seeAllRef
		end

		v5.seeAllRef = seeAllRef
		headerSlot = createElement3(WidgetHeader, v5)
	end

	return createElement(WidgetListItem, v4, {
		Widget = createElement2(WidgetLayout, {
			headerSlot = headerSlot,
			contentSlot = React.createElement(React.Fragment, nil, {
				["Widget_" .. props.widgetId] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ref = props.containerRef,
					[React.Tag] = "data-testid=CatalogItemCarouselSortView"
				}, React.createElement(ScrollingAppCarousel, {
					items = items,
					index = math.max(1, (math.min(props.carouselIndex, (math.max(1, props.carouselItemCount))))),
					styleProps = props.carouselArrowStyleProps,
					itemCount = props.carouselItemCount,
					itemWidth = math.max(1, props.itemWidth),
					itemPadding = props.itemGap,
					carouselMargin = props.carouselMargin,
					carouselHeight = 0,
					canvasWidth = math.max(1, props.canvasWidth),
					onChangeCanvasPosition = props.onScrollChanged,
					onRefCallback = props.onScrollChanged,
					shouldExpandToFitContentHeight = true
				})),
				ImpressionsDetector = React.createElement(ScreenSizeImpressionsDetector, {
					onRequestImpressionsSignal = props.onItemsUpdatedSignal,
					onImpressionsDetected = props.onImpressionsDetected,
					filterImpressionFunc = props.filterImpressionFunc,
					impressionsTag = props.impressionsKey
				})
			})
		})
	})
end

return React.forwardRef(CatalogItemCarouselSortView)
