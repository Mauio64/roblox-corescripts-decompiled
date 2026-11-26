require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")

local SduiActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
local SduiComponentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
local SduiDataBindingContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")
local snakeToCamel = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBinderTransformUtils").snakeToCamel

local v5 = {
	AUTOMATIC_SIZE_XY = "XY",
	SIZE_CONSTRAINT_RELATIVE_XY = "RelativeXY",
	SIZE_CONSTRAINT_RELATIVE_XX = "RelativeXX",
	SIZE_CONSTRAINT_RELATIVE_YY = "RelativeYY"
}

local v6 = {}

local function convertToLuaEnum(value, p2, p3)
	local v7 = string.match(value, "^" .. p2 .. "(.*)")

	if not v7 then
		return value
	end

	local v8 = v7:lower():gsub("_(%l)", function(value2)
		return value2:upper()
	end)

	if p3 then
		return v8:gsub("^%l", string.upper)
	end

	return v8
end

return {
	mapProtoEnumFormatToLua = function(p2, p3, p4)
		local v7 = v5[p2]

		if not v7 then
			v7 = convertToLuaEnum(p2, p3, p4)
			v5[p2] = v7
		end

		return v7
	end,
	mapLuaEnumFormatToProto = function(value, p2, p3)
		local v7 = p2 .. value
		local v8 = v6[v7]

		if v8 == false then
			return nil
		end

		if v8 ~= nil then
			return v8
		end

		local v9 = p2 .. string.upper((value:gsub("(%l)(%u)", "%1_%2")))
		local v10 = p3.fromName(v9)
		v6[v7] = v10 or false
		return v10
	end,
	mapUiComponentTypeToLua = function(p2)
		if p2 == nil then
			return nil
		end

		local v7 = v5[p2]

		if not v7 then
			v7 = convertToLuaEnum(p2, "UI_COMPONENT_TYPE_", true)
			v5[p2] = v7
		end

		if SduiComponentType[v7] then
			return SduiComponentType[v7]
		end

		return nil
	end,
	mapHydrationContentTypeToLua = function(value)
		if value == nil then
			return nil
		end

		local v7 = v5[value]

		if not v7 then
			local v8 = string.match(value, "^HYDRATION_CONTENT_TYPE_(.*)")

			if v8 then
				v7 = v8:lower():gsub("_(%l)", function(value2)
					return value2:upper()
				end)
			else
				v7 = value
			end

			v5[value] = v7
		end

		if SduiDataBindingContentType[v7] then
			return SduiDataBindingContentType[v7]
		end

		return nil
	end,
	mapActionTypeToLua = function(p2)
		if p2 == nil then
			return nil
		end

		local v7 = v5[p2]

		if not v7 then
			v7 = convertToLuaEnum(p2, "ACTION_TYPE_", true)
			v5[p2] = v7
		end

		if SduiActionType[v7] then
			return SduiActionType[v7]
		end

		return nil
	end,
	mapPropName = function(value)
		if value == nil then
			return nil
		end

		if typeof(value) == "number" then
			return value
		end

		local v7 = v5[value]

		if not v7 then
			v7 = snakeToCamel(value)
			v5[value] = v7
		end

		return v7
	end,
	camelCaseKeys = function(items)
		if type(items) ~= "table" then
			return items
		end

		local result = {}

		for k, item in items do
			local v7

			if type(k) == "string" then
				if k ~= nil then
					if typeof(k) == "number" then
						v7 = k
					else
						v7 = v5[k]

						if not v7 then
							v7 = snakeToCamel(k)
							v5[k] = v7
						end
					end
				end
			else
				v7 = k
			end

			result[v7] = item
		end

		return result
	end,
	mapProtoEngineEnumToLua = function(p2, p3, callback)
		if p2 == nil then
			return nil
		end

		local v7 = v5[p2]

		if not v7 then
			v7 = convertToLuaEnum(p2, p3, true)
			v5[p2] = v7
		end

		if v7 then
			return callback(v7)
		end

		return nil
	end
}
