local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local prop_condition = require(script.Parent.prop_condition)

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
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.AutomaticSize.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.AutomaticSize.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.AutomaticSizeProp_ConditionalOptions.decode(v5)
				}
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

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.AutomaticSize.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.AutomaticSize.fromNumber(data.literal) or data.literal
		else
			v3 = v.AutomaticSize.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.AutomaticSizeProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class.descriptor = {
	name = "AutomaticSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AutomaticSizeProp"
}

v.AutomaticSizeProp = class

typeRegistry.default:register(v.AutomaticSizeProp)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.AutomaticSize.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
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
				result.kind = {
					type = "literal",
					value = v.AutomaticSize.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class2:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.AutomaticSize.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.AutomaticSize.fromNumber(data.literal) or data.literal
		else
			v3 = v.AutomaticSize.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class2.descriptor = {
	name = "AutomaticSizeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.AutomaticSizeProp_ConditionalOption = class2

typeRegistry.default:register(v.AutomaticSizeProp_ConditionalOption)

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local v2 = class3.new()
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
				table.insert(v2.options, v.AutomaticSizeProp_ConditionalOption.decode(v6))
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

function class3:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.AutomaticSizeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class3.descriptor = {
	name = "AutomaticSizeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.AutomaticSizeProp_ConditionalOptions = class3

typeRegistry.default:register(v.AutomaticSizeProp_ConditionalOptions)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextTruncate.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextTruncate.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.TextTruncateProp_ConditionalOptions.decode(v5)
				}
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

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextTruncate.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextTruncate.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextTruncate.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.TextTruncateProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class4.descriptor = {
	name = "TextTruncateProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextTruncateProp"
}

v.TextTruncateProp = class4

typeRegistry.default:register(v.TextTruncateProp)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextTruncate.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
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
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextTruncate.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextTruncate.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextTruncate.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextTruncate.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class5.descriptor = {
	name = "TextTruncateProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.TextTruncateProp_ConditionalOption = class5

typeRegistry.default:register(v.TextTruncateProp_ConditionalOption)

local class6 = {}
class6.__index = class6

function class6.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local v2 = class6.new()
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
				table.insert(v2.options, v.TextTruncateProp_ConditionalOption.decode(v6))
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

function class6:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.TextTruncateProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class6.descriptor = {
	name = "TextTruncateProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.TextTruncateProp_ConditionalOptions = class6

typeRegistry.default:register(v.TextTruncateProp_ConditionalOptions)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextXAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextXAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.TextXAlignmentProp_ConditionalOptions.decode(v5)
				}
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

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextXAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextXAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextXAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.TextXAlignmentProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class7.descriptor = {
	name = "TextXAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextXAlignmentProp"
}

v.TextXAlignmentProp = class7

typeRegistry.default:register(v.TextXAlignmentProp)

local class8 = {}
class8.__index = class8

function class8.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextXAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local result = class8.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextXAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class8:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextXAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextXAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextXAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class8.descriptor = {
	name = "TextXAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.TextXAlignmentProp_ConditionalOption = class8

typeRegistry.default:register(v.TextXAlignmentProp_ConditionalOption)

local class9 = {}
class9.__index = class9

function class9.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
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
				table.insert(v2.options, v.TextXAlignmentProp_ConditionalOption.decode(v6))
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

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.TextXAlignmentProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class9.descriptor = {
	name = "TextXAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.TextXAlignmentProp_ConditionalOptions = class9

typeRegistry.default:register(v.TextXAlignmentProp_ConditionalOptions)

local class10 = {}
class10.__index = class10

function class10.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class10))
end

function class10:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextYAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class10.decode(buf: buffer)
	local result = class10.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextYAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.TextYAlignmentProp_ConditionalOptions.decode(v5)
				}
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

function class10:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextYAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class10.jsonDecode(data)
	local v2 = class10.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextYAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextYAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.TextYAlignmentProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class10.descriptor = {
	name = "TextYAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextYAlignmentProp"
}

v.TextYAlignmentProp = class10

typeRegistry.default:register(v.TextYAlignmentProp)

local class11 = {}
class11.__index = class11

function class11.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class11))
end

function class11:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.TextYAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class11.decode(buf: buffer)
	local result = class11.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.TextYAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class11:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.TextYAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class11.jsonDecode(data)
	local v2 = class11.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.TextYAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.TextYAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class11.descriptor = {
	name = "TextYAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.TextYAlignmentProp_ConditionalOption = class11

typeRegistry.default:register(v.TextYAlignmentProp_ConditionalOption)

local class12 = {}
class12.__index = class12

function class12.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class12))
end

function class12:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class12.decode(buf: buffer)
	local v2 = class12.new()
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
				table.insert(v2.options, v.TextYAlignmentProp_ConditionalOption.decode(v6))
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

function class12:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class12.jsonDecode(p)
	local v2 = class12.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.TextYAlignmentProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class12.descriptor = {
	name = "TextYAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.TextYAlignmentProp_ConditionalOptions = class12

typeRegistry.default:register(v.TextYAlignmentProp_ConditionalOptions)

local class13 = {}
class13.__index = class13

function class13.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class13))
end

