local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local background_layer = require(script.Parent.background_layer)
local catalog_sort_data = require(script.Parent.catalog_sort_data)
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local prop_condition = require(script.Parent.prop_condition)
local prop_types = require(script.Parent.prop_types)

local class = {}
class.__index = class

function class.new(p)
	local content_type

	if not (p == nil or p.content_type == nil) then
		content_type = p.content_type
	end

	return (setmetatable({ content_type = content_type }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.content_type ~= nil then
		local encoded = self.content_type:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.content_type = prop_types.StringProp.decode(v5)
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

	if self.content_type ~= nil then
		v2.contentType = self.content_type:jsonEncode()
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.content_type ~= nil then
		v2.content_type = prop_types.StringProp.jsonDecode(p.content_type)
	end

	if p.contentType ~= nil then
		v2.content_type = prop_types.StringProp.jsonDecode(p.contentType)
	end

	return v2
end

class.descriptor = {
	name = "ItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemFooter"
}

v.ItemFooter = class

typeRegistry.default:register(v.ItemFooter)

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
		elseif self.kind.type == "array_map" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfItemFooterProp_ArrayOfItemFooter.decode(v5)
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
					value = v.ArrayOfItemFooterProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "array_map",
					value = v.ArrayOfItemFooterProp_ArrayMap.decode(v5)
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

function class2:jsonEncode()
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
		return v2
	end

	if self.kind.type == "array_map" then
		v2.arrayMap = self.kind.value:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfItemFooterProp_ArrayOfItemFooter.jsonDecode(data.literal)
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
			value = v.ArrayOfItemFooterProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.array_map ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfItemFooterProp_ArrayMap.jsonDecode(data.array_map)
		}
	end

	if data.arrayMap ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfItemFooterProp_ArrayMap.jsonDecode(data.arrayMap)
		}
	end

	return v2
end

class2.descriptor = {
	name = "ArrayOfItemFooterProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfItemFooterProp"
}

v.ArrayOfItemFooterProp = class2

typeRegistry.default:register(v.ArrayOfItemFooterProp)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class3))
end

function class3:encode()
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
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfItemFooterProp_ArrayOfItemFooter.decode(v5)
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

function class3:jsonEncode()
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

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfItemFooterProp_ArrayOfItemFooter.jsonDecode(data.literal)
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

class3.descriptor = {
	name = "ArrayOfItemFooterProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfItemFooterProp_ConditionalOption = class3

typeRegistry.default:register(v.ArrayOfItemFooterProp_ConditionalOption)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class4))
end

function class4:encode()
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
				table.insert(v2.options, v.ArrayOfItemFooterProp_ConditionalOption.decode(v6))
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

function class4:jsonEncode()
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

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ArrayOfItemFooterProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class4.descriptor = {
	name = "ArrayOfItemFooterProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfItemFooterProp_ConditionalOptions = class4

typeRegistry.default:register(v.ArrayOfItemFooterProp_ConditionalOptions)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		array = (p == nil or p.array == nil) and {} or p.array
	}, class5))
end

function class5:encode()
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
				table.insert(v2.array, v.ItemFooter.decode(v6))
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

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.array == nil then
		return v2
	end

	local array = {}

	for _, item in p.array do
		table.insert(array, v.ItemFooter.jsonDecode(item))
	end

	v2.array = array

	return v2
end

class5.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayOfItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfItemFooter"
}

v.ArrayOfItemFooterProp_ArrayOfItemFooter = class5

typeRegistry.default:register(v.ArrayOfItemFooterProp_ArrayOfItemFooter)

local class6 = {}
class6.__index = class6

