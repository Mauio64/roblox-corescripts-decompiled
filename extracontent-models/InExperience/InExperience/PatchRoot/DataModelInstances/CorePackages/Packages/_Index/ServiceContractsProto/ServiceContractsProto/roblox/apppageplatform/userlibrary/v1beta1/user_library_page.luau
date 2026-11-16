local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local class = {}
class.__index = class

function class.new(data)
	local view

	if data == nil or data.view == nil then
		view = assert(v.View.fromNumber(0), "Enum has no 0 default")
	else
		view = data.view
	end

	local v2 = {
		view = view,
		cursor = (data == nil or data.cursor == nil) and "" or data.cursor,
		page_size = (data == nil or data.page_size == nil) and 0 or data.page_size,
		config_key = (data == nil or data.config_key == nil) and "" or data.config_key,
		surface_key = (data == nil or data.surface_key == nil) and "" or data.surface_key,
		cached_roblox_component_to_template_id = (data == nil or data.cached_roblox_component_to_template_id == nil) and {} or data.cached_roblox_component_to_template_id,
		client_capabilities = 0
	}
	local client_capabilities2

	if not (data == nil or data.client_capabilities == nil) then
		client_capabilities2 = data.client_capabilities
	end

	v2.client_capabilities = client_capabilities2
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.view ~= nil and (self.view ~= nil and self.view ~= 0 or self.view ~= v.View.fromNumber(0)) then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.View.toNumber(self.view))
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.cursor)
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.page_size)
	end

	if self.config_key ~= nil and self.config_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.config_key)
	end

	if self.surface_key ~= nil and self.surface_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.surface_key)
	end

	if
		self.cached_roblox_component_to_template_id ~= nil
		and next(self.cached_roblox_component_to_template_id) ~= nil
	then
		for k, v4 in self.cached_roblox_component_to_template_id do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeString(v9, v10, v4)
			local v13, v14 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.view = v.View.fromNumber(v5) or v5
			elseif v3 == 3 then
				local page_size
				page_size, v2 = proto.readVarIntI32(buf, v2)
				result.page_size = page_size
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.cursor = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.config_key = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.surface_key = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.LibraryPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v5)

				result.cached_roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.client_capabilities = client_capabilities.ClientCapabilities.decode(v5)
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

	if self.view ~= nil and (self.view ~= nil and self.view ~= 0 or self.view ~= v.View.fromNumber(0)) then
		local view

		if typeof(self.view) == "number" then
			view = self.view
		else
			view = v.View.toNumber(self.view)
		end

		v2.view = view
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		v2.cursor = self.cursor
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		v2.pageSize = self.page_size
	end

	if self.config_key ~= nil and self.config_key ~= "" then
		v2.configKey = self.config_key
	end

	if self.surface_key ~= nil and self.surface_key ~= "" then
		v2.surfaceKey = self.surface_key
	end

	if
		self.cached_roblox_component_to_template_id ~= nil
		and next(self.cached_roblox_component_to_template_id) ~= nil
	then
		local cachedRobloxComponentToTemplateId = {}

		for k, v3 in self.cached_roblox_component_to_template_id do
			cachedRobloxComponentToTemplateId[k] = v3
		end

		v2.cachedRobloxComponentToTemplateId = cachedRobloxComponentToTemplateId
	end

	if self.client_capabilities ~= nil then
		v2.clientCapabilities = self.client_capabilities:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.view ~= nil then
		local view

		if typeof(data.view) == "number" then
			view = v.View.fromNumber(data.view) or data.view
		else
			view = v.View.fromName(data.view) or data.view
		end

		v2.view = view
	end

	if data.cursor ~= nil then
		v2.cursor = data.cursor
	end

	if data.page_size ~= nil then
		v2.page_size = data.page_size
	end

	if data.pageSize ~= nil then
		v2.page_size = data.pageSize
	end

	if data.config_key ~= nil then
		v2.config_key = data.config_key
	end

	if data.configKey ~= nil then
		v2.config_key = data.configKey
	end

	if data.surface_key ~= nil then
		v2.surface_key = data.surface_key
	end

	if data.surfaceKey ~= nil then
		v2.surface_key = data.surfaceKey
	end

	if data.cached_roblox_component_to_template_id ~= nil then
		local cached_roblox_component_to_template_id = {}

		for k, v3 in data.cached_roblox_component_to_template_id do
			cached_roblox_component_to_template_id[k] = v3
		end

		v2.cached_roblox_component_to_template_id = cached_roblox_component_to_template_id
	end

	if data.cachedRobloxComponentToTemplateId ~= nil then
		local cached_roblox_component_to_template_id = {}

		for k, v3 in data.cachedRobloxComponentToTemplateId do
			cached_roblox_component_to_template_id[k] = v3
		end

		v2.cached_roblox_component_to_template_id = cached_roblox_component_to_template_id
	end

	if data.client_capabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.client_capabilities)
	end

	if data.clientCapabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.clientCapabilities)
	end

	return v2
