local HttpService = game:GetService("HttpService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)

local getProtoVariableMapper = SduiCoreSystem.getProtoVariableMapper

require(SduiSharedUtilities.SduiIntegrationTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiHydrationDataCamelCasePropertyKeys = SharedFlags.FFlagSduiHydrationDataCamelCasePropertyKeys

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableHomepagePromptsForModalsAndBanners = SharedFlags2.FFlagEnableHomepagePromptsForModalsAndBanners
local SharedFlags3 = require(parent.SharedFlags)
local FFlagPromptsHandlerEnabled = SharedFlags3.FFlagPromptsHandlerEnabled
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiSandboxContentInputData = SharedFlags4.FFlagSduiSandboxContentInputData

local function decodeProto(p, str)
	if typeof(str) == "string" then
		str = buffer.fromstring(str)
	end

	return p.decode(str)
end

local function decodeProtobufJson(p, p2)
	if typeof(p2) == "buffer" then
		p2 = buffer.tostring(p2)
	end

	return p.jsonDecode(HttpService:JSONDecode(p2))
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

	for k, v in (typeof(kind.value) ~= "table" or typeof(kind.value.values) ~= "table") and {} or kind.value.values do
		result[k] = unwrapSandboxValue(v)
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

local SduiProtobufResponseHelpers = {}
SduiProtobufResponseHelpers.decodeProto = decodeProto
SduiProtobufResponseHelpers.decodeProtobufJson = decodeProtobufJson

function SduiProtobufResponseHelpers.makeProtoResponseDecoder(p)
	return function(p2)
		return decodeProto(p, p2)
	end
end

function SduiProtobufResponseHelpers.makeProtobufJsonResponseDecoder(p)
	return function(p2)
		return decodeProtobufJson(p, p2)
	end
end

function SduiProtobufResponseHelpers.parsePageEntriesFromResponse(p)
	local pageEntriesFromResponse = {}

	if not p.page_entries then
		return pageEntriesFromResponse
	end

	for _, page_entry in p.page_entries do
		local roblox_component = page_entry.page_entry.roblox_component
		local componentInputData = page_entry.input_data
			and page_entry.input_data.kind
			and page_entry.input_data.kind.value

		if FFlagSduiSandboxContentInputData then
			local kind = page_entry.input_data and page_entry.input_data.kind

			if kind and kind.type == "sandbox_content" then
				componentInputData = unwrapSandboxStruct(kind.value)
			end
		end

		local identifier = page_entry.page_entry.identifier
		local title = page_entry.page_entry.title
		local category

		if FFlagEnableHomepagePromptsForModalsAndBanners or FFlagPromptsHandlerEnabled then
			category = page_entry.page_entry.category
		end

		local surfacing = parseSurfacing(page_entry.page_entry.surfacing)

		if identifier == "" then
			identifier = nil
		end

		if category == nil or category == "" then
			category = nil
		end

		table.insert(pageEntriesFromResponse, {
			robloxComponentType = roblox_component,
			identifier = identifier,
			componentInputData = componentInputData,
			title = title,
			category = category,
			surfacing = surfacing
		})
	end

	return pageEntriesFromResponse
end

function SduiProtobufResponseHelpers.parseHydrationDataFromResponse(p)
	local hydration_data = p.hydration_data

	if not hydration_data then
		return hydration_data
	end

	for _, v in hydration_data do
		for _, v2 in v do
			if FFlagSduiHydrationDataCamelCasePropertyKeys then
				local v3 = {}

				for k, v4 in v2 do
					v3[getProtoVariableMapper().mapPropName(k)] = v4
				end

				for k, v4 in v3 do
					v2[k] = v4
				end
			else
				for k, v3 in v2 do
					v2[getProtoVariableMapper().mapPropName(k)] = v3
				end
			end
		end
	end

	local protoVariableMapper = getProtoVariableMapper()
	local v = {}

	for k, v2 in hydration_data do
		if v2 then
			v[protoVariableMapper.mapPropName(k)] = v2
		end
	end

	for k, v2 in v do
		hydration_data[k] = v2
	end

	return hydration_data
end

function SduiProtobufResponseHelpers.parseLocalizedLiteralsFromResponse(p)
	return if p.localized_literals then p.localized_literals else nil
end

function SduiProtobufResponseHelpers.parseTemplateEntriesFromResponse(p, flag: boolean?)
	local templates = {}
	local templatesByRoblox_component = {}
	local result = {}

	if not p.templates then
		return templates, templatesByRoblox_component, result
	end

	for k, template in p.templates do
		templatesByRoblox_component[template.roblox_component] = template.template

		if flag then
			result[template.roblox_component] = k
		end

		templates[k] = template.template
	end

	return templates, templatesByRoblox_component, result
end

return SduiProtobufResponseHelpers
