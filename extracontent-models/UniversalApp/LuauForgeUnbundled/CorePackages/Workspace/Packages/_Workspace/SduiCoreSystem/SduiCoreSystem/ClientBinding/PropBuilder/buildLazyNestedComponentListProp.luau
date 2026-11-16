local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local buildInputsForNestedComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildInputsForNestedComponent")
local buildComponentList = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildComponentList")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiClientBindingTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local buildConfigForComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder").buildConfigForComponent
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local propResultCategory = SduiClientBindingTypes.PropResultCategory
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local splitDottedPath = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/splitDottedPath")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")

local v5 = {}

local function buildItemList(p2, items, p3, callback, data, p4, p5, p6, p7, p8, p9)
	local itemList = {}

	for k, item in items do
		local v6 = if fFlagSduiErrorPaths then p9 else nil
		local v7, flag

		if item and item.inline_component ~= nil then
			v7 = item.inline_component
			flag = true

			if fFlagSduiErrorPaths then
				v6 = nil
			end
		elseif item and item.roblox_component and item.roblox_component ~= "" then
			if fFlagSduiErrorPaths then
				local templateForRobloxComponent = data.getTemplateForRobloxComponent(item.roblox_component)
				v6 = if templateForRobloxComponent then item.roblox_component else p9
				v7 = templateForRobloxComponent or p2
			else
				v7 = data.getTemplateForRobloxComponent(item.roblox_component) or p2
			end

			flag = false
		elseif p8 == true then
			v7 = p2
			flag = true
		else
			v7 = p2
			flag = false
		end

		if p5 and p5[k] then
			local v8 = p5[k]

			if SduiPropUtils.isComponentVisible(v8, p7) then
				table.insert(itemList, v8)
			end
		else
			local computed = Signals.createComputed(function(p10)
				if flag then
					return Cryo.Dictionary.join(callback(p10), item or v5)
				end

				local v8

				if p3 then
					v8 = table.clone(item)
					local success, result = pcall(function()
						buildInputsForNestedComponent(callback, p3, p6, p10, v8, data)
					end)

					if not success then
						local v9 = {
							message = `Failed to build inputs for nested component in list: {module11.stringifyValue(result)}`,
							name = data.debugName,
							componentType = data.currentComponentType,
							parserName = data.currentParserName
						}

						if fFlagSduiErrorPaths then
							addSduiErrorContextFields(v9, data.errorContext)
						end

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v9, data.appPage)
					end
				else
					v8 = item
				end

				return v8
			end)
			local v10 = if flag then p6 else nil

			if not fFlagSduiErrorPaths then
				v6 = nil
			end

			local v12 = if fFlagSduiErrorPaths and typeof(item) == "table" then item.identifier else nil
			local v13 = buildConfigForComponent(v7, computed, data, p4, nil, v10, nil, v6, v12)

			if v13 and SduiPropUtils.isComponentVisible(v13, p7) then
				table.insert(itemList, v13)
			end
		end
	end

	return itemList
end

local function buildOrderedTemplateDataList(data, p2, callback, data2, p3)
	local entry_map_path = data.entry_map_path
	local entry_order = data.entry_order
	local template_data_map = data.template_data_map

	if entry_order == nil then
		error("Missing entry_order in ordered_template_data")
	end

	if template_data_map == nil or typeof(template_data_map) ~= "table" then
		error("Missing or invalid template_data_map in ordered_template_data")
	end

	local v6 = if entry_map_path and entry_map_path ~= "" then splitDottedPath(entry_map_path) else nil

	local kind = if entry_order then entry_order.kind else nil
	local v7 = if kind and kind.type == "binding_path" then splitDottedPath(kind.value) else nil

	return Signals.createComputed(function(p4)
		local success, result = pcall(function()
			local v8 = nil

			if v7 then
				v8 = SduiPropUtils.resolveBindingPathValue(p4, v7, p2, callback, nil, nil, data2)
			elseif kind and kind.type == "literal" then
				v8 = kind.value and kind.value.items
			end

			if v8 == nil then
				error("entry_order resolved to nil in ordered_template_data")
			end

			local v9 = if v6 then SduiPropUtils.resolveBindingPathValue(p4, v6, p2, callback, nil, nil, data2) else nil

			local result2 = {}

			for k, identifier in v8 do
				if typeof(identifier) == "table" then
					identifier = identifier.identifier
				end

				if not (identifier ~= nil and identifier ~= "") then
					continue
				end

				local v10 = template_data_map[identifier]
				local v11 = if v9 then v9[identifier] else nil

				local inline_component = if v10 then v10.inline_component else nil
				local roblox_component

				if v11 and v11.roblox_component and v11.roblox_component ~= "" then
					roblox_component = v11.roblox_component
				elseif v10 and v10.roblox_component then
					roblox_component = v10.roblox_component
				end

				if roblox_component == nil and inline_component == nil then
					local v12 = {
						message = `No roblox_component or inline_component for identifier "{identifier}" in ordered_template_data (not in template_data_map or feed entry)`,
						name = data2.debugName,
						componentType = data2.currentComponentType,
						parserName = data2.currentParserName
					}

					if fFlagSduiErrorPaths then
						addSduiErrorContextFields(v12, data2.errorContext)
					end

					SduiLogger.reportError(
						SduiErrors.SduiErrorType.UnknownTemplateDataIdentifier,
						v12,
						data2.appPage
					)
				else
					local v12 = roblox_component
					local v13 = inline_component
					local v14 = v11
					local v15 = identifier
					local success2, result3 = pcall(function()
						local template = SduiPropUtils.resolveTemplate(v12, v13, data2)
						local v16 = v13 ~= nil
						local inputs = if v10 then v10.inputs else nil
						local computed = Signals.createComputed(function(p5)
							local result4

							if v16 then
								result4 = table.clone(callback(p5))
							else
								result4 = {}

								if inputs then
									buildInputsForNestedComponent(callback, inputs, p2, p5, result4, data2)
								end
							end

							if not v14 then
								return result4
							end

							local value

							if v14.input_data and v14.input_data.kind and v14.input_data.kind.value then
								value = v14.input_data.kind.value
							end

							if typeof(value) == "table" then
								for k2, v17 in value do
									result4[k2] = v17
								end
							end

							return result4
						end)
						local v21 = if v16 then p2 else nil
						local v23 = if fFlagSduiErrorPaths and not v16 then v12 else nil
						return buildConfigForComponent(
							template,
							computed,
							data2,
							p3,
							nil,
							v21,
							nil,
							v23,
							if fFlagSduiErrorPaths then v15 else nil
						)
					end)

					if success2 then
						if result3 and SduiPropUtils.isComponentVisible(result3, p4) then
							table.insert(result2, result3)
						end
					else
						local v16 = {
							message = `Failed to build ordered_template_data entry for identifier {identifier}: {module11.stringifyValue(result3)}`,
							name = data2.debugName,
							componentType = data2.currentComponentType,
							parserName = data2.currentParserName
						}

						if fFlagSduiErrorPaths then
							addSduiErrorContextFields(v16, data2.errorContext)
						end

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v16, data2.appPage)
					end
				end
			end

			return result2
		end)

		if success then
			return { data = result }
		end

		local v8 = {
			message = `Failed to build ordered_template_data component list: {module11.stringifyValue(result)}`,
			name = data2.debugName,
			componentType = data2.currentComponentType,
			parserName = data2.currentParserName
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v8, data2.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v8, data2.appPage)
		return { data = {} }
	end), propResultCategory.PropSignal
