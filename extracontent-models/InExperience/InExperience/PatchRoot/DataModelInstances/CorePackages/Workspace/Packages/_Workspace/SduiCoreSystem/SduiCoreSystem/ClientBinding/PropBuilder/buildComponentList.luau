local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Signals = require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiListEntryNormalizer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)
local SduiListEntrySorter = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntrySorter)
local SduiListEntryRenderer = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryRenderer)
local SduiPoolEntryHelpers = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPoolEntryHelpers)
require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiPerSectionPoolSizing = SharedFlags2.FFlagSduiPerSectionPoolSizing

local FFlagSduiComponentListReuseByEntryIndex = require(SduiCoreSystem.ClientBinding.PropBuilder.FFlagSduiComponentListReuseByEntryIndex)

local PropResultCategory = SduiClientBindingTypes.PropResultCategory

local function canSorterReorder(items, p): boolean -- 1 equivalent call inferred from this helper
	if p ~= nil then
		return true
	end

	for _, item in items do
		if item.sortRankProp ~= nil then
			return true
		end
	end

	return false
end

local function buildItemsFromEntries(items, ordered_identifiers, p, callback, p2, data, captureErrorContext, p3, p4, defer_item_build: boolean?, callback2, p5)
	if p ~= nil and canSorterReorder(items, ordered_identifiers) then -- inferred equivalent call
		p = nil
	end

	local v = SduiListEntrySorter.applyOrder(items, ordered_identifiers, p4, p2, callback, data, p3)

	local v2 = nil
	local entryConfigExtrasFn = nil
	local computePoolSections = SduiPoolEntryHelpers.computePoolSections
	local v3

	if FFlagSduiPerSectionPoolSizing then
		v3 = p5
	end

	local v4 = computePoolSections(v, v3)

	if callback2 ~= nil or SduiPoolEntryHelpers.sectionsHaveMultiRow(v4) then
		local v5

		if callback2 ~= nil then
			v5 = callback2(p4)
		end

		local poolEntryFns = SduiPoolEntryHelpers.createPoolEntryFns(
			v4,
			callback,
			p2,
			data,
			captureErrorContext,
			v5,
			p5
		)

		v2 = poolEntryFns.inputSlicer
		entryConfigExtrasFn = poolEntryFns.entryConfigExtrasFn
	end

	if v2 == nil then
		v2 = SduiListEntryRenderer.createInputSlicer(callback, p2, data, captureErrorContext)
	end

	return SduiListEntryRenderer.buildEntryConfigs(
		v,
		v2,
		p,
		data,
		captureErrorContext,
		p3,
		p2,
		p4,
		defer_item_build,
		entryConfigExtrasFn
	)
end

