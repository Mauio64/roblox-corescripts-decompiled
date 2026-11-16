local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)

local hydration_stream_mode = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_stream_mode)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		feed_page_token = (data == nil or data.feed_page_token == nil) and "" or data.feed_page_token,
		device = (data == nil or data.device == nil) and "" or data.device,
		country = (data == nil or data.country == nil) and "" or data.country,
		age_group = (data == nil or data.age_group == nil) and "" or data.age_group,
		session_id = (data == nil or data.session_id == nil) and "" or data.session_id,
		entry_pagination_key = (data == nil or data.entry_pagination_key == nil) and "" or data.entry_pagination_key,
		entry_page_token = (data == nil or data.entry_page_token == nil) and "" or data.entry_page_token,
		max_memory = (data == nil or data.max_memory == nil) and "" or data.max_memory,
		page_type = (data == nil or data.page_type == nil) and "" or data.page_type,
		include_placeholders = 0,
		hydration_stream_enabled = 0,
		hydration_stream_mode = 0,
		collection_layout = 0,
		cached_roblox_component_to_template_id = 0,
		client_capabilities = 0,
		audience = 0
	}
	local include_placeholders

	if not (data == nil or data.include_placeholders == nil) then
		include_placeholders = data.include_placeholders
	end

	v2.include_placeholders = include_placeholders
	local hydration_stream_enabled

	if not (data == nil or data.hydration_stream_enabled == nil) then
		hydration_stream_enabled = data.hydration_stream_enabled
	end

	v2.hydration_stream_enabled = hydration_stream_enabled
	local hydration_stream_mode2

	if data == nil or data.hydration_stream_mode == nil then
		hydration_stream_mode2 = assert(
			hydration_stream_mode.HydrationStreamMode.fromNumber(0),
			"Enum has no 0 default"
		)
	else
		hydration_stream_mode2 = data.hydration_stream_mode
	end

	v2.hydration_stream_mode = hydration_stream_mode2
	local collection_layout

	if not (data == nil or data.collection_layout == nil) then
		collection_layout = data.collection_layout
	end

	v2.collection_layout = collection_layout
	v2.cached_roblox_component_to_template_id = (data == nil or data.cached_roblox_component_to_template_id == nil)
		and {}
		or data.cached_roblox_component_to_template_id
	local client_capabilities2

	if not (data == nil or data.client_capabilities == nil) then
		client_capabilities2 = data.client_capabilities
	end

	v2.client_capabilities = client_capabilities2

	v2.audience = (data == nil or data.audience == nil) and "" or data.audience
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.feed_page_token ~= nil and self.feed_page_token ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.feed_page_token)
	end

	if self.device ~= nil and self.device ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.device)
	end

	if self.country ~= nil and self.country ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.country)
	end

	if self.age_group ~= nil and self.age_group ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.age_group)
	end

	if self.session_id ~= nil and self.session_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.session_id)
	end

	if self.entry_pagination_key ~= nil and self.entry_pagination_key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.entry_pagination_key)
	end

	if self.entry_page_token ~= nil and self.entry_page_token ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.entry_page_token)
	end

	if self.max_memory ~= nil and self.max_memory ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.max_memory)
	end

	if self.page_type ~= nil and self.page_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.page_type)
	end

	if self.include_placeholders ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.include_placeholders and 1 or 0)
	end

	if self.hydration_stream_enabled ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.hydration_stream_enabled and 1 or 0)
	end

	if
		self.hydration_stream_mode ~= nil
		and (self.hydration_stream_mode ~= nil and self.hydration_stream_mode ~= 0 or self.hydration_stream_mode ~= hydration_stream_mode.HydrationStreamMode.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(
			v4,
			v5,
			hydration_stream_mode.HydrationStreamMode.toNumber(self.hydration_stream_mode)
		)
	end

	if self.collection_layout ~= nil then
		local encoded = self.collection_layout:encode()
		local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local v13, v14 = proto.writeTag(v2, v3, 14, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.audience ~= nil and self.audience ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.audience)
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
			if v3 == 10 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.include_placeholders = v5 ~= 0
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.hydration_stream_enabled = v5 ~= 0
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.hydration_stream_mode = hydration_stream_mode.HydrationStreamMode.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.feed_page_token = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.device = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.country = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.age_group = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.session_id = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.entry_pagination_key = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.entry_page_token = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.max_memory = buffer.tostring(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.page_type = buffer.tostring(v5)
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.collection_layout = v.CollectionLayoutInfo.decode(v5)
			elseif v3 == 14 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v5)

				result.cached_roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
			elseif v3 == 15 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.client_capabilities = client_capabilities.ClientCapabilities.decode(v5)
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.audience = buffer.tostring(v5)
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

	if self.feed_page_token ~= nil and self.feed_page_token ~= "" then
		v2.feedPageToken = self.feed_page_token
	end

	if self.device ~= nil and self.device ~= "" then
		v2.device = self.device
	end

	if self.country ~= nil and self.country ~= "" then
		v2.country = self.country
	end

	if self.age_group ~= nil and self.age_group ~= "" then
		v2.ageGroup = self.age_group
	end

	if self.session_id ~= nil and self.session_id ~= "" then
		v2.sessionId = self.session_id
	end

	if self.entry_pagination_key ~= nil and self.entry_pagination_key ~= "" then
		v2.entryPaginationKey = self.entry_pagination_key
	end

	if self.entry_page_token ~= nil and self.entry_page_token ~= "" then
		v2.entryPageToken = self.entry_page_token
	end

	if self.max_memory ~= nil and self.max_memory ~= "" then
		v2.maxMemory = self.max_memory
	end

	if self.page_type ~= nil and self.page_type ~= "" then
		v2.pageType = self.page_type
	end

	if self.include_placeholders ~= nil then
		v2.includePlaceholders = self.include_placeholders
	end

	if self.hydration_stream_enabled ~= nil then
		v2.hydrationStreamEnabled = self.hydration_stream_enabled
	end

	if
		self.hydration_stream_mode ~= nil
		and (self.hydration_stream_mode ~= nil and self.hydration_stream_mode ~= 0 or self.hydration_stream_mode ~= hydration_stream_mode.HydrationStreamMode.fromNumber(0))
	then
		local hydrationStreamMode

		if typeof(self.hydration_stream_mode) == "number" then
			hydrationStreamMode = self.hydration_stream_mode
		else
			hydrationStreamMode = hydration_stream_mode.HydrationStreamMode.toNumber(self.hydration_stream_mode)
		end

		v2.hydrationStreamMode = hydrationStreamMode
	end

	if self.collection_layout ~= nil then
		v2.collectionLayout = self.collection_layout:jsonEncode()
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

	if self.audience ~= nil and self.audience ~= "" then
		v2.audience = self.audience
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.feed_page_token ~= nil then
		v2.feed_page_token = data.feed_page_token
	end

	if data.feedPageToken ~= nil then
		v2.feed_page_token = data.feedPageToken
	end

	if data.device ~= nil then
		v2.device = data.device
	end

	if data.country ~= nil then
		v2.country = data.country
	end

	if data.age_group ~= nil then
		v2.age_group = data.age_group
	end

	if data.ageGroup ~= nil then
		v2.age_group = data.ageGroup
	end

	if data.session_id ~= nil then
		v2.session_id = data.session_id
	end

	if data.sessionId ~= nil then
		v2.session_id = data.sessionId
	end

	if data.entry_pagination_key ~= nil then
		v2.entry_pagination_key = data.entry_pagination_key
	end

	if data.entryPaginationKey ~= nil then
		v2.entry_pagination_key = data.entryPaginationKey
	end

	if data.entry_page_token ~= nil then
		v2.entry_page_token = data.entry_page_token
	end

	if data.entryPageToken ~= nil then
		v2.entry_page_token = data.entryPageToken
	end

	if data.max_memory ~= nil then
		v2.max_memory = data.max_memory
	end

	if data.maxMemory ~= nil then
		v2.max_memory = data.maxMemory
	end

	if data.page_type ~= nil then
		v2.page_type = data.page_type
	end

	if data.pageType ~= nil then
		v2.page_type = data.pageType
	end

	if data.include_placeholders ~= nil then
		v2.include_placeholders = data.include_placeholders
	end

	if data.includePlaceholders ~= nil then
		v2.include_placeholders = data.includePlaceholders
	end

	if data.hydration_stream_enabled ~= nil then
		v2.hydration_stream_enabled = data.hydration_stream_enabled
	end

	if data.hydrationStreamEnabled ~= nil then
		v2.hydration_stream_enabled = data.hydrationStreamEnabled
	end

	if data.hydration_stream_mode ~= nil then
		local hydration_stream_mode2

		if typeof(data.hydration_stream_mode) == "number" then
			hydration_stream_mode2 = hydration_stream_mode.HydrationStreamMode.fromNumber(data.hydration_stream_mode)
				or data.hydration_stream_mode
		else
			hydration_stream_mode2 = hydration_stream_mode.HydrationStreamMode.fromName(data.hydration_stream_mode)
				or data.hydration_stream_mode
		end

		v2.hydration_stream_mode = hydration_stream_mode2
	end

	if data.hydrationStreamMode ~= nil then
		local hydration_stream_mode2

		if typeof(data.hydrationStreamMode) == "number" then
			hydration_stream_mode2 = hydration_stream_mode.HydrationStreamMode.fromNumber(data.hydrationStreamMode)
				or data.hydrationStreamMode
		else
			hydration_stream_mode2 = hydration_stream_mode.HydrationStreamMode.fromName(data.hydrationStreamMode)
				or data.hydrationStreamMode
		end

		v2.hydration_stream_mode = hydration_stream_mode2
	end

	if data.collection_layout ~= nil then
		v2.collection_layout = v.CollectionLayoutInfo.jsonDecode(data.collection_layout)
	end

	if data.collectionLayout ~= nil then
		v2.collection_layout = v.CollectionLayoutInfo.jsonDecode(data.collectionLayout)
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

	if data.audience ~= nil then
		v2.audience = data.audience
	end

	return v2
end

class.descriptor = {
	name = "GetChartsPageRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageRequest"
}

v.GetChartsPageRequest = class

typeRegistry.default:register(v.GetChartsPageRequest)

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
	name = "GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}

v.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry = class2

typeRegistry.default:register(v.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry)

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({
		items_per_row = (p == nil or p.items_per_row == nil) and {} or p.items_per_row,
		rows_above_fold = (p == nil or p.rows_above_fold == nil) and 0 or p.rows_above_fold
	}, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.items_per_row ~= nil and next(self.items_per_row) ~= nil then
		for k, v4 in self.items_per_row do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.varint)
			local v11, v12 = proto.writeVarInt(v9, v10, v4)
			local v13, v14 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.rows_above_fold ~= nil and self.rows_above_fold ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.rows_above_fold)
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
				local rows_above_fold
				rows_above_fold, v2 = proto.readVarIntI32(buf, v2)
				result.rows_above_fold = rows_above_fold
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.CollectionLayoutInfo_ItemsPerRowEntry.decode(v5)

				result.items_per_row[decoded.key or ""] = decoded.value or 0
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

	if self.items_per_row ~= nil and next(self.items_per_row) ~= nil then
		local itemsPerRow = {}

		for k, v3 in self.items_per_row do
			itemsPerRow[k] = v3
		end

		v2.itemsPerRow = itemsPerRow
	end

	if self.rows_above_fold ~= nil and self.rows_above_fold ~= 0 then
		v2.rowsAboveFold = self.rows_above_fold
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.items_per_row ~= nil then
		local items_per_row = {}

		for k, v3 in data.items_per_row do
			items_per_row[k] = v3
		end

		v2.items_per_row = items_per_row
	end

	if data.itemsPerRow ~= nil then
		local items_per_row = {}

		for k, v3 in data.itemsPerRow do
			items_per_row[k] = v3
		end

		v2.items_per_row = items_per_row
	end

	if data.rows_above_fold ~= nil then
		v2.rows_above_fold = data.rows_above_fold
	end

	if data.rowsAboveFold ~= nil then
		v2.rows_above_fold = data.rowsAboveFold
	end

	return v2
