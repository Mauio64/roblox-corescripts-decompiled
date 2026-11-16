local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		creator_name = 0,
		creator_has_verified_badge = 0,
		price = 0
	}
	local creator_name

	if not (data == nil or data.creator_name == nil) then
		creator_name = data.creator_name
	end

	v2.creator_name = creator_name
	local creator_has_verified_badge

	if not (data == nil or data.creator_has_verified_badge == nil) then
		creator_has_verified_badge = data.creator_has_verified_badge
	end

	v2.creator_has_verified_badge = creator_has_verified_badge
	local price

	if not (data == nil or data.price == nil) then
		price = data.price
	end

	v2.price = price
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.creator_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.creator_name)
	end

	if data.creator_has_verified_badge ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.creator_has_verified_badge and 1 or 0)
	end

	if data.price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.price)
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
			if v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.creator_has_verified_badge = v5 ~= 0
			elseif v3 == 4 then
				local price
				price, v2 = proto.readVarIntI64(buf, v2)
				result.price = price
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
				result.creator_name = buffer.tostring(v5)
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

	if data.creator_name ~= nil then
		v2.creatorName = data.creator_name
	end

	if data.creator_has_verified_badge ~= nil then
		v2.creatorHasVerifiedBadge = data.creator_has_verified_badge
	end

	if data.price ~= nil then
		v2.price = data.price
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
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

	if data.price ~= nil then
		v2.price = data.price
	end

	return v2
end

class.descriptor = {
	name = "MarketplaceLookData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceLookData"
}

v.MarketplaceLookData = class

typeRegistry.default:register(v.MarketplaceLookData)

return { MarketplaceLookData = v.MarketplaceLookData }
