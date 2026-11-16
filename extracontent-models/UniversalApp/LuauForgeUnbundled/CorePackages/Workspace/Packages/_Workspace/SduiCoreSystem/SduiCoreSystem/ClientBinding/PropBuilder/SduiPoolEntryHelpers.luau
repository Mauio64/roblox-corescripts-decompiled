local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiPoolStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryNormalizer")
local SduiListEntryRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryRenderer")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/analyticsConstants")

local fFlagSduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiCollectionGridRevealRows
local fFlagSduiSkipFeedAnalyticsPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSkipFeedAnalyticsPosition
local fFlagSduiPerSectionPoolSizing = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiPerSectionPoolSizing

local fFlagSduiVerticalFeedProgressiveFillOnScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiVerticalFeedProgressiveFillOnScroll

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui
local fFlagSduiSamePoolFeedItemSpacing = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSamePoolFeedItemSpacing

local v5 = fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and {} or nil

local function getOneByTwoTileFlowId(k, k2, value, kind)
	local native_ad_data = value.native_ad_data
	local v6 = string.format(
		"%s:%s:%s:%s",
		tostring(k),
		tostring(k2),
		tostring(value.universe_id or ""),
		typeof(native_ad_data) ~= "string" and "" or native_ad_data
	)

	local v7 = v5[v6]

	if v7 == nil then
		v7 = HttpService:GenerateGUID(false):lower()
		v5[v6] = v7
	end

	if typeof(native_ad_data) ~= "string" or native_ad_data == "" then
		native_ad_data = nil
	end

	local kind2 = kind and kind.type
	return v7, native_ad_data, kind2 == "universe" and "Game" or kind2 == "ad_link" and "AdLink" or nil
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

		for k2, v6 in item.items or {} do
			if typeof(v6) ~= "table" then
				continue
			end

			local kind = v6.kind
			local value = kind and kind.value
			local layout = v6.layout

			if not (typeof(value) == "table" and typeof(layout) == "table" and (layout.col_span or layout.colSpan or 1) == 1) then
				continue
			end

			if (layout.row_span or layout.rowSpan or 1) ~= 2 then
				continue
			end

			local oneByTwoTileFlowId, v7, v8 = getOneByTwoTileFlowId(k, k2, value, kind)
			table.insert(one, {
				oneByTwoTileFlowId = oneByTwoTileFlowId,
				contentType = v8,
				adId = v7,
				alignmentType = layout.alignment_type or layout.alignmentType
			})
		end
	end

	return one
end

local fn = fFlagSduiSkipFeedAnalyticsPosition and function(p2): boolean
	if typeof(p2) ~= "table" then
		return false
	end

	local value = p2.kind and p2.kind.value
	local Shared = value and value.shared
	local analytics_data = Shared and Shared.analytics_data
	local v6 = analytics_data and analytics_data[analyticsConstants.DoesNotAdvanceStartRow]
	local kind = v6 and v6.kind
	return kind ~= nil and kind.type == "literal" and kind.value == "true"
end or nil

local function normalizePoolData(items)
	if items == nil or next(items) == nil then
		return nil
	end

	local result = {}

	for k, item in items do
		local v6 = {}
		local v7 = {}
		local v8 = false

		if typeof(item.items) == "table" then
			for k2, item2 in item.items do
				if typeof(item2) ~= "table" then
					continue
				end

				local kind = item2.kind
				local value = if typeof(kind) == "table" then kind.value else nil

				if typeof(value) == "table" then
					v6[k2] = value
				end

				local layout = item2.layout

				if typeof(layout) ~= "table" then
					continue
				end

				local colSpan = layout.colSpan or layout.col_span
				local rowSpan = layout.rowSpan or layout.row_span
				local alignmentType = layout.alignmentType or layout.alignment_type
				local minRowPadding = tonumber(layout.minRowPadding or layout.min_row_padding)
				local v9

				if
					(colSpan == nil or colSpan == 1)
					and (rowSpan == nil or rowSpan == 1)
					and (alignmentType == nil or alignmentType == "")
				then
					v9 = not (minRowPadding == nil) and minRowPadding > 0
				else
					v9 = true
				end

				if not v9 then
					continue
				end

				v7[k2] = {
					colSpan = colSpan,
					rowSpan = rowSpan,
					alignmentType = alignmentType,
					minRowPadding = minRowPadding
				}

				v8 = true

				if not (fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui and typeof(value) == "table" and (colSpan or 1) == 1 and (rowSpan or 1) == 2) then
					continue
				end

				local oneByTwoTileFlowId, v10, v11 = getOneByTwoTileFlowId(k, k2, value, kind)
				local clone = table.clone(value)
				clone.oneByTwoTileFlowId = oneByTwoTileFlowId

				if v10 ~= nil then
					clone.adId = v10
				end

				if v11 ~= nil then
					clone.contentType = v11
				end

				v6[k2] = clone
			end
		end

		local collection_item_size = item.collection_item_size

		if typeof(collection_item_size) ~= "string" or collection_item_size == "" then
			collection_item_size = nil
		end

		if not v8 then
			v7 = nil
		end

		result[k] = {
			items = v6,
			layouts = v7,
			collectionItemSize = collection_item_size
		}
	end

	return result
end

