local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		bonus_id = (data == nil or data.bonus_id == nil) and "" or data.bonus_id,
		product_identifier = (data == nil or data.product_identifier == nil) and "" or data.product_identifier,
		details = 0
	}
	local details

	if not (data == nil or data.details == nil) then
		details = data.details
	end

	v2.details = details
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.bonus_id ~= nil and self.bonus_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.bonus_id)
	end

	if self.product_identifier ~= nil and self.product_identifier ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.product_identifier)
	end

	if self.details ~= nil then
		if self.details.type == "game_pass" then
			local encoded = self.details.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.details.type == "collectible_item" then
			local encoded = self.details.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
				result.bonus_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.product_identifier = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.details = {
					type = "game_pass",
					value = v.BuyRobuxGamePassBonusData.decode(v5)
				}
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.details = {
					type = "collectible_item",
					value = v.BuyRobuxCollectibleItemBonusData.decode(v5)
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

function class:jsonEncode()
	local v2 = {}

	if self.bonus_id ~= nil and self.bonus_id ~= "" then
		v2.bonusId = self.bonus_id
	end

	if self.product_identifier ~= nil and self.product_identifier ~= "" then
		v2.productIdentifier = self.product_identifier
	end

	if self.details == nil then
		return v2
	end

	if self.details.type == "game_pass" then
		v2.gamePass = self.details.value:jsonEncode()
		return v2
	elseif self.details.type == "collectible_item" then
		v2.collectibleItem = self.details.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.bonus_id ~= nil then
		v2.bonus_id = data.bonus_id
	end

	if data.bonusId ~= nil then
		v2.bonus_id = data.bonusId
	end

	if data.product_identifier ~= nil then
		v2.product_identifier = data.product_identifier
	end

	if data.productIdentifier ~= nil then
		v2.product_identifier = data.productIdentifier
	end

	if data.game_pass ~= nil then
		v2.details = {
			type = "game_pass",
			value = v.BuyRobuxGamePassBonusData.jsonDecode(data.game_pass)
		}
	end

	if data.gamePass ~= nil then
		v2.details = {
			type = "game_pass",
			value = v.BuyRobuxGamePassBonusData.jsonDecode(data.gamePass)
		}
	end

	if data.collectible_item ~= nil then
		v2.details = {
			type = "collectible_item",
			value = v.BuyRobuxCollectibleItemBonusData.jsonDecode(data.collectible_item)
		}
	end

	if data.collectibleItem ~= nil then
		v2.details = {
			type = "collectible_item",
			value = v.BuyRobuxCollectibleItemBonusData.jsonDecode(data.collectibleItem)
		}
	end

	return v2
end

class.descriptor = {
	name = "BuyRobuxBonusItemData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxBonusItemData"
}

v.BuyRobuxBonusItemData = class

typeRegistry.default:register(v.BuyRobuxBonusItemData)

local class2 = {}
class2.__index = class2

function class2.new(data)
	return (setmetatable({
		root_place_id = (data == nil or data.root_place_id == nil) and "" or data.root_place_id,
		game_pass_display_name = (data == nil or data.game_pass_display_name == nil) and "" or data.game_pass_display_name,
		experience_display_name = (data == nil or data.experience_display_name == nil) and "" or data.experience_display_name
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.root_place_id ~= nil and self.root_place_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.root_place_id)
	end

	if self.game_pass_display_name ~= nil and self.game_pass_display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.game_pass_display_name)
	end

	if self.experience_display_name ~= nil and self.experience_display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.experience_display_name)
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
				result.root_place_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.game_pass_display_name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.experience_display_name = buffer.tostring(v5)
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

	if self.root_place_id ~= nil and self.root_place_id ~= "" then
		v2.rootPlaceId = self.root_place_id
	end

	if self.game_pass_display_name ~= nil and self.game_pass_display_name ~= "" then
		v2.gamePassDisplayName = self.game_pass_display_name
	end

	if self.experience_display_name ~= nil and self.experience_display_name ~= "" then
		v2.experienceDisplayName = self.experience_display_name
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.root_place_id ~= nil then
		v2.root_place_id = data.root_place_id
	end

	if data.rootPlaceId ~= nil then
		v2.root_place_id = data.rootPlaceId
	end

	if data.game_pass_display_name ~= nil then
		v2.game_pass_display_name = data.game_pass_display_name
	end

	if data.gamePassDisplayName ~= nil then
		v2.game_pass_display_name = data.gamePassDisplayName
	end

	if data.experience_display_name ~= nil then
		v2.experience_display_name = data.experience_display_name
	end

	if data.experienceDisplayName ~= nil then
		v2.experience_display_name = data.experienceDisplayName
	end

	return v2
end

class2.descriptor = {
	name = "BuyRobuxGamePassBonusData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxGamePassBonusData"
}

v.BuyRobuxGamePassBonusData = class2

typeRegistry.default:register(v.BuyRobuxGamePassBonusData)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		image_2d_url = (data == nil or data.image_2d_url == nil) and "" or data.image_2d_url,
		background_image_2d_url = 0,
		creator_display_name = 0,
		creator_is_verified = 0
	}
	local background_image_2d_url

	if not (data == nil or data.background_image_2d_url == nil) then
		background_image_2d_url = data.background_image_2d_url
	end

	v2.background_image_2d_url = background_image_2d_url
	local creator_display_name

	if not (data == nil or data.creator_display_name == nil) then
		creator_display_name = data.creator_display_name
	end

	v2.creator_display_name = creator_display_name

	v2.creator_is_verified = data ~= nil and data.creator_is_verified ~= nil and data.creator_is_verified
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.image_2d_url ~= nil and self.image_2d_url ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.image_2d_url)
	end

	if self.background_image_2d_url ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.background_image_2d_url)
	end

	if self.creator_display_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_display_name)
	end

	if self.creator_is_verified then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.creator_is_verified and 1 or 0)
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
			if v3 == 5 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.creator_is_verified = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.image_2d_url = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.background_image_2d_url = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_display_name = buffer.tostring(v5)
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

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.image_2d_url ~= nil and self.image_2d_url ~= "" then
		v2.image2dUrl = self.image_2d_url
	end

	if self.background_image_2d_url ~= nil then
		v2.backgroundImage2dUrl = self.background_image_2d_url
	end

	if self.creator_display_name ~= nil then
		v2.creatorDisplayName = self.creator_display_name
	end

	if self.creator_is_verified then
		v2.creatorIsVerified = self.creator_is_verified
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.image_2d_url ~= nil then
		v2.image_2d_url = data.image_2d_url
	end

	if data.image2dUrl ~= nil then
		v2.image_2d_url = data.image2dUrl
	end

	if data.background_image_2d_url ~= nil then
		v2.background_image_2d_url = data.background_image_2d_url
	end

	if data.backgroundImage2dUrl ~= nil then
		v2.background_image_2d_url = data.backgroundImage2dUrl
	end

	if data.creator_display_name ~= nil then
		v2.creator_display_name = data.creator_display_name
	end

	if data.creatorDisplayName ~= nil then
		v2.creator_display_name = data.creatorDisplayName
	end

	if data.creator_is_verified ~= nil then
		v2.creator_is_verified = data.creator_is_verified
	end

	if data.creatorIsVerified ~= nil then
		v2.creator_is_verified = data.creatorIsVerified
	end

	return v2
end

class3.descriptor = {
	name = "BuyRobuxCollectibleItemBonusData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxCollectibleItemBonusData"
}

v.BuyRobuxCollectibleItemBonusData = class3

typeRegistry.default:register(v.BuyRobuxCollectibleItemBonusData)

return {
	BuyRobuxBonusItemData = v.BuyRobuxBonusItemData,
	BuyRobuxGamePassBonusData = v.BuyRobuxGamePassBonusData,
	BuyRobuxCollectibleItemBonusData = v.BuyRobuxCollectibleItemBonusData
}
