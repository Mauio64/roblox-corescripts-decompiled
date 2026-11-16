local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "comparison" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "is_null" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "is_not_null" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "and_condition" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "or_condition" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "is_empty" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "is_not_empty" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "contains" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local result = class.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "comparison",
					value = v.ComparisonCondition.decode(v5)
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "is_null", value = v.IsNullCondition.decode(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "is_not_null",
					value = v.IsNotNullCondition.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "and_condition", value = v.AndCondition.decode(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "or_condition", value = v.OrCondition.decode(v5) }
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "is_empty", value = v.IsEmptyCondition.decode(v5) }
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "is_not_empty",
					value = v.IsNotEmptyCondition.decode(v5)
				}
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "contains", value = v.ContainsCondition.decode(v5) }
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "comparison" then
		v2.comparison = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "is_null" then
		v2.isNull = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "is_not_null" then
		v2.isNotNull = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "and_condition" then
		v2.andCondition = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "or_condition" then
		v2.orCondition = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "is_empty" then
		v2.isEmpty = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "is_not_empty" then
		v2.isNotEmpty = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "contains" then
		v2.contains = self.kind.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.comparison ~= nil then
		v2.kind = {
			type = "comparison",
			value = v.ComparisonCondition.jsonDecode(data.comparison)
		}
	end

	if data.is_null ~= nil then
		v2.kind = {
			type = "is_null",
			value = v.IsNullCondition.jsonDecode(data.is_null)
		}
	end

	if data.isNull ~= nil then
		v2.kind = {
			type = "is_null",
			value = v.IsNullCondition.jsonDecode(data.isNull)
		}
	end

	if data.is_not_null ~= nil then
		v2.kind = {
			type = "is_not_null",
			value = v.IsNotNullCondition.jsonDecode(data.is_not_null)
		}
	end

	if data.isNotNull ~= nil then
		v2.kind = {
			type = "is_not_null",
			value = v.IsNotNullCondition.jsonDecode(data.isNotNull)
		}
	end

	if data.and_condition ~= nil then
		v2.kind = {
			type = "and_condition",
			value = v.AndCondition.jsonDecode(data.and_condition)
		}
	end

	if data.andCondition ~= nil then
		v2.kind = {
			type = "and_condition",
			value = v.AndCondition.jsonDecode(data.andCondition)
		}
	end

	if data.or_condition ~= nil then
		v2.kind = {
			type = "or_condition",
			value = v.OrCondition.jsonDecode(data.or_condition)
		}
	end

	if data.orCondition ~= nil then
		v2.kind = {
			type = "or_condition",
			value = v.OrCondition.jsonDecode(data.orCondition)
		}
	end

	if data.is_empty ~= nil then
		v2.kind = {
			type = "is_empty",
			value = v.IsEmptyCondition.jsonDecode(data.is_empty)
		}
	end

	if data.isEmpty ~= nil then
		v2.kind = {
			type = "is_empty",
			value = v.IsEmptyCondition.jsonDecode(data.isEmpty)
		}
	end

	if data.is_not_empty ~= nil then
		v2.kind = {
			type = "is_not_empty",
			value = v.IsNotEmptyCondition.jsonDecode(data.is_not_empty)
		}
	end

	if data.isNotEmpty ~= nil then
		v2.kind = {
			type = "is_not_empty",
			value = v.IsNotEmptyCondition.jsonDecode(data.isNotEmpty)
		}
	end

	if data.contains ~= nil then
		v2.kind = {
			type = "contains",
			value = v.ContainsCondition.jsonDecode(data.contains)
		}
	end

	return v2
end

class.descriptor = {
	name = "PropCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.PropCondition"
}

v.PropCondition = class