function class6.new(data)
	local kind

	if not (data == nil or data.kind == nil) then
		kind = data.kind
	end

	local v2 = {
		kind = kind,
		item_hydration_specs = (data == nil or data.item_hydration_specs == nil) and {} or data.item_hydration_specs,
		field_map = 0
	}
	local field_map

	if not (data == nil or data.field_map == nil) then
		field_map = data.field_map
	end

	v2.field_map = field_map
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "literal" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.item_hydration_specs ~= nil and #self.item_hydration_specs > 0 then
		for _, item_hydration_spec in self.item_hydration_specs do
			local encoded = item_hydration_spec:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.field_map ~= nil then
		local encoded = self.field_map:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfItemFooterProp_ArrayMap_LiteralItems.decode(v5)
				}
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v5))
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field_map = v.ItemFooter.decode(v5)
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

	if self.kind ~= nil then
		if self.kind.type == "binding_path" then
			v2.bindingPath = self.kind.value
		elseif self.kind.type == "literal" then
			v2.literal = self.kind.value:jsonEncode()
		end
	end

	if self.item_hydration_specs ~= nil and #self.item_hydration_specs > 0 then
		local itemHydrationSpecs = {}

		for _, item_hydration_spec in self.item_hydration_specs do
			table.insert(itemHydrationSpecs, item_hydration_spec:jsonEncode())
		end

		v2.itemHydrationSpecs = itemHydrationSpecs
	end

	if self.field_map ~= nil then
		v2.fieldMap = self.field_map:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfItemFooterProp_ArrayMap_LiteralItems.jsonDecode(data.literal)
		}
	end

	if data.item_hydration_specs ~= nil then
		local item_hydration_specs = {}

		for _, item_hydration_spec in data.item_hydration_specs do
			table.insert(item_hydration_specs, hydration_data_spec.HydrationDataSpec.jsonDecode(item_hydration_spec))
		end

		v2.item_hydration_specs = item_hydration_specs
	end

	if data.itemHydrationSpecs ~= nil then
		local item_hydration_specs = {}

		for _, itemHydrationSpec in data.itemHydrationSpecs do
			table.insert(item_hydration_specs, hydration_data_spec.HydrationDataSpec.jsonDecode(itemHydrationSpec))
		end

		v2.item_hydration_specs = item_hydration_specs
	end

	if data.field_map ~= nil then
		v2.field_map = v.ItemFooter.jsonDecode(data.field_map)
	end

	if data.fieldMap ~= nil then
		v2.field_map = v.ItemFooter.jsonDecode(data.fieldMap)
	end

	return v2
end

class6.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}

v.ArrayOfItemFooterProp_ArrayMap = class6

typeRegistry.default:register(v.ArrayOfItemFooterProp_ArrayMap)

local class7 = {}
class7.__index = class7

