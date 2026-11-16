local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths
local Cryo = require(parent.Cryo)
require(parent.Signals)

local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
require(SduiCoreSystem.SduiComponentType)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)

local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent

local SduiDeferredItemStub = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiDeferredItemStub)

local v = {}

local function unwrapEntryData(item)
	if typeof(item) ~= "table" then
		return { value = item }
	end

	local input_data = item.input_data

	if not (input_data and input_data.kind and input_data.kind.value) then
		return table.clone(item)
	end

	local result = {}

	if typeof(input_data.kind.value) == "table" then
		for k, v2 in input_data.kind.value do
			result[k] = v2
		end
	end

	return result
end

local function fillInputs(p, inputs, callback, p2, p3, p4, data)
	if inputs == nil then
		return
	end

	local success, result = pcall(function()
		buildInputsForNestedComponent(callback, inputs, p2, p3, p, p4)
	end)

	if not success then
		local v2 = {
			message = `Failed to build inputs for ComponentList item: {SduiParseHelpers.stringifyValue(result)}`,
			name = data.name,
			componentType = data.componentType,
			parserName = data.parserName
		}

		if FFlagSduiErrorPaths then
			addSduiErrorContextFields(v2, data.nodeContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v2, data.appPage)
	end
end

local SduiListEntryRenderer = {}

function SduiListEntryRenderer.captureErrorContext(data)
	local v2 = {
		name = data.debugName,
		nodeContext = 0,
		componentType = 0,
		parserName = 0,
		appPage = 0
	}
	local nodeContext

	if FFlagSduiErrorPaths then
		nodeContext = data.errorContext
	end

	v2.nodeContext = nodeContext
	v2.componentType = data.currentComponentType
	v2.parserName = data.currentParserName
	v2.appPage = data.appPage
	return v2
end

function SduiListEntryRenderer.createInputSlicer(callback, p, p2, p3, callback2)
	local function rawSlice(data, flag: boolean)
		if data.sourceMode == "literal" then
			if flag then
				return callback
			end

			return function(p4)
				local v2 = {}
				fillInputs(v2, data.inputs, callback, p, p4, p2, p3)

				return v2
			end
		else
			local item = data.item

			if flag then
				return function(p4)
					local join = Cryo.Dictionary.join
					local v2 = callback(p4)
					local v3

					if typeof(item) == "table" then
						v3 = item
					else
						v3 = v
					end

					return join(v2, v3)
				end
			end

			return function(p4)
				local v2 = unwrapEntryData(item)
				fillInputs(v2, data.inputs, callback, p, p4, p2, p3)

				return v2
			end
		end
	end

	if callback2 == nil then
		return rawSlice
	end

	return function(p4, p5)
		local v2 = rawSlice(p4, p5)
		return function(p6)
			local v3 = callback2(p4)

			if v3 == nil then
				return v2(p6)
			end

			return Cryo.Dictionary.join(v2(p6), v3)
		end
	end
end

function SduiListEntryRenderer.buildEntryConfigs(items, callback, p, p2, data, p3, p4, p5, flag: boolean?, callback2)
	local v2 = callback2 ~= nil
	local result = {}
	local result2 = {}

	for k, item in items do
		if p and p[k] then
			local v3 = p[k]

			if SduiPropUtils.isComponentVisible(v3, p5) then
				if v2 then
					local v4 = callback2(item, p5)

					if v4 ~= nil then
						for k2, v5 in v4 do
							v3[k2] = v5
						end
					end
				end

				table.insert(result, v3)
				table.insert(result2, k)
			end
		elseif item.template == nil then
			local v3 = {
				message = `No template found for ComponentList item (identifier: {item.identifier or tostring(k)})`,
				name = data.name,
				componentType = data.componentType,
				parserName = data.parserName
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v3, data.nodeContext)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v3, data.appPage)
		else
			local v3 = callback(item, item.isInline)
			local v4

			if item.isInline then
				v4 = p4
			end

			if
				flag
				and (not item.template or not (item.template.kind and item.template.kind.value) or not item.template.kind.value.shared or item.template.kind.value.shared.is_component_filtered == nil)
			then
				local makeStub = SduiDeferredItemStub.makeStub
				local template = item.template
				local robloxComponent

				if FFlagSduiErrorPaths then
					robloxComponent = item.robloxComponent
				end

				local v5

				if FFlagSduiErrorPaths then
					v5 = item.identifier
				end

				local stub = makeStub(template, v3, p2, p3, v4, data, robloxComponent, v5)

				if v2 then
					local v6 = callback2(item, p5)

					if v6 ~= nil then
						for k2, v7 in v6 do
							stub[k2] = v7
						end
					end
				end

				table.insert(result, stub)
				table.insert(result2, k)
			else
				local template = item.template
				local robloxComponent

				if FFlagSduiErrorPaths then
					robloxComponent = item.robloxComponent
				end

				local v5

				if FFlagSduiErrorPaths then
					v5 = item.identifier
				end

				local configForComponent = buildConfigForComponent(
					template,
					v3,
					p2,
					p3,
					nil,
					v4,
					nil,
					robloxComponent,
					v5
				)

				if configForComponent and SduiPropUtils.isComponentVisible(configForComponent, p5) then
					if v2 then
						local v6 = callback2(item, p5)

						if v6 ~= nil then
							for k2, v7 in v6 do
								configForComponent[k2] = v7
							end
						end
					end

					table.insert(result, configForComponent)
					table.insert(result2, k)
				end
			end
		end
	end

	return result, result2
end

return SduiListEntryRenderer
