local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local struct = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.struct)
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local prop_condition = require(script.Parent.prop_condition)

local class = {}
class.__index = class

function class.new(data)
	return (setmetatable({
		namespace = (data == nil or data.namespace == nil) and "" or data.namespace,
		key = (data == nil or data.key == nil) and "" or data.key,
		map_key = (data == nil or data.map_key == nil) and "" or data.map_key
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.namespace ~= nil and self.namespace ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.namespace)
	end

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.map_key ~= nil and self.map_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.map_key)
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
				result.namespace = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.map_key = buffer.tostring(v5)
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

	if self.namespace ~= nil and self.namespace ~= "" then
		v2.namespace = self.namespace
	end

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.map_key ~= nil and self.map_key ~= "" then
		v2.mapKey = self.map_key
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.namespace ~= nil then
		v2.namespace = data.namespace
	end

	if data.key ~= nil then
		v2.key = data.key
	end

	if data.map_key ~= nil then
		v2.map_key = data.map_key
	end

	if data.mapKey ~= nil then
		v2.map_key = data.mapKey
	end

	return v2
end

class.descriptor = {
	name = "TranslationRef",
	fullName = "roblox.apppageplatform.shared.v1beta1.TranslationRef"
}

v.TranslationRef = class

typeRegistry.default:register(v.TranslationRef)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		str = (data == nil or data.str == nil) and "" or data.str,
		args = (data == nil or data.args == nil) and {} or data.args,
		translation = 0
	}
	local translation

	if not (data == nil or data.translation == nil) then
		translation = data.translation
	end

	v2.translation = translation
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.str ~= nil and self.str ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.str)
	end

	if self.args ~= nil and next(self.args) ~= nil then
		for k, arg in self.args do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local encoded = arg:encode()
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeBuffer(v8, v9, encoded, buffer.len(encoded))
			local v12, v13 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	if self.translation ~= nil then
		local encoded = self.translation:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
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
				result.str = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.StringFormat_ArgsEntry.decode(v5)

				local stringFormat_FormatArg = v.StringFormat_FormatArg.new()

				result.args[decoded.key or ""] = decoded.value or stringFormat_FormatArg
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.translation = v.TranslationRef.decode(v5)
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

	if self.str ~= nil and self.str ~= "" then
		v2.str = self.str
	end

	if self.args ~= nil and next(self.args) ~= nil then
		local args = {}

		for k, arg in self.args do
			args[k] = arg:jsonEncode()
		end

		v2.args = args
	end

	if self.translation ~= nil then
		v2.translation = self.translation:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.str ~= nil then
		v2.str = data.str
	end

	if data.args ~= nil then
		local args = {}

		for k, arg in data.args do
			args[k] = v.StringFormat_FormatArg.jsonDecode(arg)
		end

		v2.args = args
	end

	if data.translation ~= nil then
		v2.translation = v.TranslationRef.jsonDecode(data.translation)
	end

	return v2
end

class2.descriptor = {
	name = "StringFormat",
	fullName = "roblox.apppageplatform.shared.v1beta1.StringFormat"
}

v.StringFormat = class2

typeRegistry.default:register(v.StringFormat)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	local formatter

	if not (p == nil or p.formatter == nil) then
		formatter = p.formatter
	end

	return (setmetatable({ kind = kind, formatter = formatter }, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	if self.formatter ~= nil then
		local encoded = self.formatter:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.formatter = v.StringFormat_FormatArg_Formatter.decode(v5)
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

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			v2.literal = self.kind.value
		elseif self.kind.type == "binding_path" then
			v2.bindingPath = self.kind.value
		end
	end

	if self.formatter ~= nil then
		v2.formatter = self.formatter:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.formatter ~= nil then
		v2.formatter = v.StringFormat_FormatArg_Formatter.jsonDecode(data.formatter)
	end

	return v2
end

class3.descriptor = {
	name = "StringFormat_FormatArg",
	fullName = "roblox.apppageplatform.shared.v1beta1.FormatArg"
}

v.StringFormat_FormatArg = class3

typeRegistry.default:register(v.StringFormat_FormatArg)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local v2

	if p == nil or p.type == nil then
		v2 = assert(v.StringFormat_FormatArg_Formatter_Type.fromNumber(0), "Enum has no 0 default")
	else
		v2 = p.type
	end

	local config

	if not (p == nil or p.config == nil) then
		config = p.config
	end

	return (setmetatable({ type = v2, config = config }, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if
		self.type ~= nil
		and (self.type ~= nil and self.type ~= 0 or self.type ~= v.StringFormat_FormatArg_Formatter_Type.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.StringFormat_FormatArg_Formatter_Type.toNumber(self.type))
	end

	if self.config ~= nil and self.config.type == "date_config" then
		local encoded = self.config.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.type = v.StringFormat_FormatArg_Formatter_Type.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.config = {
					type = "date_config",
					value = v.StringFormat_FormatArg_Formatter_DateConfig.decode(v5)
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

	if
		self.type ~= nil
		and (self.type ~= nil and self.type ~= 0 or self.type ~= v.StringFormat_FormatArg_Formatter_Type.fromNumber(0))
	then
		local v3

		if typeof(self.type) == "number" then
			v3 = self.type
		else
			v3 = v.StringFormat_FormatArg_Formatter_Type.toNumber(self.type)
		end

		v2.type = v3
	end

	if self.config ~= nil and self.config.type == "date_config" then
		v2.dateConfig = self.config.value:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.type ~= nil then
		local v3

		if typeof(data.type) == "number" then
			v3 = v.StringFormat_FormatArg_Formatter_Type.fromNumber(data.type) or data.type
		else
			v3 = v.StringFormat_FormatArg_Formatter_Type.fromName(data.type) or data.type
		end

		v2.type = v3
	end

	if data.date_config ~= nil then
		v2.config = {
			type = "date_config",
			value = v.StringFormat_FormatArg_Formatter_DateConfig.jsonDecode(data.date_config)
		}
	end

	if data.dateConfig ~= nil then
		v2.config = {
			type = "date_config",
			value = v.StringFormat_FormatArg_Formatter_DateConfig.jsonDecode(data.dateConfig)
		}
	end

	return v2
end

class4.descriptor = {
	name = "StringFormat_FormatArg_Formatter",
	fullName = "roblox.apppageplatform.shared.v1beta1.Formatter"
}

v.StringFormat_FormatArg_Formatter = class4

typeRegistry.default:register(v.StringFormat_FormatArg_Formatter)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		pattern = (p == nil or p.pattern == nil) and "" or p.pattern
	}, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.pattern ~= nil and self.pattern ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.pattern)
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
				result.pattern = buffer.tostring(v5)
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

	if self.pattern ~= nil and self.pattern ~= "" then
		v2.pattern = self.pattern
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.pattern ~= nil then
		v2.pattern = p.pattern
	end

	return v2
end

class5.descriptor = {
	name = "StringFormat_FormatArg_Formatter_DateConfig",
	fullName = "roblox.apppageplatform.shared.v1beta1.DateConfig"
}

v.StringFormat_FormatArg_Formatter_DateConfig = class5

typeRegistry.default:register(v.StringFormat_FormatArg_Formatter_DateConfig)

v.StringFormat_FormatArg_Formatter_Type = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TYPE_INVALID"
		elseif p == 1 then
			return "TYPE_NUMBER_ABBREVIATE"
		elseif p == 2 then
			return "TYPE_NUMBER_LOCALIZE"
		elseif p == 3 then
			return "TYPE_DATE_FORMAT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TYPE_INVALID" then
			return 0
		elseif p == "TYPE_NUMBER_ABBREVIATE" then
			return 1
		elseif p == "TYPE_NUMBER_LOCALIZE" then
			return 2
		elseif p == "TYPE_DATE_FORMAT" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TYPE_INVALID" then
			return "TYPE_INVALID"
		elseif p == "TYPE_NUMBER_ABBREVIATE" then
			return "TYPE_NUMBER_ABBREVIATE"
		elseif p == "TYPE_NUMBER_LOCALIZE" then
			return "TYPE_NUMBER_LOCALIZE"
		elseif p == "TYPE_DATE_FORMAT" then
			return "TYPE_DATE_FORMAT"
		end

		return nil
	end
}

local class6 = {}
class6.__index = class6

function class6.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class6))
end

function class6:encode()
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = v.StringFormat_FormatArg.decode(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = v.StringFormat_FormatArg.jsonDecode(p.value)
	end

	return v2
end

class6.descriptor = {
	name = "StringFormat_ArgsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArgsEntry"
}

v.StringFormat_ArgsEntry = class6

typeRegistry.default:register(v.StringFormat_ArgsEntry)

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
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.StringProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
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
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "format" then
		v2.format = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "translation" then
		v2.translation = self.kind.value:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.StringProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	return v2
end

class7.descriptor = {
	name = "StringProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.StringProp"
}

v.StringProp = class7

typeRegistry.default:register(v.StringProp)

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
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
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
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "format" then
		v2.format = self.kind.value:jsonEncode()
		return v2
	elseif self.kind.type == "translation" then
		v2.translation = self.kind.value:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	return v2
end

class8.descriptor = {
	name = "StringProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.StringProp_ConditionalOption = class8

typeRegistry.default:register(v.StringProp_ConditionalOption)

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
				table.insert(v2.options, v.StringProp_ConditionalOption.decode(v6))
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
		table.insert(options, v.StringProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class9.descriptor = {
	name = "StringProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.StringProp_ConditionalOptions = class9

typeRegistry.default:register(v.StringProp_ConditionalOptions)

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
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i32)
			v2, v3 = proto.writeFloat(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.FloatProp_ConditionalOptions.decode(v5)
				}
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.kind = { type = "literal", value = v5 }
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
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
		v2.literal = proto.json.serializeNumber(self.kind.value)
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
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
		v2.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(data.literal)
		}
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.FloatProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class10.descriptor = {
	name = "FloatProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FloatProp"
}

v.FloatProp = class10

typeRegistry.default:register(v.FloatProp)

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
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
			v2, v3 = proto.writeFloat(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.condition = prop_condition.PropCondition.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.kind = { type = "literal", value = v5 }
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
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
		v2.literal = proto.json.serializeNumber(self.kind.value)
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	elseif self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class11.jsonDecode(data)
	local v2 = class11.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(data.literal)
		}
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	return v2
end

class11.descriptor = {
	name = "FloatProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.FloatProp_ConditionalOption = class11

typeRegistry.default:register(v.FloatProp_ConditionalOption)

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
				table.insert(v2.options, v.FloatProp_ConditionalOption.decode(v6))
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
		table.insert(options, v.FloatProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class12.descriptor = {
	name = "FloatProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.FloatProp_ConditionalOptions = class12

typeRegistry.default:register(v.FloatProp_ConditionalOptions)

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
					value = v.ArrayOfFloatProp_ArrayOfFloats.decode(v5)
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
					value = v.ArrayOfFloatProp_ConditionalOptions.decode(v5)
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
	end

	return v2
end

function class13.jsonDecode(data)
	local v2 = class13.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfFloatProp_ArrayOfFloats.jsonDecode(data.literal)
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
			value = v.ArrayOfFloatProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class13.descriptor = {
	name = "ArrayOfFloatProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfFloatProp"
}

v.ArrayOfFloatProp = class13

typeRegistry.default:register(v.ArrayOfFloatProp)

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
					value = v.ArrayOfFloatProp_ArrayOfFloats.decode(v5)
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
			value = v.ArrayOfFloatProp_ArrayOfFloats.jsonDecode(data.literal)
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
	name = "ArrayOfFloatProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfFloatProp_ConditionalOption = class14

typeRegistry.default:register(v.ArrayOfFloatProp_ConditionalOption)

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
				table.insert(v2.options, v.ArrayOfFloatProp_ConditionalOption.decode(v6))
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
		table.insert(options, v.ArrayOfFloatProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class15.descriptor = {
	name = "ArrayOfFloatProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfFloatProp_ConditionalOptions = class15

typeRegistry.default:register(v.ArrayOfFloatProp_ConditionalOptions)

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
				table.insert(v2.array, v.FloatProp.decode(v6))
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
		table.insert(array, v.FloatProp.jsonDecode(item))
	end

	v2.array = array

	return v2
end

class16.descriptor = {
	name = "ArrayOfFloatProp_ArrayOfFloats",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfFloats"
}

v.ArrayOfFloatProp_ArrayOfFloats = class16

typeRegistry.default:register(v.ArrayOfFloatProp_ArrayOfFloats)

local class17 = {}
class17.__index = class17

function class17.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class17))
end

function class17:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i64)
			v2, v3 = proto.writeDouble(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.DoubleProp_ConditionalOptions.decode(v5)
				}
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readDouble(buf, v2)
				result.kind = { type = "literal", value = v5 }
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

function class17:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = proto.json.serializeNumber(self.kind.value)
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class17.jsonDecode(data)
	local v2 = class17.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(data.literal)
		}
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.DoubleProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class17.descriptor = {
	name = "DoubleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.DoubleProp"
}

v.DoubleProp = class17

typeRegistry.default:register(v.DoubleProp)

local class18 = {}
class18.__index = class18

function class18.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class18))
end

function class18:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i64)
			v2, v3 = proto.writeDouble(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class18.decode(buf: buffer)
	local result = class18.new()
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
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
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
				result.kind = { type = "literal", value = v5 }
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

function class18:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = proto.json.serializeNumber(self.kind.value)
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	elseif self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class18.jsonDecode(data)
	local v2 = class18.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(data.literal)
		}
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	return v2
end