typeRegistry.default:register(v.PropCondition)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		field = (data == nil or data.field == nil) and "" or data.field,
		op = 0,
		kind = 0
	}
	local op

	if data == nil or data.op == nil then
		op = assert(v.ComparisonCondition_Op.fromNumber(0), "Enum has no 0 default")
	else
		op = data.op
	end

	v2.op = op
	local kind

	if not (data == nil or data.kind == nil) then
		kind = data.kind
	end

	v2.kind = kind
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	if self.op ~= nil and (self.op ~= nil and self.op ~= 0 or self.op ~= v.ComparisonCondition_Op.fromNumber(0)) then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.ComparisonCondition_Op.toNumber(self.op))
	end

	if self.kind ~= nil then
		if self.kind.type == "string_value" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "bool_value" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value and 1 or 0)
		elseif self.kind.type == "int32_value" then
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "int64_value" then
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "float_value" then
			local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.i32)
			v2, v3 = proto.writeFloat(v4, v5, self.kind.value)
		elseif self.kind.type == "double_value" then
			local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.i64)
			v2, v3 = proto.writeDouble(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path_value" then
			local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.op = v.ComparisonCondition_Op.fromNumber(v5) or v5
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.kind = {
					type = "bool_value",
					value = v5 ~= 0
				}
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = { type = "int32_value", value = v5 }
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readVarIntI64(buf, v2)
				result.kind = { type = "int64_value", value = v5 }
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "string_value", value = buffer.tostring(v5) }
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path_value", value = buffer.tostring(v5) }
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 7 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.kind = { type = "float_value", value = v5 }
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			if v3 == 8 then
				local v5
				v5, v2 = proto.readDouble(buf, v2)
				result.kind = { type = "double_value", value = v5 }
			else
				local _
				_, v2 = proto.readFixed64(buf, v2)
			end
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class2:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	if self.op ~= nil and (self.op ~= nil and self.op ~= 0 or self.op ~= v.ComparisonCondition_Op.fromNumber(0)) then
		local op

		if typeof(self.op) == "number" then
			op = self.op
		else
			op = v.ComparisonCondition_Op.toNumber(self.op)
		end

		v2.op = op
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "string_value" then
		v2.stringValue = self.kind.value
		return v2
	end

	if self.kind.type == "bool_value" then
		v2.boolValue = self.kind.value
		return v2
	end

	if self.kind.type == "int32_value" then
		v2.int32Value = self.kind.value
		return v2
	end

	if self.kind.type == "int64_value" then
		v2.int64Value = self.kind.value
		return v2
	end

	if self.kind.type == "float_value" then
		v2.floatValue = proto.json.serializeNumber(self.kind.value)
		return v2
	end

	if self.kind.type == "double_value" then
		v2.doubleValue = proto.json.serializeNumber(self.kind.value)
		return v2
	elseif self.kind.type == "binding_path_value" then
		v2.bindingPathValue = self.kind.value
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.field ~= nil then
		v2.field = data.field
	end

	if data.op ~= nil then
		local op

		if typeof(data.op) == "number" then
			op = v.ComparisonCondition_Op.fromNumber(data.op) or data.op
		else
			op = v.ComparisonCondition_Op.fromName(data.op) or data.op
		end

		v2.op = op
	end

	if data.string_value ~= nil then
		v2.kind = { type = "string_value", value = data.string_value }
	end

	if data.stringValue ~= nil then
		v2.kind = { type = "string_value", value = data.stringValue }
	end

	if data.bool_value ~= nil then
		v2.kind = { type = "bool_value", value = data.bool_value }
	end

	if data.boolValue ~= nil then
		v2.kind = { type = "bool_value", value = data.boolValue }
	end

	if data.int32_value ~= nil then
		v2.kind = { type = "int32_value", value = data.int32_value }
	end

	if data.int32Value ~= nil then
		v2.kind = { type = "int32_value", value = data.int32Value }
	end

	if data.int64_value ~= nil then
		v2.kind = { type = "int64_value", value = data.int64_value }
	end

	if data.int64Value ~= nil then
		v2.kind = { type = "int64_value", value = data.int64Value }
	end

	if data.float_value ~= nil then
		v2.kind = {
			type = "float_value",
			value = proto.json.deserializeNumber(data.float_value)
		}
	end

	if data.floatValue ~= nil then
		v2.kind = {
			type = "float_value",
			value = proto.json.deserializeNumber(data.floatValue)
		}
	end

	if data.double_value ~= nil then
		v2.kind = {
			type = "double_value",
			value = proto.json.deserializeNumber(data.double_value)
		}
	end

	if data.doubleValue ~= nil then
		v2.kind = {
			type = "double_value",
			value = proto.json.deserializeNumber(data.doubleValue)
		}
	end

	if data.binding_path_value ~= nil then
		v2.kind = { type = "binding_path_value", value = data.binding_path_value }
	end

	if data.bindingPathValue ~= nil then
		v2.kind = { type = "binding_path_value", value = data.bindingPathValue }
	end

	return v2
