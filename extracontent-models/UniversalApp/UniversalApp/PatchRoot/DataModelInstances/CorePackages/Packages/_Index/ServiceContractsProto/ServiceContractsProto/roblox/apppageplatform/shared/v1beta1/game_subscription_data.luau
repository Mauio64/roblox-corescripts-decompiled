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
		price_display = (data == nil or data.price_display == nil) and "" or data.price_display,
		period_type = (data == nil or data.period_type == nil) and "" or data.period_type,
		is_subscribed = data ~= nil and data.is_subscribed ~= nil and data.is_subscribed,
		price_in_robux = (data == nil or data.price_in_robux == nil) and 0 or data.price_in_robux,
		price_tier = (data == nil or data.price_tier == nil) and 0 or data.price_tier
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

	if data.price_display ~= nil and data.price_display ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.price_display)
	end

	if data.period_type ~= nil and data.period_type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.period_type)
	end

	if data.is_subscribed then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_subscribed and 1 or 0)
	end

	if data.price_in_robux ~= nil and data.price_in_robux ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.price_in_robux)
	end

	if data.price_tier ~= nil and data.price_tier ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.price_tier)
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
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_subscribed = v5 ~= 0
			elseif v3 == 8 then
				local price_in_robux
				price_in_robux, v2 = proto.readVarIntI64(buf, v2)
				result.price_in_robux = price_in_robux
			elseif v3 == 9 then
				local price_tier
				price_tier, v2 = proto.readVarIntI64(buf, v2)
				result.price_tier = price_tier
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
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.price_display = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.period_type = buffer.tostring(v5)
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

	if data.price_display ~= nil and data.price_display ~= "" then
		v2.priceDisplay = data.price_display
	end

	if data.period_type ~= nil and data.period_type ~= "" then
		v2.periodType = data.period_type
	end

	if data.is_subscribed then
		v2.isSubscribed = data.is_subscribed
	end

	if data.price_in_robux ~= nil and data.price_in_robux ~= 0 then
		v2.priceInRobux = data.price_in_robux
	end

	if data.price_tier ~= nil and data.price_tier ~= 0 then
		v2.priceTier = data.price_tier
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

	if data.price_display ~= nil then
		v2.price_display = data.price_display
	end

	if data.priceDisplay ~= nil then
		v2.price_display = data.priceDisplay
	end

	if data.period_type ~= nil then
		v2.period_type = data.period_type
	end

	if data.periodType ~= nil then
		v2.period_type = data.periodType
	end

	if data.is_subscribed ~= nil then
		v2.is_subscribed = data.is_subscribed
	end

	if data.isSubscribed ~= nil then
		v2.is_subscribed = data.isSubscribed
	end

	if data.price_in_robux ~= nil then
		v2.price_in_robux = data.price_in_robux
	end

	if data.priceInRobux ~= nil then
		v2.price_in_robux = data.priceInRobux
	end

	if data.price_tier ~= nil then
		v2.price_tier = data.price_tier
	end

	if data.priceTier ~= nil then
		v2.price_tier = data.priceTier
	end

	return v2
end

class.descriptor = {
	name = "GameSubscriptionData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameSubscriptionData"
}

v.GameSubscriptionData = class

typeRegistry.default:register(v.GameSubscriptionData)

return { GameSubscriptionData = v.GameSubscriptionData }
