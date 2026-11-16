local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local page_entry = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		badge_id = (data == nil or data.badge_id == nil) and 0 or data.badge_id,
		user_id = (data == nil or data.user_id == nil) and 0 or data.user_id,
		page_entry_format = 0,
		client_capabilities = 0
	}
	local page_entry_format

	if data == nil or data.page_entry_format == nil then
		page_entry_format = assert(page_entry_content.PageEntryFormat.fromNumber(0), "Enum has no 0 default")
	else
		page_entry_format = data.page_entry_format
	end

	v2.page_entry_format = page_entry_format
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

	if self.badge_id ~= nil and self.badge_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.badge_id)
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.user_id)
	end

	if
		self.page_entry_format ~= nil
		and (self.page_entry_format ~= nil and self.page_entry_format ~= 0 or self.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, page_entry_content.PageEntryFormat.toNumber(self.page_entry_format))
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
				local badge_id
				badge_id, v2 = proto.readVarIntI64(buf, v2)
				result.badge_id = badge_id
			elseif v3 == 2 then
				local user_id
				user_id, v2 = proto.readVarIntI64(buf, v2)
				result.user_id = user_id
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.page_entry_format = page_entry_content.PageEntryFormat.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 4 then
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

	if self.badge_id ~= nil and self.badge_id ~= 0 then
		v2.badgeId = self.badge_id
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		v2.userId = self.user_id
	end

	if
		self.page_entry_format ~= nil
		and (self.page_entry_format ~= nil and self.page_entry_format ~= 0 or self.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0))
	then
		local pageEntryFormat

		if typeof(self.page_entry_format) == "number" then
			pageEntryFormat = self.page_entry_format
		else
			pageEntryFormat = page_entry_content.PageEntryFormat.toNumber(self.page_entry_format)
		end

		v2.pageEntryFormat = pageEntryFormat
	end

	if self.client_capabilities ~= nil then
		v2.clientCapabilities = self.client_capabilities:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.badge_id ~= nil then
		v2.badge_id = data.badge_id
	end

	if data.badgeId ~= nil then
		v2.badge_id = data.badgeId
	end

	if data.user_id ~= nil then
		v2.user_id = data.user_id
	end

	if data.userId ~= nil then
		v2.user_id = data.userId
	end

	if data.page_entry_format ~= nil then
		local page_entry_format

		if typeof(data.page_entry_format) == "number" then
			page_entry_format = page_entry_content.PageEntryFormat.fromNumber(data.page_entry_format)
				or data.page_entry_format
		else
			page_entry_format = page_entry_content.PageEntryFormat.fromName(data.page_entry_format)
				or data.page_entry_format
		end

		v2.page_entry_format = page_entry_format
	end

	if data.pageEntryFormat ~= nil then
		local page_entry_format

		if typeof(data.pageEntryFormat) == "number" then
			page_entry_format = page_entry_content.PageEntryFormat.fromNumber(data.pageEntryFormat)
				or data.pageEntryFormat
		else
			page_entry_format = page_entry_content.PageEntryFormat.fromName(data.pageEntryFormat)
				or data.pageEntryFormat
		end

		v2.page_entry_format = page_entry_format
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
	name = "BadgeDetailsPageRequest",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageRequest"
}

v.BadgeDetailsPageRequest = class