function class13:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.UIFlexMode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class13.decode(buf: buffer)
	local result = class13.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.UIFlexMode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UIFlexModeProp_ConditionalOptions.decode(v5)
				}
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

function class13:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.UIFlexMode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class13.jsonDecode(data)
	local v2 = class13.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.UIFlexMode.fromNumber(data.literal) or data.literal
		else
			v3 = v.UIFlexMode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UIFlexModeProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class13.descriptor = {
	name = "UIFlexModeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UIFlexModeProp"
}

v.UIFlexModeProp = class13

typeRegistry.default:register(v.UIFlexModeProp)

local class14 = {}
class14.__index = class14

function class14.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class14))
end

function class14:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.UIFlexMode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class14.decode(buf: buffer)
	local result = class14.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.UIFlexMode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class14:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.UIFlexMode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class14.jsonDecode(data)
	local v2 = class14.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.UIFlexMode.fromNumber(data.literal) or data.literal
		else
			v3 = v.UIFlexMode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class14.descriptor = {
	name = "UIFlexModeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UIFlexModeProp_ConditionalOption = class14

typeRegistry.default:register(v.UIFlexModeProp_ConditionalOption)

local class15 = {}
class15.__index = class15

function class15.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class15))
end

function class15:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class15.decode(buf: buffer)
	local v2 = class15.new()
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
				table.insert(v2.options, v.UIFlexModeProp_ConditionalOption.decode(v6))
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

function class15:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class15.jsonDecode(p)
	local v2 = class15.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UIFlexModeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class15.descriptor = {
	name = "UIFlexModeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UIFlexModeProp_ConditionalOptions = class15

typeRegistry.default:register(v.UIFlexModeProp_ConditionalOptions)

local class16 = {}
class16.__index = class16

function class16.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class16))
end

function class16:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.ScaleType.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class16.decode(buf: buffer)
	local result = class16.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ScaleType.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ScaleTypeProp_ConditionalOptions.decode(v5)
				}
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

function class16:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.ScaleType.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class16.jsonDecode(data)
	local v2 = class16.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ScaleType.fromNumber(data.literal) or data.literal
		else
			v3 = v.ScaleType.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ScaleTypeProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class16.descriptor = {
	name = "ScaleTypeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ScaleTypeProp"
}

v.ScaleTypeProp = class16

typeRegistry.default:register(v.ScaleTypeProp)

local class17 = {}
class17.__index = class17

function class17.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class17))
end

function class17:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.ScaleType.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class17.decode(buf: buffer)
	local result = class17.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ScaleType.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class17:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.ScaleType.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class17.jsonDecode(data)
	local v2 = class17.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ScaleType.fromNumber(data.literal) or data.literal
		else
			v3 = v.ScaleType.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class17.descriptor = {
	name = "ScaleTypeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ScaleTypeProp_ConditionalOption = class17

typeRegistry.default:register(v.ScaleTypeProp_ConditionalOption)

local class18 = {}
class18.__index = class18

function class18.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class18))
end

function class18:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class18.decode(buf: buffer)
	local v2 = class18.new()
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
				table.insert(v2.options, v.ScaleTypeProp_ConditionalOption.decode(v6))
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

function class18:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class18.jsonDecode(p)
	local v2 = class18.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ScaleTypeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class18.descriptor = {
	name = "ScaleTypeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ScaleTypeProp_ConditionalOptions = class18

typeRegistry.default:register(v.ScaleTypeProp_ConditionalOptions)

local class19 = {}
class19.__index = class19

function class19.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class19))
end

function class19:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.ResamplerMode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class19.decode(buf: buffer)
	local result = class19.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ResamplerMode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ResamplerModeProp_ConditionalOptions.decode(v5)
				}
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

function class19:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.ResamplerMode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class19.jsonDecode(data)
	local v2 = class19.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ResamplerMode.fromNumber(data.literal) or data.literal
		else
			v3 = v.ResamplerMode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ResamplerModeProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class19.descriptor = {
	name = "ResamplerModeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ResamplerModeProp"
}

v.ResamplerModeProp = class19

typeRegistry.default:register(v.ResamplerModeProp)

local class20 = {}
class20.__index = class20

function class20.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class20))
end

function class20:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.ResamplerMode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class20.decode(buf: buffer)
	local result = class20.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ResamplerMode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class20:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.ResamplerMode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class20.jsonDecode(data)
	local v2 = class20.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ResamplerMode.fromNumber(data.literal) or data.literal
		else
			v3 = v.ResamplerMode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class20.descriptor = {
	name = "ResamplerModeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ResamplerModeProp_ConditionalOption = class20

typeRegistry.default:register(v.ResamplerModeProp_ConditionalOption)

local class21 = {}
class21.__index = class21

function class21.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class21))
end

function class21:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class21.decode(buf: buffer)
	local v2 = class21.new()
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
				table.insert(v2.options, v.ResamplerModeProp_ConditionalOption.decode(v6))
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

function class21:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class21.jsonDecode(p)
	local v2 = class21.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ResamplerModeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class21.descriptor = {
	name = "ResamplerModeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ResamplerModeProp_ConditionalOptions = class21

typeRegistry.default:register(v.ResamplerModeProp_ConditionalOptions)

local class22 = {}
class22.__index = class22

function class22.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class22))
end

