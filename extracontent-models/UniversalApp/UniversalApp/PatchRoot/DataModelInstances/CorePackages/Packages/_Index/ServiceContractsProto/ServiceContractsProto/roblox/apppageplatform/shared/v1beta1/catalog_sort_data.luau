local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local background_layer = require(script.Parent.background_layer)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		type = (data == nil or data.type == nil) and "" or data.type,
		encrypted_ad_tracking_data = 0
	}
	local encrypted_ad_tracking_data

	if not (data == nil or data.encrypted_ad_tracking_data == nil) then
		encrypted_ad_tracking_data = data.encrypted_ad_tracking_data
	end

	v2.encrypted_ad_tracking_data = encrypted_ad_tracking_data
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.type ~= nil and self.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type)
	end

	if self.encrypted_ad_tracking_data ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.encrypted_ad_tracking_data)
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
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.encrypted_ad_tracking_data = buffer.tostring(v5)
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

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.type ~= nil and self.type ~= "" then
		v2.type = self.type
	end

	if self.encrypted_ad_tracking_data ~= nil then
		v2.encryptedAdTrackingData = self.encrypted_ad_tracking_data
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.encrypted_ad_tracking_data ~= nil then
		v2.encrypted_ad_tracking_data = data.encrypted_ad_tracking_data
	end

	if data.encryptedAdTrackingData ~= nil then
		v2.encrypted_ad_tracking_data = data.encryptedAdTrackingData
	end

	return v2
end

class.descriptor = {
	name = "CatalogSortContentData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortContentData"
}

v.CatalogSortContentData = class

typeRegistry.default:register(v.CatalogSortContentData)

local class2 = {}
class2.__index = class2