typeRegistry.default:register(v.BadgeDetailsPageRequest)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_entries ~= nil and #self.page_entries > 0 then
		for _, page_entry2 in self.page_entries do
			local encoded = page_entry2:encode()
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
				table.insert(result.page_entries, v.BadgeDetailsPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.BadgeDetailsPageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
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

	if self.page_entries ~= nil and #self.page_entries > 0 then
		local pageEntries = {}

		for _, page_entry2 in self.page_entries do
			table.insert(pageEntries, page_entry2:jsonEncode())
		end

		v2.pageEntries = pageEntries
	end

	if self.hydration_data ~= nil then
		v2.hydrationData = self.hydration_data:jsonEncode()
	end

	if self.templates == nil or next(self.templates) == nil then
		return v2
	end

	local templates = {}

	for k, template in self.templates do
		templates[k] = template:jsonEncode()
	end

	v2.templates = templates

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.page_entries ~= nil then
		local page_entries = {}

		for _, page_entry2 in data.page_entries do
			table.insert(page_entries, v.BadgeDetailsPageEntry.jsonDecode(page_entry2))
		end

		v2.page_entries = page_entries
	end

	if data.pageEntries ~= nil then
		local page_entries = {}

		for _, pageEntry in data.pageEntries do
			table.insert(page_entries, v.BadgeDetailsPageEntry.jsonDecode(pageEntry))
		end

		v2.page_entries = page_entries
	end

	if data.hydration_data ~= nil then
		v2.hydration_data = hydration_content.HydrationContent.jsonDecode(data.hydration_data)
	end

	if data.hydrationData ~= nil then
		v2.hydration_data = hydration_content.HydrationContent.jsonDecode(data.hydrationData)
	end

	if data.templates == nil then
		return v2
	end

	local templates = {}

	for k, template in data.templates do
		templates[k] = template_entry.TemplateEntry.jsonDecode(template)
	end

	v2.templates = templates

	return v2
end

class2.descriptor = {
	name = "BadgeDetailsPageResponse",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageResponse"
}

v.BadgeDetailsPageResponse = class2

typeRegistry.default:register(v.BadgeDetailsPageResponse)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class3))
end

function class3:encode()
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

function class3:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class3.descriptor = {
	name = "BadgeDetailsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}

v.BadgeDetailsPageResponse_TemplatesEntry = class3

typeRegistry.default:register(v.BadgeDetailsPageResponse_TemplatesEntry)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_entries ~= nil and #self.page_entries > 0 then
		for _, page_entry2 in self.page_entries do
			local encoded = page_entry2:encode()
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.BadgeDetailsPageV2Response_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
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

	if self.page_entries ~= nil and #self.page_entries > 0 then
		local pageEntries = {}

		for _, page_entry2 in self.page_entries do
			table.insert(pageEntries, page_entry2:jsonEncode())
		end

		v2.pageEntries = pageEntries
	end

	if self.hydration_data ~= nil then
		v2.hydrationData = self.hydration_data:jsonEncode()
	end

	if self.templates == nil or next(self.templates) == nil then
		return v2
	end

	local templates = {}

	for k, template in self.templates do
		templates[k] = template:jsonEncode()
	end

	v2.templates = templates

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.page_entries ~= nil then
		local page_entries = {}

		for _, page_entry2 in data.page_entries do
			table.insert(page_entries, page_entry_content.UniversalPageEntry.jsonDecode(page_entry2))
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

	if data.templates == nil then
		return v2
	end

	local templates = {}

	for k, template in data.templates do
		templates[k] = template_entry.TemplateEntry.jsonDecode(template)
	end

	v2.templates = templates

	return v2
end

class4.descriptor = {
	name = "BadgeDetailsPageV2Response",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageV2Response"
}

v.BadgeDetailsPageV2Response = class4

typeRegistry.default:register(v.BadgeDetailsPageV2Response)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class5))
end

function class5:encode()
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

function class5:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class5.descriptor = {
	name = "BadgeDetailsPageV2Response_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}

v.BadgeDetailsPageV2Response_TemplatesEntry = class5

typeRegistry.default:register(v.BadgeDetailsPageV2Response_TemplatesEntry)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local page_entry2

	if not (p == nil or p.page_entry == nil) then
		page_entry2 = p.page_entry
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ page_entry = page_entry2, kind = kind }, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_entry ~= nil then
		local encoded = self.page_entry:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil and self.kind.type == "badge_details" then
		local encoded = self.kind.value:encode()
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
				result.page_entry = page_entry.PageEntry.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "badge_details",
					value = v.BadgeDetailsContent.decode(v5)
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

function class6:jsonEncode()
	local v2 = {}

	if self.page_entry ~= nil then
		v2.pageEntry = self.page_entry:jsonEncode()
	end

	if self.kind ~= nil and self.kind.type == "badge_details" then
		v2.badgeDetails = self.kind.value:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.page_entry ~= nil then
		v2.page_entry = page_entry.PageEntry.jsonDecode(data.page_entry)
	end

	if data.pageEntry ~= nil then
		v2.page_entry = page_entry.PageEntry.jsonDecode(data.pageEntry)
	end

	if data.badge_details ~= nil then
		v2.kind = {
			type = "badge_details",
			value = v.BadgeDetailsContent.jsonDecode(data.badge_details)
		}
	end

	if data.badgeDetails ~= nil then
		v2.kind = {
			type = "badge_details",
			value = v.BadgeDetailsContent.jsonDecode(data.badgeDetails)
		}
	end

	return v2
