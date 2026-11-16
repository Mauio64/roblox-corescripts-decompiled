local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Cryo = require(parent.Cryo)
require(parent.ServiceContractsProto)
local Signals = require(parent.Signals)

local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)
local buildComponentList = require(SduiCoreSystem.ClientBinding.PropBuilder.buildComponentList)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.SduiComponentType)

local v = {}

local function buildItemList(templateFromData, items, inputs, callback, data, p, p2, p3, p4, flag: boolean?, p5: string?)
	local itemList = {}

	for k, item in items do
		local v2

		if FFlagSduiErrorPaths then
			v2 = p5
		end

		local v3, flag2

		if item and item.inline_component ~= nil then
			v3 = item.inline_component
			flag2 = true

			if FFlagSduiErrorPaths then
				v2 = nil
			end
		elseif item and item.roblox_component and item.roblox_component ~= "" then
			if FFlagSduiErrorPaths then
				local templateForRobloxComponent = data.getTemplateForRobloxComponent(item.roblox_component)

				if templateForRobloxComponent then
					v2 = item.roblox_component
				else
					v2 = p5
				end

				v3 = templateForRobloxComponent or templateFromData
			else
				v3 = data.getTemplateForRobloxComponent(item.roblox_component) or templateFromData
			end

			flag2 = false
		elseif flag == true then
			v3 = templateFromData
			flag2 = true
		else
			v3 = templateFromData
			flag2 = false
		end

		if p2 and p2[k] then
			local v4 = p2[k]

			if SduiPropUtils.isComponentVisible(v4, p4) then
				table.insert(itemList, v4)
			end
		else
			local computed = Signals.createComputed(function(p6)
				if flag2 then
					return Cryo.Dictionary.join(callback(p6), item or v)
				end

				local v4

				if inputs then
					v4 = table.clone(item)
					local success, result = pcall(function()
						buildInputsForNestedComponent(callback, inputs, p3, p6, v4, data)
					end)

					if not success then
						local v5 = {
							message = `Failed to build inputs for nested component in list: {SduiParseHelpers.stringifyValue(result)}`,
							name = data.debugName,
							componentType = data.currentComponentType,
							parserName = data.currentParserName
						}

						if FFlagSduiErrorPaths then
							addSduiErrorContextFields(v5, data.errorContext)
						end

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, data.appPage)
					end
				else
					v4 = item
				end

				return v4
			end)
			local v4

			if flag2 then
				v4 = p3
			end

			if not FFlagSduiErrorPaths then
				v2 = nil
			end

			local v5

			if FFlagSduiErrorPaths and typeof(item) == "table" then
				v5 = item.identifier
			end

			local configForComponent = buildConfigForComponent(v3, computed, data, p, nil, v4, nil, v2, v5)

			if configForComponent and SduiPropUtils.isComponentVisible(configForComponent, p4) then
				table.insert(itemList, configForComponent)
			end
		end
	end

	return itemList
end

local function buildOrderedTemplateDataList(data, p, callback, data2, p2)
	local entry_map_path = data.entry_map_path
	local entry_order = data.entry_order
	local template_data_map = data.template_data_map

	if entry_order == nil then
		error("Missing entry_order in ordered_template_data")
	end

	if template_data_map == nil or typeof(template_data_map) ~= "table" then
		error("Missing or invalid template_data_map in ordered_template_data")
	end

	local v2

	if entry_map_path and entry_map_path ~= "" then
		v2 = splitDottedPath(entry_map_path)
	else
		v2 = nil
	end

	local kind

	if entry_order then
		kind = entry_order.kind
	else
		kind = nil
	end

	local v3

	if kind and kind.type == "binding_path" then
		v3 = splitDottedPath(kind.value)
	else
		v3 = nil
	end

	return Signals.createComputed(function(p3)
		local success, result = pcall(function()
			local v4 = nil

			if v3 then
				v4 = SduiPropUtils.resolveBindingPathValue(p3, v3, p, callback, nil, nil, data2)
			elseif kind and kind.type == "literal" then
				v4 = kind.value and kind.value.items
			end

			if v4 == nil then
				error("entry_order resolved to nil in ordered_template_data")
			end

			local v5

			if v2 then
				v5 = SduiPropUtils.resolveBindingPathValue(p3, v2, p, callback, nil, nil, data2)
			end

			local result = {}

			for _, identifier in v4 do
				if typeof(identifier) == "table" then
					identifier = identifier.identifier
				end

				if not (identifier ~= nil and identifier ~= "") then
					continue
				end

				local v6 = template_data_map[identifier]
				local v7

				if v5 then
					v7 = v5[identifier]
				end

				local inline_component

				if v6 then
					inline_component = v6.inline_component
				end

				local roblox_component

				if v7 and v7.roblox_component and v7.roblox_component ~= "" then
					roblox_component = v7.roblox_component
				elseif v6 and v6.roblox_component then
					roblox_component = v6.roblox_component
				end

				if roblox_component == nil and inline_component == nil then
					local v8 = {
						message = `No roblox_component or inline_component for identifier "{identifier}" in ordered_template_data (not in template_data_map or feed entry)`,
						name = data2.debugName,
						componentType = data2.currentComponentType,
						parserName = data2.currentParserName
					}

					if FFlagSduiErrorPaths then
						addSduiErrorContextFields(v8, data2.errorContext)
					end

					SduiLogger.reportError(SduiErrors.SduiErrorType.UnknownTemplateDataIdentifier, v8, data2.appPage)
				else
					local v8 = roblox_component
					local v9 = inline_component
					local v10 = v7
					local v11 = identifier
					local success, result2 = pcall(function()
						local template = SduiPropUtils.resolveTemplate(v8, v9, data2)
						local v12 = v9 ~= nil
						local inputs

						if v6 then
							inputs = v6.inputs
						else
							inputs = nil
						end

						local computed = Signals.createComputed(function(p4)
							local result2

							if v12 then
								result2 = table.clone(callback(p4))
							else
								result2 = {}

								if inputs then
									buildInputsForNestedComponent(callback, inputs, p, p4, result2, data2)
								end
							end

							if not v10 then
								return result2
							end

							local value

							if v10.input_data and v10.input_data.kind and v10.input_data.kind.value then
								value = v10.input_data.kind.value
							end

							if typeof(value) == "table" then
								for k, v13 in value do
									result2[k] = v13
								end
							end

							return result2
						end)
						local v13

						if v12 then
							v13 = p
						end

						local v14

						if FFlagSduiErrorPaths and not v12 then
							v14 = v8
						end

						local v15

						if FFlagSduiErrorPaths then
							v15 = v11
						end

						return buildConfigForComponent(template, computed, data2, p2, nil, v13, nil, v14, v15)
					end)

					if success then
						if result2 and SduiPropUtils.isComponentVisible(result2, p3) then
							table.insert(result, result2)
						end
					else
						local v12 = {
							message = `Failed to build ordered_template_data entry for identifier {identifier}: {SduiParseHelpers.stringifyValue(result2)}`,
							name = data2.debugName,
							componentType = data2.currentComponentType,
							parserName = data2.currentParserName
						}

						if FFlagSduiErrorPaths then
							addSduiErrorContextFields(v12, data2.errorContext)
						end

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v12, data2.appPage)
					end
				end
			end

			return result
		end)

		if success then
			return { data = result }
		end

		local v4 = {
			message = `Failed to build ordered_template_data component list: {SduiParseHelpers.stringifyValue(result)}`,
			name = data2.debugName,
			componentType = data2.currentComponentType,
			parserName = data2.currentParserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v4, data2.errorContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v4, data2.appPage)
		return { data = {} }
	end), PropResultCategory.PropSignal