class18.descriptor = {
	name = "DoubleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.DoubleProp_ConditionalOption = class18

typeRegistry.default:register(v.DoubleProp_ConditionalOption)

local class19 = {}
class19.__index = class19

function class19.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class19))
end

function class19:encode()
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

function class19.decode(buf: buffer)
	local v2 = class19.new()
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
				table.insert(v2.options, v.DoubleProp_ConditionalOption.decode(v6))
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

function class19:jsonEncode()
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

function class19.jsonDecode(p)
	local v2 = class19.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.DoubleProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class19.descriptor = {
	name = "DoubleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.DoubleProp_ConditionalOptions = class19

typeRegistry.default:register(v.DoubleProp_ConditionalOptions)

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
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = { type = "literal", value = v5 }
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.Int32Prop_ConditionalOptions.decode(v5)
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
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
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
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.Int32Prop_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class20.descriptor = {
	name = "Int32Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Int32Prop"
}

v.Int32Prop = class20

typeRegistry.default:register(v.Int32Prop)

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
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.kind = { type = "literal", value = v5 }
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
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
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
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	elseif self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class21.jsonDecode(data)
	local v2 = class21.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	return v2
end

class21.descriptor = {
	name = "Int32Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.Int32Prop_ConditionalOption = class21

typeRegistry.default:register(v.Int32Prop_ConditionalOption)

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
				table.insert(v2.options, v.Int32Prop_ConditionalOption.decode(v6))
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
		table.insert(options, v.Int32Prop_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class22.descriptor = {
	name = "Int32Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.Int32Prop_ConditionalOptions = class22

typeRegistry.default:register(v.Int32Prop_ConditionalOptions)

local class23 = {}
class23.__index = class23

function class23.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class23))
end

function class23:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI64(buf, v2)
				result.kind = { type = "literal", value = v5 }
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.Int64Prop_ConditionalOptions.decode(v5)
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

function class23:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class23.jsonDecode(data)
	local v2 = class23.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.Int64Prop_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class23.descriptor = {
	name = "Int64Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Int64Prop"
}

v.Int64Prop = class23

typeRegistry.default:register(v.Int64Prop)

local class24 = {}
class24.__index = class24

function class24.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class24))
end

function class24:encode()
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
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class24.decode(buf: buffer)
	local result = class24.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI64(buf, v2)
				result.kind = { type = "literal", value = v5 }
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
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
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

function class24:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	elseif self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class24.jsonDecode(data)
	local v2 = class24.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	return v2
end

class24.descriptor = {
	name = "Int64Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.Int64Prop_ConditionalOption = class24

typeRegistry.default:register(v.Int64Prop_ConditionalOption)

local class25 = {}
class25.__index = class25

function class25.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class25))
end

function class25:encode()
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

function class25.decode(buf: buffer)
	local v2 = class25.new()
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
				table.insert(v2.options, v.Int64Prop_ConditionalOption.decode(v6))
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

function class25:jsonEncode()
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

function class25.jsonDecode(p)
	local v2 = class25.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.Int64Prop_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class25.descriptor = {
	name = "Int64Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.Int64Prop_ConditionalOptions = class25

typeRegistry.default:register(v.Int64Prop_ConditionalOptions)

local class26 = {}
class26.__index = class26

function class26.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class26))
end

function class26:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value and 1 or 0)
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

function class26.decode(buf: buffer)
	local result = class26.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.kind = {
					type = "literal",
					value = v5 ~= 0
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
					value = v.BoolProp_ConditionalOptions.decode(v5)
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

function class26:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
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

function class26.jsonDecode(data)
	local v2 = class26.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
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
			value = v.BoolProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class26.descriptor = {
	name = "BoolProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.BoolProp"
}

v.BoolProp = class26

typeRegistry.default:register(v.BoolProp)

local class27 = {}
class27.__index = class27

function class27.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class27))
end

function class27:encode()
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
			v2, v3 = proto.writeVarInt(v4, v5, self.kind.value and 1 or 0)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class27.decode(buf: buffer)
	local result = class27.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.kind = {
					type = "literal",
					value = v5 ~= 0
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

function class27:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class27.jsonDecode(data)
	local v2 = class27.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class27.descriptor = {
	name = "BoolProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.BoolProp_ConditionalOption = class27

typeRegistry.default:register(v.BoolProp_ConditionalOption)

local class28 = {}
class28.__index = class28

function class28.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class28))
end

function class28:encode()
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

function class28.decode(buf: buffer)
	local v2 = class28.new()
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
				table.insert(v2.options, v.BoolProp_ConditionalOption.decode(v6))
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

function class28:jsonEncode()
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

function class28.jsonDecode(p)
	local v2 = class28.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.BoolProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class28.descriptor = {
	name = "BoolProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.BoolProp_ConditionalOptions = class28

typeRegistry.default:register(v.BoolProp_ConditionalOptions)

local class29 = {}
class29.__index = class29

function class29.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class29))
end

function class29:encode()
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

function class29.decode(buf: buffer)
	local result = class29.new()
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
				result.kind = { type = "literal", value = struct.Struct.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.StructProp_ConditionalOptions.decode(v5)
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

function class29:jsonEncode()
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

function class29.jsonDecode(data)
	local v2 = class29.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = struct.Struct.jsonDecode(data.literal)
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
			value = v.StructProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class29.descriptor = {
	name = "StructProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.StructProp"
}

v.StructProp = class29

typeRegistry.default:register(v.StructProp)

local class30 = {}
class30.__index = class30

function class30.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class30))
end

function class30:encode()
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

function class30.decode(buf: buffer)
	local result = class30.new()
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
				result.kind = { type = "literal", value = struct.Struct.decode(v5) }
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

function class30:jsonEncode()
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

function class30.jsonDecode(data)
	local v2 = class30.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = struct.Struct.jsonDecode(data.literal)
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

class30.descriptor = {
	name = "StructProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.StructProp_ConditionalOption = class30

typeRegistry.default:register(v.StructProp_ConditionalOption)

local class31 = {}
class31.__index = class31

function class31.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class31))
end

function class31:encode()
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

function class31.decode(buf: buffer)
	local v2 = class31.new()
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
				table.insert(v2.options, v.StructProp_ConditionalOption.decode(v6))
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

function class31:jsonEncode()
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

function class31.jsonDecode(p)
	local v2 = class31.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.StructProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class31.descriptor = {
	name = "StructProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.StructProp_ConditionalOptions = class31

typeRegistry.default:register(v.StructProp_ConditionalOptions)

local class32 = {}
class32.__index = class32

function class32.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	local alt

	if not (p == nil or p.alt == nil) then
		alt = p.alt
	end

	return (setmetatable({ kind = kind, alt = alt }, class32))
end

function class32:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.alt ~= nil then
		local encoded = self.alt:encode()
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ImageStringProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.alt = v.StringFormat.decode(v5)
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

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			v2.literal = self.kind.value
		elseif self.kind.type == "binding_path" then
			v2.bindingPath = self.kind.value
		elseif self.kind.type == "format" then
			v2.format = self.kind.value:jsonEncode()
		elseif self.kind.type == "conditional" then
			v2.conditional = self.kind.value:jsonEncode()
		elseif self.kind.type == "translation" then
			v2.translation = self.kind.value:jsonEncode()
		end
	end

	if self.alt ~= nil then
		v2.alt = self.alt:jsonEncode()
	end

	return v2
end

function class32.jsonDecode(data)
	local v2 = class32.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ImageStringProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	if data.alt ~= nil then
		v2.alt = v.StringFormat.jsonDecode(data.alt)
	end

	return v2
end

class32.descriptor = {
	name = "ImageStringProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageStringProp"
}

v.ImageStringProp = class32

typeRegistry.default:register(v.ImageStringProp)

local class33 = {}
class33.__index = class33

function class33.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class33))
end

function class33:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class33.decode(buf: buffer)
	local result = class33.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
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

function class33:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "format" then
		v2.format = self.kind.value:jsonEncode()
		return v2
	elseif self.kind.type == "translation" then
		v2.translation = self.kind.value:jsonEncode()
	end

	return v2
end

function class33.jsonDecode(data)
	local v2 = class33.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	return v2
end

class33.descriptor = {
	name = "ImageStringProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ImageStringProp_ConditionalOption = class33

typeRegistry.default:register(v.ImageStringProp_ConditionalOption)

local class34 = {}
class34.__index = class34

function class34.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class34))
end

function class34:encode()
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

function class34.decode(buf: buffer)
	local v2 = class34.new()
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
				table.insert(v2.options, v.ImageStringProp_ConditionalOption.decode(v6))
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

