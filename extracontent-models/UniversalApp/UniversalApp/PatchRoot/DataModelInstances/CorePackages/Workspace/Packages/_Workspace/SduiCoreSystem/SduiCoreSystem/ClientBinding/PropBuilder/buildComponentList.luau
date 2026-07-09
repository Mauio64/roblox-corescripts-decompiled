local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Signals = require(SduiCoreSystemParent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)

local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiListEntryNormalizer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)
local SduiListEntrySorter = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntrySorter)
local SduiListEntryRenderer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryRenderer)
local SduiPoolEntryHelpers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPoolEntryHelpers)

require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)

local FFlagSduiPoolBackedFeed = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPoolBackedFeed
local FFlagSduiDeferredListItems = require(SduiCoreSystemParent.SharedFlags).FFlagSduiDeferredListItems
local PropResultCategory = SduiClientBindingTypes.PropResultCategory

local function canSorterReorder(t1: {[any]: any}, p1) -- line: 37
	if p1 ~= nil then
		return true
	end

	for _, v22 in t1 do
		if v22.sortRankProp ~= nil then
			return true
		end
	end

	return false
end
local function buildItemsFromEntries(t2: {[any]: any}, p2, t3: {[any]: any}?, p3, p4, p5, p6, p7, p8, b1: boolean?, p9, p10) -- line: 54
	-- upvalues: SduiListEntrySorter (copy), FFlagSduiPoolBackedFeed (copy), SduiPoolEntryHelpers (copy), SduiListEntryRenderer (copy), FFlagSduiDeferredListItems (copy)
	if t3 ~= nil then
		local v35, g38

		if p2 ~= nil then
			v35 = true
		else
			g38 = nil
			v35 = nil

			for _, v37 in t2 do
				if v37.sortRankProp ~= nil then
					v35 = true
					g38 = true
				end

				if g38 then
					break
				end
			end

			if not g38 then
				v35 = false
			end
		end

		g38 = false

		if v35 then
			t3 = nil
		end
	end

	local v39 = SduiListEntrySorter.applyOrder(t2, p2, p8, p4, p3, p5, p7)
	local inputSlicer = nil
	local entryConfigExtrasFn = nil

	if FFlagSduiPoolBackedFeed then
		local v42 = SduiPoolEntryHelpers.computePoolSections(v39)

		if p9 ~= nil or SduiPoolEntryHelpers.sectionsHaveMultiRow(v42) then
			local v43 = if p9 == nil then nil else p9(p8)
			local v44 = SduiPoolEntryHelpers.createPoolEntryFns(v42, p3, p4, p5, p6, v43, p10)

			inputSlicer = v44.inputSlicer
			entryConfigExtrasFn = v44.entryConfigExtrasFn
		end
	end

	if not FFlagSduiPoolBackedFeed or inputSlicer == nil then
		inputSlicer = SduiListEntryRenderer.createInputSlicer(p3, p4, p5, p6)
	end

	return SduiListEntryRenderer.buildEntryConfigs(v39, inputSlicer, t3, p5, p6, p7, p4, p8, if not FFlagSduiDeferredListItems then nil else b1, if not FFlagSduiPoolBackedFeed then nil else entryConfigExtrasFn)
