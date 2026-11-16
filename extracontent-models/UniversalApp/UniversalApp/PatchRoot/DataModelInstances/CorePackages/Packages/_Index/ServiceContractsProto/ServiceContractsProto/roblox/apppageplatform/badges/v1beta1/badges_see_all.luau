local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		universe_id = (data == nil or data.universe_id == nil) and 0 or data.universe_id,
		user_id = (data == nil or data.user_id == nil) and 0 or data.user_id,
		page_size = (data == nil or data.page_size == nil) and 0 or data.page_size,
		cursor = (data == nil or data.cursor == nil) and "" or data.cursor,
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

	if self.universe_id ~= nil and self.universe_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.universe_id)
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.user_id)
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.page_size)
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.cursor)
	end

	if
		self.page_entry_format ~= nil
		and (self.page_entry_format ~= nil and self.page_entry_format ~= 0 or self.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, page_entry_content.PageEntryFormat.toNumber(self.page_entry_format))
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
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
				local universe_id
				universe_id, v2 = proto.readVarIntI64(buf, v2)
				result.universe_id = universe_id
			elseif v3 == 2 then
				local user_id
				user_id, v2 = proto.readVarIntI64(buf, v2)
				result.user_id = user_id
			elseif v3 == 3 then
				local page_size
				page_size, v2 = proto.readVarIntI32(buf, v2)
				result.page_size = page_size
			elseif v3 == 5 then
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
				result.cursor = buffer.tostring(v5)
			elseif v3 == 6 then
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

	if self.universe_id ~= nil and self.universe_id ~= 0 then
		v2.universeId = self.universe_id
	end

	if self.user_id ~= nil and self.user_id ~= 0 then
		v2.userId = self.user_id
	end

	if self.page_size ~= nil and self.page_size ~= 0 then
		v2.pageSize = self.page_size
	end

	if self.cursor ~= nil and self.cursor ~= "" then
		v2.cursor = self.cursor
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

	if data.universe_id ~= nil then
		v2.universe_id = data.universe_id
	end

	if data.universeId ~= nil then
		v2.universe_id = data.universeId
	end

	if data.user_id ~= nil then
		v2.user_id = data.user_id
	end

	if data.userId ~= nil then
		v2.user_id = data.userId
	end

	if data.page_size ~= nil then
		v2.page_size = data.page_size
	end

	if data.pageSize ~= nil then
		v2.page_size = data.pageSize
	end

	if data.cursor ~= nil then
		v2.cursor = data.cursor
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
	name = "BadgesSeeAllRequest",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllRequest"
}

v.BadgesSeeAllRequest = class

typeRegistry.default:register(v.BadgesSeeAllRequest)

local class2 = {}
class2.__index = class2

function class2.new(data)
	return (setmetatable({
		page_size = (data == nil or data.page_size == nil) and 0 or data.page_size,
		next_cursor = (data == nil or data.next_cursor == nil) and "" or data.next_cursor,
		prev_cursor = (data == nil or data.prev_cursor == nil) and "" or data.prev_cursor,
		total = (data == nil or data.total == nil) and 0 or data.total
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_size ~= nil and self.page_size ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.page_size)
	end

	if self.next_cursor ~= nil and self.next_cursor ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.next_cursor)
	end

	if self.prev_cursor ~= nil and self.prev_cursor ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.prev_cursor)
	end

	if self.total ~= nil and self.total ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total)
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
			if v3 == 1 then
				local page_size
				page_size, v2 = proto.readVarIntI32(buf, v2)
				result.page_size = page_size
			elseif v3 == 4 then
				local total
				total, v2 = proto.readVarIntI64(buf, v2)
				result.total = total
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.next_cursor = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.prev_cursor = buffer.tostring(v5)
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

	if self.page_size ~= nil and self.page_size ~= 0 then
		v2.pageSize = self.page_size
	end

	if self.next_cursor ~= nil and self.next_cursor ~= "" then
		v2.nextCursor = self.next_cursor
	end

	if self.prev_cursor ~= nil and self.prev_cursor ~= "" then
		v2.prevCursor = self.prev_cursor
	end

	if self.total ~= nil and self.total ~= 0 then
		v2.total = self.total
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.page_size ~= nil then
		v2.page_size = data.page_size
	end

	if data.pageSize ~= nil then
		v2.page_size = data.pageSize
	end

	if data.next_cursor ~= nil then
		v2.next_cursor = data.next_cursor
	end

	if data.nextCursor ~= nil then
		v2.next_cursor = data.nextCursor
	end

	if data.prev_cursor ~= nil then
		v2.prev_cursor = data.prev_cursor
	end

	if data.prevCursor ~= nil then
		v2.prev_cursor = data.prevCursor
	end

	if data.total ~= nil then
		v2.total = data.total
	end

	return v2