function class7.new(p)
	return (setmetatable({
		items = (p == nil or p.items == nil) and {} or p.items
	}, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.items ~= nil and #self.items > 0 then
		for _, item in self.items do
			local encoded = item:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local v2 = class7.new()
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
				table.insert(v2.items, catalog_sort_data.CatalogSortCardItemFooter.decode(v6))
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

function class7:jsonEncode()
	local v2 = {}

	if self.items == nil or not (#self.items > 0) then
		return v2
	end

	local items = {}

	for _, item in self.items do
		table.insert(items, item:jsonEncode())
	end

	v2.items = items

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.items == nil then
		return v2
	end

	local items = {}

	for _, item in p.items do
		table.insert(items, catalog_sort_data.CatalogSortCardItemFooter.jsonDecode(item))
	end

	v2.items = items

	return v2
end

class7.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayMap_LiteralItems",
	fullName = "roblox.apppageplatform.shared.v1beta1.LiteralItems"
}

v.ArrayOfItemFooterProp_ArrayMap_LiteralItems = class7

typeRegistry.default:register(v.ArrayOfItemFooterProp_ArrayMap_LiteralItems)

local class8 = {}
class8.__index = class8

function class8.new(p)
	local thumbnail_aspect_ratio

	if not (p == nil or p.thumbnail_aspect_ratio == nil) then
		thumbnail_aspect_ratio = p.thumbnail_aspect_ratio
	end

	local background_layers

	if not (p == nil or p.background_layers == nil) then
		background_layers = p.background_layers
	end

	return (setmetatable(
		{ thumbnail_aspect_ratio = thumbnail_aspect_ratio, background_layers = background_layers },
		class8
	))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.thumbnail_aspect_ratio ~= nil then
		local encoded = self.thumbnail_aspect_ratio:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.background_layers ~= nil then
		local encoded = self.background_layers:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.thumbnail_aspect_ratio = prop_types.StringProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.background_layers = background_layer.ArrayOfBackgroundLayerProp.decode(v5)
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

	if self.thumbnail_aspect_ratio ~= nil then
		v2.thumbnailAspectRatio = self.thumbnail_aspect_ratio:jsonEncode()
	end

	if self.background_layers ~= nil then
		v2.backgroundLayers = self.background_layers:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.thumbnail_aspect_ratio ~= nil then
		v2.thumbnail_aspect_ratio = prop_types.StringProp.jsonDecode(data.thumbnail_aspect_ratio)
	end

	if data.thumbnailAspectRatio ~= nil then
		v2.thumbnail_aspect_ratio = prop_types.StringProp.jsonDecode(data.thumbnailAspectRatio)
	end

	if data.background_layers ~= nil then
		v2.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(data.background_layers)
	end

	if data.backgroundLayers ~= nil then
		v2.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(data.backgroundLayers)
	end

	return v2
end

class8.descriptor = {
	name = "CardStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardStyle"
}

v.CardStyle = class8

typeRegistry.default:register(v.CardStyle)

local class9 = {}
class9.__index = class9

function class9.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class9))
end

function class9:encode()
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

function class9.decode(buf: buffer)
	local result = class9.new()
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
				result.kind = { type = "literal", value = v.CardStyle.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.CardStyleProp_ConditionalOptions.decode(v5)
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

function class9:jsonEncode()
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

function class9.jsonDecode(data)
	local v2 = class9.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.CardStyle.jsonDecode(data.literal)
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
			value = v.CardStyleProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class9.descriptor = {
	name = "CardStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardStyleProp"
}

v.CardStyleProp = class9

typeRegistry.default:register(v.CardStyleProp)

local class10 = {}
class10.__index = class10

function class10.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class10))
end

function class10:encode()
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

function class10.decode(buf: buffer)
	local result = class10.new()
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
				result.kind = { type = "literal", value = v.CardStyle.decode(v5) }
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

function class10:jsonEncode()
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

function class10.jsonDecode(data)
	local v2 = class10.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.CardStyle.jsonDecode(data.literal)
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

class10.descriptor = {
	name = "CardStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.CardStyleProp_ConditionalOption = class10

typeRegistry.default:register(v.CardStyleProp_ConditionalOption)

local class11 = {}
class11.__index = class11

function class11.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class11))
end

function class11:encode()
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

function class11.decode(buf: buffer)
	local v2 = class11.new()
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
				table.insert(v2.options, v.CardStyleProp_ConditionalOption.decode(v6))
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

function class11:jsonEncode()
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