end

class6.descriptor = {
	name = "BadgeDetailsPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageEntry"
}

v.BadgeDetailsPageEntry = class6

typeRegistry.default:register(v.BadgeDetailsPageEntry)

local class7 = {}
class7.__index = class7

function class7.new(data)
	local v2 = {
		badge_id = (data == nil or data.badge_id == nil) and "" or data.badge_id,
		universe_id = (data == nil or data.universe_id == nil) and "" or data.universe_id,
		localized_literals = 0,
		creator_key = 0
	}
	local localized_literals

	if not (data == nil or data.localized_literals == nil) then
		localized_literals = data.localized_literals
	end

	v2.localized_literals = localized_literals
	v2.creator_key = (data == nil or data.creator_key == nil) and "" or data.creator_key
	return (setmetatable(v2, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.badge_id ~= nil and self.badge_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.badge_id)
	end

	if self.universe_id ~= nil and self.universe_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.universe_id)
	end

	if self.localized_literals ~= nil then
		local encoded = self.localized_literals:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.creator_key ~= nil and self.creator_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_key)
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
				result.badge_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.universe_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.localized_literals = v.BadgeDetailsContent_LocalizedLiterals.decode(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_key = buffer.tostring(v5)
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

	if self.badge_id ~= nil and self.badge_id ~= "" then
		v2.badgeId = self.badge_id
	end

	if self.universe_id ~= nil and self.universe_id ~= "" then
		v2.universeId = self.universe_id
	end

	if self.localized_literals ~= nil then
		v2.localizedLiterals = self.localized_literals:jsonEncode()
	end

	if self.creator_key ~= nil and self.creator_key ~= "" then
		v2.creatorKey = self.creator_key
	end

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.badge_id ~= nil then
		v2.badge_id = data.badge_id
	end

	if data.badgeId ~= nil then
		v2.badge_id = data.badgeId
	end

	if data.universe_id ~= nil then
		v2.universe_id = data.universe_id
	end

	if data.universeId ~= nil then
		v2.universe_id = data.universeId
	end

	if data.localized_literals ~= nil then
		v2.localized_literals = v.BadgeDetailsContent_LocalizedLiterals.jsonDecode(data.localized_literals)
	end

	if data.localizedLiterals ~= nil then
		v2.localized_literals = v.BadgeDetailsContent_LocalizedLiterals.jsonDecode(data.localizedLiterals)
	end

	if data.creator_key ~= nil then
		v2.creator_key = data.creator_key
	end

	if data.creatorKey ~= nil then
		v2.creator_key = data.creatorKey
	end

	return v2
end

class7.descriptor = {
	name = "BadgeDetailsContent",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsContent"
}

v.BadgeDetailsContent = class7

typeRegistry.default:register(v.BadgeDetailsContent)

local class8 = {}
class8.__index = class8

function class8.new(data)
	local info_table

	if not (data == nil or data.info_table == nil) then
		info_table = data.info_table
	end

	local action_module

	if not (data == nil or data.action_module == nil) then
		action_module = data.action_module
	end

	local overflow_menu

	if not (data == nil or data.overflow_menu == nil) then
		overflow_menu = data.overflow_menu
	end

	return (setmetatable(
		{ info_table = info_table, action_module = action_module, overflow_menu = overflow_menu },
		class8
	))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.info_table ~= nil then
		local encoded = self.info_table:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.action_module ~= nil then
		local encoded = self.action_module:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.overflow_menu ~= nil then
		local encoded = self.overflow_menu:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
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
				result.info_table = v.BadgeDetailsContent_LocalizedLiterals_InfoTable.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.action_module = v.BadgeDetailsContent_LocalizedLiterals_ActionModule.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.overflow_menu = v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.decode(v5)
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

	if self.info_table ~= nil then
		v2.infoTable = self.info_table:jsonEncode()
	end

	if self.action_module ~= nil then
		v2.actionModule = self.action_module:jsonEncode()
	end

	if self.overflow_menu ~= nil then
		v2.overflowMenu = self.overflow_menu:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.info_table ~= nil then
		v2.info_table = v.BadgeDetailsContent_LocalizedLiterals_InfoTable.jsonDecode(data.info_table)
	end

	if data.infoTable ~= nil then
		v2.info_table = v.BadgeDetailsContent_LocalizedLiterals_InfoTable.jsonDecode(data.infoTable)
	end

	if data.action_module ~= nil then
		v2.action_module = v.BadgeDetailsContent_LocalizedLiterals_ActionModule.jsonDecode(data.action_module)
	end

	if data.actionModule ~= nil then
		v2.action_module = v.BadgeDetailsContent_LocalizedLiterals_ActionModule.jsonDecode(data.actionModule)
	end

	if data.overflow_menu ~= nil then
		v2.overflow_menu = v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.jsonDecode(data.overflow_menu)
	end

	if data.overflowMenu ~= nil then
		v2.overflow_menu = v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.jsonDecode(data.overflowMenu)
	end

	return v2
end

class8.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals",
	fullName = "roblox.apppageplatform.badges.v1beta1.LocalizedLiterals"
}

