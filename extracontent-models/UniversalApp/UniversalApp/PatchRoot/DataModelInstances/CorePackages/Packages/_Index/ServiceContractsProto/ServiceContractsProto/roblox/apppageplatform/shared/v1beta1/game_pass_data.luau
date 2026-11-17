local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local timestamp = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.timestamp)
require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	return (setmetatable({
		type = (data == nil or data.type == nil) and "" or data.type,
		amount_in_robux = (data == nil or data.amount_in_robux == nil) and 0 or data.amount_in_robux,
		percent = (data == nil or data.percent == nil) and 0 or data.percent
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.type ~= nil and self.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.type)
	end

	if self.amount_in_robux ~= nil and self.amount_in_robux ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.amount_in_robux)
	end

	if self.percent ~= nil and self.percent ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.percent)
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
			if v3 == 2 then
				local amount_in_robux
				amount_in_robux, v2 = proto.readVarIntI64(buf, v2)
				result.amount_in_robux = amount_in_robux
			elseif v3 == 3 then
				local percent
				percent, v2 = proto.readVarIntI64(buf, v2)
				result.percent = percent
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
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

	if self.type ~= nil and self.type ~= "" then
		v2.type = self.type
	end

	if self.amount_in_robux ~= nil and self.amount_in_robux ~= 0 then
		v2.amountInRobux = self.amount_in_robux
	end

	if self.percent ~= nil and self.percent ~= 0 then
		v2.percent = self.percent
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.amount_in_robux ~= nil then
		v2.amount_in_robux = data.amount_in_robux
	end

	if data.amountInRobux ~= nil then
		v2.amount_in_robux = data.amountInRobux
	end

	if data.percent ~= nil then
		v2.percent = data.percent
	end

	return v2
end

class.descriptor = {
	name = "PriceDiscountDetail",
	fullName = "roblox.apppageplatform.shared.v1beta1.PriceDiscountDetail"
}

v.PriceDiscountDetail = class

