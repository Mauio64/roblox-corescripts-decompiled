local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.ServiceContractsProto)

local SduiActionType = require(SduiCoreSystem.SduiActionType)
local SduiComponentType = require(SduiCoreSystem.SduiComponentType)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiDataBinderTransformUtils = require(SduiCoreSystem.ClientBinding.SduiDataBinderTransformUtils)
local snakeToCamel = SduiDataBinderTransformUtils.snakeToCamel

local v = {
	AUTOMATIC_SIZE_XY = "XY",
	SIZE_CONSTRAINT_RELATIVE_XY = "RelativeXY",
	SIZE_CONSTRAINT_RELATIVE_XX = "RelativeXX",
	SIZE_CONSTRAINT_RELATIVE_YY = "RelativeYY"
}

local v2 = {}

local function convertToLuaEnum(value, p: string, flag: boolean?)
	local v3 = string.match(value, "^" .. p .. "(.*)")

	if not v3 then
		return value
	end

	local v4 = v3:lower():gsub("_(%l)", function(value2)
		return value2:upper()
	end)

	if flag then
		return v4:gsub("^%l", string.upper)
	end

	return v4
end

local function mapProtoEnumFormatToLua(p, p2: string, flag: boolean?) -- 3 equivalent calls inferred from this helper
	local v3 = v[p]

	if not v3 then
		v3 = convertToLuaEnum(p, p2, flag)
		v[p] = v3
	end

	return v3
end

local ProtoVariableMapper = {}
ProtoVariableMapper.mapProtoEnumFormatToLua = mapProtoEnumFormatToLua

function ProtoVariableMapper.mapLuaEnumFormatToProto(value: string, p: string, p2)
	local v3 = p .. value
	local v4 = v2[v3]

	if v4 == false then
		return nil
	end

	if v4 ~= nil then
		return v4
	end

	local v5 = p .. string.upper((value:gsub("(%l)(%u)", "%1_%2")))
	local v6 = p2.fromName(v5)
	v2[v3] = v6 or false
	return v6
end

function ProtoVariableMapper.mapUiComponentTypeToLua(p)
	if p == nil then
		return nil
	end

	local v3 = mapProtoEnumFormatToLua(p, "UI_COMPONENT_TYPE_", true) -- inferred equivalent call

	if SduiComponentType[v3] then
		return SduiComponentType[v3]
	end

	return nil
end

function ProtoVariableMapper.mapHydrationContentTypeToLua(value)
	if value == nil then
		return nil
	end

	local v3 = v[value]

	if not v3 then
		local v4 = string.match(value, "^HYDRATION_CONTENT_TYPE_(.*)")

		if v4 then
			v3 = v4:lower():gsub("_(%l)", function(value2)
				return value2:upper()
			end)
		else
			v3 = value
		end

		v[value] = v3
	end

	if SduiDataBindingContentType[v3] then
		return SduiDataBindingContentType[v3]
	end

	return nil
end

function ProtoVariableMapper.mapActionTypeToLua(p)
	if p == nil then
		return nil
	end

	local v3 = mapProtoEnumFormatToLua(p, "ACTION_TYPE_", true) -- inferred equivalent call

	if SduiActionType[v3] then
		return SduiActionType[v3]
	end

	return nil
end

function ProtoVariableMapper.mapPropName(value)
	if value == nil then
		return nil
	end

	if typeof(value) == "number" then
		return value
	end

	local v3 = v[value]

	if not v3 then
		v3 = snakeToCamel(value)
		v[value] = v3
	end

	return v3
end

function ProtoVariableMapper.camelCaseKeys(items)
	if type(items) ~= "table" then
		return items
	end

	local result = {}

	for k, item in items do
		local v3

		if type(k) == "string" then
			if k ~= nil then
				if typeof(k) == "number" then
					v3 = k
				else
					v3 = v[k]

					if not v3 then
						v3 = snakeToCamel(k)
						v[k] = v3
					end
				end
			end
		else
			v3 = k
		end

		result[v3] = item
	end

	return result
end

function ProtoVariableMapper.mapProtoEngineEnumToLua(p: string, p2: string, callback)
	if p == nil then
		return nil
	end

	local v3 = mapProtoEnumFormatToLua(p, p2, true) -- inferred equivalent call

	if v3 then
		return callback(v3)
	end

	return nil
end

return ProtoVariableMapper
