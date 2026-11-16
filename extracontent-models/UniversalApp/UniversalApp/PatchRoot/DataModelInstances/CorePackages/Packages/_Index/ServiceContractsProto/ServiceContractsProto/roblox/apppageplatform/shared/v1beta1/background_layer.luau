local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local prop_condition = require(script.Parent.prop_condition)

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		resource_identifier = (p == nil or p.resource_identifier == nil) and "" or p.resource_identifier
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.resource_identifier ~= nil and self.resource_identifier ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.resource_identifier)
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
				result.resource_identifier = buffer.tostring(v5)
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

	if self.resource_identifier ~= nil and self.resource_identifier ~= "" then
		v2.resourceIdentifier = self.resource_identifier
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.resource_identifier ~= nil then
		v2.resource_identifier = p.resource_identifier
	end

	if p.resourceIdentifier ~= nil then
		v2.resource_identifier = p.resourceIdentifier
	end

	return v2
end

class.descriptor = {
	name = "ImageBackground",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageBackground"
}

v.ImageBackground = class

typeRegistry.default:register(v.ImageBackground)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil and self.kind.type == "image_background" then
		local encoded = self.kind.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
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
				result.kind = { type = "image_background", value = v.ImageBackground.decode(v5) }
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

	if self.kind ~= nil and self.kind.type == "image_background" then
		v2.imageBackground = self.kind.value:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.image_background ~= nil then
		v2.kind = {
			type = "image_background",
			value = v.ImageBackground.jsonDecode(p.image_background)
		}
	end

	if p.imageBackground ~= nil then
		v2.kind = {
			type = "image_background",
			value = v.ImageBackground.jsonDecode(p.imageBackground)
		}
	end

	return v2
end

class2.descriptor = {
	name = "BackgroundLayer",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundLayer"
}

v.BackgroundLayer = class2

typeRegistry.default:register(v.BackgroundLayer)

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
		if self.kind.type == "literal" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.kind = {
					type = "literal",
					value = v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.decode(v5)
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ArrayOfBackgroundLayerProp_ConditionalOptions.decode(v5)
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

function class3:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
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

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.jsonDecode(data.literal)
		}
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
			value = v.ArrayOfBackgroundLayerProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class3.descriptor = {
	name = "ArrayOfBackgroundLayerProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfBackgroundLayerProp"
}

v.ArrayOfBackgroundLayerProp = class3

typeRegistry.default:register(v.ArrayOfBackgroundLayerProp)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.decode(v5)
				}
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

function class4:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.jsonDecode(data.literal)
		}
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class4.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfBackgroundLayerProp_ConditionalOption = class4

typeRegistry.default:register(v.ArrayOfBackgroundLayerProp_ConditionalOption)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class5))
end

function class5:encode()
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

function class5.decode(buf: buffer)
	local v2 = class5.new()
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
				table.insert(v2.options, v.ArrayOfBackgroundLayerProp_ConditionalOption.decode(v6))
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

function class5:jsonEncode()
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

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ArrayOfBackgroundLayerProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class5.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfBackgroundLayerProp_ConditionalOptions = class5

typeRegistry.default:register(v.ArrayOfBackgroundLayerProp_ConditionalOptions)

local class6 = {}
class6.__index = class6

function class6.new(p)
	return (setmetatable({
		array = (p == nil or p.array == nil) and {} or p.array
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.array ~= nil and #self.array > 0 then
		for _, item in self.array do
			local encoded = item:encode()
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
				table.insert(v2.array, v.BackgroundLayer.decode(v6))
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

	if self.array == nil or not (#self.array > 0) then
		return v2
	end

	local array = {}

	for _, item in self.array do
		table.insert(array, item:jsonEncode())
	end

	v2.array = array

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.array == nil then
		return v2
	end

	local array = {}

	for _, item in p.array do
		table.insert(array, v.BackgroundLayer.jsonDecode(item))
	end

	v2.array = array

	return v2
end

class6.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfBackgroundLayer"
}

v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer = class6

typeRegistry.default:register(v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer)

return {
	ImageBackground = v.ImageBackground,
	BackgroundLayer = v.BackgroundLayer,
	ArrayOfBackgroundLayerProp = v.ArrayOfBackgroundLayerProp,
	ArrayOfBackgroundLayerProp_ConditionalOption = v.ArrayOfBackgroundLayerProp_ConditionalOption,
	ArrayOfBackgroundLayerProp_ConditionalOptions = v.ArrayOfBackgroundLayerProp_ConditionalOptions,
	ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer = v.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer
}