end

class2.descriptor = {
	name = "Pagination",
	fullName = "roblox.apppageplatform.badges.v1beta1.Pagination"
}

v.Pagination = class2

typeRegistry.default:register(v.Pagination)

local class3 = {}
class3.__index = class3

function class3.new(data)
	return (setmetatable({
		section_title = (data == nil or data.section_title == nil) and "" or data.section_title,
		badges = (data == nil or data.badges == nil) and {} or data.badges,
		collection_id = (data == nil or data.collection_id == nil) and "" or data.collection_id,
		collection_position = (data == nil or data.collection_position == nil) and "" or data.collection_position,
		universe_id = (data == nil or data.universe_id == nil) and "" or data.universe_id
	}, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.section_title ~= nil and self.section_title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.section_title)
	end

	if self.badges ~= nil and #self.badges > 0 then
		for _, badge in self.badges do
			local encoded = badge:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.collection_id ~= nil and self.collection_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.collection_id)
	end

	if self.collection_position ~= nil and self.collection_position ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.collection_position)
	end

	if self.universe_id ~= nil and self.universe_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.universe_id)
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
				result.section_title = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.badges, v.BadgesGridPageEntry_BadgeInputData.decode(v5))
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.collection_id = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.collection_position = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.universe_id = buffer.tostring(v5)
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

	if self.section_title ~= nil and self.section_title ~= "" then
		v2.sectionTitle = self.section_title
	end

	if self.badges ~= nil and #self.badges > 0 then
		local badges = {}

		for _, badge in self.badges do
			table.insert(badges, badge:jsonEncode())
		end

		v2.badges = badges
	end

	if self.collection_id ~= nil and self.collection_id ~= "" then
		v2.collectionId = self.collection_id
	end

	if self.collection_position ~= nil and self.collection_position ~= "" then
		v2.collectionPosition = self.collection_position
	end

	if self.universe_id ~= nil and self.universe_id ~= "" then
		v2.universeId = self.universe_id
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.section_title ~= nil then
		v2.section_title = data.section_title
	end

	if data.sectionTitle ~= nil then
		v2.section_title = data.sectionTitle
	end

	if data.badges ~= nil then
		local badges = {}

		for _, badge in data.badges do
			table.insert(badges, v.BadgesGridPageEntry_BadgeInputData.jsonDecode(badge))
		end

		v2.badges = badges
	end

	if data.collection_id ~= nil then
		v2.collection_id = data.collection_id
	end

	if data.collectionId ~= nil then
		v2.collection_id = data.collectionId
	end

	if data.collection_position ~= nil then
		v2.collection_position = data.collection_position
	end

	if data.collectionPosition ~= nil then
		v2.collection_position = data.collectionPosition
	end

	if data.universe_id ~= nil then
		v2.universe_id = data.universe_id
	end

	if data.universeId ~= nil then
		v2.universe_id = data.universeId
	end

	return v2
end

class3.descriptor = {
	name = "BadgesGridPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesGridPageEntry"
}

v.BadgesGridPageEntry = class3

typeRegistry.default:register(v.BadgesGridPageEntry)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		badge_id = (p == nil or p.badge_id == nil) and "" or p.badge_id
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.badge_id ~= nil and self.badge_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.badge_id)
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
				result.badge_id = buffer.tostring(v5)
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

	if self.badge_id ~= nil and self.badge_id ~= "" then
		v2.badgeId = self.badge_id
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.badge_id ~= nil then
		v2.badge_id = p.badge_id
	end

	if p.badgeId ~= nil then
		v2.badge_id = p.badgeId
	end

	return v2
end

class4.descriptor = {
	name = "BadgesGridPageEntry_BadgeInputData",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeInputData"
}

v.BadgesGridPageEntry_BadgeInputData = class4

typeRegistry.default:register(v.BadgesGridPageEntry_BadgeInputData)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local page_entry2

	if not (p == nil or p.page_entry == nil) then
		page_entry2 = p.page_entry
	end

	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ page_entry = page_entry2, kind = kind }, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.page_entry ~= nil then
		local encoded = self.page_entry:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.kind ~= nil and self.kind.type == "badges_grid" then
		local encoded = self.kind.value:encode()
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
				result.page_entry = page_entry.PageEntry.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "badges_grid",
					value = v.BadgesGridPageEntry.decode(v5)
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