end

class.descriptor = {
	name = "LibraryPageRequest",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.LibraryPageRequest"
}

v.LibraryPageRequest = class

typeRegistry.default:register(v.LibraryPageRequest)

local class2 = {}
class2.__index = class2

function class2.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.value)
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
				result.value = buffer.tostring(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class2.descriptor = {
	name = "LibraryPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}

v.LibraryPageRequest_CachedRobloxComponentToTemplateIdEntry = class2

typeRegistry.default:register(v.LibraryPageRequest_CachedRobloxComponentToTemplateIdEntry)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		collection_id = (data == nil or data.collection_id == nil) and "" or data.collection_id,
		view = 0,
		cursor = 0,
		page_size = 0,
		config_key = 0,
		surface_key = 0,
		cached_roblox_component_to_template_id = 0,
		client_capabilities = 0
	}
	local view

	if data == nil or data.view == nil then
		view = assert(v.View.fromNumber(0), "Enum has no 0 default")
	else
		view = data.view
	end

	v2.view = view

	v2.cursor = (data == nil or data.cursor == nil) and "" or data.cursor
	v2.page_size = (data == nil or data.page_size == nil) and 0 or data.page_size
	v2.config_key = (data == nil or data.config_key == nil) and "" or data.config_key
	v2.surface_key = (data == nil or data.surface_key == nil) and "" or data.surface_key
	v2.cached_roblox_component_to_template_id = (data == nil or data.cached_roblox_component_to_template_id == nil)
		and {}
		or data.cached_roblox_component_to_template_id
	local client_capabilities2

	if not (data == nil or data.client_capabilities == nil) then
		client_capabilities2 = data.client_capabilities
	end

	v2.client_capabilities = client_capabilities2
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.collection_id ~= nil and self.collection_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.collection_id)
	end

	if self.view ~= nil and (self.view ~= nil and self.view ~= 0 or self.view ~= v.View.fromNumber(0)) then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.View.toNumber(self.view))
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.cursor)
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.page_size)
	end

	if self.config_key ~= nil and self.config_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.config_key)
	end

	if self.surface_key ~= nil and self.surface_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.surface_key)
	end

	if
		self.cached_roblox_component_to_template_id ~= nil
		and next(self.cached_roblox_component_to_template_id) ~= nil
	then
		for k, v4 in self.cached_roblox_component_to_template_id do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeString(v9, v10, v4)
			local v13, v14 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
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
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.view = v.View.fromNumber(v5) or v5
			elseif v3 == 4 then
				local page_size
				page_size, v2 = proto.readVarIntI32(buf, v2)
				result.page_size = page_size
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.collection_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.cursor = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.config_key = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.surface_key = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.CollectionPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v5)

				result.cached_roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.client_capabilities = client_capabilities.ClientCapabilities.decode(v5)
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

	if self.collection_id ~= nil and self.collection_id ~= "" then
		v2.collectionId = self.collection_id
	end

	if self.view ~= nil and (self.view ~= nil and self.view ~= 0 or self.view ~= v.View.fromNumber(0)) then
		local view

		if typeof(self.view) == "number" then
			view = self.view
		else
			view = v.View.toNumber(self.view)
		end

		v2.view = view
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		v2.cursor = self.cursor
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		v2.pageSize = self.page_size
	end

	if self.config_key ~= nil and self.config_key ~= "" then
		v2.configKey = self.config_key
	end

	if self.surface_key ~= nil and self.surface_key ~= "" then
		v2.surfaceKey = self.surface_key
	end

	if
		self.cached_roblox_component_to_template_id ~= nil
		and next(self.cached_roblox_component_to_template_id) ~= nil
	then
		local cachedRobloxComponentToTemplateId = {}

		for k, v3 in self.cached_roblox_component_to_template_id do
			cachedRobloxComponentToTemplateId[k] = v3
		end

		v2.cachedRobloxComponentToTemplateId = cachedRobloxComponentToTemplateId
	end

	if self.client_capabilities ~= nil then
		v2.clientCapabilities = self.client_capabilities:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.collection_id ~= nil then
		v2.collection_id = data.collection_id
	end

	if data.collectionId ~= nil then
		v2.collection_id = data.collectionId
	end

	if data.view ~= nil then
		local view

		if typeof(data.view) == "number" then
			view = v.View.fromNumber(data.view) or data.view
		else
			view = v.View.fromName(data.view) or data.view
		end

		v2.view = view
	end

	if data.cursor ~= nil then
		v2.cursor = data.cursor
	end

	if data.page_size ~= nil then
		v2.page_size = data.page_size
	end

	if data.pageSize ~= nil then
		v2.page_size = data.pageSize
	end

	if data.config_key ~= nil then
		v2.config_key = data.config_key
	end

	if data.configKey ~= nil then
		v2.config_key = data.configKey
	end

	if data.surface_key ~= nil then
		v2.surface_key = data.surface_key
	end

	if data.surfaceKey ~= nil then
		v2.surface_key = data.surfaceKey
	end

	if data.cached_roblox_component_to_template_id ~= nil then
		local cached_roblox_component_to_template_id = {}

		for k, v3 in data.cached_roblox_component_to_template_id do
			cached_roblox_component_to_template_id[k] = v3
		end

		v2.cached_roblox_component_to_template_id = cached_roblox_component_to_template_id
	end

	if data.cachedRobloxComponentToTemplateId ~= nil then
		local cached_roblox_component_to_template_id = {}

		for k, v3 in data.cachedRobloxComponentToTemplateId do
			cached_roblox_component_to_template_id[k] = v3
		end

		v2.cached_roblox_component_to_template_id = cached_roblox_component_to_template_id
	end

	if data.client_capabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.client_capabilities)
	end

	if data.clientCapabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.clientCapabilities)
	end

	return v2