function class34:jsonEncode()
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

function class34.jsonDecode(p)
	local v2 = class34.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ImageStringProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class34.descriptor = {
	name = "ImageStringProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ImageStringProp_ConditionalOptions = class34

typeRegistry.default:register(v.ImageStringProp_ConditionalOptions)

local class35 = {}
class35.__index = class35

function class35.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class35))
end

function class35:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ImageSetProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
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

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "format" then
		v2.format = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "translation" then
		v2.translation = self.kind.value:jsonEncode()
	end

	return v2
end

function class35.jsonDecode(data)
	local v2 = class35.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ImageSetProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	return v2
end

class35.descriptor = {
	name = "ImageSetProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageSetProp"
}

v.ImageSetProp = class35

typeRegistry.default:register(v.ImageSetProp)

local class36 = {}
class36.__index = class36

function class36.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class36))
end

function class36:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "format" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "translation" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class36.decode(buf: buffer)
	local result = class36.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "format", value = v.StringFormat.decode(v5) }
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "translation", value = v.TranslationRef.decode(v5) }
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

function class36:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	end

	if self.kind.type == "format" then
		v2.format = self.kind.value:jsonEncode()
		return v2
	elseif self.kind.type == "translation" then
		v2.translation = self.kind.value:jsonEncode()
	end

	return v2
end

function class36.jsonDecode(data)
	local v2 = class36.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	if data.format ~= nil then
		v2.kind = {
			type = "format",
			value = v.StringFormat.jsonDecode(data.format)
		}
	end

	if data.translation ~= nil then
		v2.kind = {
			type = "translation",
			value = v.TranslationRef.jsonDecode(data.translation)
		}
	end

	return v2
end

class36.descriptor = {
	name = "ImageSetProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ImageSetProp_ConditionalOption = class36

typeRegistry.default:register(v.ImageSetProp_ConditionalOption)

local class37 = {}
class37.__index = class37

function class37.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class37))
end

function class37:encode()
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

function class37.decode(buf: buffer)
	local v2 = class37.new()
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
				table.insert(v2.options, v.ImageSetProp_ConditionalOption.decode(v6))
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

function class37:jsonEncode()
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

function class37.jsonDecode(p)
	local v2 = class37.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ImageSetProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class37.descriptor = {
	name = "ImageSetProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ImageSetProp_ConditionalOptions = class37

typeRegistry.default:register(v.ImageSetProp_ConditionalOptions)

local class38 = {}
class38.__index = class38

function class38.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class38))
end

function class38:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class38.decode(buf: buffer)
	local result = class38.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ColorProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class38:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class38.jsonDecode(data)
	local v2 = class38.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ColorProp_ConditionalOptions.jsonDecode(data.conditional)
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

class38.descriptor = {
	name = "ColorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ColorProp"
}

v.ColorProp = class38

typeRegistry.default:register(v.ColorProp)

local class39 = {}
class39.__index = class39

function class39.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class39))
end

function class39:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class39.decode(buf: buffer)
	local result = class39.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class39:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class39.jsonDecode(data)
	local v2 = class39.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class39.descriptor = {
	name = "ColorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ColorProp_ConditionalOption = class39

typeRegistry.default:register(v.ColorProp_ConditionalOption)

local class40 = {}
class40.__index = class40

function class40.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class40))
end

function class40:encode()
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

function class40.decode(buf: buffer)
	local v2 = class40.new()
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
				table.insert(v2.options, v.ColorProp_ConditionalOption.decode(v6))
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

function class40:jsonEncode()
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

function class40.jsonDecode(p)
	local v2 = class40.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ColorProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class40.descriptor = {
	name = "ColorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ColorProp_ConditionalOptions = class40

typeRegistry.default:register(v.ColorProp_ConditionalOptions)

local class41 = {}
class41.__index = class41

function class41.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class41))
end

function class41:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class41.decode(buf: buffer)
	local result = class41.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.TypographyProp_ConditionalOptions.decode(v5)
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

function class41:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class41.jsonDecode(p)
	local v2 = class41.new()

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	if p.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.TypographyProp_ConditionalOptions.jsonDecode(p.conditional)
		}
	end

	return v2
end

class41.descriptor = {
	name = "TypographyProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TypographyProp"
}

v.TypographyProp = class41

typeRegistry.default:register(v.TypographyProp)

local class42 = {}
class42.__index = class42

function class42.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class42))
end

function class42:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil and self.kind.type == "token" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.kind.value)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class42.decode(buf: buffer)
	local result = class42.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
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

function class42:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind ~= nil and self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class42.jsonDecode(p)
	local v2 = class42.new()

	if p.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(p.condition)
	end

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	return v2
end

class42.descriptor = {
	name = "TypographyProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.TypographyProp_ConditionalOption = class42

typeRegistry.default:register(v.TypographyProp_ConditionalOption)

local class43 = {}
class43.__index = class43

function class43.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class43))
end

function class43:encode()
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

function class43.decode(buf: buffer)
	local v2 = class43.new()
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
				table.insert(v2.options, v.TypographyProp_ConditionalOption.decode(v6))
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

function class43:jsonEncode()
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

function class43.jsonDecode(p)
	local v2 = class43.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.TypographyProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class43.descriptor = {
	name = "TypographyProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.TypographyProp_ConditionalOptions = class43

typeRegistry.default:register(v.TypographyProp_ConditionalOptions)

local class44 = {}
class44.__index = class44

function class44.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class44))
end

function class44:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class44.decode(buf: buffer)
	local result = class44.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.TypographyFontProp_ConditionalOptions.decode(v5)
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

function class44:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class44.jsonDecode(p)
	local v2 = class44.new()

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	if p.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.TypographyFontProp_ConditionalOptions.jsonDecode(p.conditional)
		}
	end

	return v2
end

class44.descriptor = {
	name = "TypographyFontProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TypographyFontProp"
}

v.TypographyFontProp = class44

typeRegistry.default:register(v.TypographyFontProp)

local class45 = {}
class45.__index = class45

function class45.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class45))
end

function class45:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil and self.kind.type == "token" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.kind.value)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class45.decode(buf: buffer)
	local result = class45.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
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

function class45:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind ~= nil and self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class45.jsonDecode(p)
	local v2 = class45.new()

	if p.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(p.condition)
	end

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	return v2
end

class45.descriptor = {
	name = "TypographyFontProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.TypographyFontProp_ConditionalOption = class45

typeRegistry.default:register(v.TypographyFontProp_ConditionalOption)

local class46 = {}
class46.__index = class46

function class46.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class46))
end

function class46:encode()
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

function class46.decode(buf: buffer)
	local v2 = class46.new()
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
				table.insert(v2.options, v.TypographyFontProp_ConditionalOption.decode(v6))
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

function class46:jsonEncode()
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

function class46.jsonDecode(p)
	local v2 = class46.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.TypographyFontProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class46.descriptor = {
	name = "TypographyFontProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.TypographyFontProp_ConditionalOptions = class46

typeRegistry.default:register(v.TypographyFontProp_ConditionalOptions)

local class47 = {}
class47.__index = class47

function class47.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class47))
end

function class47:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class47.decode(buf: buffer)
	local result = class47.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.ColorStyleProp_ConditionalOptions.decode(v5)
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

function class47:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class47.jsonDecode(p)
	local v2 = class47.new()

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	if p.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.ColorStyleProp_ConditionalOptions.jsonDecode(p.conditional)
		}
	end

	return v2
end

class47.descriptor = {
	name = "ColorStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ColorStyleProp"
}

v.ColorStyleProp = class47

typeRegistry.default:register(v.ColorStyleProp)

local class48 = {}
class48.__index = class48

function class48.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class48))
end

function class48:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil and self.kind.type == "token" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.kind.value)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class48.decode(buf: buffer)
	local result = class48.new()
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
				result.kind = { type = "token", value = buffer.tostring(v5) }
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

function class48:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind ~= nil and self.kind.type == "token" then
		v2.token = self.kind.value
	end

	return v2
end

function class48.jsonDecode(p)
	local v2 = class48.new()

	if p.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(p.condition)
	end

	if p.token ~= nil then
		v2.kind = { type = "token", value = p.token }
	end

	return v2
end

class48.descriptor = {
	name = "ColorStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ColorStyleProp_ConditionalOption = class48

typeRegistry.default:register(v.ColorStyleProp_ConditionalOption)

local class49 = {}
class49.__index = class49

function class49.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class49))
end

function class49:encode()
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

function class49.decode(buf: buffer)
	local v2 = class49.new()
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
				table.insert(v2.options, v.ColorStyleProp_ConditionalOption.decode(v6))
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

function class49:jsonEncode()
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

function class49.jsonDecode(p)
	local v2 = class49.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ColorStyleProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class49.descriptor = {
	name = "ColorStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ColorStyleProp_ConditionalOptions = class49

typeRegistry.default:register(v.ColorStyleProp_ConditionalOptions)

local class50 = {}
class50.__index = class50

function class50.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class50))
end

function class50:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
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

function class50.decode(buf: buffer)
	local result = class50.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.FillBehaviorProp_ConditionalOptions.decode(v5)
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

function class50:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class50.jsonDecode(data)
	local v2 = class50.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.FillBehaviorProp_ConditionalOptions.jsonDecode(data.conditional)
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

class50.descriptor = {
	name = "FillBehaviorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FillBehaviorProp"
}

v.FillBehaviorProp = class50

typeRegistry.default:register(v.FillBehaviorProp)

local class51 = {}
class51.__index = class51

function class51.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class51))
end

function class51:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class51.decode(buf: buffer)
	local result = class51.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
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

function class51:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class51.jsonDecode(data)
	local v2 = class51.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class51.descriptor = {
	name = "FillBehaviorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.FillBehaviorProp_ConditionalOption = class51

typeRegistry.default:register(v.FillBehaviorProp_ConditionalOption)

local class52 = {}
class52.__index = class52

function class52.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class52))
end

function class52:encode()
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

function class52.decode(buf: buffer)
	local v2 = class52.new()
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
				table.insert(v2.options, v.FillBehaviorProp_ConditionalOption.decode(v6))
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

function class52:jsonEncode()
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

function class52.jsonDecode(p)
	local v2 = class52.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.FillBehaviorProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class52.descriptor = {
	name = "FillBehaviorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.FillBehaviorProp_ConditionalOptions = class52

typeRegistry.default:register(v.FillBehaviorProp_ConditionalOptions)

local class53 = {}
class53.__index = class53

function class53.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class53))
end

function class53:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
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

function class53.decode(buf: buffer)
	local result = class53.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.InputSizeProp_ConditionalOptions.decode(v5)
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

function class53:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class53.jsonDecode(data)
	local v2 = class53.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.InputSizeProp_ConditionalOptions.jsonDecode(data.conditional)
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

class53.descriptor = {
	name = "InputSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.InputSizeProp"
}

v.InputSizeProp = class53

typeRegistry.default:register(v.InputSizeProp)

local class54 = {}
class54.__index = class54

function class54.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class54))
end

