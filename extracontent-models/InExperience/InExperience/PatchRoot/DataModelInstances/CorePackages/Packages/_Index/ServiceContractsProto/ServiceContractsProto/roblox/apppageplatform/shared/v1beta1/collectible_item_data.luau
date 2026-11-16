local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local id

	if not (data == nil or data.id == nil) then
		id = data.id
	end

	local name

	if not (data == nil or data.name == nil) then
		name = data.name
	end

	local v2

	if not (data == nil or data.type == nil) then
		v2 = data.type
	end

	local target_id

	if not (data == nil or data.target_id == nil) then
		target_id = data.target_id
	end

	local has_verified_badge

	if not (data == nil or data.has_verified_badge == nil) then
		has_verified_badge = data.has_verified_badge
	end

	return (setmetatable({
		id = id,
		name = name,
		type = v2,
		target_id = target_id,
		has_verified_badge = has_verified_badge
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type)
	end

	if self.target_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.target_id)
	end

	if self.has_verified_badge ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.has_verified_badge and 1 or 0)
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
			if v3 == 5 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.has_verified_badge = v5 ~= 0
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
				result.name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.target_id = buffer.tostring(v5)
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

	if self.id ~= nil then
		v2.id = self.id
	end

	if self.name ~= nil then
		v2.name = self.name
	end

	if self.type ~= nil then
		v2.type = self.type
	end

	if self.target_id ~= nil then
		v2.targetId = self.target_id
	end

	if self.has_verified_badge ~= nil then
		v2.hasVerifiedBadge = self.has_verified_badge
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.target_id ~= nil then
		v2.target_id = data.target_id
	end

	if data.targetId ~= nil then
		v2.target_id = data.targetId
	end

	if data.has_verified_badge ~= nil then
		v2.has_verified_badge = data.has_verified_badge
	end

	if data.hasVerifiedBadge ~= nil then
		v2.has_verified_badge = data.hasVerifiedBadge
	end

	return v2
end

class.descriptor = {
	name = "CollectibleItemCreator",
	fullName = "roblox.apppageplatform.shared.v1beta1.CollectibleItemCreator"
}

v.CollectibleItemCreator = class

typeRegistry.default:register(v.CollectibleItemCreator)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		name = 0,
		detail_page_link = 0
	}
	local name

	if not (data == nil or data.name == nil) then
		name = data.name
	end

	v2.name = name
	local detail_page_link

	if not (data == nil or data.detail_page_link == nil) then
		detail_page_link = data.detail_page_link
	end

	v2.detail_page_link = detail_page_link
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.detail_page_link ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.detail_page_link)
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
				result.id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.detail_page_link = buffer.tostring(v5)
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

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.name ~= nil then
		v2.name = self.name
	end

	if self.detail_page_link ~= nil then
		v2.detailPageLink = self.detail_page_link
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.detail_page_link ~= nil then
		v2.detail_page_link = data.detail_page_link
	end

	if data.detailPageLink ~= nil then
		v2.detail_page_link = data.detailPageLink
	end

	return v2
end

class2.descriptor = {
	name = "CollectibleItemExperience",
	fullName = "roblox.apppageplatform.shared.v1beta1.CollectibleItemExperience"
}

v.CollectibleItemExperience = class2