function class22:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.SizeConstraint.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class22.decode(buf: buffer)
	local result = class22.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.SizeConstraint.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.SizeConstraintProp_ConditionalOptions.decode(v5)
				}
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

function class22:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.SizeConstraint.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class22.jsonDecode(data)
	local v2 = class22.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.SizeConstraint.fromNumber(data.literal) or data.literal
		else
			v3 = v.SizeConstraint.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.SizeConstraintProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class22.descriptor = {
	name = "SizeConstraintProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.SizeConstraintProp"
}

v.SizeConstraintProp = class22

typeRegistry.default:register(v.SizeConstraintProp)

local class23 = {}
class23.__index = class23

function class23.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class23))
end

function class23:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.SizeConstraint.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class23.decode(buf: buffer)
	local result = class23.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.SizeConstraint.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class23:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.SizeConstraint.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class23.jsonDecode(data)
	local v2 = class23.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.SizeConstraint.fromNumber(data.literal) or data.literal
		else
			v3 = v.SizeConstraint.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class23.descriptor = {
	name = "SizeConstraintProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.SizeConstraintProp_ConditionalOption = class23

typeRegistry.default:register(v.SizeConstraintProp_ConditionalOption)

local class24 = {}
class24.__index = class24

function class24.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class24))
end

function class24:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class24.decode(buf: buffer)
	local v2 = class24.new()
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
				table.insert(v2.options, v.SizeConstraintProp_ConditionalOption.decode(v6))
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

function class24:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class24.jsonDecode(p)
	local v2 = class24.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.SizeConstraintProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class24.descriptor = {
	name = "SizeConstraintProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.SizeConstraintProp_ConditionalOptions = class24

typeRegistry.default:register(v.SizeConstraintProp_ConditionalOptions)

local class25 = {}
class25.__index = class25

function class25.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class25))
end

function class25:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.HorizontalAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class25.decode(buf: buffer)
	local result = class25.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.HorizontalAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.HorizontalAlignmentProp_ConditionalOptions.decode(v5)
				}
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

function class25:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.HorizontalAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class25.jsonDecode(data)
	local v2 = class25.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.HorizontalAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.HorizontalAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.HorizontalAlignmentProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class25.descriptor = {
	name = "HorizontalAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.HorizontalAlignmentProp"
}

v.HorizontalAlignmentProp = class25

typeRegistry.default:register(v.HorizontalAlignmentProp)

local class26 = {}
class26.__index = class26

function class26.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class26))
end

function class26:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.HorizontalAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class26.decode(buf: buffer)
	local result = class26.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.HorizontalAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class26:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.HorizontalAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class26.jsonDecode(data)
	local v2 = class26.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.HorizontalAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.HorizontalAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class26.descriptor = {
	name = "HorizontalAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.HorizontalAlignmentProp_ConditionalOption = class26

typeRegistry.default:register(v.HorizontalAlignmentProp_ConditionalOption)

local class27 = {}
class27.__index = class27

function class27.new(p)
	return (setmetatable({
		option = (p == nil or p.option == nil) and {} or p.option
	}, class27))
end

function class27:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.option ~= nil and #self.option > 0 then
		for _, v4 in self.option do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class27.decode(buf: buffer)
	local v2 = class27.new()
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
				table.insert(v2.option, v.HorizontalAlignmentProp_ConditionalOption.decode(v6))
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

function class27:jsonEncode()
	local v2 = {}

	if self.option == nil or not (#self.option > 0) then
		return v2
	end

	local option = {}

	for _, v3 in self.option do
		table.insert(option, v3:jsonEncode())
	end

	v2.option = option

	return v2
end

function class27.jsonDecode(p)
	local v2 = class27.new()

	if p.option == nil then
		return v2
	end

	local option = {}

	for _, v3 in p.option do
		table.insert(option, v.HorizontalAlignmentProp_ConditionalOption.jsonDecode(v3))
	end

	v2.option = option

	return v2
end

class27.descriptor = {
	name = "HorizontalAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.HorizontalAlignmentProp_ConditionalOptions = class27

typeRegistry.default:register(v.HorizontalAlignmentProp_ConditionalOptions)

local class28 = {}
class28.__index = class28

function class28.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class28))
end

function class28:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.SelectionBehavior.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class28.decode(buf: buffer)
	local result = class28.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.SelectionBehavior.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.SelectionBehaviorProp_ConditionalOptions.decode(v5)
				}
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

function class28:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.SelectionBehavior.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class28.jsonDecode(data)
	local v2 = class28.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.SelectionBehavior.fromNumber(data.literal) or data.literal
		else
			v3 = v.SelectionBehavior.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.SelectionBehaviorProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class28.descriptor = {
	name = "SelectionBehaviorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectionBehaviorProp"
}

v.SelectionBehaviorProp = class28

typeRegistry.default:register(v.SelectionBehaviorProp)

local class29 = {}
class29.__index = class29

function class29.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class29))
end