end

class3.descriptor = {
	name = "CollectionPageRequest",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.CollectionPageRequest"
}

v.CollectionPageRequest = class3

typeRegistry.default:register(v.CollectionPageRequest)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.value)
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buffer.tostring(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class4.descriptor = {
	name = "CollectionPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}

v.CollectionPageRequest_CachedRobloxComponentToTemplateIdEntry = class4

typeRegistry.default:register(v.CollectionPageRequest_CachedRobloxComponentToTemplateIdEntry)

local class5 = {}
class5.__index = class5

function class5.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0,
		localized_literals = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	v2.localized_literals = (data == nil or data.localized_literals == nil) and {} or data.localized_literals
	return (setmetatable(v2, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_entries ~= nil and #self.page_entries > 0 then
		for _, page_entry in self.page_entries do
			local encoded = page_entry:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.hydration_data ~= nil then
		local encoded = self.hydration_data:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.templates ~= nil and next(self.templates) ~= nil then
		for k, template in self.templates do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local encoded = template:encode()
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeBuffer(v8, v9, encoded, buffer.len(encoded))
			local v12, v13 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	if self.localized_literals ~= nil and next(self.localized_literals) ~= nil then
		for k, localized_literal in self.localized_literals do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeString(v8, v9, localized_literal)
			local v12, v13 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.PageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.PageResponse_LocalizedLiteralsEntry.decode(v5)

				result.localized_literals[decoded.key or ""] = decoded.value or ""
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

	if self.page_entries ~= nil and #self.page_entries > 0 then
		local pageEntries = {}

		for _, page_entry in self.page_entries do
			table.insert(pageEntries, page_entry:jsonEncode())
		end

		v2.pageEntries = pageEntries
	end

	if self.hydration_data ~= nil then
		v2.hydrationData = self.hydration_data:jsonEncode()
	end

	if self.templates ~= nil and next(self.templates) ~= nil then
		local templates = {}

		for k, template in self.templates do
			templates[k] = template:jsonEncode()
		end

		v2.templates = templates
	end

	if self.localized_literals == nil or next(self.localized_literals) == nil then
		return v2
	end

	local localized_literals = {}

	for k, localized_literal in self.localized_literals do
		localized_literals[k] = localized_literal
	end

	v2.localizedLiterals = localized_literals

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.page_entries ~= nil then
		local page_entries = {}

		for _, page_entry in data.page_entries do
			table.insert(page_entries, page_entry_content.UniversalPageEntry.jsonDecode(page_entry))
		end

		v2.page_entries = page_entries
	end

	if data.pageEntries ~= nil then
		local page_entries = {}

		for _, pageEntry in data.pageEntries do
			table.insert(page_entries, page_entry_content.UniversalPageEntry.jsonDecode(pageEntry))
		end

		v2.page_entries = page_entries
	end

	if data.hydration_data ~= nil then
		v2.hydration_data = hydration_content.HydrationContent.jsonDecode(data.hydration_data)
	end

	if data.hydrationData ~= nil then
		v2.hydration_data = hydration_content.HydrationContent.jsonDecode(data.hydrationData)
	end

	if data.templates ~= nil then
		local templates = {}

		for k, template in data.templates do
			templates[k] = template_entry.TemplateEntry.jsonDecode(template)
		end

		v2.templates = templates
	end

	if data.localized_literals ~= nil then
		local localized_literals = {}

		for k, localized_literal in data.localized_literals do
			localized_literals[k] = localized_literal
		end

		v2.localized_literals = localized_literals
	end

	if data.localizedLiterals == nil then
		return v2
	end

	local localizedLiterals = {}

	for k, localizedLiteral in data.localizedLiterals do
		localizedLiterals[k] = localizedLiteral
	end

	v2.localized_literals = localizedLiterals

	return v2
end

class5.descriptor = {
	name = "PageResponse",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.PageResponse"
}

v.PageResponse = class5

typeRegistry.default:register(v.PageResponse)

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
				result.value = template_entry.TemplateEntry.decode(v5)
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
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class6.descriptor = {
	name = "PageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.TemplatesEntry"
}

v.PageResponse_TemplatesEntry = class6

typeRegistry.default:register(v.PageResponse_TemplatesEntry)

local class7 = {}
class7.__index = class7

function class7.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.value)
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buffer.tostring(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class7.descriptor = {
	name = "PageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.userlibrary.v1beta1.LocalizedLiteralsEntry"
}

v.PageResponse_LocalizedLiteralsEntry = class7

typeRegistry.default:register(v.PageResponse_LocalizedLiteralsEntry)

v.View = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "VIEW_INVALID"
		elseif p == 1 then
			return "VIEW_ALL"
		elseif p == 2 then
			return "VIEW_COLLECTIONS"
		elseif p == 3 then
			return "VIEW_GAMES"
		elseif p == 4 then
			return "VIEW_AVATARS"
		elseif p == 5 then
			return "VIEW_AVATAR_ITEMS"
		elseif p == 6 then
			return "VIEW_SONGS"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "VIEW_INVALID" then
			return 0
		elseif p == "VIEW_ALL" then
			return 1
		elseif p == "VIEW_COLLECTIONS" then
			return 2
		elseif p == "VIEW_GAMES" then
			return 3
		elseif p == "VIEW_AVATARS" then
			return 4
		elseif p == "VIEW_AVATAR_ITEMS" then
			return 5
		elseif p == "VIEW_SONGS" then
			return 6
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "VIEW_INVALID" then
			return "VIEW_INVALID"
		elseif p == "VIEW_ALL" then
			return "VIEW_ALL"
		elseif p == "VIEW_COLLECTIONS" then
			return "VIEW_COLLECTIONS"
		elseif p == "VIEW_GAMES" then
			return "VIEW_GAMES"
		elseif p == "VIEW_AVATARS" then
			return "VIEW_AVATARS"
		elseif p == "VIEW_AVATAR_ITEMS" then
			return "VIEW_AVATAR_ITEMS"
		elseif p == "VIEW_SONGS" then
			return "VIEW_SONGS"
		end

		return nil
	end
}

return {
	LibraryPageRequest = v.LibraryPageRequest,
	CollectionPageRequest = v.CollectionPageRequest,
	PageResponse = v.PageResponse,
	View = v.View
}
