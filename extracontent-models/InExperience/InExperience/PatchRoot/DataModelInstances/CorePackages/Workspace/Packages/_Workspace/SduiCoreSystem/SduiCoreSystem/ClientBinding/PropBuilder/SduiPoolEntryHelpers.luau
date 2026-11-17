local HttpService = game:GetService("HttpService")

local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiPoolStore = require(SduiCoreSystem.ClientBinding.SduiPoolStore)
require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)
require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)
local SduiListEntryRenderer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryRenderer)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local analyticsConstants = require(SduiCoreSystem.Analytics.analyticsConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags.FFlagSduiCollectionGridRevealRows
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiSkipFeedAnalyticsPosition = SharedFlags2.FFlagSduiSkipFeedAnalyticsPosition
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiPerSectionPoolSizing = SharedFlags3.FFlagSduiPerSectionPoolSizing

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = SharedFlags4.FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSduiSamePoolFeedItemSpacing = SharedFlags5.FFlagSduiSamePoolFeedItemSpacing

local v = FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and {} or nil

local function getOneByTwoTileFlowId(k, k2, value, kind)
	local native_ad_data = value.native_ad_data
	local v2 = string.format(
		"%s:%s:%s:%s",
		tostring(k),
		tostring(k2),
		tostring(value.universe_id or ""),
		typeof(native_ad_data) ~= "string" and "" or native_ad_data
	)

	local v3 = v[v2]

	if v3 == nil then
		v3 = HttpService:GenerateGUID(false):lower()
		v[v2] = v3
	end

	if typeof(native_ad_data) ~= "string" or native_ad_data == "" then
		native_ad_data = nil
	end

	local kind2 = kind and kind.type
	return v3, native_ad_data, kind2 == "universe" and "Game" or kind2 == "ad_link" and "AdLink" or nil
end

local function getOneByTwoTileFlowIdsFromPools(items)
	local one = {}

	if items == nil then
		return one
	end

	for k, item in items do
		if typeof(item) ~= "table" then
			continue
		end

		for k2, v2 in item.items or {} do
			if typeof(v2) ~= "table" then
				continue
			end

			local kind = v2.kind
			local value = kind and kind.value
			local layout = v2.layout

			if not (typeof(value) == "table" and typeof(layout) == "table" and (layout.col_span or layout.colSpan or 1) == 1) then
				continue
			end

			if (layout.row_span or layout.rowSpan or 1) ~= 2 then
				continue
			end

			local oneByTwoTileFlowId, adId, contentType = getOneByTwoTileFlowId(k, k2, value, kind)
			table.insert(one, {
				oneByTwoTileFlowId = oneByTwoTileFlowId,
				contentType = contentType,
				adId = adId,
				alignmentType = layout.alignment_type or layout.alignmentType
			})
		end
	end

	return one
end

local fn = FFlagSduiSkipFeedAnalyticsPosition and function(p): boolean
	if typeof(p) ~= "table" then
		return false
	end

	local value = p.kind and p.kind.value
	local Shared = value and value.shared
	local analytics_data = Shared and Shared.analytics_data
	local v2 = analytics_data and analytics_data[analyticsConstants.DoesNotAdvanceStartRow]
	local kind = v2 and v2.kind
	return kind ~= nil and kind.type == "literal" and kind.value == "true"
end or nil

local function normalizePoolData(items)
	if items == nil or next(items) == nil then
		return nil
	end

	local result = {}

	for k, item in items do
		local items2 = {}
		local layouts = {}
		local v2 = false

		if typeof(item.items) == "table" then
			for k2, item2 in item.items do
				if typeof(item2) ~= "table" then
					continue
				end

				local kind = item2.kind
				local value

				if typeof(kind) == "table" then
					value = kind.value
				end

				if typeof(value) == "table" then
					items2[k2] = value
				end

				local layout = item2.layout

				if typeof(layout) ~= "table" then
					continue
				end

				local colSpan = layout.colSpan or layout.col_span
				local rowSpan = layout.rowSpan or layout.row_span
				local alignmentType = layout.alignmentType or layout.alignment_type
				local minRowPadding = tonumber(layout.minRowPadding or layout.min_row_padding)
				local v3

				if
					(colSpan == nil or colSpan == 1)
					and (rowSpan == nil or rowSpan == 1)
					and (alignmentType == nil or alignmentType == "")
				then
					if minRowPadding == nil then
						v3 = false
					else
						v3 = minRowPadding > 0
					end
				else
					v3 = true
				end

				if not v3 then
					continue
				end

				layouts[k2] = {
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding
				}

				v2 = true

				if not (FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and typeof(value) == "table" and (colSpan or 1) == 1 and (rowSpan or 1) == 2) then
					continue
				end

				local oneByTwoTileFlowId, adId, contentType = getOneByTwoTileFlowId(k, k2, value, kind)
				local clone = table.clone(value)
				clone.oneByTwoTileFlowId = oneByTwoTileFlowId

				if adId ~= nil then
					clone.adId = adId
				end

				if contentType ~= nil then
					clone.contentType = contentType
				end

				items2[k2] = clone
			end
		end

		local collection_item_size = item.collection_item_size

		if typeof(collection_item_size) ~= "string" or collection_item_size == "" then
			collection_item_size = nil
		end

		if not v2 then
			layouts = nil
		end

		result[k] = { items = items2, layouts = layouts, collectionItemSize = collection_item_size }
	end

	return result
end

local function poolSectionFromEntry(item, p)
	local identifier = item.identifier

	if typeof(identifier) ~= "string" then
		return nil
	end

	local collection_item_size = nil
	local continuesPreviousSection = nil
	local v2 = item.item
	local pool_id, max_visible_rows

	if typeof(v2) == "table" then
		local input_data = v2.input_data

		if input_data and input_data.kind and input_data.kind.value then
			v2 = input_data.kind.value
		end

		pool_id = v2.pool_id
		max_visible_rows = v2.max_visible_rows

		if
			FFlagSduiPerSectionPoolSizing
			and typeof(v2.collection_item_size) == "string"
			and v2.collection_item_size ~= ""
		then
			collection_item_size = v2.collection_item_size
		end

		if FFlagSduiSamePoolFeedItemSpacing and v2.continues_previous_section == true then
			continuesPreviousSection = true
		end
	end

	local collectionItemSize = nil

	if FFlagSduiPerSectionPoolSizing and pool_id ~= nil and p ~= nil then
		local v3 = p[pool_id]

		if v3 ~= nil then
			collectionItemSize = v3.collectionItemSize
		end
	end

	local numberOfRows = max_visible_rows == -1 and pool_id ~= nil and -1
		or (typeof(max_visible_rows) ~= "number" or not (max_visible_rows > 0)) and 1
		or max_visible_rows
	local doesNotAdvanceStartRow

	if FFlagSduiSkipFeedAnalyticsPosition then
		doesNotAdvanceStartRow = fn(item.template)
	end

	if not FFlagSduiSkipFeedAnalyticsPosition then
		doesNotAdvanceStartRow = nil
	end

	if not FFlagSduiPerSectionPoolSizing then
		collection_item_size = nil
	end

	if not FFlagSduiPerSectionPoolSizing then
		collectionItemSize = nil
	end

	if not FFlagSduiSamePoolFeedItemSpacing then
		continuesPreviousSection = nil
	end

	return {
		sectionId = identifier,
		poolId = pool_id,
		numberOfRows = numberOfRows,
		doesNotAdvanceStartRow = doesNotAdvanceStartRow,
		entryCollectionItemSize = collection_item_size,
		templateCollectionItemSize = collectionItemSize,
		continuesPreviousSection = continuesPreviousSection
	}
end

local function applyPoolEntryConfigs(p, items)
	if FFlagSduiPerSectionPoolSizing or items == nil then
		return
	end

	for k, item in items do
		local v2 = p[k]

		if v2 ~= nil and v2.collectionItemSize == nil and item.collectionItemSize ~= nil then
			v2.collectionItemSize = item.collectionItemSize
		end
	end
end

local function ingestPoolSections(list, p, p2, p3)
	local configKey = p2.configKey

	if configKey == nil or #list == 0 then
		return nil
	end

	local sduiPoolStore = SduiPoolStore.getSduiPoolStore(configKey)
	sduiPoolStore.setSections(list)
	local v2

	if p ~= nil then
		v2 = normalizePoolData(p)
	end

	if v2 ~= nil then
		applyPoolEntryConfigs(v2, p3)
		sduiPoolStore.setPools(v2)
	end

	return sduiPoolStore
end

local SduiPoolEntryHelpers = {
	resolvePoolDataGetter = function(p: string?, p2, p3, p4)
		if p == nil or p == "" then
			return nil
		end

		local dynamicBindingPropValue = SduiPropUtils.generateDynamicBindingPropValue(p, p2, p3, p4)

		return function(p5)
			return dynamicBindingPropValue(p5).data
		end
	end,
	buildPoolEntryConfigs = function(p)
		if typeof(p) ~= "table" then
			return nil
		end

		local entries = p.entries

		if typeof(entries) ~= "table" then
			return nil
		end

		local result = {}
		local flag = false

		for k, entry in entries do
			if not (typeof(k) == "string" and typeof(entry) == "table") then
				continue
			end

			local collection_item_size = entry.collection_item_size

			if typeof(collection_item_size) ~= "string" or collection_item_size == "" then
				collection_item_size = nil
			end

			if collection_item_size == nil then
				continue
			end

			result[k] = { collectionItemSize = collection_item_size }
			flag = true
		end

		return if flag then result else nil
	end,
	applyPoolEntryConfigs = applyPoolEntryConfigs,
	normalizePoolData = normalizePoolData,
	getOneByTwoTileFlowIdsFromPools = 0,
	poolSectionFromEntry = 0,
	computePoolSections = 0,
	sectionsHaveMultiRow = 0,
	ingestPoolSections = 0,
	createPoolEntryFns = 0
}

if not FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
	getOneByTwoTileFlowIdsFromPools = nil
end

SduiPoolEntryHelpers.getOneByTwoTileFlowIdsFromPools = getOneByTwoTileFlowIdsFromPools

SduiPoolEntryHelpers.poolSectionFromEntry = poolSectionFromEntry

function SduiPoolEntryHelpers.computePoolSections(items, p)
	local poolSections = {}

	for _, item in items do
		local v2

		if FFlagSduiPerSectionPoolSizing then
			v2 = p
		end

		local v3 = poolSectionFromEntry(item, v2)

		if v3 ~= nil then
			table.insert(poolSections, v3)
		end
	end

	return poolSections
end

function SduiPoolEntryHelpers.sectionsHaveMultiRow(items): boolean
	for _, item in items do
		if item.numberOfRows ~= 1 then
			return true
		end
	end

	return false
end
SduiPoolEntryHelpers.ingestPoolSections = ingestPoolSections

function SduiPoolEntryHelpers.createPoolEntryFns(items, p, p2, p3, p4, p5, p6)
	local v2 = ingestPoolSections(items, p5, p3, p6)
	local fn2, fn3

	if v2 ~= nil then
		local sectionIdSet = {}

		for _, item in items do
			if item.poolId ~= nil then
				sectionIdSet[item.sectionId] = true
			end
		end

		local sectionIdSet2 = {}

		if FFlagSduiSamePoolFeedItemSpacing then
			for _, item in items do
				if item.continuesPreviousSection then
					sectionIdSet2[item.sectionId] = true
				end
			end
		end

		fn3 = function(p7, _)
			local identifier = p7.identifier

			if typeof(identifier) ~= "string" then
				return nil
			end

			local v3 = {
				startRowGetter = v2.getSectionStartRow(identifier),
				numberOfRowsGetter = v2.getSectionRowCount(identifier),
				setDisplayedRowCount = FFlagSduiCollectionGridRevealRows and function(p8: number?)
					v2.setSectionDisplayedRowCount(identifier, p8)
				end or nil,
				continuesPreviousSection = 0,
				_requiresDataBinding = true
			}
			local continuesPreviousSection

			if FFlagSduiSamePoolFeedItemSpacing then
				continuesPreviousSection = sectionIdSet2[identifier]
			end

			v3.continuesPreviousSection = continuesPreviousSection
			return v3
		end

		fn2 = function(p7)
			local identifier = p7.identifier

			if typeof(identifier) == "string" and sectionIdSet[identifier] then
				return {
					_section = { cells = v2.getSectionCells(identifier) }
				}
			end

			return nil
		end
	end

	return {
		inputSlicer = SduiListEntryRenderer.createInputSlicer(p, p2, p3, p4, fn2),
		entryConfigExtrasFn = fn3
	}
end
return SduiPoolEntryHelpers