function class29:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.SelectionBehavior.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class29.decode(buf: buffer)
	local result = class29.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.SelectionBehavior.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class29:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.SelectionBehavior.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class29.jsonDecode(data)
	local v2 = class29.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.SelectionBehavior.fromNumber(data.literal) or data.literal
		else
			v3 = v.SelectionBehavior.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class29.descriptor = {
	name = "SelectionBehaviorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.SelectionBehaviorProp_ConditionalOption = class29

typeRegistry.default:register(v.SelectionBehaviorProp_ConditionalOption)

local class30 = {}
class30.__index = class30

function class30.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class30))
end

function class30:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class30.decode(buf: buffer)
	local v2 = class30.new()
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
				table.insert(v2.options, v.SelectionBehaviorProp_ConditionalOption.decode(v6))
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

function class30:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class30.jsonDecode(p)
	local v2 = class30.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.SelectionBehaviorProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class30.descriptor = {
	name = "SelectionBehaviorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.SelectionBehaviorProp_ConditionalOptions = class30

typeRegistry.default:register(v.SelectionBehaviorProp_ConditionalOptions)

local class31 = {}
class31.__index = class31

function class31.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class31))
end

function class31:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.KeyCode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class31.decode(buf: buffer)
	local result = class31.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.KeyCode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.KeyCodeProp_ConditionalOptions.decode(v5)
				}
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

function class31:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.KeyCode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class31.jsonDecode(data)
	local v2 = class31.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.KeyCode.fromNumber(data.literal) or data.literal
		else
			v3 = v.KeyCode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.KeyCodeProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class31.descriptor = {
	name = "KeyCodeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeyCodeProp"
}

v.KeyCodeProp = class31

typeRegistry.default:register(v.KeyCodeProp)

local class32 = {}
class32.__index = class32

function class32.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class32))
end

function class32:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.KeyCode.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class32.decode(buf: buffer)
	local result = class32.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.KeyCode.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class32:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.KeyCode.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class32.jsonDecode(data)
	local v2 = class32.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.KeyCode.fromNumber(data.literal) or data.literal
		else
			v3 = v.KeyCode.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class32.descriptor = {
	name = "KeyCodeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.KeyCodeProp_ConditionalOption = class32

typeRegistry.default:register(v.KeyCodeProp_ConditionalOption)

local class33 = {}
class33.__index = class33

function class33.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class33))
end

function class33:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.options ~= nil and #self.options > 0 then
		for _, option in self.options do
			local encoded = option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class33.decode(buf: buffer)
	local v2 = class33.new()
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
				table.insert(v2.options, v.KeyCodeProp_ConditionalOption.decode(v6))
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

function class33:jsonEncode()
	local v2 = {}

	if self.options == nil or not (#self.options > 0) then
		return v2
	end

	local options = {}

	for _, option in self.options do
		table.insert(options, option:jsonEncode())
	end

	v2.options = options

	return v2
end

function class33.jsonDecode(p)
	local v2 = class33.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.KeyCodeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class33.descriptor = {
	name = "KeyCodeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.KeyCodeProp_ConditionalOptions = class33

typeRegistry.default:register(v.KeyCodeProp_ConditionalOptions)

local class34 = {}
class34.__index = class34

function class34.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class34))
end

function class34:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.VerticalAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class34.decode(buf: buffer)
	local result = class34.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.VerticalAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.VerticalAlignmentProp_ConditionalOptions.decode(v5)
				}
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

function class34:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.VerticalAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class34.jsonDecode(data)
	local v2 = class34.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.VerticalAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.VerticalAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.VerticalAlignmentProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class34.descriptor = {
	name = "VerticalAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalAlignmentProp"
}

v.VerticalAlignmentProp = class34

typeRegistry.default:register(v.VerticalAlignmentProp)

local class35 = {}
class35.__index = class35

function class35.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class35))
end

function class35:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.VerticalAlignment.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class35.decode(buf: buffer)
	local result = class35.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = {
					type = "literal",
					value = v.VerticalAlignment.fromNumber(v5) or v5
				}
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
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