typeRegistry.default:register(v.PriceDiscountDetail)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		price = (data == nil or data.price == nil) and 0 or data.price,
		product_id = (data == nil or data.product_id == nil) and 0 or data.product_id,
		is_owned = data ~= nil and data.is_owned ~= nil and data.is_owned,
		display_icon_image_asset_id = (data == nil or data.display_icon_image_asset_id == nil) and 0 or data.display_icon_image_asset_id,
		display_description = (data == nil or data.display_description == nil) and "" or data.display_description,
		price_discount_details = (data == nil or data.price_discount_details == nil) and {} or data.price_discount_details,
		user_base_price_in_robux = (data == nil or data.user_base_price_in_robux == nil) and 0 or data.user_base_price_in_robux,
		is_discounted = data ~= nil and data.is_discounted ~= nil and data.is_discounted,
		can_configure = data ~= nil and data.can_configure ~= nil and data.can_configure,
		created_time = 0,
		updated_time = 0,
		total_up_votes = 0,
		total_down_votes = 0,
		user_vote = 0,
		is_purchasable = 0
	}
	local created_time

	if not (data == nil or data.created_time == nil) then
		created_time = data.created_time
	end

	v2.created_time = created_time
	local updated_time

	if not (data == nil or data.updated_time == nil) then
		updated_time = data.updated_time
	end

	v2.updated_time = updated_time
	local total_up_votes

	if not (data == nil or data.total_up_votes == nil) then
		total_up_votes = data.total_up_votes
	end

	v2.total_up_votes = total_up_votes
	local total_down_votes

	if not (data == nil or data.total_down_votes == nil) then
		total_down_votes = data.total_down_votes
	end

	v2.total_down_votes = total_down_votes
	local user_vote

	if not (data == nil or data.user_vote == nil) then
		user_vote = data.user_vote
	end

	v2.user_vote = user_vote
	v2.is_purchasable = data ~= nil and data.is_purchasable ~= nil and data.is_purchasable
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.id)
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.price ~= nil and self.price ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.price)
	end

	if self.product_id ~= nil and self.product_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.product_id)
	end

	if self.is_owned then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_owned and 1 or 0)
	end

	if self.display_icon_image_asset_id ~= nil and self.display_icon_image_asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.display_icon_image_asset_id)
	end

	if self.display_description ~= nil and self.display_description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_description)
	end

	if self.price_discount_details ~= nil and #self.price_discount_details > 0 then
		for _, price_discount_detail in self.price_discount_details do
			local encoded = price_discount_detail:encode()
			local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.user_base_price_in_robux ~= nil and self.user_base_price_in_robux ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.user_base_price_in_robux)
	end

	if self.is_discounted then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_discounted and 1 or 0)
	end

	if self.can_configure then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.can_configure and 1 or 0)
	end

	if self.created_time ~= nil then
		local encoded = self.created_time:encode()
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.updated_time ~= nil then
		local encoded = self.updated_time:encode()
		local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.total_up_votes ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total_up_votes)
	end

	if self.total_down_votes ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total_down_votes)
	end

	if self.user_vote ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.user_vote and 1 or 0)
	end

	if self.is_purchasable then
		local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_purchasable and 1 or 0)
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
			if v3 == 3 then
				local price
				price, v2 = proto.readVarIntI64(buf, v2)
				result.price = price
			elseif v3 == 4 then
				local product_id
				product_id, v2 = proto.readVarIntI64(buf, v2)
				result.product_id = product_id
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_owned = v5 ~= 0
			elseif v3 == 6 then
				local display_icon_image_asset_id
				display_icon_image_asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.display_icon_image_asset_id = display_icon_image_asset_id
			elseif v3 == 9 then
				local user_base_price_in_robux
				user_base_price_in_robux, v2 = proto.readVarIntI64(buf, v2)
				result.user_base_price_in_robux = user_base_price_in_robux
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_discounted = v5 ~= 0
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_configure = v5 ~= 0
			elseif v3 == 14 then
				local total_up_votes
				total_up_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_up_votes = total_up_votes
			elseif v3 == 15 then
				local total_down_votes
				total_down_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_down_votes = total_down_votes
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.user_vote = v5 ~= 0
			elseif v3 == 17 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_purchasable = v5 ~= 0
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
				result.display_name = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_description = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.price_discount_details, v.PriceDiscountDetail.decode(v5))
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.created_time = timestamp.Timestamp.decode(v5)
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.updated_time = timestamp.Timestamp.decode(v5)
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

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.price ~= nil and self.price ~= 0 then
		v2.price = self.price
	end

	if self.product_id ~= nil and self.product_id ~= 0 then
		v2.productId = self.product_id
	end

	if self.is_owned then
		v2.isOwned = self.is_owned
	end

	if self.display_icon_image_asset_id ~= nil and self.display_icon_image_asset_id ~= 0 then
		v2.displayIconImageAssetId = self.display_icon_image_asset_id
	end

	if self.display_description ~= nil and self.display_description ~= "" then
		v2.displayDescription = self.display_description
	end

	if self.price_discount_details ~= nil and #self.price_discount_details > 0 then
		local priceDiscountDetails = {}

		for _, price_discount_detail in self.price_discount_details do
			table.insert(priceDiscountDetails, price_discount_detail:jsonEncode())
		end

		v2.priceDiscountDetails = priceDiscountDetails
	end

	if self.user_base_price_in_robux ~= nil and self.user_base_price_in_robux ~= 0 then
		v2.userBasePriceInRobux = self.user_base_price_in_robux
	end

	if self.is_discounted then
		v2.isDiscounted = self.is_discounted
	end

	if self.can_configure then
		v2.canConfigure = self.can_configure
	end

	if self.created_time ~= nil then
		v2.createdTime = self.created_time:jsonEncode()
	end

	if self.updated_time ~= nil then
		v2.updatedTime = self.updated_time:jsonEncode()
	end

	if self.total_up_votes ~= nil then
		v2.totalUpVotes = self.total_up_votes
	end

	if self.total_down_votes ~= nil then
		v2.totalDownVotes = self.total_down_votes
	end

	if self.user_vote ~= nil then
		v2.userVote = self.user_vote
	end

	if self.is_purchasable then
		v2.isPurchasable = self.is_purchasable
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.price ~= nil then
		v2.price = data.price
	end

	if data.product_id ~= nil then
		v2.product_id = data.product_id
	end

	if data.productId ~= nil then
		v2.product_id = data.productId
	end

	if data.is_owned ~= nil then
		v2.is_owned = data.is_owned
	end

	if data.isOwned ~= nil then
		v2.is_owned = data.isOwned
	end

	if data.display_icon_image_asset_id ~= nil then
		v2.display_icon_image_asset_id = data.display_icon_image_asset_id
	end

	if data.displayIconImageAssetId ~= nil then
		v2.display_icon_image_asset_id = data.displayIconImageAssetId
	end

	if data.display_description ~= nil then
		v2.display_description = data.display_description
	end

	if data.displayDescription ~= nil then
		v2.display_description = data.displayDescription
	end

	if data.price_discount_details ~= nil then
		local price_discount_details = {}

		for _, price_discount_detail in data.price_discount_details do
			table.insert(price_discount_details, v.PriceDiscountDetail.jsonDecode(price_discount_detail))
		end

		v2.price_discount_details = price_discount_details
	end

	if data.priceDiscountDetails ~= nil then
		local price_discount_details = {}

		for _, priceDiscountDetail in data.priceDiscountDetails do
			table.insert(price_discount_details, v.PriceDiscountDetail.jsonDecode(priceDiscountDetail))
		end

		v2.price_discount_details = price_discount_details
	end

	if data.user_base_price_in_robux ~= nil then
		v2.user_base_price_in_robux = data.user_base_price_in_robux
	end

	if data.userBasePriceInRobux ~= nil then
		v2.user_base_price_in_robux = data.userBasePriceInRobux
	end

	if data.is_discounted ~= nil then
		v2.is_discounted = data.is_discounted
	end

	if data.isDiscounted ~= nil then
		v2.is_discounted = data.isDiscounted
	end

	if data.can_configure ~= nil then
		v2.can_configure = data.can_configure
	end

	if data.canConfigure ~= nil then
		v2.can_configure = data.canConfigure
	end

	if data.created_time ~= nil then
		v2.created_time = timestamp.Timestamp.jsonDecode(data.created_time)
	end

	if data.createdTime ~= nil then
		v2.created_time = timestamp.Timestamp.jsonDecode(data.createdTime)
	end

	if data.updated_time ~= nil then
		v2.updated_time = timestamp.Timestamp.jsonDecode(data.updated_time)
	end

	if data.updatedTime ~= nil then
		v2.updated_time = timestamp.Timestamp.jsonDecode(data.updatedTime)
	end

	if data.total_up_votes ~= nil then
		v2.total_up_votes = data.total_up_votes
	end

	if data.totalUpVotes ~= nil then
		v2.total_up_votes = data.totalUpVotes
	end

	if data.total_down_votes ~= nil then
		v2.total_down_votes = data.total_down_votes
	end

	if data.totalDownVotes ~= nil then
		v2.total_down_votes = data.totalDownVotes
	end

	if data.user_vote ~= nil then
		v2.user_vote = data.user_vote
	end

	if data.userVote ~= nil then
		v2.user_vote = data.userVote
	end

	if data.is_purchasable ~= nil then
		v2.is_purchasable = data.is_purchasable
	end

	if data.isPurchasable ~= nil then
		v2.is_purchasable = data.isPurchasable
	end

	return v2
end

class2.descriptor = {
	name = "GamePassData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassData"
}

v.GamePassData = class2

typeRegistry.default:register(v.GamePassData)

return { PriceDiscountDetail = v.PriceDiscountDetail, GamePassData = v.GamePassData }