end

local function buildLazyNestedComponentListProp(p: string, data, p2, p3, data2, p4)
	local currentComponentType = data2.currentComponentType
	local currentParserName = data2.currentParserName

	if p == "array_map" then
		local templateFromData = SduiPropUtils.resolveTemplateFromData(data, data2)
		local binding_path = data.binding_path

		if binding_path == nil or binding_path == "" then
			error(`No bindingPath specified for roblox_component {data.roblox_component}`)
		end

		local v2 = data.inline_component ~= nil

		local v3 = nil
		return SduiPropUtils.generateDynamicBindingPropValue(binding_path, p2, data2, p3, function(p5, p6)
			local inputs = data.inputs

			local v4 = v3
			local v5

			if FFlagSduiErrorPaths and not v2 then
				v5 = data.roblox_component
			end

			v3 = buildItemList(templateFromData, p5, inputs, p3, data2, p4, v4, p2, p6, v2, v5)

			return v3
		end), PropResultCategory.PropSignal
	elseif p == "item_list" then
		if typeof(data) ~= "table" then
			error(`Missing or invalid templateDataList {typeof(data)}`)
		end

		local items = data.items

		if typeof(items) ~= "table" then
			error(`Missing or invalid templateDataList.items {typeof(data)}`)
		end

		return Signals.createComputed(function(p5)
			local success, result = pcall(function()
				local configForComponents = {}

				for _, item in items do
					local templateFromData = SduiPropUtils.resolveTemplateFromData(item, data2)

					local v2 = item.inline_component ~= nil
					local inputs = item.inputs
					local v3

					if v2 then
						v3 = p3
					else
						v3 = Signals.createComputed(function(p6)
							local v4 = {}

							if not inputs then
								return v4
							end

							local success, result = pcall(function()
								buildInputsForNestedComponent(p3, inputs, p2, p6, v4, data2)
							end)

							if success then
								return v4
							end

							local v5 = {
								message = `Failed to build inputs for nested component in item_list: {SduiParseHelpers.stringifyValue(result)}`,
								name = data2.debugName,
								componentType = currentComponentType,
								parserName = currentParserName
							}

							if FFlagSduiErrorPaths then
								addSduiErrorContextFields(v5, data2.errorContext)
							end

							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v5, data2.appPage)

							return v4
						end)
					end

					local v4

					if v2 then
						v4 = p2
					end

					local v5

					if FFlagSduiErrorPaths and not v2 then
						v5 = item.roblox_component
					end

					local configForComponent = buildConfigForComponent(
						templateFromData,
						v3,
						data2,
						p4,
						nil,
						v4,
						nil,
						v5
					)

					if configForComponent and SduiPropUtils.isComponentVisible(configForComponent, p5) then
						table.insert(configForComponents, configForComponent)
					end
				end

				return configForComponents
			end)

			if success then
				return { data = result }
			end

			local v2 = {
				message = `Failed to build item_list component list: {SduiParseHelpers.stringifyValue(result)}`,
				name = data2.debugName,
				componentType = currentComponentType,
				parserName = currentParserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v2, data2.errorContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v2, data2.appPage)

			return { data = {} }
		end), PropResultCategory.PropSignal
	else
		if p == "ordered_template_data" then
			return buildOrderedTemplateDataList(data, p2, p3, data2, p4)
		elseif p == "conditional" then
			return
				SduiPropUtils.generateConditionalPropValue(data, p2, data2, p4, p3, buildLazyNestedComponentListProp),
				PropResultCategory.PropSignal
		elseif p == "component_list" then
			return buildComponentList("component_list", data, p2, p3, data2, p4)
		end

		error(`Could not build prop. Unknown propDefinitionType: {p}`)
	end
end
return buildLazyNestedComponentListProp
