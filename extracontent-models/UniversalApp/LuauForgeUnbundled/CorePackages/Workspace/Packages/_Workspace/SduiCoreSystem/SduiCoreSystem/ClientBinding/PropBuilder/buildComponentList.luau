local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiClientBindingTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
local SduiListEntryNormalizer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryNormalizer")
local SduiListEntrySorter = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntrySorter")
local SduiListEntryRenderer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryRenderer")
local SduiPoolEntryHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPoolEntryHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStoreTypes")
local fFlagSduiPerSectionPoolSizing = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiPerSectionPoolSizing

local FFlagSduiComponentListReuseByEntryIndex = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/FFlagSduiComponentListReuseByEntryIndex")

local propResultCategory = SduiClientBindingTypes.PropResultCategory

local function canSorterReorder(items, p2): boolean
	if p2 ~= nil then
		return true
	end

	for k, item in items do
		if item.sortRankProp ~= nil then
			return true
		end
	end

	return false
end

local function buildItemsFromEntries(items, ordered_identifiers, p2, callback, p3, data, captureErrorContext, p4, p5, defer_item_build, callback2, p6)
	if p2 ~= nil then
		local flag

		if ordered_identifiers == nil then
			local flag2 = true

			for k, item in items do
				if item.sortRankProp ~= nil then
					flag = true
					flag2 = false
					break
				end
			end

			if flag2 then
				flag = false
			end
		else
			flag = true
		end

		if flag then
			p2 = nil
		end
	end

	local v5 = SduiListEntrySorter.applyOrder(items, ordered_identifiers, p5, p3, callback, data, p4)

	local v6 = nil
	local entryConfigExtrasFn = nil
	local computePoolSections = SduiPoolEntryHelpers.computePoolSections
	local v7 = if fFlagSduiPerSectionPoolSizing then p6 else nil
	local v8 = computePoolSections(v5, v7)

	if callback2 ~= nil or SduiPoolEntryHelpers.sectionsHaveMultiRow(v8) then
		local v9 = if callback2 ~= nil then callback2(p5) else nil
		local poolEntryFns = SduiPoolEntryHelpers.createPoolEntryFns(
			v8,
			callback,
			p3,
			data,
			captureErrorContext,
			v9,
			p6
		)

		v6 = poolEntryFns.inputSlicer
		entryConfigExtrasFn = poolEntryFns.entryConfigExtrasFn
	end

	if v6 == nil then
		v6 = SduiListEntryRenderer.createInputSlicer(callback, p3, data, captureErrorContext)
	end

	return SduiListEntryRenderer.buildEntryConfigs(
		v5,
		v6,
		p2,
		data,
		captureErrorContext,
		p4,
		p3,
		p5,
		defer_item_build,
		entryConfigExtrasFn
	)
end

