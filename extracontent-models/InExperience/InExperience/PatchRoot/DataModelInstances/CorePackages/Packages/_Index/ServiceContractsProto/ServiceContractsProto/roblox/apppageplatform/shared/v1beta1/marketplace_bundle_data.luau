local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local marketplace_catalog_item_common = require(script.Parent.marketplace_catalog_item_common)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {}
	v2.id = (data == nil or data.id == nil) and "" or data.id
	v2.name = (data == nil or data.name == nil) and "" or data.name
	v2.creator_name = (data == nil or data.creator_name == nil) and "" or data.creator_name
	v2.creator_has_verified_badge = data ~= nil
		and data.creator_has_verified_badge ~= nil
		and data.creator_has_verified_badge
	v2.bundle_type = (data == nil or data.bundle_type == nil) and "" or data.bundle_type
	v2.price = (data == nil or data.price == nil) and 0 or data.price
	local description

	if not (data == nil or data.description == nil) then
		description = data.description
	end

	v2.description = description
	local creator_id

	if not (data == nil or data.creator_id == nil) then
		creator_id = data.creator_id
	end

	v2.creator_id = creator_id
	local creator_type

	if not (data == nil or data.creator_type == nil) then
		creator_type = data.creator_type
	end

	v2.creator_type = creator_type
	local creating_universe_id

	if not (data == nil or data.creating_universe_id == nil) then
		creating_universe_id = data.creating_universe_id
	end

	v2.creating_universe_id = creating_universe_id

	v2.taxonomy = (data == nil or data.taxonomy == nil) and {} or data.taxonomy
	v2.render_properties = (data == nil or data.render_properties == nil) and {} or data.render_properties
	v2.item_restrictions = (data == nil or data.item_restrictions == nil) and {} or data.item_restrictions
	local is_high_definition

	if not (data == nil or data.is_high_definition == nil) then
		is_high_definition = data.is_high_definition
	end

	v2.is_high_definition = is_high_definition
	local is_pbr

	if not (data == nil or data.is_pbr == nil) then
		is_pbr = data.is_pbr
	end

	v2.is_pbr = is_pbr
	local has_resellers

	if not (data == nil or data.has_resellers == nil) then
		has_resellers = data.has_resellers
	end

	v2.has_resellers = has_resellers
	local lowest_price

	if not (data == nil or data.lowest_price == nil) then
		lowest_price = data.lowest_price
	end

	v2.lowest_price = lowest_price
	local lowest_resale_price

	if not (data == nil or data.lowest_resale_price == nil) then
		lowest_resale_price = data.lowest_resale_price
	end

	v2.lowest_resale_price = lowest_resale_price
	local total_quantity

	if not (data == nil or data.total_quantity == nil) then
		total_quantity = data.total_quantity
	end

	v2.total_quantity = total_quantity
	local units_available_for_consumption

	if not (data == nil or data.units_available_for_consumption == nil) then
		units_available_for_consumption = data.units_available_for_consumption
	end

	v2.units_available_for_consumption = units_available_for_consumption
	local favorite_count

	if not (data == nil or data.favorite_count == nil) then
		favorite_count = data.favorite_count
	end

	v2.favorite_count = favorite_count
	v2.timed_options = (data == nil or data.timed_options == nil) and {} or data.timed_options
	local collectible_item_id

	if not (data == nil or data.collectible_item_id == nil) then
		collectible_item_id = data.collectible_item_id
	end

	v2.collectible_item_id = collectible_item_id
	local is_off_sale

	if not (data == nil or data.is_off_sale == nil) then
		is_off_sale = data.is_off_sale
	end

	v2.is_off_sale = is_off_sale
	local sale_location_type

	if not (data == nil or data.sale_location_type == nil) then
		sale_location_type = data.sale_location_type
	end

	v2.sale_location_type = sale_location_type
	v2.item_status = (data == nil or data.item_status == nil) and {} or data.item_status
	local price_status

	if not (data == nil or data.price_status == nil) then
		price_status = data.price_status
	end

	v2.price_status = price_status
	local product_id

	if not (data == nil or data.product_id == nil) then
		product_id = data.product_id
	end

	v2.product_id = product_id
	local owned

	if not (data == nil or data.owned == nil) then
		owned = data.owned
	end

	v2.owned = owned
	local is_purchasable

	if not (data == nil or data.is_purchasable == nil) then
		is_purchasable = data.is_purchasable
	end

	v2.is_purchasable = is_purchasable
	v2.variant_attributes = (data == nil or data.variant_attributes == nil) and {} or data.variant_attributes
	v2.genres = (data == nil or data.genres == nil) and {} or data.genres
	v2.bundled_items = (data == nil or data.bundled_items == nil) and {} or data.bundled_items
	local is_recolorable

	if not (data == nil or data.is_recolorable == nil) then
		is_recolorable = data.is_recolorable
	end

	v2.is_recolorable = is_recolorable
	local licensing

	if not (data == nil or data.licensing == nil) then
		licensing = data.licensing
	end

	v2.licensing = licensing
	local original_price

	if not (data == nil or data.original_price == nil) then
		original_price = data.original_price
	end

	v2.original_price = original_price
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.name ~= nil and self.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.name)
	end

	if self.creator_name ~= nil and self.creator_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_name)
	end

	if self.creator_has_verified_badge then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.creator_has_verified_badge and 1 or 0)
	end

	if self.bundle_type ~= nil and self.bundle_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.bundle_type)
	end

	if self.price ~= nil and self.price ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.price)
	end

	if self.description ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.description)
	end

	if self.creator_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_id)
	end

	if self.creator_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_type)
	end

	if self.creating_universe_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creating_universe_id)
	end

	if self.taxonomy ~= nil and #self.taxonomy > 0 then
		for _, v4 in self.taxonomy do
			local encoded = v4:encode()
			local v5, v6 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v5, v6, encoded, buffer.len(encoded))
		end
	end

	if self.render_properties ~= nil and #self.render_properties > 0 then
		for _, render_property in self.render_properties do
			local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, render_property)
		end
	end

	if self.item_restrictions ~= nil and #self.item_restrictions > 0 then
		for _, item_restriction in self.item_restrictions do
			local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, item_restriction)
		end
	end

	if self.is_high_definition ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_high_definition and 1 or 0)
	end

	if self.is_pbr ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_pbr and 1 or 0)
	end

	if self.has_resellers ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.has_resellers and 1 or 0)
	end

	if self.lowest_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.lowest_price)
	end

	if self.lowest_resale_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 18, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.lowest_resale_price)
	end

	if self.total_quantity ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 19, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total_quantity)
	end

	if self.units_available_for_consumption ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 20, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.units_available_for_consumption)
	end

	if self.favorite_count ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 21, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.favorite_count)
	end

	if self.timed_options ~= nil and #self.timed_options > 0 then
		for _, timed_option in self.timed_options do
			local encoded = timed_option:encode()
			local v4, v5 = proto.writeTag(v2, v3, 22, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.collectible_item_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 23, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.collectible_item_id)
	end

	if self.is_off_sale ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 24, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_off_sale and 1 or 0)
	end

	if self.sale_location_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 25, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.sale_location_type)
	end

	if self.item_status ~= nil and #self.item_status > 0 then
		for _, v4 in self.item_status do
			local v5, v6 = proto.writeTag(v2, v3, 26, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v5, v6, v4)
		end
	end

	if self.price_status ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 27, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.price_status)
	end

	if self.product_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 28, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.product_id)
	end

	if self.owned ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 29, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.owned and 1 or 0)
	end

	if self.is_purchasable ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 30, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_purchasable and 1 or 0)
	end

	if self.variant_attributes ~= nil and #self.variant_attributes > 0 then
		for _, variant_attribute in self.variant_attributes do
			local encoded = variant_attribute:encode()
			local v4, v5 = proto.writeTag(v2, v3, 31, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.genres ~= nil and #self.genres > 0 then
		for _, genre in self.genres do
			local v4, v5 = proto.writeTag(v2, v3, 32, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, genre)
		end
	end

	if self.bundled_items ~= nil and #self.bundled_items > 0 then
		for _, bundled_item in self.bundled_items do
			local encoded = bundled_item:encode()
			local v4, v5 = proto.writeTag(v2, v3, 33, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.is_recolorable ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 34, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_recolorable and 1 or 0)
	end

	if self.licensing ~= nil then
		local encoded = self.licensing:encode()
		local v4, v5 = proto.writeTag(v2, v3, 35, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.original_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 36, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.original_price)
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
			if v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.creator_has_verified_badge = v5 ~= 0
			elseif v3 == 6 then
				local price
				price, v2 = proto.readVarIntI64(buf, v2)
				result.price = price
			elseif v3 == 14 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_high_definition = v5 ~= 0
			elseif v3 == 15 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_pbr = v5 ~= 0
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.has_resellers = v5 ~= 0
			elseif v3 == 17 then
				local lowest_price
				lowest_price, v2 = proto.readVarIntI64(buf, v2)
				result.lowest_price = lowest_price
			elseif v3 == 18 then
				local lowest_resale_price
				lowest_resale_price, v2 = proto.readVarIntI64(buf, v2)
				result.lowest_resale_price = lowest_resale_price
			elseif v3 == 19 then
				local total_quantity
				total_quantity, v2 = proto.readVarIntI64(buf, v2)
				result.total_quantity = total_quantity
			elseif v3 == 20 then
				local units_available_for_consumption
				units_available_for_consumption, v2 = proto.readVarIntI64(buf, v2)
				result.units_available_for_consumption = units_available_for_consumption
			elseif v3 == 21 then
				local favorite_count
				favorite_count, v2 = proto.readVarIntI32(buf, v2)
				result.favorite_count = favorite_count
			elseif v3 == 24 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_off_sale = v5 ~= 0
			elseif v3 == 29 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.owned = v5 ~= 0
			elseif v3 == 30 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_purchasable = v5 ~= 0
			elseif v3 == 34 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_recolorable = v5 ~= 0
			elseif v3 == 36 then
				local original_price
				original_price, v2 = proto.readVarIntI64(buf, v2)
				result.original_price = original_price
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
				result.creator_name = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.bundle_type = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_id = buffer.tostring(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_type = buffer.tostring(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creating_universe_id = buffer.tostring(v5)
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.taxonomy, marketplace_catalog_item_common.MarketplaceCatalogTaxonomyNode.decode(v5))
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.render_properties, buffer.tostring(v5))
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.item_restrictions, buffer.tostring(v5))
			elseif v3 == 22 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(
					result.timed_options,
					marketplace_catalog_item_common.MarketplaceCatalogTimedOption.decode(v5)
				)
			elseif v3 == 23 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.collectible_item_id = buffer.tostring(v5)
			elseif v3 == 25 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.sale_location_type = buffer.tostring(v5)
			elseif v3 == 26 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.item_status, buffer.tostring(v5))
			elseif v3 == 27 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.price_status = buffer.tostring(v5)
			elseif v3 == 28 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.product_id = buffer.tostring(v5)
			elseif v3 == 31 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(
					result.variant_attributes,
					marketplace_catalog_item_common.MarketplaceCatalogVariantAttribute.decode(v5)
				)
			elseif v3 == 32 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.genres, buffer.tostring(v5))
			elseif v3 == 33 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(
					result.bundled_items,
					marketplace_catalog_item_common.MarketplaceCatalogBundledItem.decode(v5)
				)
			elseif v3 == 35 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.licensing = marketplace_catalog_item_common.MarketplaceCatalogItemLicensing.decode(v5)
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

	if self.name ~= nil and self.name ~= "" then
		v2.name = self.name
	end

	if self.creator_name ~= nil and self.creator_name ~= "" then
		v2.creatorName = self.creator_name
	end

	if self.creator_has_verified_badge then
		v2.creatorHasVerifiedBadge = self.creator_has_verified_badge
	end

	if self.bundle_type ~= nil and self.bundle_type ~= "" then
		v2.bundleType = self.bundle_type
	end

	if self.price ~= nil and self.price ~= 0 then
		v2.price = self.price
	end

	if self.description ~= nil then
		v2.description = self.description
	end

	if self.creator_id ~= nil then
		v2.creatorId = self.creator_id
	end

	if self.creator_type ~= nil then
		v2.creatorType = self.creator_type
	end

	if self.creating_universe_id ~= nil then
		v2.creatingUniverseId = self.creating_universe_id
	end

	if self.taxonomy ~= nil and #self.taxonomy > 0 then
		local taxonomy = {}

		for _, v3 in self.taxonomy do
			table.insert(taxonomy, v3:jsonEncode())
		end

		v2.taxonomy = taxonomy
	end

	if self.render_properties ~= nil and #self.render_properties > 0 then
		local render_properties = {}

		for _, render_property in self.render_properties do
			table.insert(render_properties, render_property)
		end

		v2.renderProperties = render_properties
	end

	if self.item_restrictions ~= nil and #self.item_restrictions > 0 then
		local item_restrictions = {}

		for _, item_restriction in self.item_restrictions do
			table.insert(item_restrictions, item_restriction)
		end

		v2.itemRestrictions = item_restrictions
	end

	if self.is_high_definition ~= nil then
		v2.isHighDefinition = self.is_high_definition
	end

	if self.is_pbr ~= nil then
		v2.isPbr = self.is_pbr
	end

	if self.has_resellers ~= nil then
		v2.hasResellers = self.has_resellers
	end

	if self.lowest_price ~= nil then
		v2.lowestPrice = self.lowest_price
	end

	if self.lowest_resale_price ~= nil then
		v2.lowestResalePrice = self.lowest_resale_price
	end

	if self.total_quantity ~= nil then
		v2.totalQuantity = self.total_quantity
	end

	if self.units_available_for_consumption ~= nil then
		v2.unitsAvailableForConsumption = self.units_available_for_consumption
	end

	if self.favorite_count ~= nil then
		v2.favoriteCount = self.favorite_count
	end

	if self.timed_options ~= nil and #self.timed_options > 0 then
		local timedOptions = {}

		for _, timed_option in self.timed_options do
			table.insert(timedOptions, timed_option:jsonEncode())
		end

		v2.timedOptions = timedOptions
	end

	if self.collectible_item_id ~= nil then
		v2.collectibleItemId = self.collectible_item_id
	end

	if self.is_off_sale ~= nil then
		v2.isOffSale = self.is_off_sale
	end

	if self.sale_location_type ~= nil then
		v2.saleLocationType = self.sale_location_type
	end

	if self.item_status ~= nil and #self.item_status > 0 then
		local itemStatus = {}

		for _, v3 in self.item_status do
			table.insert(itemStatus, v3)
		end

		v2.itemStatus = itemStatus
	end

	if self.price_status ~= nil then
		v2.priceStatus = self.price_status
	end

	if self.product_id ~= nil then
		v2.productId = self.product_id
	end

	if self.owned ~= nil then
		v2.owned = self.owned
	end

	if self.is_purchasable ~= nil then
		v2.isPurchasable = self.is_purchasable
	end

	if self.variant_attributes ~= nil and #self.variant_attributes > 0 then
		local variantAttributes = {}

		for _, variant_attribute in self.variant_attributes do
			table.insert(variantAttributes, variant_attribute:jsonEncode())
		end

		v2.variantAttributes = variantAttributes
	end

	if self.genres ~= nil and #self.genres > 0 then
		local genres = {}

		for _, genre in self.genres do
			table.insert(genres, genre)
		end

		v2.genres = genres
	end

	if self.bundled_items ~= nil and #self.bundled_items > 0 then
		local bundledItems = {}

		for _, bundled_item in self.bundled_items do
			table.insert(bundledItems, bundled_item:jsonEncode())
		end

		v2.bundledItems = bundledItems
	end

	if self.is_recolorable ~= nil then
		v2.isRecolorable = self.is_recolorable
	end

	if self.licensing ~= nil then
		v2.licensing = self.licensing:jsonEncode()
	end

	if self.original_price ~= nil then
		v2.originalPrice = self.original_price
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

	if data.creator_name ~= nil then
		v2.creator_name = data.creator_name
	end

	if data.creatorName ~= nil then
		v2.creator_name = data.creatorName
	end

	if data.creator_has_verified_badge ~= nil then
		v2.creator_has_verified_badge = data.creator_has_verified_badge
	end

	if data.creatorHasVerifiedBadge ~= nil then
		v2.creator_has_verified_badge = data.creatorHasVerifiedBadge
	end

	if data.bundle_type ~= nil then
		v2.bundle_type = data.bundle_type
	end

	if data.bundleType ~= nil then
		v2.bundle_type = data.bundleType
	end

	if data.price ~= nil then
		v2.price = data.price
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.creator_id ~= nil then
		v2.creator_id = data.creator_id
	end

	if data.creatorId ~= nil then
		v2.creator_id = data.creatorId
	end

	if data.creator_type ~= nil then
		v2.creator_type = data.creator_type
	end

	if data.creatorType ~= nil then
		v2.creator_type = data.creatorType
	end

	if data.creating_universe_id ~= nil then
		v2.creating_universe_id = data.creating_universe_id
	end

	if data.creatingUniverseId ~= nil then
		v2.creating_universe_id = data.creatingUniverseId
	end

	if data.taxonomy ~= nil then
		local taxonomy = {}

		for _, v3 in data.taxonomy do
			table.insert(taxonomy, marketplace_catalog_item_common.MarketplaceCatalogTaxonomyNode.jsonDecode(v3))
		end

		v2.taxonomy = taxonomy
	end

	if data.render_properties ~= nil then
		local render_properties = {}

		for _, render_property in data.render_properties do
			table.insert(render_properties, render_property)
		end

		v2.render_properties = render_properties
	end

	if data.renderProperties ~= nil then
		local renderProperties = {}

		for _, renderProperty in data.renderProperties do
			table.insert(renderProperties, renderProperty)
		end

		v2.render_properties = renderProperties
	end

	if data.item_restrictions ~= nil then
		local item_restrictions = {}

		for _, item_restriction in data.item_restrictions do
			table.insert(item_restrictions, item_restriction)
		end

		v2.item_restrictions = item_restrictions
	end

	if data.itemRestrictions ~= nil then
		local itemRestrictions = {}

		for _, itemRestriction in data.itemRestrictions do
			table.insert(itemRestrictions, itemRestriction)
		end

		v2.item_restrictions = itemRestrictions
	end

	if data.is_high_definition ~= nil then
		v2.is_high_definition = data.is_high_definition
	end

	if data.isHighDefinition ~= nil then
		v2.is_high_definition = data.isHighDefinition
	end

	if data.is_pbr ~= nil then
		v2.is_pbr = data.is_pbr
	end

	if data.isPbr ~= nil then
		v2.is_pbr = data.isPbr
	end

	if data.has_resellers ~= nil then
		v2.has_resellers = data.has_resellers
	end

	if data.hasResellers ~= nil then
		v2.has_resellers = data.hasResellers
	end

	if data.lowest_price ~= nil then
		v2.lowest_price = data.lowest_price
	end

	if data.lowestPrice ~= nil then
		v2.lowest_price = data.lowestPrice
	end

	if data.lowest_resale_price ~= nil then
		v2.lowest_resale_price = data.lowest_resale_price
	end

	if data.lowestResalePrice ~= nil then
		v2.lowest_resale_price = data.lowestResalePrice
	end

	if data.total_quantity ~= nil then
		v2.total_quantity = data.total_quantity
	end

	if data.totalQuantity ~= nil then
		v2.total_quantity = data.totalQuantity
	end

	if data.units_available_for_consumption ~= nil then
		v2.units_available_for_consumption = data.units_available_for_consumption
	end

	if data.unitsAvailableForConsumption ~= nil then
		v2.units_available_for_consumption = data.unitsAvailableForConsumption
	end

	if data.favorite_count ~= nil then
		v2.favorite_count = data.favorite_count
	end

	if data.favoriteCount ~= nil then
		v2.favorite_count = data.favoriteCount
	end

	if data.timed_options ~= nil then
		local timed_options = {}

		for _, timed_option in data.timed_options do
			table.insert(
				timed_options,
				marketplace_catalog_item_common.MarketplaceCatalogTimedOption.jsonDecode(timed_option)
			)
		end

		v2.timed_options = timed_options
	end

	if data.timedOptions ~= nil then
		local timed_options = {}

		for _, timedOption in data.timedOptions do
			table.insert(
				timed_options,
				marketplace_catalog_item_common.MarketplaceCatalogTimedOption.jsonDecode(timedOption)
			)
		end

		v2.timed_options = timed_options
	end

	if data.collectible_item_id ~= nil then
		v2.collectible_item_id = data.collectible_item_id
	end

	if data.collectibleItemId ~= nil then
		v2.collectible_item_id = data.collectibleItemId
	end

	if data.is_off_sale ~= nil then
		v2.is_off_sale = data.is_off_sale
	end

	if data.isOffSale ~= nil then
		v2.is_off_sale = data.isOffSale
	end

	if data.sale_location_type ~= nil then
		v2.sale_location_type = data.sale_location_type
	end

	if data.saleLocationType ~= nil then
		v2.sale_location_type = data.saleLocationType
	end

	if data.item_status ~= nil then
		local item_status = {}

		for _, v3 in data.item_status do
			table.insert(item_status, v3)
		end

		v2.item_status = item_status
	end

	if data.itemStatus ~= nil then
		local item_status = {}

		for _, v3 in data.itemStatus do
			table.insert(item_status, v3)
		end

		v2.item_status = item_status
	end

	if data.price_status ~= nil then
		v2.price_status = data.price_status
	end

	if data.priceStatus ~= nil then
		v2.price_status = data.priceStatus
	end

	if data.product_id ~= nil then
		v2.product_id = data.product_id
	end

	if data.productId ~= nil then
		v2.product_id = data.productId
	end

	if data.owned ~= nil then
		v2.owned = data.owned
	end

	if data.is_purchasable ~= nil then
		v2.is_purchasable = data.is_purchasable
	end

	if data.isPurchasable ~= nil then
		v2.is_purchasable = data.isPurchasable
	end

	if data.variant_attributes ~= nil then
		local variant_attributes = {}

		for _, variant_attribute in data.variant_attributes do
			table.insert(
				variant_attributes,
				marketplace_catalog_item_common.MarketplaceCatalogVariantAttribute.jsonDecode(variant_attribute)
			)
		end

		v2.variant_attributes = variant_attributes
	end

	if data.variantAttributes ~= nil then
		local variant_attributes = {}

		for _, variantAttribute in data.variantAttributes do
			table.insert(
				variant_attributes,
				marketplace_catalog_item_common.MarketplaceCatalogVariantAttribute.jsonDecode(variantAttribute)
			)
		end

		v2.variant_attributes = variant_attributes
	end

	if data.genres ~= nil then
		local genres = {}

		for _, genre in data.genres do
			table.insert(genres, genre)
		end

		v2.genres = genres
	end

	if data.bundled_items ~= nil then
		local bundled_items = {}

		for _, bundled_item in data.bundled_items do
			table.insert(
				bundled_items,
				marketplace_catalog_item_common.MarketplaceCatalogBundledItem.jsonDecode(bundled_item)
			)
		end

		v2.bundled_items = bundled_items
	end

	if data.bundledItems ~= nil then
		local bundled_items = {}

		for _, bundledItem in data.bundledItems do
			table.insert(
				bundled_items,
				marketplace_catalog_item_common.MarketplaceCatalogBundledItem.jsonDecode(bundledItem)
			)
		end

		v2.bundled_items = bundled_items
	end

	if data.is_recolorable ~= nil then
		v2.is_recolorable = data.is_recolorable
	end

	if data.isRecolorable ~= nil then
		v2.is_recolorable = data.isRecolorable
	end

	if data.licensing ~= nil then
		v2.licensing = marketplace_catalog_item_common.MarketplaceCatalogItemLicensing.jsonDecode(data.licensing)
	end

	if data.original_price ~= nil then
		v2.original_price = data.original_price
	end

	if data.originalPrice ~= nil then
		v2.original_price = data.originalPrice
	end

	return v2
end

class.descriptor = {
	name = "MarketplaceBundleData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceBundleData"
}

v.MarketplaceBundleData = class

typeRegistry.default:register(v.MarketplaceBundleData)

return { MarketplaceBundleData = v.MarketplaceBundleData }