end

class3.descriptor = {
	name = "CollectionLayoutInfo",
	fullName = "roblox.apppageplatform.charts.v1beta1.CollectionLayoutInfo"
}

v.CollectionLayoutInfo = class3

typeRegistry.default:register(v.CollectionLayoutInfo)

local class4 = {}
class4.__index = class4

function class4.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and 0 or p.value
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.value)
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
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.value = v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
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

	if self.value ~= nil and self.value ~= 0 then
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
	name = "CollectionLayoutInfo_ItemsPerRowEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.ItemsPerRowEntry"
}

v.CollectionLayoutInfo_ItemsPerRowEntry = class4

typeRegistry.default:register(v.CollectionLayoutInfo_ItemsPerRowEntry)

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

				local decoded = v.GetChartsPageResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.GetChartsPageResponse_LocalizedLiteralsEntry.decode(v5)

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
	name = "GetChartsPageResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageResponse"
}

v.GetChartsPageResponse = class5

typeRegistry.default:register(v.GetChartsPageResponse)

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
	name = "GetChartsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}

v.GetChartsPageResponse_TemplatesEntry = class6

typeRegistry.default:register(v.GetChartsPageResponse_TemplatesEntry)

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
	name = "GetChartsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}

v.GetChartsPageResponse_LocalizedLiteralsEntry = class7

