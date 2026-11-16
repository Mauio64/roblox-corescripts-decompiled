local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local struct = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.struct)

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local config_driven_form_data = require(script.Parent.Parent.Parent.shared.v1beta1.config_driven_form_data)

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		session_id = (data == nil or data.session_id == nil) and "" or data.session_id,
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

	if self.session_id ~= nil and self.session_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.session_id)
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
			local v13, v14 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
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
				result.session_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.SettingsPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v5)

				result.cached_roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
			elseif v3 == 3 then
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

	if self.session_id ~= nil and self.session_id ~= "" then
		v2.sessionId = self.session_id
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

	if data.session_id ~= nil then
		v2.session_id = data.session_id
	end

	if data.sessionId ~= nil then
		v2.session_id = data.sessionId
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
	name = "SettingsPageRequest",
	fullName = "roblox.apppageplatform.settings.v1beta1.SettingsPageRequest"
}

v.SettingsPageRequest = class

typeRegistry.default:register(v.SettingsPageRequest)

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
	name = "SettingsPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.settings.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}

v.SettingsPageRequest_CachedRobloxComponentToTemplateIdEntry = class2

typeRegistry.default:register(v.SettingsPageRequest_CachedRobloxComponentToTemplateIdEntry)

local class3 = {}
class3.__index = class3

function class3.new(data)
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
	return (setmetatable(v2, class3))
end

function class3:encode()
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.SettingsPageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.SettingsPageResponse_LocalizedLiteralsEntry.decode(v5)

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

function class3:jsonEncode()
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

function class3.jsonDecode(data)
	local v2 = class3.new()

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

class3.descriptor = {
	name = "SettingsPageResponse",
	fullName = "roblox.apppageplatform.settings.v1beta1.SettingsPageResponse"
}

v.SettingsPageResponse = class3

typeRegistry.default:register(v.SettingsPageResponse)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class4))
end

function class4:encode()
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

function class4:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class4.descriptor = {
	name = "SettingsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.settings.v1beta1.TemplatesEntry"
}

v.SettingsPageResponse_TemplatesEntry = class4

typeRegistry.default:register(v.SettingsPageResponse_TemplatesEntry)

local class5 = {}
class5.__index = class5

function class5.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class5))
end

function class5:encode()
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

function class5:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class5.descriptor = {
	name = "SettingsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.settings.v1beta1.LocalizedLiteralsEntry"
}

v.SettingsPageResponse_LocalizedLiteralsEntry = class5

typeRegistry.default:register(v.SettingsPageResponse_LocalizedLiteralsEntry)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local v2 = {
		name = (p == nil or p.name == nil) and "" or p.name,
		parameters = 0
	}
	local parameters

	if not (p == nil or p.parameters == nil) then
		parameters = p.parameters
	end

	v2.parameters = parameters
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.name ~= nil and self.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.parameters ~= nil then
		local encoded = self.parameters:encode()
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
				result.name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.parameters = struct.Struct.decode(v5)
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

	if self.name ~= nil and self.name ~= "" then
		v2.name = self.name
	end

	if self.parameters ~= nil then
		v2.parameters = self.parameters:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.name ~= nil then
		v2.name = p.name
	end

	if p.parameters ~= nil then
		v2.parameters = struct.Struct.jsonDecode(p.parameters)
	end

	return v2
end

class6.descriptor = {
	name = "FormAction",
	fullName = "roblox.apppageplatform.settings.v1beta1.FormAction"
}

v.FormAction = class6