function class35:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.VerticalAlignment.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class35.jsonDecode(data)
	local v2 = class35.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.VerticalAlignment.fromNumber(data.literal) or data.literal
		else
			v3 = v.VerticalAlignment.fromName(data.literal) or data.literal
		end

		v2.kind = { type = "literal", value = v3 }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class35.descriptor = {
	name = "VerticalAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.VerticalAlignmentProp_ConditionalOption = class35

typeRegistry.default:register(v.VerticalAlignmentProp_ConditionalOption)

local class36 = {}
class36.__index = class36

function class36.new(p)
	return (setmetatable({
		option = (p == nil or p.option == nil) and {} or p.option
	}, class36))
end

function class36:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.option ~= nil and #self.option > 0 then
		for _, v4 in self.option do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class36.decode(buf: buffer)
	local v2 = class36.new()
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
				table.insert(v2.option, v.VerticalAlignmentProp_ConditionalOption.decode(v6))
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

function class36:jsonEncode()
	local v2 = {}

	if self.option == nil or not (#self.option > 0) then
		return v2
	end

	local option = {}

	for _, v3 in self.option do
		table.insert(option, v3:jsonEncode())
	end

	v2.option = option

	return v2
end

function class36.jsonDecode(p)
	local v2 = class36.new()

	if p.option == nil then
		return v2
	end

	local option = {}

	for _, v3 in p.option do
		table.insert(option, v.VerticalAlignmentProp_ConditionalOption.jsonDecode(v3))
	end

	v2.option = option

	return v2
end

class36.descriptor = {
	name = "VerticalAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.VerticalAlignmentProp_ConditionalOptions = class36

typeRegistry.default:register(v.VerticalAlignmentProp_ConditionalOptions)

v.AutomaticSize = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "AUTOMATIC_SIZE_INVALID"
		elseif p == 1 then
			return "AUTOMATIC_SIZE_NONE"
		elseif p == 2 then
			return "AUTOMATIC_SIZE_X"
		elseif p == 3 then
			return "AUTOMATIC_SIZE_Y"
		elseif p == 4 then
			return "AUTOMATIC_SIZE_XY"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "AUTOMATIC_SIZE_INVALID" then
			return 0
		elseif p == "AUTOMATIC_SIZE_NONE" then
			return 1
		elseif p == "AUTOMATIC_SIZE_X" then
			return 2
		elseif p == "AUTOMATIC_SIZE_Y" then
			return 3
		elseif p == "AUTOMATIC_SIZE_XY" then
			return 4
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "AUTOMATIC_SIZE_INVALID" then
			return "AUTOMATIC_SIZE_INVALID"
		elseif p == "AUTOMATIC_SIZE_NONE" then
			return "AUTOMATIC_SIZE_NONE"
		elseif p == "AUTOMATIC_SIZE_X" then
			return "AUTOMATIC_SIZE_X"
		elseif p == "AUTOMATIC_SIZE_Y" then
			return "AUTOMATIC_SIZE_Y"
		elseif p == "AUTOMATIC_SIZE_XY" then
			return "AUTOMATIC_SIZE_XY"
		end

		return nil
	end
}

v.TextTruncate = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TEXT_TRUNCATE_INVALID"
		elseif p == 1 then
			return "TEXT_TRUNCATE_NONE"
		elseif p == 2 then
			return "TEXT_TRUNCATE_AT_END"
		elseif p == 3 then
			return "TEXT_TRUNCATE_SPLIT_WORD"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TEXT_TRUNCATE_INVALID" then
			return 0
		elseif p == "TEXT_TRUNCATE_NONE" then
			return 1
		elseif p == "TEXT_TRUNCATE_AT_END" then
			return 2
		elseif p == "TEXT_TRUNCATE_SPLIT_WORD" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TEXT_TRUNCATE_INVALID" then
			return "TEXT_TRUNCATE_INVALID"
		elseif p == "TEXT_TRUNCATE_NONE" then
			return "TEXT_TRUNCATE_NONE"
		elseif p == "TEXT_TRUNCATE_AT_END" then
			return "TEXT_TRUNCATE_AT_END"
		elseif p == "TEXT_TRUNCATE_SPLIT_WORD" then
			return "TEXT_TRUNCATE_SPLIT_WORD"
		end

		return nil
	end
}

v.TextXAlignment = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TEXT_X_ALIGNMENT_INVALID"
		elseif p == 1 then
			return "TEXT_X_ALIGNMENT_LEFT"
		elseif p == 2 then
			return "TEXT_X_ALIGNMENT_CENTER"
		elseif p == 3 then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TEXT_X_ALIGNMENT_INVALID" then
			return 0
		elseif p == "TEXT_X_ALIGNMENT_LEFT" then
			return 1
		elseif p == "TEXT_X_ALIGNMENT_CENTER" then
			return 2
		elseif p == "TEXT_X_ALIGNMENT_RIGHT" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TEXT_X_ALIGNMENT_INVALID" then
			return "TEXT_X_ALIGNMENT_INVALID"
		elseif p == "TEXT_X_ALIGNMENT_LEFT" then
			return "TEXT_X_ALIGNMENT_LEFT"
		elseif p == "TEXT_X_ALIGNMENT_CENTER" then
			return "TEXT_X_ALIGNMENT_CENTER"
		elseif p == "TEXT_X_ALIGNMENT_RIGHT" then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end
}

v.TextYAlignment = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TEXT_Y_ALIGNMENT_INVALID"
		elseif p == 1 then
			return "TEXT_Y_ALIGNMENT_TOP"
		elseif p == 2 then
			return "TEXT_Y_ALIGNMENT_CENTER"
		elseif p == 3 then
			return "TEXT_Y_ALIGNMENT_BOTTOM"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TEXT_Y_ALIGNMENT_INVALID" then
			return 0
		elseif p == "TEXT_Y_ALIGNMENT_TOP" then
			return 1
		elseif p == "TEXT_Y_ALIGNMENT_CENTER" then
			return 2
		elseif p == "TEXT_Y_ALIGNMENT_BOTTOM" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TEXT_Y_ALIGNMENT_INVALID" then
			return "TEXT_Y_ALIGNMENT_INVALID"
		elseif p == "TEXT_Y_ALIGNMENT_TOP" then
			return "TEXT_Y_ALIGNMENT_TOP"
		elseif p == "TEXT_Y_ALIGNMENT_CENTER" then
			return "TEXT_Y_ALIGNMENT_CENTER"
		elseif p == "TEXT_Y_ALIGNMENT_BOTTOM" then
			return "TEXT_Y_ALIGNMENT_BOTTOM"
		end

		return nil
	end
}