local function buildComponentList(_: string, data, p, callback, data2, p2)
	local source = data and data.source
	local default_item = data and data.default_item
	local ordered_identifiers = data and data.ordered_identifiers
	local item_overrides = data and data.item_overrides
	local defer_item_build = data and data.defer_item_build

	if source == nil then
		local v = {
			message = "ComponentList missing source",
			name = data2.debugName,
			componentType = data2.currentComponentType,
			parserName = data2.currentParserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v, data2.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, data2.appPage)
		return function()
			return { data = {} }
		end, PropResultCategory.PropSignal
	else
		local kind = source.type
		local value = source.value

		local captureErrorContext = SduiListEntryRenderer.captureErrorContext(data2)

		local pool_config = data and data.pool_config
		local poolDataGetter = SduiPoolEntryHelpers.resolvePoolDataGetter(
			pool_config and pool_config.pool_path,
			p,
			data2,
			callback
		)

		local poolEntryConfigs = SduiPoolEntryHelpers.buildPoolEntryConfigs(pool_config)

		if kind == "binding_path" then
			local v = nil
			return SduiPropUtils.generateDynamicBindingPropValue(value, p, data2, callback, function(p3, p4)
				local itemsFromEntries, v2 = buildItemsFromEntries(
					SduiListEntryNormalizer.normalizeBoundData(p3, default_item, item_overrides, data2),
					ordered_identifiers,
					v,
					callback,
					p,
					data2,
					captureErrorContext,
					p2,
					p4,
					defer_item_build,
					poolDataGetter,
					poolEntryConfigs
				)

				if not FFlagSduiComponentListReuseByEntryIndex then
					v = itemsFromEntries

					return itemsFromEntries
				end

				local v3 = {}

				for k, v4 in v2 do
					v3[v4] = itemsFromEntries[k]
				end

				v = v3
				return itemsFromEntries
			end), PropResultCategory.PropSignal
		end

		if kind == "literal" then
			local items = value and value.items

			if items == nil then
				return function()
					return { data = {} }
				end, PropResultCategory.PropSignal
			end

			return function(p3)
				local success, result = pcall(function()
					return (buildItemsFromEntries(
						SduiListEntryNormalizer.normalizeLiteralItems(items, default_item, data2),
						ordered_identifiers,
						nil,
						callback,
						p,
						data2,
						captureErrorContext,
						p2,
						p3,
						defer_item_build,
						poolDataGetter,
						poolEntryConfigs
					))
				end)

				if success then
					return { data = result }
				end

				local v = {
					message = `Failed to build ComponentList from literal source: {SduiParseHelpers.stringifyValue(result)}`,
					name = captureErrorContext.name,
					componentType = captureErrorContext.componentType,
					parserName = captureErrorContext.parserName
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v, captureErrorContext.nodeContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, captureErrorContext.appPage)

				return { data = {} }
			end, PropResultCategory.PropSignal
		end

		if kind == "pool" then
			return Signals.createComputed(function(p3)
				local success, result = pcall(function()
					local section = (callback(p3) or {})._section

					if typeof(section) ~= "table" then
						return {}
					end

					local cells = section.cells

					if typeof(cells) ~= "function" then
						return {}
					end

					local v = cells(p3)

					if #v == 0 then
						return {}
					end

					local v2 = table.create(#v, 0)
					local v3 = {}

					for k, v4 in v do
						if v4.item == nil then
							continue
						end

						table.insert(v3, v4.item)
						v2[k] = #v3
					end

					local itemsFromEntries, v4 = buildItemsFromEntries(
						SduiListEntryNormalizer.normalizeBoundData(v3, default_item, item_overrides, data2),
						ordered_identifiers,
						nil,
						callback,
						p,
						data2,
						captureErrorContext,
						p2,
						p3,
						defer_item_build,
						nil,
						nil
					)

					if #itemsFromEntries ~= #v3 then
						local v5 = {
							message = `Pool-backed ComponentList dropped {#v3 - #itemsFromEntries} of {#v3} items;` .. " pool templates must resolve to valid templates and must not use is_component_filtered",
							name = captureErrorContext.name,
							componentType = captureErrorContext.componentType,
							parserName = captureErrorContext.parserName
						}

						if FFlagSduiErrorPaths then
							addSduiErrorContextFields(v5, captureErrorContext.nodeContext)
						end

						SduiLogger.reportError(
							SduiErrors.SduiErrorType.FailedToParseProp,
							v5,
							captureErrorContext.appPage
						)
					end

					local v5 = {}

					for k, v6 in v4 do
						v5[v6] = itemsFromEntries[k]
					end

					local result = {}

					for k, v6 in v do
						local v7 = v2[k]

						if v7 == 0 then
							table.insert(result, { isBlank = true })
						else
							local v8 = v5[v7]

							if v8 ~= nil then
								v8.realIndex = v6.realIndex
								v8.spanOverride = v6.spanOverride
								table.insert(result, v8)
							end
						end
					end

					return result
				end)

				if success then
					return { data = result }
				end

				local v = {
					message = `Failed to build ComponentList from pool source: {SduiParseHelpers.stringifyValue(result)}`,
					name = captureErrorContext.name,
					componentType = captureErrorContext.componentType,
					parserName = captureErrorContext.parserName
				}

				if FFlagSduiErrorPaths then
					addSduiErrorContextFields(v, captureErrorContext.nodeContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v, captureErrorContext.appPage)

				return { data = {} }
			end), PropResultCategory.PropSignal
		end

		error(`Unknown ComponentList source kind: {kind}`)
	end
end

return buildComponentList