typeRegistry.default:register(v.GetChartsPageResponse_LocalizedLiteralsEntry)

local class8 = {}
class8.__index = class8

function class8.new(data)
	local v2 = {
		sort_id = (data == nil or data.sort_id == nil) and "" or data.sort_id,
		content_page_token = (data == nil or data.content_page_token == nil) and "" or data.content_page_token,
		device = (data == nil or data.device == nil) and "" or data.device,
		country = (data == nil or data.country == nil) and "" or data.country,
		session_id = (data == nil or data.session_id == nil) and "" or data.session_id,
		age_group = (data == nil or data.age_group == nil) and "" or data.age_group,
		max_memory = (data == nil or data.max_memory == nil) and "" or data.max_memory,
		selected_genre = (data == nil or data.selected_genre == nil) and "" or data.selected_genre,
		cached_roblox_component_to_template_id = (data == nil or data.cached_roblox_component_to_template_id == nil) and {} or data.cached_roblox_component_to_template_id,
		client_capabilities = 0,
		audience = 0
	}
	local client_capabilities2

	if not (data == nil or data.client_capabilities == nil) then
		client_capabilities2 = data.client_capabilities
	end

	v2.client_capabilities = client_capabilities2

	v2.audience = (data == nil or data.audience == nil) and "" or data.audience
	return (setmetatable(v2, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.sort_id ~= nil and self.sort_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.sort_id)
	end

	if self.content_page_token ~= nil and self.content_page_token ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.content_page_token)
	end

	if self.device ~= nil and self.device ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.device)
	end

	if self.country ~= nil and self.country ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.country)
	end

	if self.session_id ~= nil and self.session_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.session_id)
	end

	if self.age_group ~= nil and self.age_group ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.age_group)
	end

	if self.max_memory ~= nil and self.max_memory ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.max_memory)
	end

	if self.selected_genre ~= nil and self.selected_genre ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.selected_genre)
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
			local v13, v14 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.audience ~= nil and self.audience ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.audience)
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
				result.sort_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content_page_token = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.device = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.country = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.session_id = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.age_group = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.max_memory = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.selected_genre = buffer.tostring(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry.decode(v5)

				result.cached_roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.client_capabilities = client_capabilities.ClientCapabilities.decode(v5)
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.audience = buffer.tostring(v5)
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

	if self.sort_id ~= nil and self.sort_id ~= "" then
		v2.sortId = self.sort_id
	end

	if self.content_page_token ~= nil and self.content_page_token ~= "" then
		v2.contentPageToken = self.content_page_token
	end

	if self.device ~= nil and self.device ~= "" then
		v2.device = self.device
	end

	if self.country ~= nil and self.country ~= "" then
		v2.country = self.country
	end

	if self.session_id ~= nil and self.session_id ~= "" then
		v2.sessionId = self.session_id
	end

	if self.age_group ~= nil and self.age_group ~= "" then
		v2.ageGroup = self.age_group
	end

	if self.max_memory ~= nil and self.max_memory ~= "" then
		v2.maxMemory = self.max_memory
	end

	if self.selected_genre ~= nil and self.selected_genre ~= "" then
		v2.selectedGenre = self.selected_genre
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

	if self.audience ~= nil and self.audience ~= "" then
		v2.audience = self.audience
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.sort_id ~= nil then
		v2.sort_id = data.sort_id
	end

	if data.sortId ~= nil then
		v2.sort_id = data.sortId
	end

	if data.content_page_token ~= nil then
		v2.content_page_token = data.content_page_token
	end

	if data.contentPageToken ~= nil then
		v2.content_page_token = data.contentPageToken
	end

	if data.device ~= nil then
		v2.device = data.device
	end

	if data.country ~= nil then
		v2.country = data.country
	end

	if data.session_id ~= nil then
		v2.session_id = data.session_id
	end

	if data.sessionId ~= nil then
		v2.session_id = data.sessionId
	end

	if data.age_group ~= nil then
		v2.age_group = data.age_group
	end

	if data.ageGroup ~= nil then
		v2.age_group = data.ageGroup
	end

	if data.max_memory ~= nil then
		v2.max_memory = data.max_memory
	end

	if data.maxMemory ~= nil then
		v2.max_memory = data.maxMemory
	end

	if data.selected_genre ~= nil then
		v2.selected_genre = data.selected_genre
	end

	if data.selectedGenre ~= nil then
		v2.selected_genre = data.selectedGenre
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

	if data.audience ~= nil then
		v2.audience = data.audience
	end

	return v2
end

class8.descriptor = {
	name = "GetChartsSortDetailRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailRequest"
}

v.GetChartsSortDetailRequest = class8

typeRegistry.default:register(v.GetChartsSortDetailRequest)

local class9 = {}
class9.__index = class9

function class9.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class9))
end