v.UIFlexMode = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "UI_FLEX_MODE_INVALID"
		elseif p == 1 then
			return "UI_FLEX_MODE_NONE"
		elseif p == 2 then
			return "UI_FLEX_MODE_GROW"
		elseif p == 3 then
			return "UI_FLEX_MODE_SHRINK"
		elseif p == 4 then
			return "UI_FLEX_MODE_FILL"
		elseif p == 5 then
			return "UI_FLEX_MODE_CUSTOM"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "UI_FLEX_MODE_INVALID" then
			return 0
		elseif p == "UI_FLEX_MODE_NONE" then
			return 1
		elseif p == "UI_FLEX_MODE_GROW" then
			return 2
		elseif p == "UI_FLEX_MODE_SHRINK" then
			return 3
		elseif p == "UI_FLEX_MODE_FILL" then
			return 4
		elseif p == "UI_FLEX_MODE_CUSTOM" then
			return 5
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "UI_FLEX_MODE_INVALID" then
			return "UI_FLEX_MODE_INVALID"
		elseif p == "UI_FLEX_MODE_NONE" then
			return "UI_FLEX_MODE_NONE"
		elseif p == "UI_FLEX_MODE_GROW" then
			return "UI_FLEX_MODE_GROW"
		elseif p == "UI_FLEX_MODE_SHRINK" then
			return "UI_FLEX_MODE_SHRINK"
		elseif p == "UI_FLEX_MODE_FILL" then
			return "UI_FLEX_MODE_FILL"
		elseif p == "UI_FLEX_MODE_CUSTOM" then
			return "UI_FLEX_MODE_CUSTOM"
		end

		return nil
	end
}

v.ScaleType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "SCALE_TYPE_INVALID"
		elseif p == 1 then
			return "SCALE_TYPE_STRETCH"
		elseif p == 2 then
			return "SCALE_TYPE_SLICE"
		elseif p == 3 then
			return "SCALE_TYPE_TILE"
		elseif p == 4 then
			return "SCALE_TYPE_FIT"
		elseif p == 5 then
			return "SCALE_TYPE_CROP"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "SCALE_TYPE_INVALID" then
			return 0
		elseif p == "SCALE_TYPE_STRETCH" then
			return 1
		elseif p == "SCALE_TYPE_SLICE" then
			return 2
		elseif p == "SCALE_TYPE_TILE" then
			return 3
		elseif p == "SCALE_TYPE_FIT" then
			return 4
		elseif p == "SCALE_TYPE_CROP" then
			return 5
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "SCALE_TYPE_INVALID" then
			return "SCALE_TYPE_INVALID"
		elseif p == "SCALE_TYPE_STRETCH" then
			return "SCALE_TYPE_STRETCH"
		elseif p == "SCALE_TYPE_SLICE" then
			return "SCALE_TYPE_SLICE"
		elseif p == "SCALE_TYPE_TILE" then
			return "SCALE_TYPE_TILE"
		elseif p == "SCALE_TYPE_FIT" then
			return "SCALE_TYPE_FIT"
		elseif p == "SCALE_TYPE_CROP" then
			return "SCALE_TYPE_CROP"
		end

		return nil
	end
}

v.ResamplerMode = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "RESAMPLER_MODE_INVALID"
		elseif p == 1 then
			return "RESAMPLER_MODE_DEFAULT"
		elseif p == 2 then
			return "RESAMPLER_MODE_PIXELATED"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "RESAMPLER_MODE_INVALID" then
			return 0
		elseif p == "RESAMPLER_MODE_DEFAULT" then
			return 1
		elseif p == "RESAMPLER_MODE_PIXELATED" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "RESAMPLER_MODE_INVALID" then
			return "RESAMPLER_MODE_INVALID"
		elseif p == "RESAMPLER_MODE_DEFAULT" then
			return "RESAMPLER_MODE_DEFAULT"
		elseif p == "RESAMPLER_MODE_PIXELATED" then
			return "RESAMPLER_MODE_PIXELATED"
		end

		return nil
	end
}

v.SizeConstraint = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "SIZE_CONSTRAINT_INVALID"
		elseif p == 1 then
			return "SIZE_CONSTRAINT_RELATIVE_XY"
		elseif p == 2 then
			return "SIZE_CONSTRAINT_RELATIVE_XX"
		elseif p == 3 then
			return "SIZE_CONSTRAINT_RELATIVE_YY"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "SIZE_CONSTRAINT_INVALID" then
			return 0
		elseif p == "SIZE_CONSTRAINT_RELATIVE_XY" then
			return 1
		elseif p == "SIZE_CONSTRAINT_RELATIVE_XX" then
			return 2
		elseif p == "SIZE_CONSTRAINT_RELATIVE_YY" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "SIZE_CONSTRAINT_INVALID" then
			return "SIZE_CONSTRAINT_INVALID"
		elseif p == "SIZE_CONSTRAINT_RELATIVE_XY" then
			return "SIZE_CONSTRAINT_RELATIVE_XY"
		elseif p == "SIZE_CONSTRAINT_RELATIVE_XX" then
			return "SIZE_CONSTRAINT_RELATIVE_XX"
		elseif p == "SIZE_CONSTRAINT_RELATIVE_YY" then
			return "SIZE_CONSTRAINT_RELATIVE_YY"
		end

		return nil
	end
}

