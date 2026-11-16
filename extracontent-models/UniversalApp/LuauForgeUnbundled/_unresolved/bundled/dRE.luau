local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dPV")
local useSignalState = require("@luauforge/bundled/dRp").useSignalState

local module3 = require("@luauforge/bundled/dRz")

local catalogItemGroupSortContainer = module3.Components.CatalogItemGroupSort.CatalogItemGroupSortContainer
local CATALOG_RESULTS_HORIZONTAL_MARGIN = module3.Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local catalogSduiPageContext = module3.Sdui.CatalogSduiPageContext
local getCatalogPageRequestIdStore = module3.Stores.getCatalogPageRequestIdStore
require("@luauforge/bundled/dQS")
local module4 = require("@luauforge/bundled/dQh")

require("@luauforge/bundled/dQa")
require("@luauforge/bundled/dRF")
local module5 = require("@luauforge/bundled/dRG")
local module6 = require("@luauforge/bundled/dRH")
require("@luauforge/bundled/dRD")
local module7 = require("@luauforge/bundled/dRI")
local module8 = require("@luauforge/bundled/dRJ")

local module9 = require("@luauforge/bundled/dPZ")
local fFlagAXSduiWidgetsTTITracking = module9.FFlagAXSduiWidgetsTTITracking
local fFlagAXSduiSponsoredItemClickTracking = module9.FFlagAXSduiSponsoredItemClickTracking
local fFlagAXSduiCatalogItemGroupNilIdGuard = module9.FFlagAXSduiCatalogItemGroupNilIdGuard

local v5 = if fFlagAXSduiCatalogItemGroupNilIdGuard then module2.createSignal(nil) else nil

local function getAdTrackingDataByItemId(p2)
	if p2 == nil or p2.content == nil then
		return nil
	end

	local encrypted_ad_tracking_datasById = {}

	for k, v6 in p2.content do
		local encrypted_ad_tracking_data = v6.encrypted_ad_tracking_data or v6.encryptedAdTrackingData

		if encrypted_ad_tracking_data ~= nil and encrypted_ad_tracking_data ~= "" then
			encrypted_ad_tracking_datasById[v6.id] = encrypted_ad_tracking_data
		end
	end

	if next(encrypted_ad_tracking_datasById) == nil then
		return nil
	end

	return encrypted_ad_tracking_datasById
end

local function SduiCatalogItemGroup(props)
	local id = props.id
	local kind = props.type
	local content = props.content
	local previewRows = props.previewRows
	local previewColumns = props.previewColumns
	local title = props.title
	local description = props.description
	local itemFooters = props.itemFooters or module7.DEFAULT_ITEM_FOOTERS
	local cardStyle = props.cardStyle
	local tagId = props.tagId
	local informationPopoverText = props.informationPopoverText
	local layoutOrder = props.layoutOrder or props.startRow or 1

	local v6 = previewColumns or module7.DEFAULT_PREVIEW_COLUMNS
	local v7 = previewRows or 1

	local v8 = module.useMemo(function()
		return {
			id = id,
			type = kind,
			content = content or {},
			template = {
				type = "ItemGroup",
				localizedTitle = title,
				localizedDescription = description,
				informationPopoverText = informationPopoverText,
				itemFooters = itemFooters,
				cardStyle = cardStyle,
				previewRows = v7,
				previewColumns = v6
			},
			tagId = tagId
		}
	end, {
		id,
		kind,
		content,
		title,
		description,
		informationPopoverText,
		itemFooters,
		cardStyle,
		tagId,
		v7,
		v6
	})

	local v9 = module.useContext(catalogSduiPageContext)
	local identifier = if v9 then v9.identifier else nil
	local catalogPageRequestIdStore = getCatalogPageRequestIdStore(false)
	local v10 = useSignalState(catalogPageRequestIdStore.getPageRequestIdMap)[identifier or ""]

	module.useEffect(function()
		if identifier ~= nil then
			catalogPageRequestIdStore.getOrCreatePageRequestId(identifier)
		end
	end, { identifier, catalogPageRequestIdStore })

	local v11 = module.useMemo(function()
		local v12 = content or {}
		local ids = {}

		for i = 1, math.min(#v12, v6) do
			local v13 = v12[i]

			if v13 ~= nil and v13.id ~= nil then
				table.insert(ids, v13.id)
			end
		end

		return ids
	end, { content, v6 })

	local v12 = module.useMemo(function()
		return {
			widgetId = id,
			widgetType = kind,
			widgetPosition = layoutOrder,
			widgetAbsPosition = (layoutOrder - 1) * v6,
			requestId = v10,
			widgetItemIds = v11
		}
	end, { id, kind, layoutOrder, v6, v10, v11 })

	local v13 = module6(props.onSeeAll)

	local v14, v15 = module5(props.feedRowWidth)

	local horizontalMargin = props.horizontalMargin or CATALOG_RESULTS_HORIZONTAL_MARGIN

	local v16 = if fFlagAXSduiWidgetsTTITracking then module.useContext(module8) else nil
	local v17

	if fFlagAXSduiSponsoredItemClickTracking then
		local marketplaceCatalogSortStore = module4.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)
		local v19

		if fFlagAXSduiCatalogItemGroupNilIdGuard and id == nil then
			v19 = v5
		else
			v19 = marketplaceCatalogSortStore.getMarketplaceCatalogSort(id).data
		end

		local v20 = useSignalState(v19)

		v17 = module.useMemo(function()
			return getAdTrackingDataByItemId(v20)
		end, { v20 })
	end

	local createElement = module.createElement
	local v19 = {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[module.Change.AbsoluteSize] = v15
	}

	local createElement2 = module.createElement
	local v22 = {
		widgetRow = layoutOrder,
		widgetInfo = v8,
		itemsPerRow = v6,
		rowCount = v7,
		widgetAnalyticsInfo = v12,
		onSeeAll = v13,
		rowWidth = v14,
		horizontalMargin = horizontalMargin,
		onThumbnailLoaded = v16,
		adTrackingDataByItemId = nil
	}

	if not fFlagAXSduiSponsoredItemClickTracking then
		v17 = nil
	end

	v22.adTrackingDataByItemId = v17
	return createElement("Frame", v19, {
		Group = createElement2(catalogItemGroupSortContainer, v22)
	})
end

return module.memo(SduiCatalogItemGroup)