function class11.jsonDecode(p)
	local v2 = class11.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.CardStyleProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class11.descriptor = {
	name = "CardStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.CardStyleProp_ConditionalOptions = class11

typeRegistry.default:register(v.CardStyleProp_ConditionalOptions)

local class12 = {}
class12.__index = class12

function class12.new(p)
	local id

	if not (p == nil or p.id == nil) then
		id = p.id
	end

	local v2

	if not (p == nil or p.type == nil) then
		v2 = p.type
	end

	return (setmetatable({ id = id, type = v2 }, class12))
end

function class12:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil then
		local encoded = self.id:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.type ~= nil then
		local encoded = self.type:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class12.decode(buf: buffer)
	local result = class12.new()
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
				result.id = prop_types.StringProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = prop_types.StringProp.decode(v5)
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

function class12:jsonEncode()
	local v2 = {}

	if self.id ~= nil then
		v2.id = self.id:jsonEncode()
	end

	if self.type ~= nil then
		v2.type = self.type:jsonEncode()
	end

	return v2
end

function class12.jsonDecode(p)
	local v2 = class12.new()

	if p.id ~= nil then
		v2.id = prop_types.StringProp.jsonDecode(p.id)
	end

	if p.type ~= nil then
		v2.type = prop_types.StringProp.jsonDecode(p.type)
	end

	return v2
end

class12.descriptor = {
	name = "CatalogSortContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortContent"
}

v.CatalogSortContent = class12

typeRegistry.default:register(v.CatalogSortContent)

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
		elseif self.kind.type == "array_map" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.decode(v5)
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
					value = v.ArrayOfCatalogSortContentProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "array_map",
					value = v.ArrayOfCatalogSortContentProp_ArrayMap.decode(v5)
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
		v2.literal = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "array_map" then
		v2.arrayMap = self.kind.value:jsonEncode()
	end

	return v2
end

function class13.jsonDecode(data)
	local v2 = class13.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.jsonDecode(data.literal)
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
			value = v.ArrayOfCatalogSortContentProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.array_map ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfCatalogSortContentProp_ArrayMap.jsonDecode(data.array_map)
		}
	end

	if data.arrayMap ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfCatalogSortContentProp_ArrayMap.jsonDecode(data.arrayMap)
		}
	end

	return v2
end

class13.descriptor = {
	name = "ArrayOfCatalogSortContentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfCatalogSortContentProp"
}

v.ArrayOfCatalogSortContentProp = class13

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp)

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

function class14.decode(buf: buffer)
	local result = class14.new()
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
					value = v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.decode(v5)
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

function class14:jsonEncode()
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

function class14.jsonDecode(data)
	local v2 = class14.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.jsonDecode(data.literal)
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

class14.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfCatalogSortContentProp_ConditionalOption = class14

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp_ConditionalOption)

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
				table.insert(v2.options, v.ArrayOfCatalogSortContentProp_ConditionalOption.decode(v6))
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
		table.insert(options, v.ArrayOfCatalogSortContentProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class15.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfCatalogSortContentProp_ConditionalOptions = class15

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp_ConditionalOptions)

local class16 = {}
class16.__index = class16

function class16.new(p)
	return (setmetatable({
		array = (p == nil or p.array == nil) and {} or p.array
	}, class16))
end

function class16:encode()
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

function class16.decode(buf: buffer)
	local v2 = class16.new()
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
				table.insert(v2.array, v.CatalogSortContent.decode(v6))
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

function class16:jsonEncode()
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

function class16.jsonDecode(p)
	local v2 = class16.new()

	if p.array == nil then
		return v2
	end

	local array = {}

	for _, item in p.array do
		table.insert(array, v.CatalogSortContent.jsonDecode(item))
	end

	v2.array = array

	return v2
end

class16.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfCatalogSortContent"
}

v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent = class16

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent)

local class17 = {}
class17.__index = class17

function class17.new(data)
	local kind

	if not (data == nil or data.kind == nil) then
		kind = data.kind
	end

	local v2 = {
		kind = kind,
		item_hydration_specs = (data == nil or data.item_hydration_specs == nil) and {} or data.item_hydration_specs,
		field_map = 0
	}
	local field_map

	if not (data == nil or data.field_map == nil) then
		field_map = data.field_map
	end

	v2.field_map = field_map
	return (setmetatable(v2, class17))
end