local function poolSectionFromEntry(data, p2)
	local identifier = data.identifier

	if typeof(identifier) ~= "string" then
		return nil
	end

	local collection_item_size = nil
	local v6 = nil
	local v7 = data.item
	local pool_id, max_visible_rows

	if typeof(v7) == "table" then
		local input_data = v7.input_data

		if input_data and input_data.kind and input_data.kind.value then
			v7 = input_data.kind.value
		end

		pool_id = v7.pool_id
		max_visible_rows = v7.max_visible_rows

		if
			fFlagSduiPerSectionPoolSizing
			and typeof(v7.collection_item_size) == "string"
			and v7.collection_item_size ~= ""
		then
			collection_item_size = v7.collection_item_size
		end

		if fFlagSduiSamePoolFeedItemSpacing and v7.continues_previous_section == true then
			v6 = true
		end
	end

	local collectionItemSize = nil

	if fFlagSduiPerSectionPoolSizing and pool_id ~= nil and p2 ~= nil then
		local v8 = p2[pool_id]

		if v8 ~= nil then
			collectionItemSize = v8.collectionItemSize
		end
	end

	local v8 = max_visible_rows == -1 and pool_id ~= nil and -1
		or (typeof(max_visible_rows) ~= "number" or not (max_visible_rows > 0)) and 1
		or max_visible_rows

	local v9 = if fFlagSduiSkipFeedAnalyticsPosition then fn(data.template) else nil

	if not fFlagSduiSkipFeedAnalyticsPosition then
		v9 = nil
	end

	if not fFlagSduiPerSectionPoolSizing then
		collection_item_size = nil
	end

	if not fFlagSduiPerSectionPoolSizing then
		collectionItemSize = nil
	end

	if not fFlagSduiSamePoolFeedItemSpacing then
		v6 = nil
	end

	return {
		sectionId = identifier,
		poolId = pool_id,
		numberOfRows = v8,
		doesNotAdvanceStartRow = v9,
		entryCollectionItemSize = collection_item_size,
		templateCollectionItemSize = collectionItemSize,
		continuesPreviousSection = v6
	}
end

local function applyPoolEntryConfigs(p2, items)
	if fFlagSduiPerSectionPoolSizing or items == nil then
		return
	end

	for k, item in items do
		local v6 = p2[k]

		if v6 ~= nil and v6.collectionItemSize == nil and item.collectionItemSize ~= nil then
			v6.collectionItemSize = item.collectionItemSize
		end
	end
end

local function ingestPoolSections(list, p2, p3, p4)
	local configKey = p3.configKey

	if configKey == nil or #list == 0 then
		return nil
	end

	local sduiPoolStore = SduiPoolStore.getSduiPoolStore(configKey)
	sduiPoolStore.setSections(list)
	local v6 = if p2 ~= nil then normalizePoolData(p2) else nil

	if v6 ~= nil then
		applyPoolEntryConfigs(v6, p4)
		sduiPoolStore.setPools(v6)
	end

	return sduiPoolStore
end

local v6 = {
	resolvePoolDataGetter = function(p2, p3, p4, p5)
		if p2 == nil or p2 == "" then
			return nil
		end

		local dynamicBindingPropValue = SduiPropUtils.generateDynamicBindingPropValue(p2, p3, p4, p5)

		return function(p6)
			return dynamicBindingPropValue(p6).data
		end
	end,
	buildPoolEntryConfigs = function(p2)
		if typeof(p2) ~= "table" then
			return nil
		end

		local entries = p2.entries

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

		if flag then
			return result
		end

		return nil
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

if not fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
	getOneByTwoTileFlowIdsFromPools = nil
end

v6.getOneByTwoTileFlowIdsFromPools = getOneByTwoTileFlowIdsFromPools

v6.poolSectionFromEntry = poolSectionFromEntry

function v6.computePoolSections(items, p2)
	local poolSections = {}

	for k, item in items do
		local v7 = if fFlagSduiPerSectionPoolSizing then p2 else nil
		local v8 = poolSectionFromEntry(item, v7)

		if v8 ~= nil then
			table.insert(poolSections, v8)
		end
	end

	return poolSections
end

function v6.sectionsHaveMultiRow(items): boolean
	for k, item in items do
		if item.numberOfRows ~= 1 then
			return true
		end
	end

	return false
end
v6.ingestPoolSections = ingestPoolSections

function v6.createPoolEntryFns(items, p2, p3, p4, p5, p6, p7)
	local v6 = ingestPoolSections(items, p6, p4, p7)
	local fn2, fn3

	if v6 ~= nil then
		local sectionIdSet = {}

		for k, item in items do
			if item.poolId ~= nil then
				sectionIdSet[item.sectionId] = true
			end
		end

		local sectionIdSet2 = {}

		if fFlagSduiSamePoolFeedItemSpacing then
			for k, item in items do
				if item.continuesPreviousSection then
					sectionIdSet2[item.sectionId] = true
				end
			end
		end

		fn3 = function(p8, p9)
			local identifier = p8.identifier

			if typeof(identifier) ~= "string" then
				return nil
			end

			local v7 = {
				startRowGetter = v6.getSectionStartRow(identifier),
				numberOfRowsGetter = 0,
				setDisplayedRowCount = 0,
				continuesPreviousSection = 0,
				_requiresDataBinding = true
			}

			local v8 = if fFlagSduiVerticalFeedProgressiveFillOnScroll then v6.getSectionRowCount(identifier) else nil
			v7.numberOfRowsGetter = v8

			v7.setDisplayedRowCount = fFlagSduiCollectionGridRevealRows and function(p10)
				v6.setSectionDisplayedRowCount(identifier, p10)
			end or nil

			local v9 = if fFlagSduiSamePoolFeedItemSpacing then sectionIdSet2[identifier] else nil
			v7.continuesPreviousSection = v9
			return v7
		end

		fn2 = function(p8)
			local identifier = p8.identifier

			if typeof(identifier) == "string" and sectionIdSet[identifier] then
				return {
					_section = { cells = v6.getSectionCells(identifier) }
				}
			end

			return nil
		end
	end

	return {
		inputSlicer = SduiListEntryRenderer.createInputSlicer(p2, p3, p4, p5, fn2),
		entryConfigExtrasFn = fn3
	}
end
return v6