typeRegistry.default:register(v.CollectibleItemExperience)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		collectible_product_id = 0,
		name = 0,
		description = 0,
		creator = 0,
		price = 0,
		lowest_price = 0,
		units_available_for_consumption = 0,
		offsale_deadline = 0,
		asset_stock = 0,
		has_resellers = 0,
		universe_ids = 0,
		sale_location_type = 0,
		quantity_limit_per_user = 0,
		resale_restriction = 0,
		lowest_available_resale_product_id = 0,
		lowest_available_resale_item_instance_id = 0,
		experiences = 0
	}
	local collectible_product_id

	if not (data == nil or data.collectible_product_id == nil) then
		collectible_product_id = data.collectible_product_id
	end

	v2.collectible_product_id = collectible_product_id
	local name

	if not (data == nil or data.name == nil) then
		name = data.name
	end

	v2.name = name
	local description

	if not (data == nil or data.description == nil) then
		description = data.description
	end

	v2.description = description
	local creator

	if not (data == nil or data.creator == nil) then
		creator = data.creator
	end

	v2.creator = creator
	local price

	if not (data == nil or data.price == nil) then
		price = data.price
	end

	v2.price = price
	local lowest_price

	if not (data == nil or data.lowest_price == nil) then
		lowest_price = data.lowest_price
	end

	v2.lowest_price = lowest_price
	local units_available_for_consumption

	if not (data == nil or data.units_available_for_consumption == nil) then
		units_available_for_consumption = data.units_available_for_consumption
	end

	v2.units_available_for_consumption = units_available_for_consumption
	local offsale_deadline

	if not (data == nil or data.offsale_deadline == nil) then
		offsale_deadline = data.offsale_deadline
	end

	v2.offsale_deadline = offsale_deadline
	local asset_stock

	if not (data == nil or data.asset_stock == nil) then
		asset_stock = data.asset_stock
	end

	v2.asset_stock = asset_stock
	local has_resellers

	if not (data == nil or data.has_resellers == nil) then
		has_resellers = data.has_resellers
	end

	v2.has_resellers = has_resellers
	v2.universe_ids = (data == nil or data.universe_ids == nil) and {} or data.universe_ids
	local sale_location_type

	if not (data == nil or data.sale_location_type == nil) then
		sale_location_type = data.sale_location_type
	end

	v2.sale_location_type = sale_location_type
	local quantity_limit_per_user

	if not (data == nil or data.quantity_limit_per_user == nil) then
		quantity_limit_per_user = data.quantity_limit_per_user
	end

	v2.quantity_limit_per_user = quantity_limit_per_user
	local resale_restriction

	if not (data == nil or data.resale_restriction == nil) then
		resale_restriction = data.resale_restriction
	end

	v2.resale_restriction = resale_restriction
	local lowest_available_resale_product_id

	if not (data == nil or data.lowest_available_resale_product_id == nil) then
		lowest_available_resale_product_id = data.lowest_available_resale_product_id
	end

	v2.lowest_available_resale_product_id = lowest_available_resale_product_id
	local lowest_available_resale_item_instance_id

	if not (data == nil or data.lowest_available_resale_item_instance_id == nil) then
		lowest_available_resale_item_instance_id = data.lowest_available_resale_item_instance_id
	end

	v2.lowest_available_resale_item_instance_id = lowest_available_resale_item_instance_id

	v2.experiences = (data == nil or data.experiences == nil) and {} or data.experiences
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.collectible_product_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.collectible_product_id)
	end

	if self.name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.description ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.description)
	end

	if self.creator ~= nil then
		local encoded = self.creator:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.price)
	end

	if self.lowest_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.lowest_price)
	end

	if self.units_available_for_consumption ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.units_available_for_consumption)
	end

	if self.offsale_deadline ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.offsale_deadline)
	end

	if self.asset_stock ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.asset_stock)
	end

	if self.has_resellers ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.has_resellers and 1 or 0)
	end

	if self.universe_ids ~= nil and #self.universe_ids > 0 then
		for _, universe_id in self.universe_ids do
			local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, universe_id)
		end
	end

	if self.sale_location_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.sale_location_type)
	end

	if self.quantity_limit_per_user ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.quantity_limit_per_user)
	end

	if self.resale_restriction ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.resale_restriction)
	end

	if self.lowest_available_resale_product_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.lowest_available_resale_product_id)
	end

	if self.lowest_available_resale_item_instance_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.lowest_available_resale_item_instance_id)
	end

	if self.experiences ~= nil and #self.experiences > 0 then
		for _, experience in self.experiences do
			local encoded = experience:encode()
			local v4, v5 = proto.writeTag(v2, v3, 18, proto.wireTypes.lengthDelimited)
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
			if v3 == 6 then
				local price
				price, v2 = proto.readVarIntI64(buf, v2)
				result.price = price
			elseif v3 == 7 then
				local lowest_price
				lowest_price, v2 = proto.readVarIntI64(buf, v2)
				result.lowest_price = lowest_price
			elseif v3 == 8 then
				local units_available_for_consumption
				units_available_for_consumption, v2 = proto.readVarIntI64(buf, v2)
				result.units_available_for_consumption = units_available_for_consumption
			elseif v3 == 10 then
				local asset_stock
				asset_stock, v2 = proto.readVarIntI64(buf, v2)
				result.asset_stock = asset_stock
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.has_resellers = v5 ~= 0
			elseif v3 == 14 then
				local quantity_limit_per_user
				quantity_limit_per_user, v2 = proto.readVarIntI32(buf, v2)
				result.quantity_limit_per_user = quantity_limit_per_user
			elseif v3 == 15 then
				local resale_restriction
				resale_restriction, v2 = proto.readVarIntI32(buf, v2)
				result.resale_restriction = resale_restriction
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
				result.collectible_product_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator = v.CollectibleItemCreator.decode(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.offsale_deadline = buffer.tostring(v5)
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.universe_ids, buffer.tostring(v5))
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.sale_location_type = buffer.tostring(v5)
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.lowest_available_resale_product_id = buffer.tostring(v5)
			elseif v3 == 17 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.lowest_available_resale_item_instance_id = buffer.tostring(v5)
			elseif v3 == 18 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.experiences, v.CollectibleItemExperience.decode(v5))
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

	if self.id ~= nil and self.id ~= "" then
		v2.id = self.id
	end

	if self.collectible_product_id ~= nil then
		v2.collectibleProductId = self.collectible_product_id
	end

	if self.name ~= nil then
		v2.name = self.name
	end

	if self.description ~= nil then
		v2.description = self.description
	end

	if self.creator ~= nil then
		v2.creator = self.creator:jsonEncode()
	end

	if self.price ~= nil then
		v2.price = self.price
	end

	if self.lowest_price ~= nil then
		v2.lowestPrice = self.lowest_price
	end

	if self.units_available_for_consumption ~= nil then
		v2.unitsAvailableForConsumption = self.units_available_for_consumption
	end

	if self.offsale_deadline ~= nil then
		v2.offsaleDeadline = self.offsale_deadline
	end

	if self.asset_stock ~= nil then
		v2.assetStock = self.asset_stock
	end

	if self.has_resellers ~= nil then
		v2.hasResellers = self.has_resellers
	end

	if self.universe_ids ~= nil and #self.universe_ids > 0 then
		local universe_ids = {}

		for _, universe_id in self.universe_ids do
			table.insert(universe_ids, universe_id)
		end

		v2.universeIds = universe_ids
	end

	if self.sale_location_type ~= nil then
		v2.saleLocationType = self.sale_location_type
	end

	if self.quantity_limit_per_user ~= nil then
		v2.quantityLimitPerUser = self.quantity_limit_per_user
	end

	if self.resale_restriction ~= nil then
		v2.resaleRestriction = self.resale_restriction
	end

	if self.lowest_available_resale_product_id ~= nil then
		v2.lowestAvailableResaleProductId = self.lowest_available_resale_product_id
	end

	if self.lowest_available_resale_item_instance_id ~= nil then
		v2.lowestAvailableResaleItemInstanceId = self.lowest_available_resale_item_instance_id
	end

	if self.experiences == nil or not (#self.experiences > 0) then
		return v2
	end

	local experiences = {}

	for _, experience in self.experiences do
		table.insert(experiences, experience:jsonEncode())
	end

	v2.experiences = experiences

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.collectible_product_id ~= nil then
		v2.collectible_product_id = data.collectible_product_id
	end

	if data.collectibleProductId ~= nil then
		v2.collectible_product_id = data.collectibleProductId
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.creator ~= nil then
		v2.creator = v.CollectibleItemCreator.jsonDecode(data.creator)
	end

	if data.price ~= nil then
		v2.price = data.price
	end

	if data.lowest_price ~= nil then
		v2.lowest_price = data.lowest_price
	end

	if data.lowestPrice ~= nil then
		v2.lowest_price = data.lowestPrice
	end

	if data.units_available_for_consumption ~= nil then
		v2.units_available_for_consumption = data.units_available_for_consumption
	end

	if data.unitsAvailableForConsumption ~= nil then
		v2.units_available_for_consumption = data.unitsAvailableForConsumption
	end

	if data.offsale_deadline ~= nil then
		v2.offsale_deadline = data.offsale_deadline
	end

	if data.offsaleDeadline ~= nil then
		v2.offsale_deadline = data.offsaleDeadline
	end

	if data.asset_stock ~= nil then
		v2.asset_stock = data.asset_stock
	end

	if data.assetStock ~= nil then
		v2.asset_stock = data.assetStock
	end

	if data.has_resellers ~= nil then
		v2.has_resellers = data.has_resellers
	end

	if data.hasResellers ~= nil then
		v2.has_resellers = data.hasResellers
	end

	if data.universe_ids ~= nil then
		local universe_ids = {}

		for _, universe_id in data.universe_ids do
			table.insert(universe_ids, universe_id)
		end

		v2.universe_ids = universe_ids
	end

	if data.universeIds ~= nil then
		local universeIds = {}

		for _, universeId in data.universeIds do
			table.insert(universeIds, universeId)
		end

		v2.universe_ids = universeIds
	end

	if data.sale_location_type ~= nil then
		v2.sale_location_type = data.sale_location_type
	end

	if data.saleLocationType ~= nil then
		v2.sale_location_type = data.saleLocationType
	end

	if data.quantity_limit_per_user ~= nil then
		v2.quantity_limit_per_user = data.quantity_limit_per_user
	end

	if data.quantityLimitPerUser ~= nil then
		v2.quantity_limit_per_user = data.quantityLimitPerUser
	end

	if data.resale_restriction ~= nil then
		v2.resale_restriction = data.resale_restriction
	end

	if data.resaleRestriction ~= nil then
		v2.resale_restriction = data.resaleRestriction
	end

	if data.lowest_available_resale_product_id ~= nil then
		v2.lowest_available_resale_product_id = data.lowest_available_resale_product_id
	end

	if data.lowestAvailableResaleProductId ~= nil then
		v2.lowest_available_resale_product_id = data.lowestAvailableResaleProductId
	end

	if data.lowest_available_resale_item_instance_id ~= nil then
		v2.lowest_available_resale_item_instance_id = data.lowest_available_resale_item_instance_id
	end

	if data.lowestAvailableResaleItemInstanceId ~= nil then
		v2.lowest_available_resale_item_instance_id = data.lowestAvailableResaleItemInstanceId
	end

	if data.experiences == nil then
		return v2
	end

	local experiences = {}

	for _, experience in data.experiences do
		table.insert(experiences, v.CollectibleItemExperience.jsonDecode(experience))
	end

	v2.experiences = experiences

	return v2
end

class3.descriptor = {
	name = "CollectibleItemData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CollectibleItemData"
}

v.CollectibleItemData = class3

typeRegistry.default:register(v.CollectibleItemData)

return {
	CollectibleItemCreator = v.CollectibleItemCreator,
	CollectibleItemExperience = v.CollectibleItemExperience,
	CollectibleItemData = v.CollectibleItemData
}