v.BadgeDetailsContent_LocalizedLiterals = class8

typeRegistry.default:register(v.BadgeDetailsContent_LocalizedLiterals)

local class9 = {}
class9.__index = class9

function class9.new(data)
	return (setmetatable({
		type_label = (data == nil or data.type_label == nil) and "" or data.type_label,
		earned_label = (data == nil or data.earned_label == nil) and "" or data.earned_label,
		updated_label = (data == nil or data.updated_label == nil) and "" or data.updated_label,
		experience_label = (data == nil or data.experience_label == nil) and "" or data.experience_label,
		rarity_label = (data == nil or data.rarity_label == nil) and "" or data.rarity_label,
		won_yesterday_label = (data == nil or data.won_yesterday_label == nil) and "" or data.won_yesterday_label,
		won_ever_label = (data == nil or data.won_ever_label == nil) and "" or data.won_ever_label
	}, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.type_label ~= nil and self.type_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type_label)
	end

	if self.earned_label ~= nil and self.earned_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.earned_label)
	end

	if self.updated_label ~= nil and self.updated_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.updated_label)
	end

	if self.experience_label ~= nil and self.experience_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.experience_label)
	end

	if self.rarity_label ~= nil and self.rarity_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.rarity_label)
	end

	if self.won_yesterday_label ~= nil and self.won_yesterday_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.won_yesterday_label)
	end

	if self.won_ever_label ~= nil and self.won_ever_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.won_ever_label)
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
				result.type_label = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.earned_label = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.updated_label = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.experience_label = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.rarity_label = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.won_yesterday_label = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.won_ever_label = buffer.tostring(v5)
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

	if self.type_label ~= nil and self.type_label ~= "" then
		v2.typeLabel = self.type_label
	end

	if self.earned_label ~= nil and self.earned_label ~= "" then
		v2.earnedLabel = self.earned_label
	end

	if self.updated_label ~= nil and self.updated_label ~= "" then
		v2.updatedLabel = self.updated_label
	end

	if self.experience_label ~= nil and self.experience_label ~= "" then
		v2.experienceLabel = self.experience_label
	end

	if self.rarity_label ~= nil and self.rarity_label ~= "" then
		v2.rarityLabel = self.rarity_label
	end

	if self.won_yesterday_label ~= nil and self.won_yesterday_label ~= "" then
		v2.wonYesterdayLabel = self.won_yesterday_label
	end

	if self.won_ever_label ~= nil and self.won_ever_label ~= "" then
		v2.wonEverLabel = self.won_ever_label
	end

	return v2
end

