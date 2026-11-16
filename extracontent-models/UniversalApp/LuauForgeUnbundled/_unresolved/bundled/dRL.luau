local module = require("@luauforge/bundled/dPU")

local module2 = require("@luauforge/bundled/dRr")
local useTokens = module2.Hooks.useTokens

local virtualizedFeed = require("@luauforge/bundled/dRq").FeedComponents.VirtualizedFeed

local module3 = require("@luauforge/bundled/dRz")
local CATALOG_RESULTS_HORIZONTAL_MARGIN = module3.Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local getFooterVisibilityFromItemFooters = module3.Utils.getFooterVisibilityFromItemFooters
local catalogPageMonolithDependenciesContext = module3.Providers.CatalogPageMonolithDependenciesContext
local useHydrateCatalogItemGridOnDemandEffect = module3.Hooks.useHydrateCatalogItemGridOnDemandEffect
local useCatalogSduiPageRequestId = module3.Sdui.useCatalogSduiPageRequestId

local sduiErrors = require("@luauforge/bundled/dQa").SduiErrors
local module4 = require("@luauforge/bundled/dRH")
require("@luauforge/bundled/dRF")
require("@luauforge/bundled/dRD")
local module5 = require("@luauforge/bundled/dRI")

require("@luauforge/bundled/dQS")

local v5 = {}

local function computeItemWidth(p2, p3, p4)
	local v6 = not (p3 > 0) and 1 or p3
	return (math.floor(math.max(0, p2 - (v6 - 1) * p4) / v6))
end

local function createRefCache()
	return (setmetatable({}, {
		__index = function(p2, p3)
			local ref = module.createRef()
			rawset(p2, p3, ref)
			return ref
		end
	}))
end

local function chunkIntoRows(content, previewColumns)
	local v6 = math.max(1, previewColumns)
	local result = {}

	for k, item in content do
		local v7 = math.floor((k - 1) / v6) + 1
		local v8 = result[v7]

		if v8 == nil then
			v8 = {}
			result[v7] = v8
		end

		table.insert(v8, item)
	end

	return result
end

