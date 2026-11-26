local module = require("@luauforge/bundled/dTk")
local useSignalState = require("@luauforge/bundled/dUJ").useSignalState

local module2 = require("@luauforge/bundled/dUU")

local catalogItemCarouselSortContainer = module2.Components.CatalogItemCarouselSort.CatalogItemCarouselSortContainer
local CATALOG_RESULTS_HORIZONTAL_MARGIN = module2.Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local catalogSduiPageContext = module2.Sdui.CatalogSduiPageContext
local getCatalogPageRequestIdStore = module2.Stores.getCatalogPageRequestIdStore
require("@luauforge/bundled/dUj")

require("@luauforge/bundled/dTq")
require("@luauforge/bundled/dVa")
local module3 = require("@luauforge/bundled/dVb")
local module4 = require("@luauforge/bundled/dVc")
require("@luauforge/bundled/dUY")
local module5 = require("@luauforge/bundled/dVd")
local module6 = require("@luauforge/bundled/dVe")

local fFlagAXSduiWidgetsTTITracking = require("@luauforge/bundled/dTp").FFlagAXSduiWidgetsTTITracking

local function SduiCatalogItemCarousel(props)
	local id = props.id
	local kind = props.type
	local content = props.content
	local numItemsToShow = props.numItemsToShow
	local previewColumns = props.previewColumns
	local title = props.title
	local description = props.description
	local itemFooters = props.itemFooters or module5.DEFAULT_ITEM_FOOTERS
	local cardStyle = props.cardStyle
	local tagId = props.tagId
	local informationPopoverText = props.informationPopoverText

	local layoutOrder = props.layoutOrder or props.startRow or 1

	local v5 = previewColumns or module5.DEFAULT_PREVIEW_COLUMNS

	local v6 = module.useMemo(function()
		return {
			id = id,
			type = kind,
			content = content or {},
			template = {
				type = "Carousel",
				numItemsToShow = numItemsToShow,
				localizedTitle = title,
				localizedDescription = description,
				informationPopoverText = informationPopoverText,
				itemFooters = itemFooters,
				cardStyle = cardStyle,
				previewRows = 1,
				previewColumns = v5
			},
			tagId = tagId
		}
	end, {
		id,
		kind,
		content,
		numItemsToShow,
		title,
		description,
		informationPopoverText,
		itemFooters,
		cardStyle,
		tagId,
		v5
	})

	local v7 = module.useContext(catalogSduiPageContext)
	local identifier = if v7 then v7.identifier else nil
	local catalogPageRequestIdStore = getCatalogPageRequestIdStore(false)
	local v8 = useSignalState(catalogPageRequestIdStore.getPageRequestIdMap)[identifier or ""]

	module.useEffect(function()
		if identifier ~= nil then
			catalogPageRequestIdStore.getOrCreatePageRequestId(identifier)
		end
	end, { identifier, catalogPageRequestIdStore })

	local v9 = module.useMemo(function()
		local v10 = content or {}
		local ids = {}

		for i = 1, math.min(#v10, v5) do
			local v11 = v10[i]

			if v11 ~= nil and v11.id ~= nil then
				table.insert(ids, v11.id)
			end
		end

		return ids
	end, { content, v5 })

	local v10 = module.useMemo(function()
		return {
			widgetId = id,
			widgetType = kind,
			widgetPosition = layoutOrder,
			widgetAbsPosition = (layoutOrder - 1) * v5,
			requestId = v8,
			widgetItemIds = v9
		}
	end, { id, kind, layoutOrder, v5, v8, v9 })

	local v11 = module4(props.onSeeAll)

	local v12, v13 = module3(props.feedRowWidth)

	local horizontalMargin = props.horizontalMargin or CATALOG_RESULTS_HORIZONTAL_MARGIN

	local v14 = if fFlagAXSduiWidgetsTTITracking then module.useContext(module6) else nil

	return module.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[module.Change.AbsoluteSize] = v13
		},
		{
			Carousel = module.createElement(catalogItemCarouselSortContainer, {
				widgetRow = layoutOrder,
				widgetInfo = v6,
				itemsPerRow = v5,
				widgetAnalyticsInfo = v10,
				onSeeAll = v11,
				rowWidth = v12,
				horizontalMargin = horizontalMargin,
				onThumbnailLoaded = v14
			})
		}
	)
end

return module.memo(SduiCatalogItemCarousel)