function class9.jsonDecode(data)
	local v2 = class9.new()

	if data.type_label ~= nil then
		v2.type_label = data.type_label
	end

	if data.typeLabel ~= nil then
		v2.type_label = data.typeLabel
	end

	if data.earned_label ~= nil then
		v2.earned_label = data.earned_label
	end

	if data.earnedLabel ~= nil then
		v2.earned_label = data.earnedLabel
	end

	if data.updated_label ~= nil then
		v2.updated_label = data.updated_label
	end

	if data.updatedLabel ~= nil then
		v2.updated_label = data.updatedLabel
	end

	if data.experience_label ~= nil then
		v2.experience_label = data.experience_label
	end

	if data.experienceLabel ~= nil then
		v2.experience_label = data.experienceLabel
	end

	if data.rarity_label ~= nil then
		v2.rarity_label = data.rarity_label
	end

	if data.rarityLabel ~= nil then
		v2.rarity_label = data.rarityLabel
	end

	if data.won_yesterday_label ~= nil then
		v2.won_yesterday_label = data.won_yesterday_label
	end

	if data.wonYesterdayLabel ~= nil then
		v2.won_yesterday_label = data.wonYesterdayLabel
	end

	if data.won_ever_label ~= nil then
		v2.won_ever_label = data.won_ever_label
	end

	if data.wonEverLabel ~= nil then
		v2.won_ever_label = data.wonEverLabel
	end

	return v2
end

class9.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.badges.v1beta1.InfoTable"
}

v.BadgeDetailsContent_LocalizedLiterals_InfoTable = class9

typeRegistry.default:register(v.BadgeDetailsContent_LocalizedLiterals_InfoTable)

local class10 = {}
class10.__index = class10

function class10.new(p)
	return (setmetatable({
		share = (p == nil or p.share == nil) and "" or p.share,
		report = (p == nil or p.report == nil) and "" or p.report
	}, class10))
end

function class10:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.share ~= nil and self.share ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.share)
	end

	if self.report ~= nil and self.report ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.report)
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
				result.share = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.report = buffer.tostring(v5)
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

	if self.share ~= nil and self.share ~= "" then
		v2.share = self.share
	end

	if self.report ~= nil and self.report ~= "" then
		v2.report = self.report
	end

	return v2
end

function class10.jsonDecode(p)
	local v2 = class10.new()

	if p.share ~= nil then
		v2.share = p.share
	end

	if p.report ~= nil then
		v2.report = p.report
	end

	return v2
end

class10.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.badges.v1beta1.ActionModule"
}

v.BadgeDetailsContent_LocalizedLiterals_ActionModule = class10

typeRegistry.default:register(v.BadgeDetailsContent_LocalizedLiterals_ActionModule)

local class11 = {}
class11.__index = class11

function class11.new(p)
	return (setmetatable({
		report = (p == nil or p.report == nil) and "" or p.report,
		remove = (p == nil or p.remove == nil) and "" or p.remove
	}, class11))
end

function class11:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.report ~= nil and self.report ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.report)
	end

	if self.remove ~= nil and self.remove ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.remove)
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
				result.report = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.remove = buffer.tostring(v5)
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

	if self.report ~= nil and self.report ~= "" then
		v2.report = self.report
	end

	if self.remove ~= nil and self.remove ~= "" then
		v2.remove = self.remove
	end

	return v2
end

function class11.jsonDecode(p)
	local v2 = class11.new()

	if p.report ~= nil then
		v2.report = p.report
	end

	if p.remove ~= nil then
		v2.remove = p.remove
	end

	return v2
end

class11.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.badges.v1beta1.OverflowMenu"
}

v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu = class11

typeRegistry.default:register(v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu)

return {
	BadgeDetailsPageRequest = v.BadgeDetailsPageRequest,
	BadgeDetailsPageResponse = v.BadgeDetailsPageResponse,
	BadgeDetailsPageV2Response = v.BadgeDetailsPageV2Response,
	BadgeDetailsPageEntry = v.BadgeDetailsPageEntry,
	BadgeDetailsContent = v.BadgeDetailsContent,
	BadgeDetailsContent_LocalizedLiterals = v.BadgeDetailsContent_LocalizedLiterals,
	BadgeDetailsContent_LocalizedLiterals_InfoTable = v.BadgeDetailsContent_LocalizedLiterals_InfoTable,
	BadgeDetailsContent_LocalizedLiterals_ActionModule = v.BadgeDetailsContent_LocalizedLiterals_ActionModule,
	BadgeDetailsContent_LocalizedLiterals_OverflowMenu = v.BadgeDetailsContent_LocalizedLiterals_OverflowMenu
}