function class9:encode()
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

function class9:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class9.descriptor = {
	name = "GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}

v.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry = class9

typeRegistry.default:register(v.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry)

local class10 = {}
class10.__index = class10

function class10.new(data)
	local v2 = {
		page_entries = (data == nil or data.page_entries == nil) and {} or data.page_entries,
		hydration_data = 0,
		templates = 0,
		next_content_page_token = 0,
		localized_literals = 0
	}
	local hydration_data

	if not (data == nil or data.hydration_data == nil) then
		hydration_data = data.hydration_data
	end

	v2.hydration_data = hydration_data
	v2.templates = (data == nil or data.templates == nil) and {} or data.templates
	v2.next_content_page_token = (data == nil or data.next_content_page_token == nil) and ""
		or data.next_content_page_token
	v2.localized_literals = (data == nil or data.localized_literals == nil) and {} or data.localized_literals
	return (setmetatable(v2, class10))
end

function class10:encode()
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

	if self.next_content_page_token ~= nil and self.next_content_page_token ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.next_content_page_token)
	end

	if self.localized_literals ~= nil and next(self.localized_literals) ~= nil then
		for k, localized_literal in self.localized_literals do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeString(v8, v9, localized_literal)
			local v12, v13 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
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
				table.insert(result.page_entries, page_entry_content.UniversalPageEntry.decode(v5))
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.hydration_data = hydration_content.HydrationContent.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.GetChartsSortDetailResponse_TemplatesEntry.decode(v5)

				local templateEntry = template_entry.TemplateEntry.new()

				result.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.next_content_page_token = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.GetChartsSortDetailResponse_LocalizedLiteralsEntry.decode(v5)

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