v.HorizontalAlignment = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "HORIZONTAL_ALIGNMENT_INVALID"
		elseif p == 1 then
			return "HORIZONTAL_ALIGNMENT_LEFT"
		elseif p == 2 then
			return "HORIZONTAL_ALIGNMENT_CENTER"
		elseif p == 3 then
			return "HORIZONTAL_ALIGNMENT_RIGHT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "HORIZONTAL_ALIGNMENT_INVALID" then
			return 0
		elseif p == "HORIZONTAL_ALIGNMENT_LEFT" then
			return 1
		elseif p == "HORIZONTAL_ALIGNMENT_CENTER" then
			return 2
		elseif p == "HORIZONTAL_ALIGNMENT_RIGHT" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "HORIZONTAL_ALIGNMENT_INVALID" then
			return "HORIZONTAL_ALIGNMENT_INVALID"
		elseif p == "HORIZONTAL_ALIGNMENT_LEFT" then
			return "HORIZONTAL_ALIGNMENT_LEFT"
		elseif p == "HORIZONTAL_ALIGNMENT_CENTER" then
			return "HORIZONTAL_ALIGNMENT_CENTER"
		elseif p == "HORIZONTAL_ALIGNMENT_RIGHT" then
			return "HORIZONTAL_ALIGNMENT_RIGHT"
		end

		return nil
	end
}

v.VerticalAlignment = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "VERTICAL_ALIGNMENT_INVALID"
		elseif p == 1 then
			return "VERTICAL_ALIGNMENT_TOP"
		elseif p == 2 then
			return "VERTICAL_ALIGNMENT_CENTER"
		elseif p == 3 then
			return "VERTICAL_ALIGNMENT_BOTTOM"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "VERTICAL_ALIGNMENT_INVALID" then
			return 0
		elseif p == "VERTICAL_ALIGNMENT_TOP" then
			return 1
		elseif p == "VERTICAL_ALIGNMENT_CENTER" then
			return 2
		elseif p == "VERTICAL_ALIGNMENT_BOTTOM" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "VERTICAL_ALIGNMENT_INVALID" then
			return "VERTICAL_ALIGNMENT_INVALID"
		elseif p == "VERTICAL_ALIGNMENT_TOP" then
			return "VERTICAL_ALIGNMENT_TOP"
		elseif p == "VERTICAL_ALIGNMENT_CENTER" then
			return "VERTICAL_ALIGNMENT_CENTER"
		elseif p == "VERTICAL_ALIGNMENT_BOTTOM" then
			return "VERTICAL_ALIGNMENT_BOTTOM"
		end

		return nil
	end
}

v.SelectionBehavior = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "SELECTION_BEHAVIOR_INVALID"
		elseif p == 1 then
			return "SELECTION_BEHAVIOR_ESCAPE"
		elseif p == 2 then
			return "SELECTION_BEHAVIOR_STOP"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "SELECTION_BEHAVIOR_INVALID" then
			return 0
		elseif p == "SELECTION_BEHAVIOR_ESCAPE" then
			return 1
		elseif p == "SELECTION_BEHAVIOR_STOP" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "SELECTION_BEHAVIOR_INVALID" then
			return "SELECTION_BEHAVIOR_INVALID"
		elseif p == "SELECTION_BEHAVIOR_ESCAPE" then
			return "SELECTION_BEHAVIOR_ESCAPE"
		elseif p == "SELECTION_BEHAVIOR_STOP" then
			return "SELECTION_BEHAVIOR_STOP"
		end

		return nil
	end
}

v.KeyCode = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "KEY_CODE_INVALID"
		elseif p == 1 then
			return "KEY_CODE_BUTTON_A"
		elseif p == 2 then
			return "KEY_CODE_BUTTON_B"
		elseif p == 3 then
			return "KEY_CODE_BUTTON_X"
		elseif p == 4 then
			return "KEY_CODE_BUTTON_Y"
		elseif p == 5 then
			return "KEY_CODE_BUTTON_L1"
		elseif p == 6 then
			return "KEY_CODE_BUTTON_R1"
		elseif p == 7 then
			return "KEY_CODE_BUTTON_L2"
		elseif p == 8 then
			return "KEY_CODE_BUTTON_R2"
		elseif p == 9 then
			return "KEY_CODE_BUTTON_L3"
		elseif p == 10 then
			return "KEY_CODE_BUTTON_R3"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "KEY_CODE_INVALID" then
			return 0
		elseif p == "KEY_CODE_BUTTON_A" then
			return 1
		elseif p == "KEY_CODE_BUTTON_B" then
			return 2
		elseif p == "KEY_CODE_BUTTON_X" then
			return 3
		elseif p == "KEY_CODE_BUTTON_Y" then
			return 4
		elseif p == "KEY_CODE_BUTTON_L1" then
			return 5
		elseif p == "KEY_CODE_BUTTON_R1" then
			return 6
		elseif p == "KEY_CODE_BUTTON_L2" then
			return 7
		elseif p == "KEY_CODE_BUTTON_R2" then
			return 8
		elseif p == "KEY_CODE_BUTTON_L3" then
			return 9
		elseif p == "KEY_CODE_BUTTON_R3" then
			return 10
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "KEY_CODE_INVALID" then
			return "KEY_CODE_INVALID"
		elseif p == "KEY_CODE_BUTTON_A" then
			return "KEY_CODE_BUTTON_A"
		elseif p == "KEY_CODE_BUTTON_B" then
			return "KEY_CODE_BUTTON_B"
		elseif p == "KEY_CODE_BUTTON_X" then
			return "KEY_CODE_BUTTON_X"
		elseif p == "KEY_CODE_BUTTON_Y" then
			return "KEY_CODE_BUTTON_Y"
		elseif p == "KEY_CODE_BUTTON_L1" then
			return "KEY_CODE_BUTTON_L1"
		elseif p == "KEY_CODE_BUTTON_R1" then
			return "KEY_CODE_BUTTON_R1"
		elseif p == "KEY_CODE_BUTTON_L2" then
			return "KEY_CODE_BUTTON_L2"
		elseif p == "KEY_CODE_BUTTON_R2" then
			return "KEY_CODE_BUTTON_R2"
		elseif p == "KEY_CODE_BUTTON_L3" then
			return "KEY_CODE_BUTTON_L3"
		elseif p == "KEY_CODE_BUTTON_R3" then
			return "KEY_CODE_BUTTON_R3"
		end

		return nil
	end
}

