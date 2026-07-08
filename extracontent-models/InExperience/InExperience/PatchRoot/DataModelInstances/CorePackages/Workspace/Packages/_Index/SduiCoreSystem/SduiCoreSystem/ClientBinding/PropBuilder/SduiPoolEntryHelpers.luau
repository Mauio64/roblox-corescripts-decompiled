local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiPoolStore = require(SduiCoreSystem.ClientBinding.SduiPoolStore)

require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)
require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)

local SduiListEntryRenderer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryRenderer)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)

local function normalizePoolData(t1: {[any]: any}?) -- line: 79
	if t1 == nil or next(t1) == nil then
		return nil
	end

	local t2 = {}

	for v25, v26 in t1 do
		local t3 = {}
		local t4 = {}
		local v29 = false

		if typeof(v26.items) == "table" then
			for v30, v31 in v26.items do
				if typeof(v31) == "table" then
					local kind = v31.kind
					local v33 = if typeof(kind) ~= "table" then nil else kind.value

					if typeof(v33) == "table" then
						t3[v30] = v33
					end

					local layout = v31.layout

					if typeof(layout) == "table" then
						local v35 = layout.colSpan or layout.col_span
						local v36 = layout.rowSpan or layout.row_span
						local v37 = layout.alignmentType or layout.alignment_type
						local num = tonumber(layout.minRowPadding or layout.min_row_padding)

						if v35 ~= nil and v35 ~= 1 or (v36 ~= nil and v36 ~= 1 or (v37 ~= nil and v37 ~= "" or num ~= nil and num > 0)) then
							t4[v30] = {
								colSpan = v35,
								rowSpan = v36,
								alignmentType = v37,
								minRowPadding = num
							}
							v29 = true
						end
					end
				end
			end
		end

		local collection_item_size = v26.collection_item_size
		local v40 = if typeof(collection_item_size) ~= "string" or collection_item_size == "" then nil else collection_item_size

		t2[v25] = {
			items = t3,
			layouts = if not v29 then nil else t4,
			collectionItemSize = v40
		}
	end

	return t2
end
local function poolSectionFromEntry(p1) -- line: 135
	local identifier = p1.identifier

	if typeof(identifier) ~= "string" then
		return nil
	end

	local pool_id = nil
	local max_visible_rows = nil
	local item = p1.item

	if typeof(item) == "table" then
		local input_data = item.input_data

		if input_data and input_data.kind and input_data.kind.value then
			item = input_data.kind.value
		end

		pool_id = item.pool_id
		max_visible_rows = item.max_visible_rows
	end

	local v47 = if max_visible_rows ~= -1 or pool_id == nil then (typeof(max_visible_rows) ~= "number" or not (max_visible_rows > 0)) and 1 or max_visible_rows else -1

	return {
		sectionId = identifier,
		poolId = pool_id,
		numberOfRows = v47
	}
end
local function applyPoolEntryConfigs(t5: {[any]: any}, t6: {[any]: any}?) -- line: 189
	if t6 == nil then
		return
	end

	for v58, v59 in t6 do
		local v60 = t5[v58]

		if v60 ~= nil and v60.collectionItemSize == nil and v59.collectionItemSize ~= nil then
			v60.collectionItemSize = v59.collectionItemSize
		end
	end
end
local function ingestPoolSections(t7: {[any]: any}, t8: {[any]: any}?, p2, t9: {[any]: any}?) -- line: 207
	-- upvalues: SduiPoolStore (copy), normalizePoolData (copy), applyPoolEntryConfigs (copy)
	local configKey = p2.configKey

	if configKey == nil or #t7 == 0 then
		return nil
	end

	local v66 = SduiPoolStore.getSduiPoolStore(configKey)

	v66.setSections(t7)

	local v67 = if t8 == nil then nil else normalizePoolData(t8)

	if v67 ~= nil then
		applyPoolEntryConfigs(v67, t9)
		v66.setPools(v67)
	end

	return v66
end

return {
	resolvePoolDataGetter = function(s1: string?, p3, p4, p5) -- line: 24
		-- upvalues: SduiPropUtils (copy)
		if s1 == nil or s1 == "" then
			return nil
		end

		local v14 = SduiPropUtils.generateDynamicBindingPropValue(s1, p3, p4, p5)

		return function(p6) -- line: 39
			-- upvalues: v14 (copy)
			return v14(p6).data
		end
	end,
	buildPoolEntryConfigs = function(p7) -- line: 50
		if typeof(p7) ~= "table" then
			return nil
		end

		local entries = p7.entries

		if typeof(entries) ~= "table" then
			return nil
		end

		local t10 = {}
		local v18 = false

		for v19, v20 in entries do
			if typeof(v19) == "string" and typeof(v20) == "table" then
				local collection_item_size = v20.collection_item_size
				local v22 = if typeof(collection_item_size) ~= "string" or collection_item_size == "" then nil else collection_item_size

				if v22 ~= nil then
					t10[v19] = {
						collectionItemSize = v22
					}
					v18 = true
				end
			end
		end

		if v18 then
			return t10
		end

		return nil
	end,
	applyPoolEntryConfigs = applyPoolEntryConfigs,
	normalizePoolData = normalizePoolData,
	poolSectionFromEntry = poolSectionFromEntry,
	computePoolSections = function(t11: {[any]: any}) -- line: 165
		-- upvalues: poolSectionFromEntry (copy)
		local t12 = {}

		for _, v51 in t11 do
			local v52 = poolSectionFromEntry(v51)

			if v52 ~= nil then
				table.insert(t12, v52)
			end
		end

		return t12
	end,
	sectionsHaveMultiRow = function(t13: {[any]: any}) -- line: 178
		for _, v55 in t13 do
			if v55.numberOfRows ~= 1 then
				return true
			end
		end

		return false
	end,
	ingestPoolSections = ingestPoolSections,
	createPoolEntryFns = function(t14: {[any]: any}, p8, p9, p10, p11, t15: {[any]: any}?, t16: {[any]: any}?) -- line: 232
		-- upvalues: ingestPoolSections (copy), SduiListEntryRenderer (copy)
		local v75 = ingestPoolSections(t14, t15, p10, t16)
		local v76 = nil
		local v77 = nil

		if v75 ~= nil then
			local t17 = {}

			for _, v80 in t14 do
				if v80.poolId ~= nil then
					t17[v80.sectionId] = true
				end
			end

			function v76(p12) -- line: 254
				-- upvalues: t17 (copy), v75 (copy)
				local identifier = p12.identifier

				if typeof(identifier) ~= "string" or not t17[identifier] then
					return nil
				end

				return {
					_section = {
						cells = v75.getSectionCells(identifier)
					}
				}
			end
			function v77(p13, _) -- line: 266
				-- upvalues: v75 (copy)
				local identifier = p13.identifier

				if typeof(identifier) ~= "string" then
					return nil
				end

				return {
					_requiresDataBinding = true,
					startRowGetter = v75.getSectionStartRow(identifier)
				}
			end
		end

		return {
			inputSlicer = SduiListEntryRenderer.createInputSlicer(p8, p9, p10, p11, v76),
			entryConfigExtrasFn = v77
		}
	end
}