function class54:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class54.decode(buf: buffer)
	local result = class54.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
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

function class54:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class54.jsonDecode(data)
	local v2 = class54.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class54.descriptor = {
	name = "InputSizeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.InputSizeProp_ConditionalOption = class54

typeRegistry.default:register(v.InputSizeProp_ConditionalOption)

local class55 = {}
class55.__index = class55

function class55.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class55))
end

function class55:encode()
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

function class55.decode(buf: buffer)
	local v2 = class55.new()
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
				table.insert(v2.options, v.InputSizeProp_ConditionalOption.decode(v6))
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

function class55:jsonEncode()
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

function class55.jsonDecode(p)
	local v2 = class55.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.InputSizeProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class55.descriptor = {
	name = "InputSizeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.InputSizeProp_ConditionalOptions = class55

typeRegistry.default:register(v.InputSizeProp_ConditionalOptions)

local class56 = {}
class56.__index = class56

function class56.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class56))
end

function class56:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class56.decode(buf: buffer)
	local result = class56.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UDimProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class56:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class56.jsonDecode(data)
	local v2 = class56.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UDimProp_ConditionalOptions.jsonDecode(data.conditional)
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

class56.descriptor = {
	name = "UDimProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UDimProp"
}

v.UDimProp = class56

typeRegistry.default:register(v.UDimProp)

local class57 = {}
class57.__index = class57

function class57.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class57))
end

function class57:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class57.decode(buf: buffer)
	local result = class57.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class57:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class57.jsonDecode(data)
	local v2 = class57.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class57.descriptor = {
	name = "UDimProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UDimProp_ConditionalOption = class57

typeRegistry.default:register(v.UDimProp_ConditionalOption)

local class58 = {}
class58.__index = class58

function class58.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class58))
end

function class58:encode()
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

function class58.decode(buf: buffer)
	local v2 = class58.new()
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
				table.insert(v2.options, v.UDimProp_ConditionalOption.decode(v6))
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

function class58:jsonEncode()
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

function class58.jsonDecode(p)
	local v2 = class58.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UDimProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class58.descriptor = {
	name = "UDimProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UDimProp_ConditionalOptions = class58

typeRegistry.default:register(v.UDimProp_ConditionalOptions)

local class59 = {}
class59.__index = class59

function class59.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class59))
end

function class59:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class59.decode(buf: buffer)
	local result = class59.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UDim2Prop_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class59:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class59.jsonDecode(data)
	local v2 = class59.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UDim2Prop_ConditionalOptions.jsonDecode(data.conditional)
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

class59.descriptor = {
	name = "UDim2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.UDim2Prop"
}

v.UDim2Prop = class59

typeRegistry.default:register(v.UDim2Prop)

local class60 = {}
class60.__index = class60

function class60.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class60))
end

function class60:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class60.decode(buf: buffer)
	local result = class60.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class60:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class60.jsonDecode(data)
	local v2 = class60.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class60.descriptor = {
	name = "UDim2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UDim2Prop_ConditionalOption = class60

typeRegistry.default:register(v.UDim2Prop_ConditionalOption)

local class61 = {}
class61.__index = class61

function class61.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class61))
end

function class61:encode()
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

function class61.decode(buf: buffer)
	local v2 = class61.new()
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
				table.insert(v2.options, v.UDim2Prop_ConditionalOption.decode(v6))
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

function class61:jsonEncode()
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

function class61.jsonDecode(p)
	local v2 = class61.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UDim2Prop_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class61.descriptor = {
	name = "UDim2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UDim2Prop_ConditionalOptions = class61

typeRegistry.default:register(v.UDim2Prop_ConditionalOptions)

local class62 = {}
class62.__index = class62

function class62.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class62))
end

function class62:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class62.decode(buf: buffer)
	local result = class62.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.Vector2Prop_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class62:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class62.jsonDecode(data)
	local v2 = class62.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.Vector2Prop_ConditionalOptions.jsonDecode(data.conditional)
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

class62.descriptor = {
	name = "Vector2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Vector2Prop"
}

v.Vector2Prop = class62

typeRegistry.default:register(v.Vector2Prop)

local class63 = {}
class63.__index = class63

function class63.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class63))
end

function class63:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class63.decode(buf: buffer)
	local result = class63.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class63:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class63.jsonDecode(data)
	local v2 = class63.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class63.descriptor = {
	name = "Vector2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.Vector2Prop_ConditionalOption = class63

typeRegistry.default:register(v.Vector2Prop_ConditionalOption)

local class64 = {}
class64.__index = class64

function class64.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class64))
end

function class64:encode()
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

function class64.decode(buf: buffer)
	local v2 = class64.new()
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
				table.insert(v2.options, v.Vector2Prop_ConditionalOption.decode(v6))
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

function class64:jsonEncode()
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

function class64.jsonDecode(p)
	local v2 = class64.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.Vector2Prop_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class64.descriptor = {
	name = "Vector2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.Vector2Prop_ConditionalOptions = class64

typeRegistry.default:register(v.Vector2Prop_ConditionalOptions)

local class65 = {}
class65.__index = class65

function class65.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class65))
end

function class65:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
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

function class65.decode(buf: buffer)
	local result = class65.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.IconProp_ConditionalOptions.decode(v5)
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

function class65:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
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

function class65.jsonDecode(data)
	local v2 = class65.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
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
			value = v.IconProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class65.descriptor = {
	name = "IconProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.IconProp"
}

v.IconProp = class65

typeRegistry.default:register(v.IconProp)

local class66 = {}
class66.__index = class66

function class66.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class66))
end

function class66:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class66.decode(buf: buffer)
	local result = class66.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
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

function class66:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class66.jsonDecode(data)
	local v2 = class66.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class66.descriptor = {
	name = "IconProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.IconProp_ConditionalOption = class66

typeRegistry.default:register(v.IconProp_ConditionalOption)

local class67 = {}
class67.__index = class67

function class67.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class67))
end

function class67:encode()
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

function class67.decode(buf: buffer)
	local v2 = class67.new()
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
				table.insert(v2.options, v.IconProp_ConditionalOption.decode(v6))
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

function class67:jsonEncode()
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

function class67.jsonDecode(p)
	local v2 = class67.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.IconProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class67.descriptor = {
	name = "IconProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.IconProp_ConditionalOptions = class67

typeRegistry.default:register(v.IconProp_ConditionalOptions)

local class68 = {}
class68.__index = class68

function class68.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class68))
end

function class68:encode()
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

function class68.decode(buf: buffer)
	local result = class68.new()
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
					value = v.FoundationIconConfigProp_FoundationIconConfig.decode(v5)
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
					value = v.FoundationIconConfigProp_ConditionalOptions.decode(v5)
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

function class68:jsonEncode()
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

function class68.jsonDecode(data)
	local v2 = class68.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.FoundationIconConfigProp_FoundationIconConfig.jsonDecode(data.literal)
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
			value = v.FoundationIconConfigProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class68.descriptor = {
	name = "FoundationIconConfigProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FoundationIconConfigProp"
}

v.FoundationIconConfigProp = class68

typeRegistry.default:register(v.FoundationIconConfigProp)

local class69 = {}
class69.__index = class69

function class69.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class69))
end

function class69:encode()
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

function class69.decode(buf: buffer)
	local result = class69.new()
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
					value = v.FoundationIconConfigProp_FoundationIconConfig.decode(v5)
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

function class69:jsonEncode()
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

function class69.jsonDecode(data)
	local v2 = class69.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.FoundationIconConfigProp_FoundationIconConfig.jsonDecode(data.literal)
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

class69.descriptor = {
	name = "FoundationIconConfigProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.FoundationIconConfigProp_ConditionalOption = class69

typeRegistry.default:register(v.FoundationIconConfigProp_ConditionalOption)

local class70 = {}
class70.__index = class70

function class70.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class70))
end

function class70:encode()
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

function class70.decode(buf: buffer)
	local v2 = class70.new()
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
				table.insert(v2.options, v.FoundationIconConfigProp_ConditionalOption.decode(v6))
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

function class70:jsonEncode()
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

function class70.jsonDecode(p)
	local v2 = class70.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.FoundationIconConfigProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class70.descriptor = {
	name = "FoundationIconConfigProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.FoundationIconConfigProp_ConditionalOptions = class70

typeRegistry.default:register(v.FoundationIconConfigProp_ConditionalOptions)

local class71 = {}
class71.__index = class71

function class71.new(p)
	local name

	if not (p == nil or p.name == nil) then
		name = p.name
	end

	local variant

	if not (p == nil or p.variant == nil) then
		variant = p.variant
	end

	return (setmetatable({ name = name, variant = variant }, class71))
end

function class71:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.name ~= nil then
		local encoded = self.name:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.variant ~= nil then
		local encoded = self.variant:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class71.decode(buf: buffer)
	local result = class71.new()
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
				result.name = v.StringProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.variant = v.StringProp.decode(v5)
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

function class71:jsonEncode()
	local v2 = {}

	if self.name ~= nil then
		v2.name = self.name:jsonEncode()
	end

	if self.variant ~= nil then
		v2.variant = self.variant:jsonEncode()
	end

	return v2
end

function class71.jsonDecode(p)
	local v2 = class71.new()

	if p.name ~= nil then
		v2.name = v.StringProp.jsonDecode(p.name)
	end

	if p.variant ~= nil then
		v2.variant = v.StringProp.jsonDecode(p.variant)
	end

	return v2
end

class71.descriptor = {
	name = "FoundationIconConfigProp_FoundationIconConfig",
	fullName = "roblox.apppageplatform.shared.v1beta1.FoundationIconConfig"
}

v.FoundationIconConfigProp_FoundationIconConfig = class71

typeRegistry.default:register(v.FoundationIconConfigProp_FoundationIconConfig)

local class72 = {}
class72.__index = class72

function class72.new(p)
	local oneof_prop

	if not (p == nil or p.oneof_prop == nil) then
		oneof_prop = p.oneof_prop
	end

	return (setmetatable({ oneof_prop = oneof_prop }, class72))
end

function class72:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.oneof_prop ~= nil then
		if self.oneof_prop.type == "string_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "int32_prop" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class72.decode(buf: buffer)
	local result = class72.new()
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
				result.oneof_prop = { type = "string_prop", value = v.StringProp.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = { type = "int32_prop", value = v.Int32Prop.decode(v5) }
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

function class72:jsonEncode()
	local v2 = {}

	if self.oneof_prop == nil then
		return v2
	end

	if self.oneof_prop.type == "string_prop" then
		v2.stringProp = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "int32_prop" then
		v2.int32Prop = self.oneof_prop.value:jsonEncode()
	end

	return v2
end

function class72.jsonDecode(data)
	local v2 = class72.new()

	if data.string_prop ~= nil then
		v2.oneof_prop = {
			type = "string_prop",
			value = v.StringProp.jsonDecode(data.string_prop)
		}
	end

	if data.stringProp ~= nil then
		v2.oneof_prop = {
			type = "string_prop",
			value = v.StringProp.jsonDecode(data.stringProp)
		}
	end

	if data.int32_prop ~= nil then
		v2.oneof_prop = {
			type = "int32_prop",
			value = v.Int32Prop.jsonDecode(data.int32_prop)
		}
	end

	if data.int32Prop ~= nil then
		v2.oneof_prop = {
			type = "int32_prop",
			value = v.Int32Prop.jsonDecode(data.int32Prop)
		}
	end

	return v2
end

class72.descriptor = {
	name = "IconSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.IconSizeProp"
}

v.IconSizeProp = class72

typeRegistry.default:register(v.IconSizeProp)

local class73 = {}
class73.__index = class73

function class73.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class73))
end