end

local function buildLazyNestedComponentListProp(p2, data, p3, p4, data2, p5)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p2 == "array_map" then
		local templateFromData = SduiPropUtils.resolveTemplateFromData(data, data2)
		local binding_path = data.binding_path

		if binding_path == nil or binding_path == "" then
			error(`No bindingPath specified for roblox_component {data.roblox_component}`)
		end

		local v6 = data.inline_component ~= nil

		local v7 = nil
		return SduiPropUtils.generateDynamicBindingPropValue(binding_path, p3, data2, p4, function(p6, p7)
			local inputs = data.inputs

			local v13 = v7

			local v16 = if fFlagSduiErrorPaths and not v6 then data.roblox_component else nil
			v7 = buildItemList(templateFromData, p6, inputs, p4, data2, p5, v13, p3, p7, v6, v16)

			return v7
		end), propResultCategory.PropSignal
	elseif p2 == "item_list" then
		if typeof(data) ~= "table" then
			error(`Missing or invalid templateDataList {typeof(data)}`)
		end

		local items = data.items

		if typeof(items) ~= "table" then
			error(`Missing or invalid templateDataList.items {typeof(data)}`)
		end

		return Signals.createComputed(function(p6)
			local success, result = pcall(function()
				local result2 = {}

				for k, item in items do
					local templateFromData = SduiPropUtils.resolveTemplateFromData(item, data2)

					local v6 = item.inline_component ~= nil
					local inputs = item.inputs
					local v7

					if v6 then
						v7 = p4
					else
						v7 = Signals.createComputed(function(p7)
							local v8 = {}

							if not inputs then
								return v8
							end

							local success2, result3 = pcall(function()
								buildInputsForNestedComponent(p4, inputs, p3, p7, v8, data2)
							end)

							if success2 then
								return v8
							end

							local v9 = {
								message = `Failed to build inputs for nested component in item_list: {module11.stringifyValue(result3)}`,
								name = data2.debugName,
								componentType = currentComponentType,
								parserName = currentParserName
							}

							if fFlagSduiErrorPaths then
								addSduiErrorContextFields(v9, data2.errorContext)
							end

							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v9, data2.appPage)

							return v8
						end)
					end

					local v12 = if v6 then p3 else nil
					local v14 = if fFlagSduiErrorPaths and not v6 then item.roblox_component else nil
					local v15 = buildConfigForComponent(templateFromData, v7, data2, p5, nil, v12, nil, v14)

					if v15 and SduiPropUtils.isComponentVisible(v15, p6) then
						table.insert(result2, v15)
					end
				end

				return result2
			end)

			if success then
				return { data = result }
			end

			local v6 = {
				message = `Failed to build item_list component list: {module11.stringifyValue(result)}`,
				name = data2.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, data2.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v6, data2.appPage)

			return { data = {} }
		end), propResultCategory.PropSignal
	else
		if p2 == "ordered_template_data" then
			return buildOrderedTemplateDataList(data, p3, p4, data2, p5)
		elseif p2 == "conditional" then
			return
				SduiPropUtils.generateConditionalPropValue(
					data,
					p3,
					data2,
					p5,
					p4,
					buildLazyNestedComponentListProp
				),
				propResultCategory.PropSignal
		elseif p2 == "component_list" then
			return buildComponentList("component_list", data, p3, p4, data2, p5)
		end

		error(`Could not build prop. Unknown propDefinitionType: {p2}`)
	end
end
return buildLazyNestedComponentListProp
