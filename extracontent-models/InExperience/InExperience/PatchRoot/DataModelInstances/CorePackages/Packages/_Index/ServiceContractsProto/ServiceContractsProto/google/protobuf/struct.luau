local proto = require(script.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		fields = (p == nil or p.fields == nil) and {} or p.fields
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.fields ~= nil and next(self.fields) ~= nil then
		for k, field in self.fields do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local encoded = field:encode()
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeBuffer(v8, v9, encoded, buffer.len(encoded))
			local v12, v13 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local v2 = class.new()
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

				local decoded = v.Struct_FieldsEntry.decode(v6)

				local value = v.Value.new()

				v2.fields[decoded.key or ""] = decoded.value or value
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

function class.jsonEncode(p)
	local result = {}

	for k, field in p.fields do
		result[k] = v.Value.jsonEncode(field)
	end

	return result
end

function class.jsonDecode(items)
	local fields = {}

	for k, item in items do
		fields[k] = v.Value.jsonDecode(item)
	end

	return class.new({ fields = fields })
end

class.descriptor = { name = "Struct", fullName = "google.protobuf.Struct" }

v.Struct = class

typeRegistry.default:register(v.Struct)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = v.Value.decode(v5)
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

function class2.jsonEncode(p)
	local v2 = {}

	if p.key ~= nil and p.key ~= "" then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = v.Value.jsonDecode(p.value)
	end

	return v2
end

class2.descriptor = { name = "Struct_FieldsEntry", fullName = "google.protobuf.FieldsEntry" }

v.Struct_FieldsEntry = class2

typeRegistry.default:register(v.Struct_FieldsEntry)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "null_value" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.NullValue.toNumber(self.kind.value))
		elseif self.kind.type == "number_value" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i64)
			v2, v3 = proto.writeDouble(v4, v5, self.kind.value)
		elseif self.kind.type == "string_value" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "bool_value" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value and 1 or 0)
		elseif self.kind.type == "struct_value" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "list_value" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "null_value",
					value = v.NullValue.fromNumber(v5) or v5
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.kind = {
					type = "bool_value",
					value = v5 ~= 0
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "string_value", value = buffer.tostring(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "struct_value", value = v.Struct.decode(v5) }
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "list_value", value = v.ListValue.decode(v5) }
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readDouble(buf, v2)
				result.kind = { type = "number_value", value = v5 }
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

function class3.jsonEncode(p)
	local kind = p.kind

	if kind == nil or kind.type == "null_value" then
		return nil
	end

	if kind.type == "number_value" or kind.type == "string_value" or kind.type == "bool_value" then
		return kind.value
	end

	if kind.type == "list_value" then
		return v.ListValue.jsonEncode(kind.value)
	end

	if kind.type == "struct_value" then
		return v.Struct.jsonEncode(kind.value)
	end

	return kind.type
end

function class3.jsonDecode(value)
	if value == nil then
		return class3.new({
			kind = { type = "null_value", value = "NULL_VALUE" }
		})
	end

	if typeof(value) == "number" then
		return class3.new({
			kind = { type = "number_value", value = value }
		})
	end

	if typeof(value) == "string" then
		return class3.new({
			kind = { type = "string_value", value = value }
		})
	end

	if typeof(value) == "boolean" then
		return class3.new({
			kind = { type = "bool_value", value = value }
		})
	end

	if typeof(value) ~= "table" then
		error(`Unknown input type: {typeof(value)}`)

		return
	end

	local count = 0

	for _ in value do
		count += 1

		if #value < count then
			break
		end
	end

	if count == #value then
		return class3.new({
			kind = { type = "list_value", value = v.ListValue.jsonDecode(value) }
		})
	end

	return class3.new({
		kind = { type = "struct_value", value = v.Struct.jsonDecode(value) }
	})
end

class3.descriptor = { name = "Value", fullName = "google.protobuf.Value" }

v.Value = class3

typeRegistry.default:register(v.Value)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		values = (p == nil or p.values == nil) and {} or p.values
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.values ~= nil and #self.values > 0 then
		for _, value in self.values do
			local encoded = value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local v2 = class4.new()
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
				table.insert(v2.values, v.Value.decode(v6))
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

function class4.jsonEncode(p)
	local result = {}

	for _, value in p.values do
		table.insert(result, v.Value.jsonEncode(value))
	end

	return result
end

function class4.jsonDecode(items)
	local values = {}

	for _, item in items do
		table.insert(values, v.Value.jsonDecode(item))
	end

	return class4.new({ values = values })
end

class4.descriptor = { name = "ListValue", fullName = "google.protobuf.ListValue" }

v.ListValue = class4

typeRegistry.default:register(v.ListValue)

v.NullValue = {
	fromNumber = function(p: number): nil | string
		return if p == 0 then "NULL_VALUE" else nil
	end,
	toNumber = function(p)
		return if p == "NULL_VALUE" then 0 else p
	end,
	fromName = function(p: string): nil | string
		return if p == "NULL_VALUE" then "NULL_VALUE" else nil
	end
}

return { Struct = v.Struct, Value = v.Value, ListValue = v.ListValue, NullValue = v.NullValue }
