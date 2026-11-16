local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		event_id = (p == nil or p.event_id == nil) and 0 or p.event_id,
		user_id = (p == nil or p.user_id == nil) and 0 or p.user_id
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.event_id ~= nil and self.event_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.event_id)
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.user_id)
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
				local event_id
				event_id, v2 = proto.readVarIntI64(buf, v2)
				result.event_id = event_id
			elseif v3 == 2 then
				local user_id
				user_id, v2 = proto.readVarIntI64(buf, v2)
				result.user_id = user_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

	if self.event_id ~= nil and self.event_id ~= 0 then
		v2.eventId = self.event_id
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		v2.userId = self.user_id
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.event_id ~= nil then
		v2.event_id = data.event_id
	end

	if data.eventId ~= nil then
		v2.event_id = data.eventId
	end

	if data.user_id ~= nil then
		v2.user_id = data.user_id
	end

	if data.userId ~= nil then
		v2.user_id = data.userId
	end

	return v2
end

class.descriptor = {
	name = "ExperienceEventDetailsPageRequest",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.ExperienceEventDetailsPageRequest"
}

v.ExperienceEventDetailsPageRequest = class

typeRegistry.default:register(v.ExperienceEventDetailsPageRequest)

local class2 = {}
class2.__index = class2

function class2.new(data)
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
	return (setmetatable(v2, class2))
end

function class2:encode()
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.ExperienceEventDetailsPageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry.decode(v5)

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

function class2:jsonEncode()
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

function class2.jsonDecode(data)
	local v2 = class2.new()

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

class2.descriptor = {
	name = "ExperienceEventDetailsPageResponse",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.ExperienceEventDetailsPageResponse"
}

v.ExperienceEventDetailsPageResponse = class2

typeRegistry.default:register(v.ExperienceEventDetailsPageResponse)

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
	name = "ExperienceEventDetailsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.TemplatesEntry"
}

v.ExperienceEventDetailsPageResponse_TemplatesEntry = class3

typeRegistry.default:register(v.ExperienceEventDetailsPageResponse_TemplatesEntry)

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
	name = "ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.LocalizedLiteralsEntry"
}

v.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry = class4

typeRegistry.default:register(v.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry)

return {
	ExperienceEventDetailsPageRequest = v.ExperienceEventDetailsPageRequest,
	ExperienceEventDetailsPageResponse = v.ExperienceEventDetailsPageResponse
}