function class73:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "conditional" then
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

function class73.decode(buf: buffer)
	local result = class73.new()
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
					value = v.GradientProp_GradientData.decode(v5)
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.GradientProp_ConditionalOptions.decode(v5)
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

function class73:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class73.jsonDecode(data)
	local v2 = class73.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.GradientProp_GradientData.jsonDecode(data.literal)
		}
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.GradientProp_ConditionalOptions.jsonDecode(data.conditional)
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

class73.descriptor = {
	name = "GradientProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.GradientProp"
}

v.GradientProp = class73

typeRegistry.default:register(v.GradientProp)

local class74 = {}
class74.__index = class74

function class74.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class74))
end

function class74:encode()
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

function class74.decode(buf: buffer)
	local result = class74.new()
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
					value = v.GradientProp_GradientData.decode(v5)
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

function class74:jsonEncode()
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

function class74.jsonDecode(data)
	local v2 = class74.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.GradientProp_GradientData.jsonDecode(data.literal)
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

class74.descriptor = {
	name = "GradientProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.GradientProp_ConditionalOption = class74

typeRegistry.default:register(v.GradientProp_ConditionalOption)

local class75 = {}
class75.__index = class75

function class75.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class75))
end

function class75:encode()
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

function class75.decode(buf: buffer)
	local v2 = class75.new()
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
				table.insert(v2.options, v.GradientProp_ConditionalOption.decode(v6))
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

function class75:jsonEncode()
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

function class75.jsonDecode(p)
	local v2 = class75.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.GradientProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class75.descriptor = {
	name = "GradientProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.GradientProp_ConditionalOptions = class75

typeRegistry.default:register(v.GradientProp_ConditionalOptions)

local class76 = {}
class76.__index = class76

function class76.new(data)
	return (setmetatable({
		start_color = (data == nil or data.start_color == nil) and "" or data.start_color,
		end_color = (data == nil or data.end_color == nil) and "" or data.end_color,
		start_opacity = (data == nil or data.start_opacity == nil) and 0 or data.start_opacity,
		end_opacity = (data == nil or data.end_opacity == nil) and 0 or data.end_opacity,
		degree = (data == nil or data.degree == nil) and 0 or data.degree,
		midpoint_percent = (data == nil or data.midpoint_percent == nil) and 0 or data.midpoint_percent
	}, class76))
end

function class76:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.start_color ~= nil and self.start_color ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.start_color)
	end

	if self.end_color ~= nil and self.end_color ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.end_color)
	end

	if self.start_opacity ~= nil and self.start_opacity ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.start_opacity)
	end

	if self.end_opacity ~= nil and self.end_opacity ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.end_opacity)
	end

	if self.degree ~= nil and self.degree ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.degree)
	end

	if self.midpoint_percent ~= nil and self.midpoint_percent ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.midpoint_percent)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class76.decode(buf: buffer)
	local result = class76.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 5 then
				local degree
				degree, v2 = proto.readVarIntI32(buf, v2)
				result.degree = degree
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.start_color = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.end_color = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 3 then
				local start_opacity
				start_opacity, v2 = proto.readFloat(buf, v2)
				result.start_opacity = start_opacity
			elseif v3 == 4 then
				local end_opacity
				end_opacity, v2 = proto.readFloat(buf, v2)
				result.end_opacity = end_opacity
			elseif v3 == 6 then
				local midpoint_percent
				midpoint_percent, v2 = proto.readFloat(buf, v2)
				result.midpoint_percent = midpoint_percent
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class76:jsonEncode()
	local v2 = {}

	if self.start_color ~= nil and self.start_color ~= "" then
		v2.startColor = self.start_color
	end

	if self.end_color ~= nil and self.end_color ~= "" then
		v2.endColor = self.end_color
	end

	if self.start_opacity ~= nil and self.start_opacity ~= 0 then
		v2.startOpacity = proto.json.serializeNumber(self.start_opacity)
	end

	if self.end_opacity ~= nil and self.end_opacity ~= 0 then
		v2.endOpacity = proto.json.serializeNumber(self.end_opacity)
	end

	if self.degree ~= nil and self.degree ~= 0 then
		v2.degree = self.degree
	end

	if self.midpoint_percent ~= nil and self.midpoint_percent ~= 0 then
		v2.midpointPercent = proto.json.serializeNumber(self.midpoint_percent)
	end

	return v2
end

function class76.jsonDecode(data)
	local v2 = class76.new()

	if data.start_color ~= nil then
		v2.start_color = data.start_color
	end

	if data.startColor ~= nil then
		v2.start_color = data.startColor
	end

	if data.end_color ~= nil then
		v2.end_color = data.end_color
	end

	if data.endColor ~= nil then
		v2.end_color = data.endColor
	end

	if data.start_opacity ~= nil then
		v2.start_opacity = proto.json.deserializeNumber(data.start_opacity)
	end

	if data.startOpacity ~= nil then
		v2.start_opacity = proto.json.deserializeNumber(data.startOpacity)
	end

	if data.end_opacity ~= nil then
		v2.end_opacity = proto.json.deserializeNumber(data.end_opacity)
	end

	if data.endOpacity ~= nil then
		v2.end_opacity = proto.json.deserializeNumber(data.endOpacity)
	end

	if data.degree ~= nil then
		v2.degree = data.degree
	end

	if data.midpoint_percent ~= nil then
		v2.midpoint_percent = proto.json.deserializeNumber(data.midpoint_percent)
	end

	if data.midpointPercent ~= nil then
		v2.midpoint_percent = proto.json.deserializeNumber(data.midpointPercent)
	end

	return v2
end

class76.descriptor = {
	name = "GradientProp_GradientData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GradientData"
}

v.GradientProp_GradientData = class76

typeRegistry.default:register(v.GradientProp_GradientData)

local class77 = {}
class77.__index = class77

function class77.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class77))
end

function class77:encode()
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

function class77.decode(buf: buffer)
	local result = class77.new()
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
					value = v.ArrayOfStructProp_ArrayOfStructs.decode(v5)
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
					value = v.ArrayOfStructProp_ConditionalOptions.decode(v5)
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

function class77:jsonEncode()
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

function class77.jsonDecode(data)
	local v2 = class77.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfStructProp_ArrayOfStructs.jsonDecode(data.literal)
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
			value = v.ArrayOfStructProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class77.descriptor = {
	name = "ArrayOfStructProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfStructProp"
}

v.ArrayOfStructProp = class77

typeRegistry.default:register(v.ArrayOfStructProp)

local class78 = {}
class78.__index = class78

function class78.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class78))
end

function class78:encode()
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

function class78.decode(buf: buffer)
	local result = class78.new()
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
					value = v.ArrayOfStructProp_ArrayOfStructs.decode(v5)
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

function class78:jsonEncode()
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

function class78.jsonDecode(data)
	local v2 = class78.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfStructProp_ArrayOfStructs.jsonDecode(data.literal)
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

class78.descriptor = {
	name = "ArrayOfStructProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfStructProp_ConditionalOption = class78

typeRegistry.default:register(v.ArrayOfStructProp_ConditionalOption)

local class79 = {}
class79.__index = class79

function class79.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class79))
end

function class79:encode()
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

function class79.decode(buf: buffer)
	local v2 = class79.new()
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
				table.insert(v2.options, v.ArrayOfStructProp_ConditionalOption.decode(v6))
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

function class79:jsonEncode()
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

function class79.jsonDecode(p)
	local v2 = class79.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ArrayOfStructProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class79.descriptor = {
	name = "ArrayOfStructProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfStructProp_ConditionalOptions = class79

typeRegistry.default:register(v.ArrayOfStructProp_ConditionalOptions)

local class80 = {}
class80.__index = class80

function class80.new(p)
	return (setmetatable({
		entry = (p == nil or p.entry == nil) and {} or p.entry
	}, class80))
end

function class80:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.entry ~= nil and #self.entry > 0 then
		for _, v4 in self.entry do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class80.decode(buf: buffer)
	local v2 = class80.new()
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
				table.insert(v2.entry, struct.Struct.decode(v6))
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

function class80:jsonEncode()
	local v2 = {}

	if self.entry == nil or not (#self.entry > 0) then
		return v2
	end

	local entry = {}

	for _, v3 in self.entry do
		table.insert(entry, v3:jsonEncode())
	end

	v2.entry = entry

	return v2
end

function class80.jsonDecode(p)
	local v2 = class80.new()

	if p.entry == nil then
		return v2
	end

	local entry = {}

	for _, v3 in p.entry do
		table.insert(entry, struct.Struct.jsonDecode(v3))
	end

	v2.entry = entry

	return v2
end

class80.descriptor = {
	name = "ArrayOfStructProp_ArrayOfStructs",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfStructs"
}

v.ArrayOfStructProp_ArrayOfStructs = class80

typeRegistry.default:register(v.ArrayOfStructProp_ArrayOfStructs)

local class81 = {}
class81.__index = class81

function class81.new(data)
	local v2 = {
		item_id = (data == nil or data.item_id == nil) and "" or data.item_id,
		has_pending_friend_request = data ~= nil and data.has_pending_friend_request ~= nil and data.has_pending_friend_request,
		is_seed_user_friend = data ~= nil and data.is_seed_user_friend ~= nil and data.is_seed_user_friend
	}
	return (setmetatable(v2, class81))
end

function class81:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.item_id ~= nil and self.item_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.item_id)
	end

	if self.has_pending_friend_request then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.has_pending_friend_request and 1 or 0)
	end

	if self.is_seed_user_friend then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_seed_user_friend and 1 or 0)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class81.decode(buf: buffer)
	local result = class81.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.has_pending_friend_request = v5 ~= 0
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_seed_user_friend = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.item_id = buffer.tostring(v5)
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

function class81:jsonEncode()
	local v2 = {}

	if self.item_id ~= nil and self.item_id ~= "" then
		v2.itemId = self.item_id
	end

	if self.has_pending_friend_request then
		v2.hasPendingFriendRequest = self.has_pending_friend_request
	end

	if self.is_seed_user_friend then
		v2.isSeedUserFriend = self.is_seed_user_friend
	end

	return v2
end