function class2.new(p)
	return (setmetatable({
		content_type = (p == nil or p.content_type == nil) and "" or p.content_type
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.content_type ~= nil and self.content_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.content_type)
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
				result.content_type = buffer.tostring(v5)
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

	if self.content_type ~= nil and self.content_type ~= "" then
		v2.contentType = self.content_type
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.content_type ~= nil then
		v2.content_type = p.content_type
	end

	if p.contentType ~= nil then
		v2.content_type = p.contentType
	end

	return v2
end

class2.descriptor = {
	name = "CatalogSortCardItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortCardItemFooter"
}

v.CatalogSortCardItemFooter = class2

typeRegistry.default:register(v.CatalogSortCardItemFooter)

local class3 = {}
class3.__index = class3

function class3.new(p)
	return (setmetatable({
		thumbnail_aspect_ratio = (p == nil or p.thumbnail_aspect_ratio == nil) and "" or p.thumbnail_aspect_ratio,
		background_layers = (p == nil or p.background_layers == nil) and {} or p.background_layers
	}, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.thumbnail_aspect_ratio ~= nil and self.thumbnail_aspect_ratio ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.thumbnail_aspect_ratio)
	end

	if self.background_layers ~= nil and #self.background_layers > 0 then
		for _, background_layer2 in self.background_layers do
			local encoded = background_layer2:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.thumbnail_aspect_ratio = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.background_layers, background_layer.BackgroundLayer.decode(v5))
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

	if self.thumbnail_aspect_ratio ~= nil and self.thumbnail_aspect_ratio ~= "" then
		v2.thumbnailAspectRatio = self.thumbnail_aspect_ratio
	end

	if self.background_layers == nil or not (#self.background_layers > 0) then
		return v2
	end

	local backgroundLayers = {}

	for _, background_layer2 in self.background_layers do
		table.insert(backgroundLayers, background_layer2:jsonEncode())
	end

	v2.backgroundLayers = backgroundLayers

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.thumbnail_aspect_ratio ~= nil then
		v2.thumbnail_aspect_ratio = data.thumbnail_aspect_ratio
	end

	if data.thumbnailAspectRatio ~= nil then
		v2.thumbnail_aspect_ratio = data.thumbnailAspectRatio
	end

	if data.background_layers ~= nil then
		local background_layers = {}

		for _, background_layer2 in data.background_layers do
			table.insert(background_layers, background_layer.BackgroundLayer.jsonDecode(background_layer2))
		end

		v2.background_layers = background_layers
	end

	if data.backgroundLayers == nil then
		return v2
	end

	local background_layers = {}

	for _, backgroundLayer in data.backgroundLayers do
		table.insert(background_layers, background_layer.BackgroundLayer.jsonDecode(backgroundLayer))
	end

	v2.background_layers = background_layers

	return v2
end

class3.descriptor = {
	name = "CatalogSortCardStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortCardStyle"
}

v.CatalogSortCardStyle = class3

typeRegistry.default:register(v.CatalogSortCardStyle)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		type = (data == nil or data.type == nil) and "" or data.type,
		hydration_priority = (data == nil or data.hydration_priority == nil) and 0 or data.hydration_priority,
		hydration_count = (data == nil or data.hydration_count == nil) and 0 or data.hydration_count,
		content = (data == nil or data.content == nil) and {} or data.content,
		preview_columns = (data == nil or data.preview_columns == nil) and 0 or data.preview_columns,
		title = (data == nil or data.title == nil) and "" or data.title,
		description = (data == nil or data.description == nil) and "" or data.description,
		card_style = 0,
		card_footers = 0,
		tag_id = 0
	}
	local card_style

	if not (data == nil or data.card_style == nil) then
		card_style = data.card_style
	end

	v2.card_style = card_style
	v2.card_footers = (data == nil or data.card_footers == nil) and {} or data.card_footers
	v2.tag_id = (data == nil or data.tag_id == nil) and "" or data.tag_id
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.type ~= nil and self.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type)
	end

	if self.hydration_priority ~= nil and self.hydration_priority ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.hydration_priority)
	end

	if self.hydration_count ~= nil and self.hydration_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.hydration_count)
	end

	if self.content ~= nil and #self.content > 0 then
		for _, v4 in self.content do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	if self.preview_columns ~= nil and self.preview_columns ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.preview_columns)
	end

	if self.title ~= nil and self.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.title)
	end

	if self.description ~= nil and self.description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.description)
	end

	if self.card_style ~= nil then
		local encoded = self.card_style:encode()
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.card_footers ~= nil and #self.card_footers > 0 then
		for _, card_footer in self.card_footers do
			local encoded = card_footer:encode()
			local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.tag_id ~= nil and self.tag_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.tag_id)
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
			if v3 == 3 then
				local hydration_priority
				hydration_priority, v2 = proto.readVarIntI32(buf, v2)
				result.hydration_priority = hydration_priority
			elseif v3 == 4 then
				local hydration_count
				hydration_count, v2 = proto.readVarIntI32(buf, v2)
				result.hydration_count = hydration_count
			elseif v3 == 6 then
				local preview_columns
				preview_columns, v2 = proto.readVarIntI64(buf, v2)
				result.preview_columns = preview_columns
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.content, v.CatalogSortContentData.decode(v5))
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.card_style = v.CatalogSortCardStyle.decode(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.card_footers, v.CatalogSortCardItemFooter.decode(v5))
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.tag_id = buffer.tostring(v5)
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

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.type ~= nil and self.type ~= "" then
		v2.type = self.type
	end

	if self.hydration_priority ~= nil and self.hydration_priority ~= 0 then
		v2.hydrationPriority = self.hydration_priority
	end

	if self.hydration_count ~= nil and self.hydration_count ~= 0 then
		v2.hydrationCount = self.hydration_count
	end

	if self.content ~= nil and #self.content > 0 then
		local content = {}

		for _, v3 in self.content do
			table.insert(content, v3:jsonEncode())
		end

		v2.content = content
	end

	if self.preview_columns ~= nil and self.preview_columns ~= 0 then
		v2.previewColumns = self.preview_columns
	end

	if self.title ~= nil and self.title ~= "" then
		v2.title = self.title
	end

	if self.description ~= nil and self.description ~= "" then
		v2.description = self.description
	end

	if self.card_style ~= nil then
		v2.cardStyle = self.card_style:jsonEncode()
	end

	if self.card_footers ~= nil and #self.card_footers > 0 then
		local cardFooters = {}

		for _, card_footer in self.card_footers do
			table.insert(cardFooters, card_footer:jsonEncode())
		end

		v2.cardFooters = cardFooters
	end

	if self.tag_id ~= nil and self.tag_id ~= "" then
		v2.tagId = self.tag_id
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.hydration_priority ~= nil then
		v2.hydration_priority = data.hydration_priority
	end

	if data.hydrationPriority ~= nil then
		v2.hydration_priority = data.hydrationPriority
	end

	if data.hydration_count ~= nil then
		v2.hydration_count = data.hydration_count
	end

	if data.hydrationCount ~= nil then
		v2.hydration_count = data.hydrationCount
	end

	if data.content ~= nil then
		local content = {}

		for _, v3 in data.content do
			table.insert(content, v.CatalogSortContentData.jsonDecode(v3))
		end

		v2.content = content
	end

	if data.preview_columns ~= nil then
		v2.preview_columns = data.preview_columns
	end

	if data.previewColumns ~= nil then
		v2.preview_columns = data.previewColumns
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.card_style ~= nil then
		v2.card_style = v.CatalogSortCardStyle.jsonDecode(data.card_style)
	end

	if data.cardStyle ~= nil then
		v2.card_style = v.CatalogSortCardStyle.jsonDecode(data.cardStyle)
	end

	if data.card_footers ~= nil then
		local card_footers = {}

		for _, card_footer in data.card_footers do
			table.insert(card_footers, v.CatalogSortCardItemFooter.jsonDecode(card_footer))
		end

		v2.card_footers = card_footers
	end

	if data.cardFooters ~= nil then
		local card_footers = {}

		for _, cardFooter in data.cardFooters do
			table.insert(card_footers, v.CatalogSortCardItemFooter.jsonDecode(cardFooter))
		end

		v2.card_footers = card_footers
	end

	if data.tag_id ~= nil then
		v2.tag_id = data.tag_id
	end

	if data.tagId ~= nil then
		v2.tag_id = data.tagId
	end

	return v2
end

class4.descriptor = {
	name = "CatalogSortData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortData"
}

v.CatalogSortData = class4

typeRegistry.default:register(v.CatalogSortData)

return {
	CatalogSortContentData = v.CatalogSortContentData,
	CatalogSortCardItemFooter = v.CatalogSortCardItemFooter,
	CatalogSortCardStyle = v.CatalogSortCardStyle,
	CatalogSortData = v.CatalogSortData
}
