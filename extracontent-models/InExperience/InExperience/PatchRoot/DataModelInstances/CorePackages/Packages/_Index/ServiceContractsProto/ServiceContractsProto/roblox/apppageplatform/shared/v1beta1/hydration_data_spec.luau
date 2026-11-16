local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local hydration_content_type = require(script.Parent.hydration_content_type)

local class = {}
class.__index = class

function class.new(data)
	local content_type

	if data == nil or data.content_type == nil then
		content_type = assert(hydration_content_type.HydrationContentType.fromNumber(0), "Enum has no 0 default")
	else
		content_type = data.content_type
	end

	local id_binding

	if not (data == nil or data.id_binding == nil) then
		id_binding = data.id_binding
	end

	local v2 = {
		content_type = content_type,
		id_binding = id_binding,
		alias = (data == nil or data.alias == nil) and "" or data.alias,
		client_fetch = data ~= nil and data.client_fetch ~= nil and data.client_fetch,
		required_fields = (data == nil or data.required_fields == nil) and {} or data.required_fields,
		required = data ~= nil and data.required ~= nil and data.required,
		client_hints = (data == nil or data.client_hints == nil) and {} or data.client_hints
	}
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if
		self.content_type ~= nil
		and (self.content_type ~= nil and self.content_type ~= 0 or self.content_type ~= hydration_content_type.HydrationContentType.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, hydration_content_type.HydrationContentType.toNumber(self.content_type))
	end

	if self.id_binding ~= nil then
		local encoded = self.id_binding:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.alias ~= nil and self.alias ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.alias)
	end

	if self.client_fetch then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.client_fetch and 1 or 0)
	end

	if self.required_fields ~= nil and #self.required_fields > 0 then
		for _, required_field in self.required_fields do
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, required_field)
		end
	end

	if self.required then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.required and 1 or 0)
	end

	if self.client_hints ~= nil and #self.client_hints > 0 then
		for _, client_hint in self.client_hints do
			local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, client_hint)
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
				result.content_type = hydration_content_type.HydrationContentType.fromNumber(v5) or v5
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.client_fetch = v5 ~= 0
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.required = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id_binding = v.IdBinding.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.alias = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.required_fields, buffer.tostring(v5))
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.client_hints, buffer.tostring(v5))
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

	if
		self.content_type ~= nil
		and (self.content_type ~= nil and self.content_type ~= 0 or self.content_type ~= hydration_content_type.HydrationContentType.fromNumber(0))
	then
		local contentType

		if typeof(self.content_type) == "number" then
			contentType = self.content_type
		else
			contentType = hydration_content_type.HydrationContentType.toNumber(self.content_type)
		end

		v2.contentType = contentType
	end

	if self.id_binding ~= nil then
		v2.idBinding = self.id_binding:jsonEncode()
	end

	if self.alias ~= nil and self.alias ~= "" then
		v2.alias = self.alias
	end

	if self.client_fetch then
		v2.clientFetch = self.client_fetch
	end

	if self.required_fields ~= nil and #self.required_fields > 0 then
		local required_fields = {}

		for _, required_field in self.required_fields do
			table.insert(required_fields, required_field)
		end

		v2.requiredFields = required_fields
	end

	if self.required then
		v2.required = self.required
	end

	if self.client_hints == nil or not (#self.client_hints > 0) then
		return v2
	end

	local client_hints = {}

	for _, client_hint in self.client_hints do
		table.insert(client_hints, client_hint)
	end

	v2.clientHints = client_hints

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.content_type ~= nil then
		local content_type

		if typeof(data.content_type) == "number" then
			content_type = hydration_content_type.HydrationContentType.fromNumber(data.content_type)
				or data.content_type
		else
			content_type = hydration_content_type.HydrationContentType.fromName(data.content_type) or data.content_type
		end

		v2.content_type = content_type
	end

	if data.contentType ~= nil then
		local content_type

		if typeof(data.contentType) == "number" then
			content_type = hydration_content_type.HydrationContentType.fromNumber(data.contentType) or data.contentType
		else
			content_type = hydration_content_type.HydrationContentType.fromName(data.contentType) or data.contentType
		end

		v2.content_type = content_type
	end

	if data.id_binding ~= nil then
		v2.id_binding = v.IdBinding.jsonDecode(data.id_binding)
	end

	if data.idBinding ~= nil then
		v2.id_binding = v.IdBinding.jsonDecode(data.idBinding)
	end

	if data.alias ~= nil then
		v2.alias = data.alias
	end

	if data.client_fetch ~= nil then
		v2.client_fetch = data.client_fetch
	end

	if data.clientFetch ~= nil then
		v2.client_fetch = data.clientFetch
	end

	if data.required_fields ~= nil then
		local required_fields = {}

		for _, required_field in data.required_fields do
			table.insert(required_fields, required_field)
		end

		v2.required_fields = required_fields
	end

	if data.requiredFields ~= nil then
		local requiredFields = {}

		for _, requiredField in data.requiredFields do
			table.insert(requiredFields, requiredField)
		end

		v2.required_fields = requiredFields
	end

	if data.required ~= nil then
		v2.required = data.required
	end

	if data.client_hints ~= nil then
		local client_hints = {}

		for _, client_hint in data.client_hints do
			table.insert(client_hints, client_hint)
		end

		v2.client_hints = client_hints
	end

	if data.clientHints == nil then
		return v2
	end

	local clientHints = {}

	for _, clientHint in data.clientHints do
		table.insert(clientHints, clientHint)
	end

	v2.client_hints = clientHints

	return v2
end

class.descriptor = {
	name = "HydrationDataSpec",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationDataSpec"
}

v.HydrationDataSpec = class

typeRegistry.default:register(v.HydrationDataSpec)

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
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, self.kind.value)
		elseif self.kind.type == "input_path" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
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
				result.kind = { type = "input_path", value = buffer.tostring(v5) }
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
		v2.literal = self.kind.value
		return v2
	end

	if self.kind.type == "input_path" then
		v2.inputPath = self.kind.value
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.literal ~= nil then
		v2.kind = { type = "literal", value = data.literal }
	end

	if data.input_path ~= nil then
		v2.kind = { type = "input_path", value = data.input_path }
	end

	if data.inputPath ~= nil then
		v2.kind = { type = "input_path", value = data.inputPath }
	end

	return v2
end

class2.descriptor = {
	name = "IdBinding",
	fullName = "roblox.apppageplatform.shared.v1beta1.IdBinding"
}

v.IdBinding = class2

typeRegistry.default:register(v.IdBinding)

return { HydrationDataSpec = v.HydrationDataSpec, IdBinding = v.IdBinding }
