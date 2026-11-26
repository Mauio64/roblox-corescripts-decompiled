local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local buildInputsForNestedComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/buildInputsForNestedComponent")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
local SduiPropUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiPropUtils")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryNormalizer")

local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent

local SduiDeferredItemStub = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiDeferredItemStub")

local v5 = {}

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
		for k, v6 in input_data.kind.value do
			result[k] = v6
		end
	end

	return result
end

local function fillInputs(p2, inputs, callback, p3, p4, p5, data)
	if inputs == nil then
		return
	end

	local success, result = pcall(function()
		buildInputsForNestedComponent(callback, inputs, p3, p4, p2, p5)
	end)

	if not success then
		local v6 = {
			message = `Failed to build inputs for ComponentList item: {module8.stringifyValue(result)}`,
			name = data.name,
			componentType = data.componentType,
			parserName = data.parserName
		}

		if fFlagSduiErrorPaths then
			addSduiErrorContextFields(v6, data.nodeContext)
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v6, data.appPage)
	end
end

return {
	captureErrorContext = function(data)
		local v6 = {
			name = data.debugName,
			nodeContext = 0,
			componentType = 0,
			parserName = 0,
			appPage = 0
		}
		local v7 = if fFlagSduiErrorPaths then data.errorContext else nil
		v6.nodeContext = v7
		v6.componentType = data.currentComponentType
		v6.parserName = data.currentParserName
		v6.appPage = data.appPage
		return v6
	end,
	createInputSlicer = function(callback, p2, p3, p4, callback2)
		local function rawSlice(data, p5)
			if data.sourceMode == "literal" then
				if p5 then
					return callback
				end

				return function(p6)
					local v6 = {}
					fillInputs(v6, data.inputs, callback, p2, p6, p3, p4)

					return v6
				end
			else
				local item = data.item

				if p5 then
					return function(p6)
						local join = Cryo.Dictionary.join
						local v6 = callback(p6)
						local v7 = if typeof(item) == "table" then item else v5
						return join(v6, v7)
					end
				end

				return function(p6)
					local v6 = unwrapEntryData(item)
					fillInputs(v6, data.inputs, callback, p2, p6, p3, p4)

					return v6
				end
			end
		end

		if callback2 == nil then
			return rawSlice
		end

		return function(p5, p6)
			local v6 = rawSlice(p5, p6)
			return function(p7)
				local v7 = callback2(p5)

				if v7 == nil then
					return v6(p7)
				end

				return Cryo.Dictionary.join(v6(p7), v7)
			end
		end
	end,
	buildEntryConfigs = function(items, callback, p2, p3, data, p4, p5, p6, p7, callback2)
		local v6 = callback2 ~= nil
		local result = {}
		local result2 = {}

		for k, item in items do
			if p2 and p2[k] then
				local v7 = p2[k]

				if SduiPropUtils.isComponentVisible(v7, p6) then
					if v6 then
						local v8 = callback2(item, p6)

						if v8 ~= nil then
							for k2, v9 in v8 do
								v7[k2] = v9
							end
						end
					end

					table.insert(result, v7)
					table.insert(result2, k)
				end
			elseif item.template == nil then
				local v7 = {
					message = `No template found for ComponentList item (identifier: {item.identifier or tostring(k)})`,
					name = data.name,
					componentType = data.componentType,
					parserName = data.parserName
				}

				if fFlagSduiErrorPaths then
					addSduiErrorContextFields(v7, data.nodeContext)
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, v7, data.appPage)
			else
				local v7 = callback(item, item.isInline)

				local v8 = if item.isInline then p5 else nil

				if
					p7
					and (not item.template or not (item.template.kind and item.template.kind.value) or not item.template.kind.value.shared or item.template.kind.value.shared.is_component_filtered == nil)
				then
					local makeStub = SduiDeferredItemStub.makeStub
					local template = item.template

					local robloxComponent = if fFlagSduiErrorPaths then item.robloxComponent else nil
					local v9 = if fFlagSduiErrorPaths then item.identifier else nil
					local stub = makeStub(template, v7, p3, p4, v8, data, robloxComponent, v9)

					if v6 then
						local v10 = callback2(item, p6)

						if v10 ~= nil then
							for k2, v11 in v10 do
								stub[k2] = v11
							end
						end
					end

					table.insert(result, stub)
					table.insert(result2, k)
				else
					local template = item.template

					local robloxComponent = if fFlagSduiErrorPaths then item.robloxComponent else nil
					local v12 = if fFlagSduiErrorPaths then item.identifier else nil
					local v13 = buildConfigForComponent(
						template,
						v7,
						p3,
						p4,
						nil,
						v8,
						nil,
						robloxComponent,
						v12
					)

					if v13 and SduiPropUtils.isComponentVisible(v13, p6) then
						if v6 then
							local v14 = callback2(item, p6)

							if v14 ~= nil then
								for k2, v15 in v14 do
									v13[k2] = v15
								end
							end
						end

						table.insert(result, v13)
						table.insert(result2, k)
					end
				end
			end
		end

		return result, result2
	end
}
