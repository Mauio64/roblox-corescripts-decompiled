local HttpService = game:GetService("HttpService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local getProtoVariableMapper = require(SduiSharedUtilitiesParent.SduiCoreSystem).getProtoVariableMapper

require(SduiSharedUtilities.SduiIntegrationTypes)

local FFlagSduiUniversalPageEntry = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUniversalPageEntry
local FFlagSduiHydrationDataCamelCaseTopLevelKeys = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiHydrationDataCamelCaseTopLevelKeys
local FFlagSduiHydrationDataCamelCasePropertyKeys = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiHydrationDataCamelCasePropertyKeys
local FFlagEnableHomepagePromptsForModalsAndBanners = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = require(SduiSharedUtilitiesParent.SharedFlags).FFlagPromptsHandlerEnabled
local FFlagSduiPageEntrySurfacing = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntrySurfacing
local FFlagSduiClientTemplateCache = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiClientTemplateCache

local function decodeProto(p1, p2) -- line: 27
	local v17 = if typeof(p2) ~= "string" then p2 else buffer.fromstring(p2)

	return p1.decode(v17)
end
local function decodeProtobufJson(p3, p4) -- line: 39
	-- upvalues: HttpService (copy)
	local v20 = if typeof(p4) ~= "buffer" then p4 else buffer.tostring(p4)

	return p3.jsonDecode(HttpService:JSONDecode(v20))
end
local function parseSurfacing(p5) -- line: 71
	-- upvalues: getProtoVariableMapper (copy)
	if not p5 or not p5.kind then
		return nil
	end

	local kind = p5.kind

	if kind.type == nil or kind.value == nil then
		return nil
	end

	local v25 = getProtoVariableMapper()

	return {
		[v25.mapPropName(kind.type)] = v25.camelCaseKeys(kind.value)
	}
end

return {
	decodeProto = decodeProto,
	decodeProtobufJson = decodeProtobufJson,
	makeProtoResponseDecoder = function(p6) -- line: 47
		-- upvalues: decodeProto (copy)
		return function(p7) -- line: 48
			-- upvalues: decodeProto (copy), p6 (copy)
			return decodeProto(p6, p7)
		end
	end,
	makeProtobufJsonResponseDecoder = function(p8) -- line: 56
		-- upvalues: decodeProtobufJson (copy)
		return function(p9) -- line: 57
			-- upvalues: decodeProtobufJson (copy), p8 (copy)
			return decodeProtobufJson(p8, p9)
		end
	end,
	parsePageEntriesFromResponse = function(p10) -- line: 88
		-- upvalues: FFlagSduiUniversalPageEntry (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagPromptsHandlerEnabled (copy), FFlagSduiPageEntrySurfacing (copy), parseSurfacing (copy)
		local t1 = {}

		if p10.page_entries then
			for _, v29 in p10.page_entries do
				local roblox_component = v29.page_entry.roblox_component
				local v31 = if not FFlagSduiUniversalPageEntry then v29.kind and v29.kind.value else v29.input_data and (v29.input_data.kind and v29.input_data.kind.value)
				local identifier = v29.page_entry.identifier
				local title = v29.page_entry.title
				local v34 = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else v29.page_entry.category
				local v35 = if not FFlagSduiPageEntrySurfacing then nil else parseSurfacing(v29.page_entry.surfacing)

				table.insert(t1, {
					robloxComponentType = roblox_component,
					identifier = if identifier == "" then nil else identifier,
					componentInputData = v31,
					title = title,
					category = if v34 == nil or v34 == "" then nil else v34,
					surfacing = v35
				})
			end
		end

		return t1
	end,
	parseHydrationDataFromResponse = function(t2: {[any]: any}) -- line: 122
		-- upvalues: FFlagSduiHydrationDataCamelCasePropertyKeys (copy), getProtoVariableMapper (copy), FFlagSduiHydrationDataCamelCaseTopLevelKeys (copy)
		local hydration_data = t2.hydration_data

		if hydration_data then
			for _, v39 in hydration_data do
				for _, v41 in v39 do
					if FFlagSduiHydrationDataCamelCasePropertyKeys then
						local t3 = {}

						for v43, v44 in v41 do
							t3[getProtoVariableMapper().mapPropName(v43)] = v44
						end

						for v45, v46 in t3 do
							v41[v45] = v46
						end
					else
						for v47, v48 in v41 do
							v41[getProtoVariableMapper().mapPropName(v47)] = v48
						end
					end
				end
			end

			if FFlagSduiHydrationDataCamelCaseTopLevelKeys then
				local v49 = getProtoVariableMapper()
				local t4 = {}

				for v51, v52 in hydration_data do
					if v52 then
						t4[v49.mapPropName(v51)] = v52
					end
				end

				for v53, v54 in t4 do
					hydration_data[v53] = v54
				end
			end
		end

		return hydration_data
	end,
	parseLocalizedLiteralsFromResponse = function(t5: {[any]: any}) -- line: 171
		if t5.localized_literals then
			return t5.localized_literals
		end

		return nil
	end,
	parseTemplateEntriesFromResponse = function(t6: {[any]: any}, b1: boolean?) -- line: 186
		-- upvalues: FFlagSduiClientTemplateCache (copy)
		local t7 = {}
		local t8 = {}
		local t9 = {}

		if t6.templates then
			for v61, v62 in t6.templates do
				t8[v62.roblox_component] = v62.template

				if FFlagSduiClientTemplateCache and b1 then
					t9[v62.roblox_component] = v61
				end

				t7[v61] = v62.template
			end
		end

		return t7, t8, t9
	end
}