end
local function buildComponentList(_: string, p11, p12, p13, p14, p15) -- line: 125
	-- upvalues: FFlagSduiDeferredListItems (copy), SduiLogger (copy), SduiErrors (copy), PropResultCategory (copy), SduiListEntryRenderer (copy), FFlagSduiPoolBackedFeed (copy), SduiPoolEntryHelpers (copy), SduiPropUtils (copy), SduiListEntryNormalizer (copy), buildItemsFromEntries (copy), SduiParseHelpers (copy), Signals (copy)
	local v51 = p11 and p11.source
	local v52 = p11 and p11.default_item
	local v53 = p11 and p11.ordered_identifiers
	local v54 = p11 and p11.item_overrides
	local v55 = if not FFlagSduiDeferredListItems then nil else p11 and p11.defer_item_build

	if v51 == nil then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
			message = "ComponentList missing source",
			name = p14.debugName,
			componentType = p14.currentComponentType,
			parserName = p14.currentParserName
		}, p14.appPage)

		return function() -- line: 150
			return {
				data = {}
			}
		end, PropResultCategory.PropSignal
	end

	local type = v51.type
	local value = v51.value
	local v58 = SduiListEntryRenderer.captureErrorContext(p14)
	local u59 = nil
	local u60 = nil

	if FFlagSduiPoolBackedFeed then
		local v61 = p11 and p11.pool_config

		u59 = SduiPoolEntryHelpers.resolvePoolDataGetter(v61 and v61.pool_path, p12, p14, p13)
		u60 = SduiPoolEntryHelpers.buildPoolEntryConfigs(v61)
	end

	if type == "binding_path" then
		local u62 = nil

		return SduiPropUtils.generateDynamicBindingPropValue(value, p12, p14, p13, function(p16, p17) -- line: 185
			-- upvalues: SduiListEntryNormalizer (copy), v52 (copy), v54 (copy), p14 (copy), u62 (ref), buildItemsFromEntries (copy), v53 (copy), p13 (copy), p12 (copy), v58 (copy), p15 (copy), FFlagSduiDeferredListItems (copy), v55 (copy), u59 (ref), FFlagSduiPoolBackedFeed (copy), u60 (ref)
			local v66 = SduiListEntryNormalizer.normalizeBoundData(p16, v52, v54, p14)

			u62 = buildItemsFromEntries(v66, v53, u62, p13, p12, p14, v58, p15, p17, if not FFlagSduiDeferredListItems then nil else v55, u59, if not FFlagSduiPoolBackedFeed then nil else u60)

			return u62
		end), PropResultCategory.PropSignal
	end

	if type == "literal" then
		local v63 = value and value.items

		if v63 == nil then
			return function() -- line: 214
				return {
					data = {}
				}
			end, PropResultCategory.PropSignal
		end

		return function(p18) -- line: 222
			-- upvalues: SduiListEntryNormalizer (copy), v63 (copy), v52 (copy), p14 (copy), buildItemsFromEntries (copy), v53 (copy), p13 (copy), p12 (copy), v58 (copy), p15 (copy), FFlagSduiDeferredListItems (copy), v55 (copy), u59 (ref), FFlagSduiPoolBackedFeed (copy), u60 (ref), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy)
			local ok, result = pcall(function() -- line: 223
				-- upvalues: SduiListEntryNormalizer (copy), v63 (copy), v52 (copy), p14 (copy), buildItemsFromEntries (copy), v53 (copy), p13 (copy), p12 (copy), v58 (copy), p15 (copy), p18 (copy), FFlagSduiDeferredListItems (copy), v55 (copy), u59 (ref), FFlagSduiPoolBackedFeed (copy), u60 (ref)
				local v73 = SduiListEntryNormalizer.normalizeLiteralItems(v63, v52, p14)

				return (buildItemsFromEntries(v73, v53, nil, p13, p12, p14, v58, p15, p18, if not FFlagSduiDeferredListItems then nil else v55, u59, if not FFlagSduiPoolBackedFeed then nil else u60))
			end)

			if not ok then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Failed to build ComponentList from literal source: { SduiParseHelpers.stringifyValue(result) }`,
					name = v58.name,
					componentType = v58.componentType,
					parserName = v58.parserName
				}, v58.appPage)

				return {
					data = {}
				}
			end

			return {
				data = result
			}
		end, PropResultCategory.PropSignal
	end

	if FFlagSduiPoolBackedFeed and type == "pool" then
		return Signals.createComputed(function(p19) -- line: 263
			-- upvalues: p13 (copy), SduiListEntryNormalizer (copy), v52 (copy), v54 (copy), p14 (copy), buildItemsFromEntries (copy), v53 (copy), p12 (copy), v58 (copy), p15 (copy), FFlagSduiDeferredListItems (copy), v55 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy)
			local ok, result = pcall(function() -- line: 264
				-- upvalues: p13 (copy), p19 (copy), SduiListEntryNormalizer (copy), v52 (copy), v54 (copy), p14 (copy), buildItemsFromEntries (copy), v53 (copy), p12 (copy), v58 (copy), p15 (copy), FFlagSduiDeferredListItems (copy), v55 (copy), SduiLogger (copy), SduiErrors (copy)
				local _section = (p13(p19) or {})._section

				if typeof(_section) ~= "table" then
					return {}
				end

				local cells = _section.cells

				if typeof(cells) ~= "function" then
					return {}
				end

				local v76 = cells(p19)

				if #v76 == 0 then
					return {}
				end

				local t4 = {}
				local t5 = table.create(#v76, 0)

				for v79, v80 in v76 do
					if v80.item ~= nil then
						table.insert(t4, v80.item)
						t5[v79] = #t4
					end
				end

				local v81 = SduiListEntryNormalizer.normalizeBoundData(t4, v52, v54, p14)
				local v82, v83 = buildItemsFromEntries(v81, v53, nil, p13, p12, p14, v58, p15, p19, if not FFlagSduiDeferredListItems then nil else v55, nil, nil)

				if #v82 ~= #t4 then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
						message = `Pool-backed ComponentList dropped { #t4 - #v82 } of { #t4 } items;` .. " pool templates must resolve to valid templates and must not use is_component_filtered",
						name = v58.name,
						componentType = v58.componentType,
						parserName = v58.parserName
					}, v58.appPage)
				end

				local t6 = {}

				for v85, v86 in v83 do
					t6[v86] = v82[v85]
				end

				local t7 = {}

				for v88, v89 in v76 do
					local v90 = t5[v88]

					if v90 == 0 then
						table.insert(t7, {
							isBlank = true
						})
					else
						local v91 = t6[v90]

						if v91 ~= nil then
							v91.realIndex = v89.realIndex
							v91.spanOverride = v89.spanOverride
							table.insert(t7, v91)
						end
					end
				end

				return t7
			end)

			if not ok then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Failed to build ComponentList from pool source: { SduiParseHelpers.stringifyValue(result) }`,
					name = v58.name,
					componentType = v58.componentType,
					parserName = v58.parserName
				}, v58.appPage)

				return {
					data = {}
				}
			end

			return {
				data = result
			}
		end), PropResultCategory.PropSignal
	end

	error(`Unknown ComponentList source kind: { type }`)
end

return buildComponentList