function class81.jsonDecode(data)
	local v2 = class81.new()

	if data.item_id ~= nil then
		v2.item_id = data.item_id
	end

	if data.itemId ~= nil then
		v2.item_id = data.itemId
	end

	if data.has_pending_friend_request ~= nil then
		v2.has_pending_friend_request = data.has_pending_friend_request
	end

	if data.hasPendingFriendRequest ~= nil then
		v2.has_pending_friend_request = data.hasPendingFriendRequest
	end

	if data.is_seed_user_friend ~= nil then
		v2.is_seed_user_friend = data.is_seed_user_friend
	end

	if data.isSeedUserFriend ~= nil then
		v2.is_seed_user_friend = data.isSeedUserFriend
	end

	return v2
end

class81.descriptor = {
	name = "PymkItemData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PymkItemData"
}

v.PymkItemData = class81

typeRegistry.default:register(v.PymkItemData)

local class82 = {}
class82.__index = class82

function class82.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class82))
end

function class82:encode()
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

function class82.decode(buf: buffer)
	local result = class82.new()
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
					value = v.ArrayOfPymkItemDataProp_PymkItems.decode(v5)
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
					value = v.ArrayOfPymkItemDataProp_ConditionalOptions.decode(v5)
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

function class82:jsonEncode()
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

function class82.jsonDecode(data)
	local v2 = class82.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfPymkItemDataProp_PymkItems.jsonDecode(data.literal)
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
			value = v.ArrayOfPymkItemDataProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class82.descriptor = {
	name = "ArrayOfPymkItemDataProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfPymkItemDataProp"
}

v.ArrayOfPymkItemDataProp = class82

typeRegistry.default:register(v.ArrayOfPymkItemDataProp)

local class83 = {}
class83.__index = class83

function class83.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class83))
end

function class83:encode()
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

function class83.decode(buf: buffer)
	local result = class83.new()
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
					value = v.ArrayOfPymkItemDataProp_PymkItems.decode(v5)
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

function class83:jsonEncode()
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

function class83.jsonDecode(data)
	local v2 = class83.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfPymkItemDataProp_PymkItems.jsonDecode(data.literal)
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

class83.descriptor = {
	name = "ArrayOfPymkItemDataProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfPymkItemDataProp_ConditionalOption = class83

typeRegistry.default:register(v.ArrayOfPymkItemDataProp_ConditionalOption)

local class84 = {}
class84.__index = class84

function class84.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class84))
end

function class84:encode()
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

function class84.decode(buf: buffer)
	local v2 = class84.new()
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
				table.insert(v2.options, v.ArrayOfPymkItemDataProp_ConditionalOption.decode(v6))
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

function class84:jsonEncode()
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

function class84.jsonDecode(p)
	local v2 = class84.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ArrayOfPymkItemDataProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class84.descriptor = {
	name = "ArrayOfPymkItemDataProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfPymkItemDataProp_ConditionalOptions = class84

typeRegistry.default:register(v.ArrayOfPymkItemDataProp_ConditionalOptions)

local class85 = {}
class85.__index = class85

function class85.new(p)
	return (setmetatable({
		items = (p == nil or p.items == nil) and {} or p.items
	}, class85))
end

function class85:encode()
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

function class85.decode(buf: buffer)
	local v2 = class85.new()
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
				table.insert(v2.items, v.PymkItemData.decode(v6))
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

function class85:jsonEncode()
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

function class85.jsonDecode(p)
	local v2 = class85.new()

	if p.items == nil then
		return v2
	end

	local items = {}

	for _, item in p.items do
		table.insert(items, v.PymkItemData.jsonDecode(item))
	end

	v2.items = items

	return v2
end

class85.descriptor = {
	name = "ArrayOfPymkItemDataProp_PymkItems",
	fullName = "roblox.apppageplatform.shared.v1beta1.PymkItems"
}

v.ArrayOfPymkItemDataProp_PymkItems = class85

typeRegistry.default:register(v.ArrayOfPymkItemDataProp_PymkItems)

local class86 = {}
class86.__index = class86

function class86.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class86))
end

function class86:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class86.decode(buf: buffer)
	local result = class86.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UiScaledFloatProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class86:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class86.jsonDecode(data)
	local v2 = class86.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UiScaledFloatProp_ConditionalOptions.jsonDecode(data.conditional)
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

class86.descriptor = {
	name = "UiScaledFloatProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledFloatProp"
}

v.UiScaledFloatProp = class86

typeRegistry.default:register(v.UiScaledFloatProp)

local class87 = {}
class87.__index = class87

function class87.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class87))
end

function class87:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class87.decode(buf: buffer)
	local result = class87.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class87:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class87.jsonDecode(data)
	local v2 = class87.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class87.descriptor = {
	name = "UiScaledFloatProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UiScaledFloatProp_ConditionalOption = class87

typeRegistry.default:register(v.UiScaledFloatProp_ConditionalOption)

local class88 = {}
class88.__index = class88

function class88.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class88))
end

function class88:encode()
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

function class88.decode(buf: buffer)
	local v2 = class88.new()
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
				table.insert(v2.options, v.UiScaledFloatProp_ConditionalOption.decode(v6))
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

function class88:jsonEncode()
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

function class88.jsonDecode(p)
	local v2 = class88.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UiScaledFloatProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class88.descriptor = {
	name = "UiScaledFloatProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UiScaledFloatProp_ConditionalOptions = class88

typeRegistry.default:register(v.UiScaledFloatProp_ConditionalOptions)

local class89 = {}
class89.__index = class89

function class89.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class89))
end

function class89:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class89.decode(buf: buffer)
	local result = class89.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UiScaledUDimProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class89:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class89.jsonDecode(data)
	local v2 = class89.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UiScaledUDimProp_ConditionalOptions.jsonDecode(data.conditional)
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

class89.descriptor = {
	name = "UiScaledUDimProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledUDimProp"
}

v.UiScaledUDimProp = class89

typeRegistry.default:register(v.UiScaledUDimProp)

local class90 = {}
class90.__index = class90

function class90.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class90))
end

function class90:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class90.decode(buf: buffer)
	local result = class90.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class90:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class90.jsonDecode(data)
	local v2 = class90.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class90.descriptor = {
	name = "UiScaledUDimProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UiScaledUDimProp_ConditionalOption = class90

typeRegistry.default:register(v.UiScaledUDimProp_ConditionalOption)

local class91 = {}
class91.__index = class91

function class91.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class91))
end

function class91:encode()
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

function class91.decode(buf: buffer)
	local v2 = class91.new()
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
				table.insert(v2.options, v.UiScaledUDimProp_ConditionalOption.decode(v6))
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

function class91:jsonEncode()
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

function class91.jsonDecode(p)
	local v2 = class91.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UiScaledUDimProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class91.descriptor = {
	name = "UiScaledUDimProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UiScaledUDimProp_ConditionalOptions = class91

typeRegistry.default:register(v.UiScaledUDimProp_ConditionalOptions)

local class92 = {}
class92.__index = class92

function class92.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class92))
end

function class92:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class92.decode(buf: buffer)
	local result = class92.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.UiScaledUDim2Prop_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
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

function class92:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	end

	if self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class92.jsonDecode(data)
	local v2 = class92.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.conditional ~= nil then
		v2.kind = {
			type = "conditional",
			value = v.UiScaledUDim2Prop_ConditionalOptions.jsonDecode(data.conditional)
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

class92.descriptor = {
	name = "UiScaledUDim2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledUDim2Prop"
}

v.UiScaledUDim2Prop = class92

typeRegistry.default:register(v.UiScaledUDim2Prop)

local class93 = {}
class93.__index = class93

function class93.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class93))
end

function class93:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.condition ~= nil then
		local encoded = self.condition:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "token" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class93.decode(buf: buffer)
	local result = class93.new()
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
				result.kind = { type = "literal", value = buffer.tostring(v5) }
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "token", value = buffer.tostring(v5) }
			elseif v3 == 4 then
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

function class93:jsonEncode()
	local v2 = {}

	if self.condition ~= nil then
		v2.condition = self.condition:jsonEncode()
	end

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "token" then
		v2.token = self.kind.value
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class93.jsonDecode(data)
	local v2 = class93.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.token ~= nil then
		v2.kind = { type = "token", value = data.token }
	end

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
	end

	return v2
end

class93.descriptor = {
	name = "UiScaledUDim2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.UiScaledUDim2Prop_ConditionalOption = class93

typeRegistry.default:register(v.UiScaledUDim2Prop_ConditionalOption)

local class94 = {}
class94.__index = class94

function class94.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class94))
end

function class94:encode()
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

function class94.decode(buf: buffer)
	local v2 = class94.new()
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
				table.insert(v2.options, v.UiScaledUDim2Prop_ConditionalOption.decode(v6))
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

function class94:jsonEncode()
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

function class94.jsonDecode(p)
	local v2 = class94.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.UiScaledUDim2Prop_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class94.descriptor = {
	name = "UiScaledUDim2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.UiScaledUDim2Prop_ConditionalOptions = class94

typeRegistry.default:register(v.UiScaledUDim2Prop_ConditionalOptions)

local class95 = {}
class95.__index = class95

function class95.new(p)
	local user_id

	if not (p == nil or p.user_id == nil) then
		user_id = p.user_id
	end

	local user_presence

	if not (p == nil or p.user_presence == nil) then
		user_presence = p.user_presence
	end

	return (setmetatable({ user_id = user_id, user_presence = user_presence }, class95))
end

function class95:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.user_id ~= nil then
		local encoded = self.user_id:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.user_presence ~= nil then
		local encoded = self.user_presence:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class95.decode(buf: buffer)
	local result = class95.new()
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
				result.user_id = v.Int64Prop.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.user_presence = v.StringProp.decode(v5)
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

function class95:jsonEncode()
	local v2 = {}

	if self.user_id ~= nil then
		v2.userId = self.user_id:jsonEncode()
	end

	if self.user_presence ~= nil then
		v2.userPresence = self.user_presence:jsonEncode()
	end

	return v2
end

function class95.jsonDecode(data)
	local v2 = class95.new()

	if data.user_id ~= nil then
		v2.user_id = v.Int64Prop.jsonDecode(data.user_id)
	end

	if data.userId ~= nil then
		v2.user_id = v.Int64Prop.jsonDecode(data.userId)
	end

	if data.user_presence ~= nil then
		v2.user_presence = v.StringProp.jsonDecode(data.user_presence)
	end

	if data.userPresence ~= nil then
		v2.user_presence = v.StringProp.jsonDecode(data.userPresence)
	end

	return v2
end

class95.descriptor = {
	name = "AvatarConfigProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AvatarConfigProp"
}

v.AvatarConfigProp = class95

typeRegistry.default:register(v.AvatarConfigProp)

local class96 = {}
class96.__index = class96

function class96.new(p)
	local oneof_prop

	if not (p == nil or p.oneof_prop == nil) then
		oneof_prop = p.oneof_prop
	end

	return (setmetatable({ oneof_prop = oneof_prop }, class96))
end

function class96:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.oneof_prop ~= nil then
		if self.oneof_prop.type == "user_id" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "avatar_config" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class96.decode(buf: buffer)
	local result = class96.new()
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
				result.oneof_prop = { type = "user_id", value = v.Int64Prop.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "avatar_config",
					value = v.AvatarConfigProp.decode(v5)
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

function class96:jsonEncode()
	local v2 = {}

	if self.oneof_prop == nil then
		return v2
	end

	if self.oneof_prop.type == "user_id" then
		v2.userId = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "avatar_config" then
		v2.avatarConfig = self.oneof_prop.value:jsonEncode()
	end

	return v2
end

function class96.jsonDecode(data)
	local v2 = class96.new()

	if data.user_id ~= nil then
		v2.oneof_prop = {
			type = "user_id",
			value = v.Int64Prop.jsonDecode(data.user_id)
		}
	end

	if data.userId ~= nil then
		v2.oneof_prop = {
			type = "user_id",
			value = v.Int64Prop.jsonDecode(data.userId)
		}
	end

	if data.avatar_config ~= nil then
		v2.oneof_prop = {
			type = "avatar_config",
			value = v.AvatarConfigProp.jsonDecode(data.avatar_config)
		}
	end

	if data.avatarConfig ~= nil then
		v2.oneof_prop = {
			type = "avatar_config",
			value = v.AvatarConfigProp.jsonDecode(data.avatarConfig)
		}
	end

	return v2
end

class96.descriptor = {
	name = "AvatarProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AvatarProp"
}

v.AvatarProp = class96

typeRegistry.default:register(v.AvatarProp)

local class97 = {}
class97.__index = class97

function class97.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class97))
end