function class10:jsonEncode()
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

	if self.next_content_page_token ~= nil and self.next_content_page_token ~= "" then
		v2.nextContentPageToken = self.next_content_page_token
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

function class10.jsonDecode(data)
	local v2 = class10.new()

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

	if data.next_content_page_token ~= nil then
		v2.next_content_page_token = data.next_content_page_token
	end

	if data.nextContentPageToken ~= nil then
		v2.next_content_page_token = data.nextContentPageToken
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

class10.descriptor = {
	name = "GetChartsSortDetailResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailResponse"
}

v.GetChartsSortDetailResponse = class10

typeRegistry.default:register(v.GetChartsSortDetailResponse)

local class11 = {}
class11.__index = class11

function class11.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class11))
end

function class11:encode()
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

function class11:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class11.jsonDecode(p)
	local v2 = class11.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class11.descriptor = {
	name = "GetChartsSortDetailResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}

v.GetChartsSortDetailResponse_TemplatesEntry = class11

typeRegistry.default:register(v.GetChartsSortDetailResponse_TemplatesEntry)

local class12 = {}
class12.__index = class12

function class12.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class12))
end

function class12:encode()
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

function class12:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class12.jsonDecode(p)
	local v2 = class12.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class12.descriptor = {
	name = "GetChartsSortDetailResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}

v.GetChartsSortDetailResponse_LocalizedLiteralsEntry = class12

typeRegistry.default:register(v.GetChartsSortDetailResponse_LocalizedLiteralsEntry)

return {
	GetChartsPageRequest = v.GetChartsPageRequest,
	CollectionLayoutInfo = v.CollectionLayoutInfo,
	GetChartsPageResponse = v.GetChartsPageResponse,
	GetChartsSortDetailRequest = v.GetChartsSortDetailRequest,
	GetChartsSortDetailResponse = v.GetChartsSortDetailResponse
}