return {
	AutomaticSizeProp = v.AutomaticSizeProp,
	AutomaticSizeProp_ConditionalOption = v.AutomaticSizeProp_ConditionalOption,
	AutomaticSizeProp_ConditionalOptions = v.AutomaticSizeProp_ConditionalOptions,
	TextTruncateProp = v.TextTruncateProp,
	TextTruncateProp_ConditionalOption = v.TextTruncateProp_ConditionalOption,
	TextTruncateProp_ConditionalOptions = v.TextTruncateProp_ConditionalOptions,
	TextXAlignmentProp = v.TextXAlignmentProp,
	TextXAlignmentProp_ConditionalOption = v.TextXAlignmentProp_ConditionalOption,
	TextXAlignmentProp_ConditionalOptions = v.TextXAlignmentProp_ConditionalOptions,
	TextYAlignmentProp = v.TextYAlignmentProp,
	TextYAlignmentProp_ConditionalOption = v.TextYAlignmentProp_ConditionalOption,
	TextYAlignmentProp_ConditionalOptions = v.TextYAlignmentProp_ConditionalOptions,
	UIFlexModeProp = v.UIFlexModeProp,
	UIFlexModeProp_ConditionalOption = v.UIFlexModeProp_ConditionalOption,
	UIFlexModeProp_ConditionalOptions = v.UIFlexModeProp_ConditionalOptions,
	ScaleTypeProp = v.ScaleTypeProp,
	ScaleTypeProp_ConditionalOption = v.ScaleTypeProp_ConditionalOption,
	ScaleTypeProp_ConditionalOptions = v.ScaleTypeProp_ConditionalOptions,
	ResamplerModeProp = v.ResamplerModeProp,
	ResamplerModeProp_ConditionalOption = v.ResamplerModeProp_ConditionalOption,
	ResamplerModeProp_ConditionalOptions = v.ResamplerModeProp_ConditionalOptions,
	SizeConstraintProp = v.SizeConstraintProp,
	SizeConstraintProp_ConditionalOption = v.SizeConstraintProp_ConditionalOption,
	SizeConstraintProp_ConditionalOptions = v.SizeConstraintProp_ConditionalOptions,
	HorizontalAlignmentProp = v.HorizontalAlignmentProp,
	HorizontalAlignmentProp_ConditionalOption = v.HorizontalAlignmentProp_ConditionalOption,
	HorizontalAlignmentProp_ConditionalOptions = v.HorizontalAlignmentProp_ConditionalOptions,
	SelectionBehaviorProp = v.SelectionBehaviorProp,
	SelectionBehaviorProp_ConditionalOption = v.SelectionBehaviorProp_ConditionalOption,
	SelectionBehaviorProp_ConditionalOptions = v.SelectionBehaviorProp_ConditionalOptions,
	KeyCodeProp = v.KeyCodeProp,
	KeyCodeProp_ConditionalOption = v.KeyCodeProp_ConditionalOption,
	KeyCodeProp_ConditionalOptions = v.KeyCodeProp_ConditionalOptions,
	VerticalAlignmentProp = v.VerticalAlignmentProp,
	VerticalAlignmentProp_ConditionalOption = v.VerticalAlignmentProp_ConditionalOption,
	VerticalAlignmentProp_ConditionalOptions = v.VerticalAlignmentProp_ConditionalOptions,
	AutomaticSize = v.AutomaticSize,
	TextTruncate = v.TextTruncate,
	TextXAlignment = v.TextXAlignment,
	TextYAlignment = v.TextYAlignment,
	UIFlexMode = v.UIFlexMode,
	ScaleType = v.ScaleType,
	ResamplerMode = v.ResamplerMode,
	SizeConstraint = v.SizeConstraint,
	HorizontalAlignment = v.HorizontalAlignment,
	VerticalAlignment = v.VerticalAlignment,
	SelectionBehavior = v.SelectionBehavior,
	KeyCode = v.KeyCode
}