local function buildComponentList(p2, data, p3, callback, data2, p4)
	local source = data and data.source
	local default_item = data and data.default_item
	local ordered_identifiers = data and data.ordered_identifiers
	local item_overrides = data and data.item_overrides
	local defer_item_build = data and data.defer_item_build

	if source == nil then
		local v5 = {
			message = "ComponentList missing source",
			name = data2.debugName,
			componentType = data2.currentComponentType,
			parserName = data2.currentParserName
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v5, data2.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, data2.appPage)
		return function()
			return { data = {} }
		end, propResultCategory.PropSignal
	else
		local kind = source.type
		local value = source.value

		local captureErrorContext = SduiListEntryRenderer.captureErrorContext(data2)

		local pool_config = data and data.pool_config
		local poolDataGetter = SduiPoolEntryHelpers.resolvePoolDataGetter(
			pool_config and pool_config.pool_path,
			p3,
			data2,
			callback
		)

		local poolEntryConfigs = SduiPoolEntryHelpers.buildPoolEntryConfigs(pool_config)

		if kind == "binding_path" then
			local v5 = nil
			return SduiPropUtils.generateDynamicBindingPropValue(value, p3, data2, callback, function(p5, p6)
				local itemsFromEntries, v6 = buildItemsFromEntries(
					SduiListEntryNormalizer.normalizeBoundData(p5, default_item, item_overrides, data2),
					ordered_identifiers,
					v5,
					callback,
					p3,
					data2,
					captureErrorContext,
					p4,
					p6,
					defer_item_build,
					poolDataGetter,
					poolEntryConfigs
				)

				if not FFlagSduiComponentListReuseByEntryIndex then
					v5 = itemsFromEntries

					return itemsFromEntries
				end

				local v7 = {}

				for k, v8 in v6 do
					v7[v8] = itemsFromEntries[k]
				end

				v5 = v7
				return itemsFromEntries
			end), propResultCategory.PropSignal
		end

		if kind == "literal" then
			local items = value and value.items

			if items == nil then
				return function()
					return { data = {} }
				end, propResultCategory.PropSignal
			end

			return function(p5)
				local success, result = pcall(function()
					return (buildItemsFromEntries(
						SduiListEntryNormalizer.normalizeLiteralItems(items, default_item, data2),
						ordered_identifiers,
						nil,
						callback,
						p3,
						data2,
						captureErrorContext,
						p4,
						p5,
						defer_item_build,
						poolDataGetter,
						poolEntryConfigs
					))
				end)

				if success then
					return { data = result }
				end

				local v5 = {
					message = `Failed to build ComponentList from literal source: {module7.stringifyValue(result)}`,
					name = captureErrorContext.name,
					componentType = captureErrorContext.componentType,
					parserName = captureErrorContext.parserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v5, captureErrorContext.nodeContext)
				end

				SduiLogger.reportError(
					SduiErrors.SduiErrorType.FailedToParseProp,
					v5,
					captureErrorContext.appPage
				)

				return { data = {} }
			end, propResultCategory.PropSignal
		end

		if kind == "pool" then
			return Signals.createComputed(function(p5)
				local success, result = pcall(function()
					local section = (callback(p5) or {})._section

					if typeof(section) ~= "table" then
						return {}
					end

					local cells = section.cells

					if typeof(cells) ~= "function" then
						return {}
					end

					local v5 = cells(p5)

					if #v5 == 0 then
						return {}
					end

					local v6 = table.create(#v5, 0)
					local v7 = {}

					for k, v8 in v5 do
						if v8.item == nil then
							continue
						end

						table.insert(v7, v8.item)
						v6[k] = #v7
					end

					local itemsFromEntries, v8 = buildItemsFromEntries(
						SduiListEntryNormalizer.normalizeBoundData(v7, default_item, item_overrides, data2),
						ordered_identifiers,
						nil,
						callback,
						p3,
						data2,
						captureErrorContext,
						p4,
						p5,
						defer_item_build,
						nil,
						nil
					)

					if #itemsFromEntries ~= #v7 then
						local v9 = {
							message = `Pool-backed ComponentList dropped {#v7 - #itemsFromEntries} of {#v7} items;` .. " pool templates must resolve to valid templates and must not use is_component_filtered",
							name = captureErrorContext.name,
							componentType = captureErrorContext.componentType,
							parserName = captureErrorContext.parserName
						}

						if fFlagSduiErrorPaths then
							addSduiErrorContextFields(v9, captureErrorContext.nodeContext)
						end

						SduiLogger.reportError(
							SduiErrors.SduiErrorType.FailedToParseProp,
							v9,
							captureErrorContext.appPage
						)
					end

					local v9 = {}

					for k, v10 in v8 do
						v9[v10] = itemsFromEntries[k]
					end

					local result2 = {}

					for k, v10 in v5 do
						local v11 = v6[k]

						if v11 == 0 then
							table.insert(result2, { isBlank = true })
						else
							local v12 = v9[v11]

							if v12 ~= nil then
								v12.realIndex = v10.realIndex
								v12.spanOverride = v10.spanOverride
								table.insert(result2, v12)
							end
						end
					end

					return result2
				end)

				if success then
					return { data = result }
				end

				local v5 = {
					message = `Failed to build ComponentList from pool source: {module7.stringifyValue(result)}`,
					name = captureErrorContext.name,
					componentType = captureErrorContext.componentType,
					parserName = captureErrorContext.parserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v5, captureErrorContext.nodeContext)
				end

				SduiLogger.reportError(
					SduiErrors.SduiErrorType.FailedToParseProp,
					v5,
					captureErrorContext.appPage
				)

				return { data = {} }
			end), propResultCategory.PropSignal
		end

		error(`Unknown ComponentList source kind: {kind}`)
	end
end

return buildComponentList
