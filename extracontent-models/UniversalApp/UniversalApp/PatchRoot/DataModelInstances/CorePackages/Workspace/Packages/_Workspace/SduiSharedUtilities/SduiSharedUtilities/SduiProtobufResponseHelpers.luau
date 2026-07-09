local HttpService = game:GetService("HttpService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local getProtoVariableMapper = require(SduiSharedUtilitiesParent.SduiCoreSystem).getProtoVariableMapper

require(SduiSharedUtilities.SduiIntegrationTypes)

local FFlagSduiUniversalPageEntry = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiUniversalPageEntry
local FFlagSduiHydrationDataCamelCaseTopLevelKeys = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiHydrationDataCamelCaseTopLevelKeys
local FFlagSduiHydrationDataCamelCasePropertyKeys = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiHydrationDataCamelCasePropertyKeys
local FFlagSduiLocalizedLiterals = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagEnableHomepagePromptsForModalsAndBanners = require(SduiSharedUtilitiesParent.SharedFlags).FFlagEnableHomepagePromptsForModalsAndBanners
local FFlagPromptsHandlerEnabled = require(SduiSharedUtilitiesParent.SharedFlags).FFlagPromptsHandlerEnabled
local FFlagSduiPageEntrySurfacing = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiPageEntrySurfacing
local FFlagSduiClientTemplateCache = require(SduiSharedUtilitiesParent.SharedFlags).FFlagSduiClientTemplateCache

local function decodeProto(p1, p2) -- line: 28
	local v18 = if typeof(p2) ~= "string" then p2 else buffer.fromstring(p2)

	return p1.decode(v18)
end
local function decodeProtobufJson(p3, p4) -- line: 40
	-- upvalues: HttpService (copy)
	local v21 = if typeof(p4) ~= "buffer" then p4 else buffer.tostring(p4)

	return p3.jsonDecode(HttpService:JSONDecode(v21))
end
local function parseSurfacing(p5) -- line: 72
	-- upvalues: getProtoVariableMapper (copy)
	if not p5 or not p5.kind then
		return nil
	end

	local kind = p5.kind

	if kind.type == nil or kind.value == nil then
		return nil
	end

	local v26 = getProtoVariableMapper()

	return {
		[v26.mapPropName(kind.type)] = v26.camelCaseKeys(kind.value)
	}
end

return {
	decodeProto = decodeProto,
	decodeProtobufJson = decodeProtobufJson,
	makeProtoResponseDecoder = function(p6) -- line: 48
		-- upvalues: decodeProto (copy)
		return function(p7) -- line: 49
			-- upvalues: decodeProto (copy), p6 (copy)
			return decodeProto(p6, p7)
		end
	end,
	makeProtobufJsonResponseDecoder = function(p8) -- line: 57
		-- upvalues: decodeProtobufJson (copy)
		return function(p9) -- line: 58
			-- upvalues: decodeProtobufJson (copy), p8 (copy)
			return decodeProtobufJson(p8, p9)
		end
	end,
	parsePageEntriesFromResponse = function(p10) -- line: 89
		-- upvalues: FFlagSduiUniversalPageEntry (copy), FFlagEnableHomepagePromptsForModalsAndBanners (copy), FFlagPromptsHandlerEnabled (copy), FFlagSduiPageEntrySurfacing (copy), parseSurfacing (copy)
		local t1 = {}

		if p10.page_entries then
			for _, v30 in p10.page_entries do
				local roblox_component = v30.page_entry.roblox_component
				local v32 = if not FFlagSduiUniversalPageEntry then v30.kind and v30.kind.value else v30.input_data and (v30.input_data.kind and v30.input_data.kind.value)
				local identifier = v30.page_entry.identifier
				local title = v30.page_entry.title
				local v35 = if not FFlagEnableHomepagePromptsForModalsAndBanners and not FFlagPromptsHandlerEnabled then nil else v30.page_entry.category
				local v36 = if not FFlagSduiPageEntrySurfacing then nil else parseSurfacing(v30.page_entry.surfacing)

				table.insert(t1, {
					robloxComponentType = roblox_component,
					identifier = if identifier == "" then nil else identifier,
					componentInputData = v32,
					title = title,
					category = if v35 == nil or v35 == "" then nil else v35,
					surfacing = v36
				})
			end
		end

		return t1
	end,
	parseHydrationDataFromResponse = function(t2: {[any]: any}) -- line: 123
		-- upvalues: FFlagSduiHydrationDataCamelCasePropertyKeys (copy), getProtoVariableMapper (copy), FFlagSduiHydrationDataCamelCaseTopLevelKeys (copy)
		local hydration_data = t2.hydration_data

		if hydration_data then
			for _, v40 in hydration_data do
				for _, v42 in v40 do
					if FFlagSduiHydrationDataCamelCasePropertyKeys then
						local t3 = {}

						for v44, v45 in v42 do
							t3[getProtoVariableMapper().mapPropName(v44)] = v45
						end

						for v46, v47 in t3 do
							v42[v46] = v47
						end
					else
						for v48, v49 in v42 do
							v42[getProtoVariableMapper().mapPropName(v48)] = v49
						end
					end
				end
			end

			if FFlagSduiHydrationDataCamelCaseTopLevelKeys then
				local v50 = getProtoVariableMapper()
				local t4 = {}

				for v52, v53 in hydration_data do
					if v53 then
						t4[v50.mapPropName(v52)] = v53
					end
				end

				for v54, v55 in t4 do
					hydration_data[v54] = v55
				end
			end
		end

		return hydration_data
	end,
	parseLocalizedLiteralsFromResponse = function(t5: {[any]: any}) -- line: 172
		-- upvalues: FFlagSduiLocalizedLiterals (copy)
		if FFlagSduiLocalizedLiterals and t5.localized_literals then
			return t5.localized_literals
		end

		return nil
	end,
	parseTemplateEntriesFromResponse = function(t6: {[any]: any}, b1: boolean?) -- line: 187
		-- upvalues: FFlagSduiClientTemplateCache (copy)
		local t7 = {}
		local t8 = {}
		local t9 = {}

		if t6.templates then
			for v62, v63 in t6.templates do
				t8[v63.roblox_component] = v63.template

				if FFlagSduiClientTemplateCache and b1 then
					t9[v63.roblox_component] = v62
				end

				t7[v62] = v63.template
			end
		end

		return t7, t8, t9
	end
}