function class17:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "literal" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.item_hydration_specs ~= nil and #self.item_hydration_specs > 0 then
		for _, item_hydration_spec in self.item_hydration_specs do
			local encoded = item_hydration_spec:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.field_map ~= nil then
		local encoded = self.field_map:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems.decode(v5)
				}
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v5))
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field_map = v.CatalogSortContent.decode(v5)
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

	if self.kind ~= nil then
		if self.kind.type == "binding_path" then
			v2.bindingPath = self.kind.value
		elseif self.kind.type == "literal" then
			v2.literal = self.kind.value:jsonEncode()
		end
	end

	if self.item_hydration_specs ~= nil and #self.item_hydration_specs > 0 then
		local itemHydrationSpecs = {}

		for _, item_hydration_spec in self.item_hydration_specs do
			table.insert(itemHydrationSpecs, item_hydration_spec:jsonEncode())
		end

		v2.itemHydrationSpecs = itemHydrationSpecs
	end

	if self.field_map ~= nil then
		v2.fieldMap = self.field_map:jsonEncode()
	end

	return v2
end

function class17.jsonDecode(data)
	local v2 = class17.new()

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems.jsonDecode(data.literal)
		}
	end

	if data.item_hydration_specs ~= nil then
		local item_hydration_specs = {}

		for _, item_hydration_spec in data.item_hydration_specs do
			table.insert(item_hydration_specs, hydration_data_spec.HydrationDataSpec.jsonDecode(item_hydration_spec))
		end

		v2.item_hydration_specs = item_hydration_specs
	end

	if data.itemHydrationSpecs ~= nil then
		local item_hydration_specs = {}

		for _, itemHydrationSpec in data.itemHydrationSpecs do
			table.insert(item_hydration_specs, hydration_data_spec.HydrationDataSpec.jsonDecode(itemHydrationSpec))
		end

		v2.item_hydration_specs = item_hydration_specs
	end

	if data.field_map ~= nil then
		v2.field_map = v.CatalogSortContent.jsonDecode(data.field_map)
	end

	if data.fieldMap ~= nil then
		v2.field_map = v.CatalogSortContent.jsonDecode(data.fieldMap)
	end

	return v2
end

class17.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}

v.ArrayOfCatalogSortContentProp_ArrayMap = class17

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp_ArrayMap)

local class18 = {}
class18.__index = class18

function class18.new(p)
	return (setmetatable({
		items = (p == nil or p.items == nil) and {} or p.items
	}, class18))
end

function class18:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.items ~= nil and #self.items > 0 then
		for _, item in self.items do
			local encoded = item:encode()
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
				table.insert(v2.items, catalog_sort_data.CatalogSortContentData.decode(v6))
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

	if self.items == nil or not (#self.items > 0) then
		return v2
	end

	local items = {}

	for _, item in self.items do
		table.insert(items, item:jsonEncode())
	end

	v2.items = items

	return v2
end

function class18.jsonDecode(p)
	local v2 = class18.new()

	if p.items == nil then
		return v2
	end

	local items = {}

	for _, item in p.items do
		table.insert(items, catalog_sort_data.CatalogSortContentData.jsonDecode(item))
	end

	v2.items = items

	return v2
end

class18.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems",
	fullName = "roblox.apppageplatform.shared.v1beta1.LiteralItems"
}

v.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems = class18

typeRegistry.default:register(v.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems)

local class19 = {}
class19.__index = class19

function class19.new(p)
	local background_layers

	if not (p == nil or p.background_layers == nil) then
		background_layers = p.background_layers
	end

	return (setmetatable({ background_layers = background_layers }, class19))
end

function class19:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.background_layers ~= nil then
		local encoded = self.background_layers:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.background_layers = background_layer.ArrayOfBackgroundLayerProp.decode(v5)
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

	if self.background_layers ~= nil then
		v2.backgroundLayers = self.background_layers:jsonEncode()
	end

	return v2
end

function class19.jsonDecode(p)
	local v2 = class19.new()

	if p.background_layers ~= nil then
		v2.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(p.background_layers)
	end

	if p.backgroundLayers ~= nil then
		v2.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(p.backgroundLayers)
	end

	return v2
end

class19.descriptor = {
	name = "WidgetStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyle"
}

v.WidgetStyle = class19