end

class2.descriptor = {
	name = "ComparisonCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.ComparisonCondition"
}

v.ComparisonCondition = class2

typeRegistry.default:register(v.ComparisonCondition)

v.ComparisonCondition_Op = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "OP_INVALID"
		elseif p == 1 then
			return "OP_LT"
		elseif p == 2 then
			return "OP_LTE"
		elseif p == 3 then
			return "OP_GT"
		elseif p == 4 then
			return "OP_GTE"
		elseif p == 5 then
			return "OP_E"
		elseif p == 6 then
			return "OP_NE"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "OP_INVALID" then
			return 0
		elseif p == "OP_LT" then
			return 1
		elseif p == "OP_LTE" then
			return 2
		elseif p == "OP_GT" then
			return 3
		elseif p == "OP_GTE" then
			return 4
		elseif p == "OP_E" then
			return 5
		elseif p == "OP_NE" then
			return 6
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "OP_INVALID" then
			return "OP_INVALID"
		elseif p == "OP_LT" then
			return "OP_LT"
		elseif p == "OP_LTE" then
			return "OP_LTE"
		elseif p == "OP_GT" then
			return "OP_GT"
		elseif p == "OP_GTE" then
			return "OP_GTE"
		elseif p == "OP_E" then
			return "OP_E"
		elseif p == "OP_NE" then
			return "OP_NE"
		end

		return nil
	end
}

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({
		field = (p == nil or p.field == nil) and "" or p.field
	}, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class3:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.field ~= nil then
		v2.field = p.field
	end

	return v2
end

class3.descriptor = {
	name = "IsNullCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNullCondition"
}

v.IsNullCondition = class3

typeRegistry.default:register(v.IsNullCondition)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		field = (p == nil or p.field == nil) and "" or p.field
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class4:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.field ~= nil then
		v2.field = p.field
	end

	return v2
end

class4.descriptor = {
	name = "IsNotNullCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNotNullCondition"
}

v.IsNotNullCondition = class4

typeRegistry.default:register(v.IsNotNullCondition)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		field = (p == nil or p.field == nil) and "" or p.field
	}, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class5:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.field ~= nil then
		v2.field = p.field
	end

	return v2
end

class5.descriptor = {
	name = "IsEmptyCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsEmptyCondition"
}

v.IsEmptyCondition = class5

typeRegistry.default:register(v.IsEmptyCondition)

local class6 = {}
class6.__index = class6