function class5:jsonEncode()
	local v2 = {}

	if self.page_entry ~= nil then
		v2.pageEntry = self.page_entry:jsonEncode()
	end

	if self.kind ~= nil and self.kind.type == "badges_grid" then
		v2.badgesGrid = self.kind.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.page_entry ~= nil then
		v2.page_entry = page_entry.PageEntry.jsonDecode(data.page_entry)
	end

	if data.pageEntry ~= nil then
		v2.page_entry = page_entry.PageEntry.jsonDecode(data.pageEntry)
	end

	if data.badges_grid ~= nil then
		v2.kind = {
			type = "badges_grid",
			value = v.BadgesGridPageEntry.jsonDecode(data.badges_grid)
		}
	end

	if data.badgesGrid ~= nil then
		v2.kind = {
			type = "badges_grid",
			value = v.BadgesGridPageEntry.jsonDecode(data.badgesGrid)
		}
	end

	return v2
end

class5.descriptor = {
	name = "BadgesSeeAllPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllPageEntry"
}

v.BadgesSeeAllPageEntry = class5

typeRegistry.default:register(v.BadgesSeeAllPageEntry)

local class6 = {}
class6.__index = class6

function class6.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0,
		pagination = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	local pagination

	if not (data == nil or data.pagination == nil) then
		pagination = data.pagination
	end

	v2.pagination = pagination
	return (setmetatable(v2, class6))
end

function class6:encode()
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

	if self.pagination ~= nil then
		local encoded = self.pagination:encode()
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
				table.insert(result.page_entries, v.BadgesSeeAllPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.BadgesSeeAllResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.pagination = v.Pagination.decode(v5)
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

	if self.templates ~= nil and next(self.templates) ~= nil then
		local templates = {}

		for k, template in self.templates do
			templates[k] = template:jsonEncode()
		end

		v2.templates = templates
	end

	if self.pagination ~= nil then
		v2.pagination = self.pagination:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.page_entries ~= nil then
		local page_entries = {}

		for _, page_entry2 in data.page_entries do
			table.insert(page_entries, v.BadgesSeeAllPageEntry.jsonDecode(page_entry2))
		end

		v2.page_entries = page_entries
	end

	if data.pageEntries ~= nil then
		local page_entries = {}

		for _, pageEntry in data.pageEntries do
			table.insert(page_entries, v.BadgesSeeAllPageEntry.jsonDecode(pageEntry))
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

	if data.pagination ~= nil then
		v2.pagination = v.Pagination.jsonDecode(data.pagination)
	end

	return v2
end

class6.descriptor = {
	name = "BadgesSeeAllResponse",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllResponse"
}

v.BadgesSeeAllResponse = class6

typeRegistry.default:register(v.BadgesSeeAllResponse)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class7))
end

function class7:encode()
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

function class7:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class7.descriptor = {
	name = "BadgesSeeAllResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}

v.BadgesSeeAllResponse_TemplatesEntry = class7

typeRegistry.default:register(v.BadgesSeeAllResponse_TemplatesEntry)

local class8 = {}
class8.__index = class8

function class8.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0,
		pagination = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	local pagination

	if not (data == nil or data.pagination == nil) then
		pagination = data.pagination
	end

	v2.pagination = pagination
	return (setmetatable(v2, class8))
end

function class8:encode()
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

	if self.pagination ~= nil then
		local encoded = self.pagination:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.BadgesSeeAllV2Response_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.pagination = v.Pagination.decode(v5)
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

	if self.templates ~= nil and next(self.templates) ~= nil then
		local templates = {}

		for k, template in self.templates do
			templates[k] = template:jsonEncode()
		end

		v2.templates = templates
	end

	if self.pagination ~= nil then
		v2.pagination = self.pagination:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

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

	if data.templates ~= nil then
		local templates = {}

		for k, template in data.templates do
			templates[k] = template_entry.TemplateEntry.jsonDecode(template)
		end

		v2.templates = templates
	end

	if data.pagination ~= nil then
		v2.pagination = v.Pagination.jsonDecode(data.pagination)
	end

	return v2
end

class8.descriptor = {
	name = "BadgesSeeAllV2Response",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllV2Response"
}

v.BadgesSeeAllV2Response = class8

typeRegistry.default:register(v.BadgesSeeAllV2Response)

local class9 = {}
class9.__index = class9

function class9.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class9))
end

function class9:encode()
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

function class9:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class9.descriptor = {
	name = "BadgesSeeAllV2Response_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}

v.BadgesSeeAllV2Response_TemplatesEntry = class9

typeRegistry.default:register(v.BadgesSeeAllV2Response_TemplatesEntry)

return {
	BadgesSeeAllRequest = v.BadgesSeeAllRequest,
	Pagination = v.Pagination,
	BadgesGridPageEntry = v.BadgesGridPageEntry,
	BadgesGridPageEntry_BadgeInputData = v.BadgesGridPageEntry_BadgeInputData,
	BadgesSeeAllPageEntry = v.BadgesSeeAllPageEntry,
	BadgesSeeAllResponse = v.BadgesSeeAllResponse,
	BadgesSeeAllV2Response = v.BadgesSeeAllV2Response
}