local function SduiCatalogItemGrid(props)
	local content = props.content or v5
	local previewColumns = props.previewColumns or module5.DEFAULT_PREVIEW_COLUMNS

	local DEFAULT_ITEM_FOOTERS = module5.DEFAULT_ITEM_FOOTERS

	local v6 = useTokens()

	local medium = v6.Gap.Medium

	local large = v6.Padding.Large

	local v7 = module.useContext(catalogPageMonolithDependenciesContext)
	local widgetTileWithImpressionsTagging = if v7 then v7.WidgetTileWithImpressionsTagging else nil

	module.useEffect(function()
		if widgetTileWithImpressionsTagging ~= nil then
			return
		end

		local sduiContext = props.sduiContext
		local reportError

		if sduiContext.dependencies and sduiContext.dependencies.logger then
			reportError = sduiContext.dependencies.logger.reportError
		end

		if reportError then
			reportError(
				sduiErrors.SduiErrorType.InvalidProps,
				{
					name = "CatalogItemGrid",
					message = "WidgetTileWithImpressionsTagging not provided by CatalogPageMonolithDependenciesContext; grid tiles will not render"
				},
				sduiContext.appPage
			)
		end
	end, { widgetTileWithImpressionsTagging, props.sduiContext })

	local footerVisibilityFromItemFooters = getFooterVisibilityFromItemFooters(DEFAULT_ITEM_FOOTERS)

	local v8 = module.useMemo(createRefCache, {})

	local state, setState = module.useState(0)
	local v9 = module.useCallback(function(p2)
		setState((math.max(0, p2 - 2 * CATALOG_RESULTS_HORIZONTAL_MARGIN)))
	end, {})
	local v10 = not (previewColumns > 0) and 1 or previewColumns
	local v11 = math.floor(math.max(0, state - (v10 - 1) * medium) / v10)

	local v12 = module.useMemo(function()
		return chunkIntoRows(content, previewColumns)
	end, { content, previewColumns })

	local v13, v14 = useCatalogSduiPageRequestId()

	local v15 = v13 == nil and props.debugName == nil
	local v16 = v13 or props.debugName or "catalog-item-grid"
	local v17 = "CATALOG_ITEM_GRID" .. "_" .. v16

	module.useEffect(function()
		if not v15 then
			return
		end

		local sduiContext = props.sduiContext
		local reportError

		if sduiContext.dependencies and sduiContext.dependencies.logger then
			reportError = sduiContext.dependencies.logger.reportError
		end

		if reportError then
			reportError(
				sduiErrors.SduiErrorType.InvalidProps,
				{
					name = "CatalogItemGrid",
					message = "CatalogSduiPageContext.identifier (and debugName) missing; falling back to shared widgetId \"catalog-item-grid\" — impressions/hydration keys may collide if multiple grids mount"
				},
				sduiContext.appPage
			)
		end
	end, { v15, props.sduiContext })

	useHydrateCatalogItemGridOnDemandEffect(v16, content)

	local v18 = module.useCallback(function(p2, p3)
		if widgetTileWithImpressionsTagging == nil then
			return nil
		end

		local v19 = {
			widgetId = v16,
			widgetType = props.type,
			requestId = v14,
			itemPosition = p3,
			itemId = p2.id,
			itemType = p2.type
		}

		return module.createElement(widgetTileWithImpressionsTagging, {
			size = UDim2.new(0, v11, 0, 0),
			contentType = p2.type,
			tileContentType = props.type,
			contentId = p2.id or "",
			index = p3,
			refCache = v8,
			itemsPerRow = previewColumns,
			analyticsItemCountPerPage = previewColumns,
			isCreatorNameVisible = footerVisibilityFromItemFooters.isCreatorNameVisible,
			isTitleVisible = footerVisibilityFromItemFooters.isTitleVisible,
			isPriceVisible = footerVisibilityFromItemFooters.isPriceVisible,
			impressionsTag = v17,
			widgetAnalyticsInfo = v19
		})
	end, {
		widgetTileWithImpressionsTagging,
		v11,
		previewColumns,
		footerVisibilityFromItemFooters.isCreatorNameVisible,
		footerVisibilityFromItemFooters.isTitleVisible,
		footerVisibilityFromItemFooters.isPriceVisible,
		v17,
		v16,
		props.type,
		v8,
		v14
	})

	local v19 = module.useCallback(function(p2)
		local item = p2.item
		local index = p2.index
		local v20 = index == 1
		local v21 = index == #v12

		local children = {}

		for k, v22 in item do
			local v23 = (index - 1) * previewColumns + k
			local v24 = v18(v22, v23)

			if v24 == nil then
				continue
			end

			local v25 = if v22.id == nil then `tile-idx-{v23}` else `tile-{v22.id}`
			children[v25] = module.createElement(
				module2.View,
				{ Size = UDim2.new(0, v11, 0, 0), tag = "auto-y", LayoutOrder = k },
				v24
			)
		end

		local createElement = module.createElement
		local view = module2.View
		local v22 = {
			tag = "row align-x-left align-y-top size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, medium),
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			padding = 0,
			LayoutOrder = 0
		}

		local newUDim = UDim.new
		local v25 = if v20 then large else medium
		local v23 = { top = newUDim(0, v25), bottom = 0 }
		local v26 = if v21 then UDim.new(0, large) else nil
		v23.bottom = v26
		v22.padding = v23

		v22.LayoutOrder = index
		return createElement(view, v22, children)
	end, { v18, v11, previewColumns, medium, large, v12 })

	local v20 = module4(props.onLoadMore)

	local ref = module.useRef(nil)
	local v21 = module.useCallback(function()
		if not (v20 ~= nil and ref.current ~= content) then
			return
		end

		ref.current = content
		v20()
	end, { v20, content })

	return module.createElement(virtualizedFeed, {
		data = v12,
		renderItem = v19,
		horizontalPadding = CATALOG_RESULTS_HORIZONTAL_MARGIN,
		onContainerWidthChanged = v9,
		onEndReached = v21,
		onEndReachedThreshold = props.onEndReachedThreshold or 0.1,
		LayoutOrder = props.layoutOrder,
		Size = props.Size
	})
end

return module.memo(SduiCatalogItemGrid)
