local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local timestamp = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.timestamp)
require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and 0 or data.id,
		display_name = (data == nil or data.display_name == nil) and "" or data.display_name,
		display_icon_image_id = (data == nil or data.display_icon_image_id == nil) and 0 or data.display_icon_image_id,
		display_description = (data == nil or data.display_description == nil) and "" or data.display_description,
		total_awarded_count = (data == nil or data.total_awarded_count == nil) and 0 or data.total_awarded_count,
		past_day_awarded_count = (data == nil or data.past_day_awarded_count == nil) and 0 or data.past_day_awarded_count,
		rarity = (data == nil or data.rarity == nil) and "" or data.rarity,
		badge_type_label = (data == nil or data.badge_type_label == nil) and "" or data.badge_type_label,
		created_time = 0,
		updated_time = 0,
		is_earned_by_user = 0,
		awarded_time = 0
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
	v2.is_earned_by_user = data ~= nil and data.is_earned_by_user ~= nil and data.is_earned_by_user
	local awarded_time

	if not (data == nil or data.awarded_time == nil) then
		awarded_time = data.awarded_time
	end

	v2.awarded_time = awarded_time
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.id ~= nil and self.id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.id)
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_name)
	end

	if self.display_icon_image_id ~= nil and self.display_icon_image_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.display_icon_image_id)
	end

	if self.display_description ~= nil and self.display_description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.display_description)
	end

	if self.total_awarded_count ~= nil and self.total_awarded_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.total_awarded_count)
	end

	if self.past_day_awarded_count ~= nil and self.past_day_awarded_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.past_day_awarded_count)
	end

	if self.rarity ~= nil and self.rarity ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.rarity)
	end

	if self.badge_type_label ~= nil and self.badge_type_label ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.badge_type_label)
	end

	if self.created_time ~= nil then
		local encoded = self.created_time:encode()
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.updated_time ~= nil then
		local encoded = self.updated_time:encode()
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.is_earned_by_user then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.is_earned_by_user and 1 or 0)
	end

	if self.awarded_time ~= nil then
		local encoded = self.awarded_time:encode()
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
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
			if v3 == 1 then
				local id
				id, v2 = proto.readVarIntI64(buf, v2)
				result.id = id
			elseif v3 == 3 then
				local display_icon_image_id
				display_icon_image_id, v2 = proto.readVarIntI64(buf, v2)
				result.display_icon_image_id = display_icon_image_id
			elseif v3 == 5 then
				local total_awarded_count
				total_awarded_count, v2 = proto.readVarIntI64(buf, v2)
				result.total_awarded_count = total_awarded_count
			elseif v3 == 6 then
				local past_day_awarded_count
				past_day_awarded_count, v2 = proto.readVarIntI64(buf, v2)
				result.past_day_awarded_count = past_day_awarded_count
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_earned_by_user = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_description = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.rarity = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.badge_type_label = buffer.tostring(v5)
			elseif v3 == 9 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.created_time = timestamp.Timestamp.decode(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.updated_time = timestamp.Timestamp.decode(v5)
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.awarded_time = timestamp.Timestamp.decode(v5)
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

	if self.id ~= nil and self.id ~= 0 then
		v2.id = self.id
	end

	if self.display_name ~= nil and self.display_name ~= "" then
		v2.displayName = self.display_name
	end

	if self.display_icon_image_id ~= nil and self.display_icon_image_id ~= 0 then
		v2.displayIconImageId = self.display_icon_image_id
	end

	if self.display_description ~= nil and self.display_description ~= "" then
		v2.displayDescription = self.display_description
	end

	if self.total_awarded_count ~= nil and self.total_awarded_count ~= 0 then
		v2.totalAwardedCount = self.total_awarded_count
	end

	if self.past_day_awarded_count ~= nil and self.past_day_awarded_count ~= 0 then
		v2.pastDayAwardedCount = self.past_day_awarded_count
	end

	if self.rarity ~= nil and self.rarity ~= "" then
		v2.rarity = self.rarity
	end

	if self.badge_type_label ~= nil and self.badge_type_label ~= "" then
		v2.badgeTypeLabel = self.badge_type_label
	end

	if self.created_time ~= nil then
		v2.createdTime = self.created_time:jsonEncode()
	end

	if self.updated_time ~= nil then
		v2.updatedTime = self.updated_time:jsonEncode()
	end

	if self.is_earned_by_user then
		v2.isEarnedByUser = self.is_earned_by_user
	end

	if self.awarded_time ~= nil then
		v2.awardedTime = self.awarded_time:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.display_icon_image_id ~= nil then
		v2.display_icon_image_id = data.display_icon_image_id
	end

	if data.displayIconImageId ~= nil then
		v2.display_icon_image_id = data.displayIconImageId
	end

	if data.display_description ~= nil then
		v2.display_description = data.display_description
	end

	if data.displayDescription ~= nil then
		v2.display_description = data.displayDescription
	end

	if data.total_awarded_count ~= nil then
		v2.total_awarded_count = data.total_awarded_count
	end

	if data.totalAwardedCount ~= nil then
		v2.total_awarded_count = data.totalAwardedCount
	end

	if data.past_day_awarded_count ~= nil then
		v2.past_day_awarded_count = data.past_day_awarded_count
	end

	if data.pastDayAwardedCount ~= nil then
		v2.past_day_awarded_count = data.pastDayAwardedCount
	end

	if data.rarity ~= nil then
		v2.rarity = data.rarity
	end

	if data.badge_type_label ~= nil then
		v2.badge_type_label = data.badge_type_label
	end

	if data.badgeTypeLabel ~= nil then
		v2.badge_type_label = data.badgeTypeLabel
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

	if data.is_earned_by_user ~= nil then
		v2.is_earned_by_user = data.is_earned_by_user
	end

	if data.isEarnedByUser ~= nil then
		v2.is_earned_by_user = data.isEarnedByUser
	end

	if data.awarded_time ~= nil then
		v2.awarded_time = timestamp.Timestamp.jsonDecode(data.awarded_time)
	end

	if data.awardedTime ~= nil then
		v2.awarded_time = timestamp.Timestamp.jsonDecode(data.awardedTime)
	end

	return v2
end

class.descriptor = {
	name = "BadgeData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeData"
}

v.BadgeData = class

typeRegistry.default:register(v.BadgeData)

return { BadgeData = v.BadgeData }