typeRegistry.default:register(v.FormAction)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local operation

	if not (p == nil or p.operation == nil) then
		operation = p.operation
	end

	return (setmetatable({ operation = operation }, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.operation ~= nil then
		if self.operation.type == "diff" then
			local encoded = self.operation.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.operation.type == "action" then
			local encoded = self.operation.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
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
				result.operation = { type = "diff", value = struct.Struct.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.operation = { type = "action", value = v.FormAction.decode(v5) }
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

	if self.operation == nil then
		return v2
	end

	if self.operation.type == "diff" then
		v2.diff = self.operation.value:jsonEncode()
		return v2
	end

	if self.operation.type == "action" then
		v2.action = self.operation.value:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.diff ~= nil then
		v2.operation = {
			type = "diff",
			value = struct.Struct.jsonDecode(p.diff)
		}
	end

	if p.action ~= nil then
		v2.operation = {
			type = "action",
			value = v.FormAction.jsonDecode(p.action)
		}
	end

	return v2
end

class7.descriptor = {
	name = "SaveSettingsFormRequest",
	fullName = "roblox.apppageplatform.settings.v1beta1.SaveSettingsFormRequest"
}

v.SaveSettingsFormRequest = class7

typeRegistry.default:register(v.SaveSettingsFormRequest)

local class8 = {}
class8.__index = class8

function class8.new(data)
	return (setmetatable({
		name = (data == nil or data.name == nil) and "" or data.name,
		status = (data == nil or data.status == nil) and 0 or data.status,
		message = (data == nil or data.message == nil) and "" or data.message
	}, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.name ~= nil and self.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.status ~= nil and self.status ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.status)
	end

	if self.message ~= nil and self.message ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.message)
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
				local status
				status, v2 = proto.readVarIntI32(buf, v2)
				result.status = status
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.message = buffer.tostring(v5)
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

	if self.name ~= nil and self.name ~= "" then
		v2.name = self.name
	end

	if self.status ~= nil and self.status ~= 0 then
		v2.status = self.status
	end

	if self.message ~= nil and self.message ~= "" then
		v2.message = self.message
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.status ~= nil then
		v2.status = data.status
	end

	if data.message ~= nil then
		v2.message = data.message
	end

	return v2
end

class8.descriptor = {
	name = "FormWriteError",
	fullName = "roblox.apppageplatform.settings.v1beta1.FormWriteError"
}

v.FormWriteError = class8

typeRegistry.default:register(v.FormWriteError)

local class9 = {}
class9.__index = class9

function class9.new(data)
	local refreshed_data

	if not (data == nil or data.refreshed_data == nil) then
		refreshed_data = data.refreshed_data
	end

	local v2 = {
		refreshed_data = refreshed_data,
		committed_groups = (data == nil or data.committed_groups == nil) and {} or data.committed_groups,
		write_errors = (data == nil or data.write_errors == nil) and {} or data.write_errors
	}
	return (setmetatable(v2, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.refreshed_data ~= nil then
		local encoded = self.refreshed_data:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.committed_groups ~= nil and #self.committed_groups > 0 then
		for _, committed_group in self.committed_groups do
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, committed_group)
		end
	end

	if self.write_errors ~= nil and #self.write_errors > 0 then
		for _, write_error in self.write_errors do
			local encoded = write_error:encode()
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
				result.refreshed_data = config_driven_form_data.ConfigDrivenFormInputData.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.committed_groups, buffer.tostring(v5))
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.write_errors, v.FormWriteError.decode(v5))
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

	if self.refreshed_data ~= nil then
		v2.refreshedData = self.refreshed_data:jsonEncode()
	end

	if self.committed_groups ~= nil and #self.committed_groups > 0 then
		local committed_groups = {}

		for _, committed_group in self.committed_groups do
			table.insert(committed_groups, committed_group)
		end

		v2.committedGroups = committed_groups
	end

	if self.write_errors == nil or not (#self.write_errors > 0) then
		return v2
	end

	local writeErrors = {}

	for _, write_error in self.write_errors do
		table.insert(writeErrors, write_error:jsonEncode())
	end

	v2.writeErrors = writeErrors

	return v2
end

function class9.jsonDecode(data)
	local v2 = class9.new()

	if data.refreshed_data ~= nil then
		v2.refreshed_data = config_driven_form_data.ConfigDrivenFormInputData.jsonDecode(data.refreshed_data)
	end

	if data.refreshedData ~= nil then
		v2.refreshed_data = config_driven_form_data.ConfigDrivenFormInputData.jsonDecode(data.refreshedData)
	end

	if data.committed_groups ~= nil then
		local committed_groups = {}

		for _, committed_group in data.committed_groups do
			table.insert(committed_groups, committed_group)
		end

		v2.committed_groups = committed_groups
	end

	if data.committedGroups ~= nil then
		local committedGroups = {}

		for _, committedGroup in data.committedGroups do
			table.insert(committedGroups, committedGroup)
		end

		v2.committed_groups = committedGroups
	end

	if data.write_errors ~= nil then
		local write_errors = {}

		for _, write_error in data.write_errors do
			table.insert(write_errors, v.FormWriteError.jsonDecode(write_error))
		end

		v2.write_errors = write_errors
	end

	if data.writeErrors == nil then
		return v2
	end

	local write_errors = {}

	for _, writeError in data.writeErrors do
		table.insert(write_errors, v.FormWriteError.jsonDecode(writeError))
	end

	v2.write_errors = write_errors

	return v2
end

class9.descriptor = {
	name = "SaveSettingsFormResponse",
	fullName = "roblox.apppageplatform.settings.v1beta1.SaveSettingsFormResponse"
}

v.SaveSettingsFormResponse = class9

typeRegistry.default:register(v.SaveSettingsFormResponse)

return {
	SettingsPageRequest = v.SettingsPageRequest,
	SettingsPageResponse = v.SettingsPageResponse,
	FormAction = v.FormAction,
	SaveSettingsFormRequest = v.SaveSettingsFormRequest,
	FormWriteError = v.FormWriteError,
	SaveSettingsFormResponse = v.SaveSettingsFormResponse
}