function class97:encode()
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

function class97.decode(buf: buffer)
	local result = class97.new()
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
					value = v.ArrayOfAvatarProp_ArrayOfAvatars.decode(v5)
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
					value = v.ArrayOfAvatarProp_ConditionalOptions.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "array_map",
					value = v.ArrayOfAvatarProp_ArrayMap.decode(v5)
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

function class97:jsonEncode()
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

function class97.jsonDecode(data)
	local v2 = class97.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfAvatarProp_ArrayOfAvatars.jsonDecode(data.literal)
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
			value = v.ArrayOfAvatarProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	if data.array_map ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfAvatarProp_ArrayMap.jsonDecode(data.array_map)
		}
	end

	if data.arrayMap ~= nil then
		v2.kind = {
			type = "array_map",
			value = v.ArrayOfAvatarProp_ArrayMap.jsonDecode(data.arrayMap)
		}
	end

	return v2
end

class97.descriptor = {
	name = "ArrayOfAvatarProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfAvatarProp"
}

v.ArrayOfAvatarProp = class97

typeRegistry.default:register(v.ArrayOfAvatarProp)

local class98 = {}
class98.__index = class98

function class98.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class98))
end

function class98:encode()
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

function class98.decode(buf: buffer)
	local result = class98.new()
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
					value = v.ArrayOfAvatarProp_ArrayOfAvatars.decode(v5)
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

function class98:jsonEncode()
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

function class98.jsonDecode(data)
	local v2 = class98.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ArrayOfAvatarProp_ArrayOfAvatars.jsonDecode(data.literal)
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

class98.descriptor = {
	name = "ArrayOfAvatarProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ArrayOfAvatarProp_ConditionalOption = class98

typeRegistry.default:register(v.ArrayOfAvatarProp_ConditionalOption)

local class99 = {}
class99.__index = class99

function class99.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class99))
end

function class99:encode()
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

function class99.decode(buf: buffer)
	local v2 = class99.new()
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
				table.insert(v2.options, v.ArrayOfAvatarProp_ConditionalOption.decode(v6))
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

function class99:jsonEncode()
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

function class99.jsonDecode(p)
	local v2 = class99.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ArrayOfAvatarProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class99.descriptor = {
	name = "ArrayOfAvatarProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ArrayOfAvatarProp_ConditionalOptions = class99

typeRegistry.default:register(v.ArrayOfAvatarProp_ConditionalOptions)

local class100 = {}
class100.__index = class100

function class100.new(p)
	return (setmetatable({
		array = (p == nil or p.array == nil) and {} or p.array
	}, class100))
end

function class100:encode()
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

function class100.decode(buf: buffer)
	local v2 = class100.new()
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
				table.insert(v2.array, v.AvatarProp.decode(v6))
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

function class100:jsonEncode()
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

function class100.jsonDecode(p)
	local v2 = class100.new()

	if p.array == nil then
		return v2
	end

	local array = {}

	for _, item in p.array do
		table.insert(array, v.AvatarProp.jsonDecode(item))
	end

	v2.array = array

	return v2
end

class100.descriptor = {
	name = "ArrayOfAvatarProp_ArrayOfAvatars",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfAvatars"
}

v.ArrayOfAvatarProp_ArrayOfAvatars = class100

typeRegistry.default:register(v.ArrayOfAvatarProp_ArrayOfAvatars)

local class101 = {}
class101.__index = class101

function class101.new(data)
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
	return (setmetatable(v2, class101))
end

function class101:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil and self.kind.type == "binding_path" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.kind.value)
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

function class101.decode(buf: buffer)
	local result = class101.new()
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
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v5))
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.field_map = v.AvatarConfigProp.decode(v5)
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

function class101:jsonEncode()
	local v2 = {}

	if self.kind ~= nil and self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
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

function class101.jsonDecode(data)
	local v2 = class101.new()

	if data.binding_path ~= nil then
		v2.kind = { type = "binding_path", value = data.binding_path }
	end

	if data.bindingPath ~= nil then
		v2.kind = { type = "binding_path", value = data.bindingPath }
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
		v2.field_map = v.AvatarConfigProp.jsonDecode(data.field_map)
	end

	if data.fieldMap ~= nil then
		v2.field_map = v.AvatarConfigProp.jsonDecode(data.fieldMap)
	end

	return v2
end

class101.descriptor = {
	name = "ArrayOfAvatarProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}

v.ArrayOfAvatarProp_ArrayMap = class101

typeRegistry.default:register(v.ArrayOfAvatarProp_ArrayMap)

local class102 = {}
class102.__index = class102

function class102.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class102))
end

function class102:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "literal" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, v.ScaleBasis.toNumber(self.kind.value))
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

function class102.decode(buf: buffer)
	local result = class102.new()
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
					value = v.ScaleBasis.fromNumber(v5) or v5
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
					value = v.ScaleBasisProp_ConditionalOptions.decode(v5)
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

function class102:jsonEncode()
	local v2 = {}

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "literal" then
		local literal

		if typeof(self.kind.value) == "number" then
			literal = self.kind.value
		else
			literal = v.ScaleBasis.toNumber(self.kind.value)
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

function class102.jsonDecode(data)
	local v2 = class102.new()

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ScaleBasis.fromNumber(data.literal) or data.literal
		else
			v3 = v.ScaleBasis.fromName(data.literal) or data.literal
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
			value = v.ScaleBasisProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class102.descriptor = {
	name = "ScaleBasisProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ScaleBasisProp"
}

v.ScaleBasisProp = class102

typeRegistry.default:register(v.ScaleBasisProp)

local class103 = {}
class103.__index = class103

function class103.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class103))
end

function class103:encode()
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
			v2, v3 = proto.writeVarInt(v4, v5, v.ScaleBasis.toNumber(self.kind.value))
		elseif self.kind.type == "binding_path" then
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class103.decode(buf: buffer)
	local result = class103.new()
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
					value = v.ScaleBasis.fromNumber(v5) or v5
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

function class103:jsonEncode()
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
			literal = v.ScaleBasis.toNumber(self.kind.value)
		end

		v2.literal = literal
		return v2
	elseif self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
	end

	return v2
end

function class103.jsonDecode(data)
	local v2 = class103.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		local v3

		if typeof(data.literal) == "number" then
			v3 = v.ScaleBasis.fromNumber(data.literal) or data.literal
		else
			v3 = v.ScaleBasis.fromName(data.literal) or data.literal
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

class103.descriptor = {
	name = "ScaleBasisProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.ScaleBasisProp_ConditionalOption = class103

typeRegistry.default:register(v.ScaleBasisProp_ConditionalOption)

local class104 = {}
class104.__index = class104

function class104.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class104))
end

function class104:encode()
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

function class104.decode(buf: buffer)
	local v2 = class104.new()
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
				table.insert(v2.options, v.ScaleBasisProp_ConditionalOption.decode(v6))
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

function class104:jsonEncode()
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

function class104.jsonDecode(p)
	local v2 = class104.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.ScaleBasisProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class104.descriptor = {
	name = "ScaleBasisProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.ScaleBasisProp_ConditionalOptions = class104

typeRegistry.default:register(v.ScaleBasisProp_ConditionalOptions)

local class105 = {}
class105.__index = class105

function class105.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class105))
end

function class105:encode()
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

function class105.decode(buf: buffer)
	local result = class105.new()
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
					value = v.StringArrayProp_LiteralValue.decode(v5)
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
					value = v.StringArrayProp_ConditionalOptions.decode(v5)
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

function class105:jsonEncode()
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

function class105.jsonDecode(data)
	local v2 = class105.new()

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.StringArrayProp_LiteralValue.jsonDecode(data.literal)
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
			value = v.StringArrayProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class105.descriptor = {
	name = "StringArrayProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.StringArrayProp"
}

v.StringArrayProp = class105

typeRegistry.default:register(v.StringArrayProp)

local class106 = {}
class106.__index = class106

function class106.new(p)
	return (setmetatable({
		items = (p == nil or p.items == nil) and {} or p.items
	}, class106))
end

function class106:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.items ~= nil and #self.items > 0 then
		for _, item in self.items do
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, item)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class106.decode(buf: buffer)
	local v2 = class106.new()
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
				table.insert(v2.items, buffer.tostring(v6))
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

function class106:jsonEncode()
	local v2 = {}

	if self.items == nil or not (#self.items > 0) then
		return v2
	end

	local items = {}

	for _, item in self.items do
		table.insert(items, item)
	end

	v2.items = items

	return v2
end

function class106.jsonDecode(p)
	local v2 = class106.new()

	if p.items == nil then
		return v2
	end

	local items = {}

	for _, item in p.items do
		table.insert(items, item)
	end

	v2.items = items

	return v2
end

class106.descriptor = {
	name = "StringArrayProp_LiteralValue",
	fullName = "roblox.apppageplatform.shared.v1beta1.LiteralValue"
}

v.StringArrayProp_LiteralValue = class106

typeRegistry.default:register(v.StringArrayProp_LiteralValue)

local class107 = {}
class107.__index = class107

function class107.new(p)
	local condition

	if not (p == nil or p.condition == nil) then
		condition = p.condition
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ condition = condition, kind = kind }, class107))
end

function class107:encode()
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
		elseif self.kind.type == "conditional" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class107.decode(buf: buffer)
	local result = class107.new()
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
					value = v.StringArrayProp_LiteralValue.decode(v5)
				}
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "binding_path", value = buffer.tostring(v5) }
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "conditional",
					value = v.StringArrayProp_ConditionalOptions.decode(v5)
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

function class107:jsonEncode()
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
	end

	if self.kind.type == "binding_path" then
		v2.bindingPath = self.kind.value
		return v2
	elseif self.kind.type == "conditional" then
		v2.conditional = self.kind.value:jsonEncode()
	end

	return v2
