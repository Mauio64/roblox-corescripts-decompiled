local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		request_id = (data == nil or data.request_id == nil) and "" or data.request_id,
		context = (data == nil or data.context == nil) and "" or data.context,
		screen_size = (data == nil or data.screen_size == nil) and "" or data.screen_size,
		pagination = 0
	}
	local pagination

	if not (data == nil or data.pagination == nil) then
		pagination = data.pagination
	end

	v2.pagination = pagination
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.request_id ~= nil and self.request_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.request_id)
	end

	if self.context ~= nil and self.context ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.context)
	end

	if self.screen_size ~= nil and self.screen_size ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.screen_size)
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
				result.request_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.context = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.screen_size = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.pagination = v.RequestPagination.decode(v5)
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

	if self.request_id ~= nil and self.request_id ~= "" then
		v2.requestId = self.request_id
	end

	if self.context ~= nil and self.context ~= "" then
		v2.context = self.context
	end

	if self.screen_size ~= nil and self.screen_size ~= "" then
		v2.screenSize = self.screen_size
	end

	if self.pagination ~= nil then
		v2.pagination = self.pagination:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.request_id ~= nil then
		v2.request_id = data.request_id
	end

	if data.requestId ~= nil then
		v2.request_id = data.requestId
	end

	if data.context ~= nil then
		v2.context = data.context
	end

	if data.screen_size ~= nil then
		v2.screen_size = data.screen_size
	end

	if data.screenSize ~= nil then
		v2.screen_size = data.screenSize
	end

	if data.pagination ~= nil then
		v2.pagination = v.RequestPagination.jsonDecode(data.pagination)
	end

	return v2
end

class.descriptor = {
	name = "MarketplaceCatalogPageRequest",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.MarketplaceCatalogPageRequest"
}

v.MarketplaceCatalogPageRequest = class

typeRegistry.default:register(v.MarketplaceCatalogPageRequest)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local cursor

	if not (data == nil or data.cursor == nil) then
		cursor = data.cursor
	end

	local page_size

	if not (data == nil or data.page_size == nil) then
		page_size = data.page_size
	end

	local direction

	if not (data == nil or data.direction == nil) then
		direction = data.direction
	end

	return (setmetatable({ cursor = cursor, page_size = page_size, direction = direction }, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.cursor ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.cursor)
	end

	if self.page_size ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.page_size)
	end

	if self.direction ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)

		v2, v3 = proto.writeVarInt(v4, v5, v.PaginationDirection.toNumber(self.direction))
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
				local page_size
				page_size, v2 = proto.readVarIntI32(buf, v2)
				result.page_size = page_size
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.direction = v.PaginationDirection.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.cursor = buffer.tostring(v5)
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

	if self.cursor ~= nil then
		v2.cursor = self.cursor
	end

	if self.page_size ~= nil then
		v2.pageSize = self.page_size
	end

	if self.direction == nil then
		return v2
	end

	local direction

	if typeof(self.direction) == "number" then
		direction = self.direction
	else
		direction = v.PaginationDirection.toNumber(self.direction)
	end

	v2.direction = direction

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.cursor ~= nil then
		v2.cursor = data.cursor
	end

	if data.page_size ~= nil then
		v2.page_size = data.page_size
	end

	if data.pageSize ~= nil then
		v2.page_size = data.pageSize
	end

	if data.direction == nil then
		return v2
	end

	local direction

	if typeof(data.direction) == "number" then
		direction = v.PaginationDirection.fromNumber(data.direction) or data.direction
	else
		direction = v.PaginationDirection.fromName(data.direction) or data.direction
	end

	v2.direction = direction

	return v2
end

class2.descriptor = {
	name = "RequestPagination",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.RequestPagination"
}

v.RequestPagination = class2

typeRegistry.default:register(v.RequestPagination)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0,
		localized_literals = 0,
		pagination = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	v2.localized_literals = (data == nil or data.localized_literals == nil) and {} or data.localized_literals
	local pagination

	if not (data == nil or data.pagination == nil) then
		pagination = data.pagination
	end

	v2.pagination = pagination
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

	if self.pagination ~= nil then
		local encoded = self.pagination:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.MarketplaceCatalogPageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry.decode(v5)

				result.localized_literals[decoded.key or ""] = decoded.value or ""
			elseif v3 == 5 then
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

	if self.localized_literals ~= nil and next(self.localized_literals) ~= nil then
		local localized_literals = {}

		for k, localized_literal in self.localized_literals do
			localized_literals[k] = localized_literal
		end

		v2.localizedLiterals = localized_literals
	end

	if self.pagination ~= nil then
		v2.pagination = self.pagination:jsonEncode()
	end

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

	if data.localizedLiterals ~= nil then
		local localizedLiterals = {}

		for k, localizedLiteral in data.localizedLiterals do
			localizedLiterals[k] = localizedLiteral
		end

		v2.localized_literals = localizedLiterals
	end

	if data.pagination ~= nil then
		v2.pagination = v.Pagination.jsonDecode(data.pagination)
	end

	return v2
end

class3.descriptor = {
	name = "MarketplaceCatalogPageResponse",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.MarketplaceCatalogPageResponse"
}

v.MarketplaceCatalogPageResponse = class3

typeRegistry.default:register(v.MarketplaceCatalogPageResponse)

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
	name = "MarketplaceCatalogPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.TemplatesEntry"
}

v.MarketplaceCatalogPageResponse_TemplatesEntry = class4

typeRegistry.default:register(v.MarketplaceCatalogPageResponse_TemplatesEntry)

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
	name = "MarketplaceCatalogPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.LocalizedLiteralsEntry"
}

v.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry = class5

typeRegistry.default:register(v.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local next_cursor

	if not (p == nil or p.next_cursor == nil) then
		next_cursor = p.next_cursor
	end

	return (setmetatable({ next_cursor = next_cursor }, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.next_cursor ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.next_cursor)
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
				result.next_cursor = buffer.tostring(v5)
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

	if self.next_cursor ~= nil then
		v2.nextCursor = self.next_cursor
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.next_cursor ~= nil then
		v2.next_cursor = p.next_cursor
	end

	if p.nextCursor ~= nil then
		v2.next_cursor = p.nextCursor
	end

	return v2
end

class6.descriptor = {
	name = "Pagination",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.Pagination"
}

v.Pagination = class6

typeRegistry.default:register(v.Pagination)

v.PaginationDirection = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "PAGINATION_DIRECTION_INVALID"
		elseif p == 1 then
			return "PAGINATION_DIRECTION_FORWARD"
		elseif p == 2 then
			return "PAGINATION_DIRECTION_BACKWARD"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "PAGINATION_DIRECTION_INVALID" then
			return 0
		elseif p == "PAGINATION_DIRECTION_FORWARD" then
			return 1
		elseif p == "PAGINATION_DIRECTION_BACKWARD" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "PAGINATION_DIRECTION_INVALID" then
			return "PAGINATION_DIRECTION_INVALID"
		elseif p == "PAGINATION_DIRECTION_FORWARD" then
			return "PAGINATION_DIRECTION_FORWARD"
		elseif p == "PAGINATION_DIRECTION_BACKWARD" then
			return "PAGINATION_DIRECTION_BACKWARD"
		end

		return nil
	end
}

return {
	MarketplaceCatalogPageRequest = v.MarketplaceCatalogPageRequest,
	RequestPagination = v.RequestPagination,
	MarketplaceCatalogPageResponse = v.MarketplaceCatalogPageResponse,
	Pagination = v.Pagination,
	PaginationDirection = v.PaginationDirection
}