typeRegistry.default:register(v.WidgetStyle)

local class20 = {}
class20.__index = class20

function class20.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class20))
end

function class20:encode()
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

function class20.decode(buf: buffer)
	local result = class20.new()
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
				result.kind = { type = "literal", value = v.WidgetStyle.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.WidgetStyleProp_ConditionalOptions.decode(v5)
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

function class20:jsonEncode()
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

function class20.jsonDecode(data)
	local v2 = class20.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.WidgetStyle.jsonDecode(data.literal)
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
			value = v.WidgetStyleProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class20.descriptor = {
	name = "WidgetStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleProp"
}

v.WidgetStyleProp = class20

typeRegistry.default:register(v.WidgetStyleProp)

local class21 = {}
class21.__index = class21

function class21.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class21))
end

function class21:encode()
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

function class21.decode(buf: buffer)
	local result = class21.new()
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
				result.kind = { type = "literal", value = v.WidgetStyle.decode(v5) }
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

function class21:jsonEncode()
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

function class21.jsonDecode(data)
	local v2 = class21.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.WidgetStyle.jsonDecode(data.literal)
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

class21.descriptor = {
	name = "WidgetStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.WidgetStyleProp_ConditionalOption = class21

typeRegistry.default:register(v.WidgetStyleProp_ConditionalOption)

local class22 = {}
class22.__index = class22

function class22.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class22))
end

function class22:encode()
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

function class22.decode(buf: buffer)
	local v2 = class22.new()
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
				table.insert(v2.options, v.WidgetStyleProp_ConditionalOption.decode(v6))
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

function class22:jsonEncode()
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

function class22.jsonDecode(p)
	local v2 = class22.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.WidgetStyleProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class22.descriptor = {
	name = "WidgetStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.WidgetStyleProp_ConditionalOptions = class22

typeRegistry.default:register(v.WidgetStyleProp_ConditionalOptions)

return {
	ItemFooter = v.ItemFooter,
	ArrayOfItemFooterProp = v.ArrayOfItemFooterProp,
	ArrayOfItemFooterProp_ConditionalOption = v.ArrayOfItemFooterProp_ConditionalOption,
	ArrayOfItemFooterProp_ConditionalOptions = v.ArrayOfItemFooterProp_ConditionalOptions,
	ArrayOfItemFooterProp_ArrayOfItemFooter = v.ArrayOfItemFooterProp_ArrayOfItemFooter,
	ArrayOfItemFooterProp_ArrayMap = v.ArrayOfItemFooterProp_ArrayMap,
	ArrayOfItemFooterProp_ArrayMap_LiteralItems = v.ArrayOfItemFooterProp_ArrayMap_LiteralItems,
	CardStyle = v.CardStyle,
	CardStyleProp = v.CardStyleProp,
	CardStyleProp_ConditionalOption = v.CardStyleProp_ConditionalOption,
	CardStyleProp_ConditionalOptions = v.CardStyleProp_ConditionalOptions,
	CatalogSortContent = v.CatalogSortContent,
	ArrayOfCatalogSortContentProp = v.ArrayOfCatalogSortContentProp,
	ArrayOfCatalogSortContentProp_ConditionalOption = v.ArrayOfCatalogSortContentProp_ConditionalOption,
	ArrayOfCatalogSortContentProp_ConditionalOptions = v.ArrayOfCatalogSortContentProp_ConditionalOptions,
	ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent = v.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent,
	ArrayOfCatalogSortContentProp_ArrayMap = v.ArrayOfCatalogSortContentProp_ArrayMap,
	ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems = v.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems,
	WidgetStyle = v.WidgetStyle,
	WidgetStyleProp = v.WidgetStyleProp,
	WidgetStyleProp_ConditionalOption = v.WidgetStyleProp_ConditionalOption,
	WidgetStyleProp_ConditionalOptions = v.WidgetStyleProp_ConditionalOptions
}
