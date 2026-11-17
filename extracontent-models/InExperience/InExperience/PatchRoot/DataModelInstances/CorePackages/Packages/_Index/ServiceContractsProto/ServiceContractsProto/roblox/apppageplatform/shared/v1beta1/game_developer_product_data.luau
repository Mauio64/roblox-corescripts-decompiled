local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		name = (data == nil or data.name == nil) and "" or data.name,
		description = (data == nil or data.description == nil) and "" or data.description,
		image_asset_id = (data == nil or data.image_asset_id == nil) and 0 or data.image_asset_id,
		price_in_robux = (data == nil or data.price_in_robux == nil) and 0 or data.price_in_robux,
		pending_receipt_count = (data == nil or data.pending_receipt_count == nil) and 0 or data.pending_receipt_count,
		status_tooltip = (data == nil or data.status_tooltip == nil) and "" or data.status_tooltip,
		base_price_in_robux = (data == nil or data.base_price_in_robux == nil) and 0 or data.base_price_in_robux,
		is_discounted = data ~= nil and data.is_discounted ~= nil and data.is_discounted,
		is_purchasable = data ~= nil and data.is_purchasable ~= nil and data.is_purchasable
	}
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.name ~= nil and data.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.name)
	end

	if data.description ~= nil and data.description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.description)
	end

	if data.image_asset_id ~= nil and data.image_asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.image_asset_id)
	end

	if data.price_in_robux ~= nil and data.price_in_robux ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.price_in_robux)
	end

	if data.pending_receipt_count ~= nil and data.pending_receipt_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.pending_receipt_count)
	end

	if data.status_tooltip ~= nil and data.status_tooltip ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.status_tooltip)
	end

	if data.base_price_in_robux ~= nil and data.base_price_in_robux ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.base_price_in_robux)
	end

	if data.is_discounted then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_discounted and 1 or 0)
	end

	if data.is_purchasable then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_purchasable and 1 or 0)
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
				local image_asset_id
				image_asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.image_asset_id = image_asset_id
			elseif v3 == 5 then
				local price_in_robux
				price_in_robux, v2 = proto.readVarIntI64(buf, v2)
				result.price_in_robux = price_in_robux
			elseif v3 == 6 then
				local pending_receipt_count
				pending_receipt_count, v2 = proto.readVarIntI32(buf, v2)
				result.pending_receipt_count = pending_receipt_count
			elseif v3 == 8 then
				local base_price_in_robux
				base_price_in_robux, v2 = proto.readVarIntI64(buf, v2)
				result.base_price_in_robux = base_price_in_robux
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_discounted = v5 ~= 0
			elseif v3 == 10 then
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
				result.name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.status_tooltip = buffer.tostring(v5)
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

function class.jsonEncode(data)
	local v2 = {}

	if data.id ~= nil and data.id ~= "" then
		v2.id = data.id
	end

	if data.name ~= nil and data.name ~= "" then
		v2.name = data.name
	end

	if data.description ~= nil and data.description ~= "" then
		v2.description = data.description
	end

	if data.image_asset_id ~= nil and data.image_asset_id ~= 0 then
		v2.imageAssetId = data.image_asset_id
	end

	if data.price_in_robux ~= nil and data.price_in_robux ~= 0 then
		v2.priceInRobux = data.price_in_robux
	end

	if data.pending_receipt_count ~= nil and data.pending_receipt_count ~= 0 then
		v2.pendingReceiptCount = data.pending_receipt_count
	end

	if data.status_tooltip ~= nil and data.status_tooltip ~= "" then
		v2.statusTooltip = data.status_tooltip
	end

	if data.base_price_in_robux ~= nil and data.base_price_in_robux ~= 0 then
		v2.basePriceInRobux = data.base_price_in_robux
	end

	if data.is_discounted then
		v2.isDiscounted = data.is_discounted
	end

	if data.is_purchasable then
		v2.isPurchasable = data.is_purchasable
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

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.image_asset_id ~= nil then
		v2.image_asset_id = data.image_asset_id
	end

	if data.imageAssetId ~= nil then
		v2.image_asset_id = data.imageAssetId
	end

	if data.price_in_robux ~= nil then
		v2.price_in_robux = data.price_in_robux
	end

	if data.priceInRobux ~= nil then
		v2.price_in_robux = data.priceInRobux
	end

	if data.pending_receipt_count ~= nil then
		v2.pending_receipt_count = data.pending_receipt_count
	end

	if data.pendingReceiptCount ~= nil then
		v2.pending_receipt_count = data.pendingReceiptCount
	end

	if data.status_tooltip ~= nil then
		v2.status_tooltip = data.status_tooltip
	end

	if data.statusTooltip ~= nil then
		v2.status_tooltip = data.statusTooltip
	end

	if data.base_price_in_robux ~= nil then
		v2.base_price_in_robux = data.base_price_in_robux
	end

	if data.basePriceInRobux ~= nil then
		v2.base_price_in_robux = data.basePriceInRobux
	end

	if data.is_discounted ~= nil then
		v2.is_discounted = data.is_discounted
	end

	if data.isDiscounted ~= nil then
		v2.is_discounted = data.isDiscounted
	end

	if data.is_purchasable ~= nil then
		v2.is_purchasable = data.is_purchasable
	end

	if data.isPurchasable ~= nil then
		v2.is_purchasable = data.isPurchasable
	end

	return v2
end

class.descriptor = {
	name = "GameDeveloperProductData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameDeveloperProductData"
}

v.GameDeveloperProductData = class

typeRegistry.default:register(v.GameDeveloperProductData)

return { GameDeveloperProductData = v.GameDeveloperProductData }
