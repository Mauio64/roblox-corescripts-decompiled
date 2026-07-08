local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local SduiActionType = require(SduiCoreSystem.SduiActionType)
local SduiComponentType = require(SduiCoreSystem.SduiComponentType)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local snakeToCamel = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils).snakeToCamel
local t1 = {
	AUTOMATIC_SIZE_XY = "XY",
	SIZE_CONSTRAINT_RELATIVE_XY = "RelativeXY",
	SIZE_CONSTRAINT_RELATIVE_XX = "RelativeXX",
	SIZE_CONSTRAINT_RELATIVE_YY = "RelativeYY"
}

local function convertToLuaEnum(p1, s1: string, b1: boolean?) -- line: 48
	local match = string.match(p1, "^" .. s1 .. "(.*)")

	if not match then
		return p1
	end

	local v13 = match:lower():gsub("_(%l)", function(p2) -- line: 62
		return p2:upper()
	end)

	if b1 then
		return v13:gsub("^%l", string.upper)
	end

	return v13
end

return {
	mapProtoEnumFormatToLua = function(p3, s2: string, b2: boolean?) -- line: 80
		-- upvalues: t1 (copy), convertToLuaEnum (copy)
		local v17 = t1[p3]

		if not v17 then
			v17 = convertToLuaEnum(p3, s2, b2)
			t1[p3] = v17
		end

		return v17
	end,
	mapUiComponentTypeToLua = function(p4) -- line: 114
		-- upvalues: t1 (copy), convertToLuaEnum (copy), SduiComponentType (copy)
		if p4 == nil then
			return nil
		end

		local v23 = t1[p4]

		if not v23 then
			v23 = convertToLuaEnum(p4, "UI_COMPONENT_TYPE_", true)
			t1[p4] = v23
		end

		if SduiComponentType[v23] then
			return SduiComponentType[v23]
		end

		return nil
	end,
	mapHydrationContentTypeToLua = function(p5) -- line: 148
		-- upvalues: t1 (copy), SduiDataBindingContentType (copy)
		if p5 == nil then
			return nil
		end

		local v27 = t1[p5]

		if not v27 then
			local match = string.match(p5, "^HYDRATION_CONTENT_TYPE_(.*)")

			v27 = if match then match:lower():gsub("_(%l)", function(p6) -- line: 62
				return p6:upper()
			end) else p5
			t1[p5] = v27
		end

		if SduiDataBindingContentType[v27] then
			return SduiDataBindingContentType[v27]
		end

		return nil
	end,
	mapActionTypeToLua = function(p7) -- line: 131
		-- upvalues: t1 (copy), convertToLuaEnum (copy), SduiActionType (copy)
		if p7 == nil then
			return nil
		end

		local v25 = t1[p7]

		if not v25 then
			v25 = convertToLuaEnum(p7, "ACTION_TYPE_", true)
			t1[p7] = v25
		end

		if SduiActionType[v25] then
			return SduiActionType[v25]
		end

		return nil
	end,
	mapPropName = function(p8) -- line: 168
		-- upvalues: t1 (copy), snakeToCamel (copy)
		if p8 == nil then
			return nil
		end

		if typeof(p8) == "number" then
			return p8
		end

		local v30 = t1[p8]

		if not v30 then
			v30 = snakeToCamel(p8)
			t1[p8] = v30
		end

		return v30
	end,
	camelCaseKeys = function(p9) -- line: 189
		-- upvalues: t1 (copy), snakeToCamel (copy)
		if type(p9) ~= "table" then
			return p9
		end

		local t2 = {}

		for v33, v34 in p9 do
			local v35

			if type(v33) == "string" then
				if v33 == nil then
					v35 = nil
				elseif typeof(v33) == "number" then
					v35 = v33
				else
					v35 = t1[v33]

					if not v35 then
						v35 = snakeToCamel(v33)
						t1[v33] = v35
					end
				end
			else
				v35 = v33
			end

			t2[v35] = v34
		end

		return t2
	end,
	mapProtoEngineEnumToLua = function(s3: string, s4: string, p10: ((...any) -> ...any)) -- line: 93
		-- upvalues: t1 (copy), convertToLuaEnum (copy)
		if s3 == nil then
			return nil
		end

		local v21 = t1[s3]

		if not v21 then
			v21 = convertToLuaEnum(s3, s4, true)
			t1[s3] = v21
		end

		if v21 then
			return p10(v21)
		end

		return nil
	end
}