end

function class107.jsonDecode(data)
	local v2 = class107.new()

	if data.condition ~= nil then
		v2.condition = prop_condition.PropCondition.jsonDecode(data.condition)
	end

	if data.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.StringArrayProp_LiteralValue.jsonDecode(data.literal)
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
			value = v.StringArrayProp_ConditionalOptions.jsonDecode(data.conditional)
		}
	end

	return v2
end

class107.descriptor = {
	name = "StringArrayProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}

v.StringArrayProp_ConditionalOption = class107

typeRegistry.default:register(v.StringArrayProp_ConditionalOption)

local class108 = {}
class108.__index = class108

function class108.new(p)
	return (setmetatable({
		options = (p == nil or p.options == nil) and {} or p.options
	}, class108))
end

function class108:encode()
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

function class108.decode(buf: buffer)
	local v2 = class108.new()
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
				table.insert(v2.options, v.StringArrayProp_ConditionalOption.decode(v6))
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

function class108:jsonEncode()
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

function class108.jsonDecode(p)
	local v2 = class108.new()

	if p.options == nil then
		return v2
	end

	local options = {}

	for _, option in p.options do
		table.insert(options, v.StringArrayProp_ConditionalOption.jsonDecode(option))
	end

	v2.options = options

	return v2
end

class108.descriptor = {
	name = "StringArrayProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}

v.StringArrayProp_ConditionalOptions = class108

typeRegistry.default:register(v.StringArrayProp_ConditionalOptions)

v.ScaleBasis = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "SCALE_BASIS_INVALID"
		elseif p == 1 then
			return "SCALE_BASIS_PARENT"
		elseif p == 2 then
			return "SCALE_BASIS_VIEWPORT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "SCALE_BASIS_INVALID" then
			return 0
		elseif p == "SCALE_BASIS_PARENT" then
			return 1
		elseif p == "SCALE_BASIS_VIEWPORT" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "SCALE_BASIS_INVALID" then
			return "SCALE_BASIS_INVALID"
		elseif p == "SCALE_BASIS_PARENT" then
			return "SCALE_BASIS_PARENT"
		elseif p == "SCALE_BASIS_VIEWPORT" then
			return "SCALE_BASIS_VIEWPORT"
		end

		return nil
	end
}

return {
	TranslationRef = v.TranslationRef,
	StringFormat = v.StringFormat,
	StringFormat_FormatArg = v.StringFormat_FormatArg,
	StringFormat_FormatArg_Formatter = v.StringFormat_FormatArg_Formatter,
	StringFormat_FormatArg_Formatter_DateConfig = v.StringFormat_FormatArg_Formatter_DateConfig,
	StringFormat_FormatArg_Formatter_Type = v.StringFormat_FormatArg_Formatter_Type,
	StringProp = v.StringProp,
	StringProp_ConditionalOption = v.StringProp_ConditionalOption,
	StringProp_ConditionalOptions = v.StringProp_ConditionalOptions,
	FloatProp = v.FloatProp,
	FloatProp_ConditionalOption = v.FloatProp_ConditionalOption,
	FloatProp_ConditionalOptions = v.FloatProp_ConditionalOptions,
	ArrayOfFloatProp = v.ArrayOfFloatProp,
	ArrayOfFloatProp_ConditionalOption = v.ArrayOfFloatProp_ConditionalOption,
	ArrayOfFloatProp_ConditionalOptions = v.ArrayOfFloatProp_ConditionalOptions,
	ArrayOfFloatProp_ArrayOfFloats = v.ArrayOfFloatProp_ArrayOfFloats,
	DoubleProp = v.DoubleProp,
	DoubleProp_ConditionalOption = v.DoubleProp_ConditionalOption,
	DoubleProp_ConditionalOptions = v.DoubleProp_ConditionalOptions,
	Int32Prop = v.Int32Prop,
	Int32Prop_ConditionalOption = v.Int32Prop_ConditionalOption,
	Int32Prop_ConditionalOptions = v.Int32Prop_ConditionalOptions,
	Int64Prop = v.Int64Prop,
	Int64Prop_ConditionalOption = v.Int64Prop_ConditionalOption,
	Int64Prop_ConditionalOptions = v.Int64Prop_ConditionalOptions,
	BoolProp = v.BoolProp,
	BoolProp_ConditionalOption = v.BoolProp_ConditionalOption,
	BoolProp_ConditionalOptions = v.BoolProp_ConditionalOptions,
	StructProp = v.StructProp,
	StructProp_ConditionalOption = v.StructProp_ConditionalOption,
	StructProp_ConditionalOptions = v.StructProp_ConditionalOptions,
	ImageStringProp = v.ImageStringProp,
	ImageStringProp_ConditionalOption = v.ImageStringProp_ConditionalOption,
	ImageStringProp_ConditionalOptions = v.ImageStringProp_ConditionalOptions,
	ImageSetProp = v.ImageSetProp,
	ImageSetProp_ConditionalOption = v.ImageSetProp_ConditionalOption,
	ImageSetProp_ConditionalOptions = v.ImageSetProp_ConditionalOptions,
	ColorProp = v.ColorProp,
	ColorProp_ConditionalOption = v.ColorProp_ConditionalOption,
	ColorProp_ConditionalOptions = v.ColorProp_ConditionalOptions,
	TypographyProp = v.TypographyProp,
	TypographyProp_ConditionalOption = v.TypographyProp_ConditionalOption,
	TypographyProp_ConditionalOptions = v.TypographyProp_ConditionalOptions,
	TypographyFontProp = v.TypographyFontProp,
	TypographyFontProp_ConditionalOption = v.TypographyFontProp_ConditionalOption,
	TypographyFontProp_ConditionalOptions = v.TypographyFontProp_ConditionalOptions,
	ColorStyleProp = v.ColorStyleProp,
	ColorStyleProp_ConditionalOption = v.ColorStyleProp_ConditionalOption,
	ColorStyleProp_ConditionalOptions = v.ColorStyleProp_ConditionalOptions,
	FillBehaviorProp = v.FillBehaviorProp,
	FillBehaviorProp_ConditionalOption = v.FillBehaviorProp_ConditionalOption,
	FillBehaviorProp_ConditionalOptions = v.FillBehaviorProp_ConditionalOptions,
	InputSizeProp = v.InputSizeProp,
	InputSizeProp_ConditionalOption = v.InputSizeProp_ConditionalOption,
	InputSizeProp_ConditionalOptions = v.InputSizeProp_ConditionalOptions,
	UDimProp = v.UDimProp,
	UDimProp_ConditionalOption = v.UDimProp_ConditionalOption,
	UDimProp_ConditionalOptions = v.UDimProp_ConditionalOptions,
	UDim2Prop = v.UDim2Prop,
	UDim2Prop_ConditionalOption = v.UDim2Prop_ConditionalOption,
	UDim2Prop_ConditionalOptions = v.UDim2Prop_ConditionalOptions,
	Vector2Prop = v.Vector2Prop,
	Vector2Prop_ConditionalOption = v.Vector2Prop_ConditionalOption,
	Vector2Prop_ConditionalOptions = v.Vector2Prop_ConditionalOptions,
	IconProp = v.IconProp,
	IconProp_ConditionalOption = v.IconProp_ConditionalOption,
	IconProp_ConditionalOptions = v.IconProp_ConditionalOptions,
	FoundationIconConfigProp = v.FoundationIconConfigProp,
	FoundationIconConfigProp_ConditionalOption = v.FoundationIconConfigProp_ConditionalOption,
	FoundationIconConfigProp_ConditionalOptions = v.FoundationIconConfigProp_ConditionalOptions,
	FoundationIconConfigProp_FoundationIconConfig = v.FoundationIconConfigProp_FoundationIconConfig,
	IconSizeProp = v.IconSizeProp,
	GradientProp = v.GradientProp,
	GradientProp_ConditionalOption = v.GradientProp_ConditionalOption,
	GradientProp_ConditionalOptions = v.GradientProp_ConditionalOptions,
	GradientProp_GradientData = v.GradientProp_GradientData,
	ArrayOfStructProp = v.ArrayOfStructProp,
	ArrayOfStructProp_ConditionalOption = v.ArrayOfStructProp_ConditionalOption,
	ArrayOfStructProp_ConditionalOptions = v.ArrayOfStructProp_ConditionalOptions,
	ArrayOfStructProp_ArrayOfStructs = v.ArrayOfStructProp_ArrayOfStructs,
	PymkItemData = v.PymkItemData,
	ArrayOfPymkItemDataProp = v.ArrayOfPymkItemDataProp,
	ArrayOfPymkItemDataProp_ConditionalOption = v.ArrayOfPymkItemDataProp_ConditionalOption,
	ArrayOfPymkItemDataProp_ConditionalOptions = v.ArrayOfPymkItemDataProp_ConditionalOptions,
	ArrayOfPymkItemDataProp_PymkItems = v.ArrayOfPymkItemDataProp_PymkItems,
	UiScaledFloatProp = v.UiScaledFloatProp,
	UiScaledFloatProp_ConditionalOption = v.UiScaledFloatProp_ConditionalOption,
	UiScaledFloatProp_ConditionalOptions = v.UiScaledFloatProp_ConditionalOptions,
	UiScaledUDimProp = v.UiScaledUDimProp,
	UiScaledUDimProp_ConditionalOption = v.UiScaledUDimProp_ConditionalOption,
	UiScaledUDimProp_ConditionalOptions = v.UiScaledUDimProp_ConditionalOptions,
	UiScaledUDim2Prop = v.UiScaledUDim2Prop,
	UiScaledUDim2Prop_ConditionalOption = v.UiScaledUDim2Prop_ConditionalOption,
	UiScaledUDim2Prop_ConditionalOptions = v.UiScaledUDim2Prop_ConditionalOptions,
	AvatarConfigProp = v.AvatarConfigProp,
	AvatarProp = v.AvatarProp,
	ArrayOfAvatarProp = v.ArrayOfAvatarProp,
	ArrayOfAvatarProp_ConditionalOption = v.ArrayOfAvatarProp_ConditionalOption,
	ArrayOfAvatarProp_ConditionalOptions = v.ArrayOfAvatarProp_ConditionalOptions,
	ArrayOfAvatarProp_ArrayOfAvatars = v.ArrayOfAvatarProp_ArrayOfAvatars,
	ArrayOfAvatarProp_ArrayMap = v.ArrayOfAvatarProp_ArrayMap,
	ScaleBasisProp = v.ScaleBasisProp,
	ScaleBasisProp_ConditionalOption = v.ScaleBasisProp_ConditionalOption,
	ScaleBasisProp_ConditionalOptions = v.ScaleBasisProp_ConditionalOptions,
	StringArrayProp = v.StringArrayProp,
	StringArrayProp_LiteralValue = v.StringArrayProp_LiteralValue,
	StringArrayProp_ConditionalOption = v.StringArrayProp_ConditionalOption,
	StringArrayProp_ConditionalOptions = v.StringArrayProp_ConditionalOptions,
	ScaleBasis = v.ScaleBasis
}
