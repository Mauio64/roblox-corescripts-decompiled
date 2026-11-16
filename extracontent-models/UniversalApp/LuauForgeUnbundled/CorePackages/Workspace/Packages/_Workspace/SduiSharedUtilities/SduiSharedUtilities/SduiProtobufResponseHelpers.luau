local HttpService = game:GetService("HttpService")

local getProtoVariableMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getProtoVariableMapper

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local fFlagSduiHydrationDataCamelCasePropertyKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiHydrationDataCamelCasePropertyKeys

local fFlagEnableHomepagePromptsForModalsAndBanners = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagEnableHomepagePromptsForModalsAndBanners
local fFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagPromptsHandlerEnabled
local fFlagSduiSandboxContentInputData = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagSduiSandboxContentInputData

local function decodeProto(p2, str)
	if typeof(str) == "string" then
		str = buffer.fromstring(str)
	end

	return p2.decode(str)
end

local function decodeProtobufJson(p2, p3)
	if typeof(p3) == "buffer" then
		p3 = buffer.tostring(p3)
	end

	return p2.jsonDecode(HttpService:JSONDecode(p3))
end

local function parseSurfacing(surfacing)
	if not (surfacing and surfacing.kind) then
		return nil
	end

	local kind = surfacing.kind

	if kind.type == nil or kind.value == nil then
		return nil
	end

	local protoVariableMapper = getProtoVariableMapper()
	return {
		[protoVariableMapper.mapPropName(kind.type)] = protoVariableMapper.camelCaseKeys(kind.value)
	}
end

local unwrapSandboxStruct
local function unwrapSandboxValue(field)
	if typeof(field) ~= "table" or typeof(field.kind) ~= "table" then
		return field
	end

	local kind = field.kind

	if kind.type == "null_value" then
		return nil
	end

	if kind.type == "struct_value" then
		return unwrapSandboxStruct(kind.value)
	end

	if kind.type ~= "list_value" then
		return kind.value
	end

	local result = {}

	for k, v5 in (typeof(kind.value) ~= "table" or typeof(kind.value.values) ~= "table") and {} or kind.value.values do
		result[k] = unwrapSandboxValue(v5)
	end

	return result
end

unwrapSandboxStruct = function(value)
	if typeof(value) ~= "table" or typeof(value.fields) ~= "table" then
		return value
	end

	local result = {}

	for k, field in value.fields do
		result[k] = unwrapSandboxValue(field)
	end

	return result
end

return {
	decodeProto = decodeProto,
	decodeProtobufJson = decodeProtobufJson,
	makeProtoResponseDecoder = function(p2)
		return function(p3)
			return decodeProto(p2, p3)
		end
	end,
	makeProtobufJsonResponseDecoder = function(p2)
		return function(p3)
			return decodeProtobufJson(p2, p3)
		end
	end,
	parsePageEntriesFromResponse = function(p2)
		local pageEntriesFromResponse = {}

		if not p2.page_entries then
			return pageEntriesFromResponse
		end

		for k, page_entry in p2.page_entries do
			local roblox_component = page_entry.page_entry.roblox_component
			local v5 = page_entry.input_data
				and page_entry.input_data.kind
				and page_entry.input_data.kind.value

			if fFlagSduiSandboxContentInputData then
				local kind = page_entry.input_data and page_entry.input_data.kind

				if kind and kind.type == "sandbox_content" then
					v5 = unwrapSandboxStruct(kind.value)
				end
			end

			local identifier = page_entry.page_entry.identifier
			local title = page_entry.page_entry.title
			local category

			if fFlagEnableHomepagePromptsForModalsAndBanners or fFlagPromptsHandlerEnabled then
				category = page_entry.page_entry.category
			end

			local v6 = parseSurfacing(page_entry.page_entry.surfacing)

			if identifier == "" then
				identifier = nil
			end

			if category == nil or category == "" then
				category = nil
			end

			table.insert(pageEntriesFromResponse, {
				robloxComponentType = roblox_component,
				identifier = identifier,
				componentInputData = v5,
				title = title,
				category = category,
				surfacing = v6
			})
		end

		return pageEntriesFromResponse
	end,
	parseHydrationDataFromResponse = function(p2)
		local hydration_data = p2.hydration_data

		if not hydration_data then
			return hydration_data
		end

		for k, v5 in hydration_data do
			for k2, v6 in v5 do
				if fFlagSduiHydrationDataCamelCasePropertyKeys then
					local v7 = {}

					for k3, v8 in v6 do
						v7[getProtoVariableMapper().mapPropName(k3)] = v8
					end

					for k3, v8 in v7 do
						v6[k3] = v8
					end
				else
					for k3, v7 in v6 do
						v6[getProtoVariableMapper().mapPropName(k3)] = v7
					end
				end
			end
		end

		local protoVariableMapper = getProtoVariableMapper()
		local v5 = {}

		for k, v6 in hydration_data do
			if v6 then
				v5[protoVariableMapper.mapPropName(k)] = v6
			end
		end

		for k, v6 in v5 do
			hydration_data[k] = v6
		end

		return hydration_data
	end,
	parseLocalizedLiteralsFromResponse = function(p2)
		if p2.localized_literals then
			return p2.localized_literals
		end

		return nil
	end,
	parseTemplateEntriesFromResponse = function(p2, p3)
		local templates = {}
		local templatesByRoblox_component = {}
		local result = {}

		if not p2.templates then
			return templates, templatesByRoblox_component, result
		end

		for k, template in p2.templates do
			templatesByRoblox_component[template.roblox_component] = template.template

			if p3 then
				result[template.roblox_component] = k
			end

			templates[k] = template.template
		end

		return templates, templatesByRoblox_component, result
	end
}