function class6.new(p)
	return (setmetatable({
		field = (p == nil or p.field == nil) and "" or p.field
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class6:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.field ~= nil then
		v2.field = p.field
	end

	return v2
end

class6.descriptor = {
	name = "IsNotEmptyCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNotEmptyCondition"
}

v.IsNotEmptyCondition = class6

typeRegistry.default:register(v.IsNotEmptyCondition)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local v2 = {
		field = (p == nil or p.field == nil) and "" or p.field,
		kind = 0
	}
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	v2.kind = kind
	return (setmetatable(v2, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.field ~= nil and self.field ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.field)
	end

	if self.kind ~= nil then
		if self.kind.type == "string_value" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path_value" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local result = class7.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "string_value", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path_value", value = buffer.tostring(v5) }
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class7:jsonEncode()
	local v2 = {}

	if self.field ~= nil and self.field ~= "" then
		v2.field = self.field
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "string_value" then
		v2.stringValue = self.kind.value
		return v2
	elseif self.kind.type == "binding_path_value" then
		v2.bindingPathValue = self.kind.value
	end

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.field ~= nil then
		v2.field = data.field
	end

	if data.string_value ~= nil then
		v2.kind = { type = "string_value", value = data.string_value }
	end

	if data.stringValue ~= nil then
		v2.kind = { type = "string_value", value = data.stringValue }
	end

	if data.binding_path_value ~= nil then
		v2.kind = { type = "binding_path_value", value = data.binding_path_value }
	end

	if data.bindingPathValue ~= nil then
		v2.kind = { type = "binding_path_value", value = data.bindingPathValue }
	end

	return v2
end

class7.descriptor = {
	name = "ContainsCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.ContainsCondition"
}

v.ContainsCondition = class7

typeRegistry.default:register(v.ContainsCondition)

local class8 = {}
class8.__index = class8

function class8.new(p)
	return (setmetatable({
		conditions = (p == nil or p.conditions == nil) and {} or p.conditions
	}, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.conditions ~= nil and #self.conditions > 0 then
		for _, condition in self.conditions do
			local encoded = condition:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local v2 = class8.new()
	local v3 = 0

	while v3 < buffer.len(buf) do
		local v4, v5
		v4, v5, v3 = proto.readTag(buf, v3)

		if v5 == proto.wireTypes.varint then
			local _
			_, v3 = proto.readVarInt(buf, v3)
		elseif v5 == proto.wireTypes.lengthDelimited then
			if v4 == 1 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)
				table.insert(v2.conditions, v.PropCondition.decode(v6))
			else
				local varInt, v6 = proto.readVarInt(buf, v3)

				v3 = v6 + varInt
			end
		elseif v5 == proto.wireTypes.i32 then
			local _
			_, v3 = proto.readFixed32(buf, v3)
		elseif v5 == proto.wireTypes.i64 then
			local _
			_, v3 = proto.readFixed64(buf, v3)
		else
			error("Unsupported wire type: " .. v5)
		end
	end

	return v2
end

function class8:jsonEncode()
	local v2 = {}

	if self.conditions == nil or not (#self.conditions > 0) then
		return v2
	end

	local conditions = {}

	for _, condition in self.conditions do
		table.insert(conditions, condition:jsonEncode())
	end

	v2.conditions = conditions

	return v2
end

function class8.jsonDecode(p)
	local v2 = class8.new()

	if p.conditions == nil then
		return v2
	end

	local conditions = {}

	for _, condition in p.conditions do
		table.insert(conditions, v.PropCondition.jsonDecode(condition))
	end

	v2.conditions = conditions

	return v2
end

class8.descriptor = {
	name = "AndCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.AndCondition"
}

v.AndCondition = class8

typeRegistry.default:register(v.AndCondition)

local class9 = {}
class9.__index = class9

function class9.new(p)
	return (setmetatable({
		conditions = (p == nil or p.conditions == nil) and {} or p.conditions
	}, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.conditions ~= nil and #self.conditions > 0 then
		for _, condition in self.conditions do
			local encoded = condition:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class9.decode(buf: buffer)
	local v2 = class9.new()
	local v3 = 0

	while v3 < buffer.len(buf) do
		local v4, v5
		v4, v5, v3 = proto.readTag(buf, v3)

		if v5 == proto.wireTypes.varint then
			local _
			_, v3 = proto.readVarInt(buf, v3)
		elseif v5 == proto.wireTypes.lengthDelimited then
			if v4 == 1 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)
				table.insert(v2.conditions, v.PropCondition.decode(v6))
			else
				local varInt, v6 = proto.readVarInt(buf, v3)

				v3 = v6 + varInt
			end
		elseif v5 == proto.wireTypes.i32 then
			local _
			_, v3 = proto.readFixed32(buf, v3)
		elseif v5 == proto.wireTypes.i64 then
			local _
			_, v3 = proto.readFixed64(buf, v3)
		else
			error("Unsupported wire type: " .. v5)
		end
	end

	return v2
end

function class9:jsonEncode()
	local v2 = {}

	if self.conditions == nil or not (#self.conditions > 0) then
		return v2
	end

	local conditions = {}

	for _, condition in self.conditions do
		table.insert(conditions, condition:jsonEncode())
	end

	v2.conditions = conditions

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.conditions == nil then
		return v2
	end

	local conditions = {}

	for _, condition in p.conditions do
		table.insert(conditions, v.PropCondition.jsonDecode(condition))
	end

	v2.conditions = conditions

	return v2
end

class9.descriptor = {
	name = "OrCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.OrCondition"
}

v.OrCondition = class9

typeRegistry.default:register(v.OrCondition)

return {
	PropCondition = v.PropCondition,
	ComparisonCondition = v.ComparisonCondition,
	ComparisonCondition_Op = v.ComparisonCondition_Op,
	IsNullCondition = v.IsNullCondition,
	IsNotNullCondition = v.IsNotNullCondition,
	IsEmptyCondition = v.IsEmptyCondition,
	IsNotEmptyCondition = v.IsNotEmptyCondition,
	ContainsCondition = v.ContainsCondition,
	AndCondition = v.AndCondition,
	OrCondition = v.OrCondition
}
