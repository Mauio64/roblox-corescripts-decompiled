local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local timestamp = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.timestamp)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 63
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else 0,
		display_name = if t3 ~= nil and t3.display_name ~= nil then t3.display_name else "",
		display_icon_image_id = if t3 ~= nil and t3.display_icon_image_id ~= nil then t3.display_icon_image_id else 0,
		display_description = if t3 ~= nil and t3.display_description ~= nil then t3.display_description else "",
		total_awarded_count = if t3 ~= nil and t3.total_awarded_count ~= nil then t3.total_awarded_count else 0,
		past_day_awarded_count = if t3 ~= nil and t3.past_day_awarded_count ~= nil then t3.past_day_awarded_count else 0,
		rarity = if t3 ~= nil and t3.rarity ~= nil then t3.rarity else "",
		badge_type_label = if t3 ~= nil and t3.badge_type_label ~= nil then t3.badge_type_label else "",
		created_time = if t3 ~= nil and t3.created_time ~= nil then t3.created_time else nil,
		updated_time = if t3 ~= nil and t3.updated_time ~= nil then t3.updated_time else nil,
		is_earned_by_user = t3 ~= nil and (t3.is_earned_by_user ~= nil and t3.is_earned_by_user),
		awarded_time = if t3 ~= nil and t3.awarded_time ~= nil then t3.awarded_time else nil
	}, t2))
end
function t2.encode(p1) -- line: 88
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= 0 then
		local v10, v11 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v10, v11, p1.id)
	end

	if p1.display_name ~= nil and p1.display_name ~= "" then
		local v12, v13 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v12, v13, p1.display_name)
	end

	if p1.display_icon_image_id ~= nil and p1.display_icon_image_id ~= 0 then
		local v14, v15 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v14, v15, p1.display_icon_image_id)
	end

	if p1.display_description ~= nil and p1.display_description ~= "" then
		local v16, v17 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v16, v17, p1.display_description)
	end

	if p1.total_awarded_count ~= nil and p1.total_awarded_count ~= 0 then
		local v18, v19 = proto.writeTag(buf, n1, 5, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v18, v19, p1.total_awarded_count)
	end

	if p1.past_day_awarded_count ~= nil and p1.past_day_awarded_count ~= 0 then
		local v20, v21 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v20, v21, p1.past_day_awarded_count)
	end

	if p1.rarity ~= nil and p1.rarity ~= "" then
		local v22, v23 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v22, v23, p1.rarity)
	end

	if p1.badge_type_label ~= nil and p1.badge_type_label ~= "" then
		local v24, v25 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v24, v25, p1.badge_type_label)
	end

	if p1.created_time ~= nil then
		local v26 = p1.created_time:encode()
		local v27, v28 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v27, v28, v26, buffer.len(v26))
	end

	if p1.updated_time ~= nil then
		local v29 = p1.updated_time:encode()
		local v30, v31 = proto.writeTag(buf, n1, 10, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v30, v31, v29, buffer.len(v29))
	end

	if p1.is_earned_by_user then
		local v32, v33 = proto.writeTag(buf, n1, 11, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v32, v33, not p1.is_earned_by_user and 0 or 1)
	end

	if p1.awarded_time ~= nil then
		local v34 = p1.awarded_time:encode()
		local v35, v36 = proto.writeTag(buf, n1, 12, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v35, v36, v34, buffer.len(v34))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 160
	-- upvalues: t2 (copy), proto (copy), timestamp (copy)
	local v39 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v41, v42

		v41, v42, n2 = proto.readTag(p2, n2)

		if v42 == proto.wireTypes.varint then
			if v41 == 1 then
				local v43

				v43, n2 = proto.readVarIntI64(p2, n2)
				v39.id = v43
			elseif v41 == 3 then
				local v44

				v44, n2 = proto.readVarIntI64(p2, n2)
				v39.display_icon_image_id = v44
			elseif v41 == 5 then
				local v45

				v45, n2 = proto.readVarIntI64(p2, n2)
				v39.total_awarded_count = v45
			elseif v41 == 6 then
				local v46

				v46, n2 = proto.readVarIntI64(p2, n2)
				v39.past_day_awarded_count = v46
			elseif v41 == 11 then
				local v47

				v47, n2 = proto.readVarInt(p2, n2)
				v39.is_earned_by_user = v47 ~= 0
			else
				local v48

				v48, n2 = proto.readVarInt(p2, n2)
			end
		elseif v42 == proto.wireTypes.lengthDelimited then
			if v41 == 2 then
				local v49

				v49, n2 = proto.readBuffer(p2, n2)
				v39.display_name = buffer.tostring(v49)
			elseif v41 == 4 then
				local v50

				v50, n2 = proto.readBuffer(p2, n2)
				v39.display_description = buffer.tostring(v50)
			elseif v41 == 7 then
				local v51

				v51, n2 = proto.readBuffer(p2, n2)
				v39.rarity = buffer.tostring(v51)
			elseif v41 == 8 then
				local v52

				v52, n2 = proto.readBuffer(p2, n2)
				v39.badge_type_label = buffer.tostring(v52)
			elseif v41 == 9 then
				local v53

				v53, n2 = proto.readBuffer(p2, n2)
				v39.created_time = timestamp.Timestamp.decode(v53)
			elseif v41 == 10 then
				local v54

				v54, n2 = proto.readBuffer(p2, n2)
				v39.updated_time = timestamp.Timestamp.decode(v54)
			elseif v41 == 12 then
				local v55

				v55, n2 = proto.readBuffer(p2, n2)
				v39.awarded_time = timestamp.Timestamp.decode(v55)
			else
				local v56, v57 = proto.readVarInt(p2, n2)

				n2 = v57 + v56
			end
		elseif v42 == proto.wireTypes.i32 then
			local v58

			v58, n2 = proto.readFixed32(p2, n2)
		elseif v42 == proto.wireTypes.i64 then
			local v59

			v59, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v42)
		end
	end

	return v39
end
function t2.jsonEncode(p3) -- line: 258
	local t4 = {}

	if p3.id ~= nil and p3.id ~= 0 then
		t4.id = p3.id
	end

	if p3.display_name ~= nil and p3.display_name ~= "" then
		t4.displayName = p3.display_name
	end

	if p3.display_icon_image_id ~= nil and p3.display_icon_image_id ~= 0 then
		t4.displayIconImageId = p3.display_icon_image_id
	end

	if p3.display_description ~= nil and p3.display_description ~= "" then
		t4.displayDescription = p3.display_description
	end

	if p3.total_awarded_count ~= nil and p3.total_awarded_count ~= 0 then
		t4.totalAwardedCount = p3.total_awarded_count
	end

	if p3.past_day_awarded_count ~= nil and p3.past_day_awarded_count ~= 0 then
		t4.pastDayAwardedCount = p3.past_day_awarded_count
	end

	if p3.rarity ~= nil and p3.rarity ~= "" then
		t4.rarity = p3.rarity
	end

	if p3.badge_type_label ~= nil and p3.badge_type_label ~= "" then
		t4.badgeTypeLabel = p3.badge_type_label
	end

	if p3.created_time ~= nil then
		t4.createdTime = p3.created_time:jsonEncode()
	end

	if p3.updated_time ~= nil then
		t4.updatedTime = p3.updated_time:jsonEncode()
	end

	if p3.is_earned_by_user then
		t4.isEarnedByUser = p3.is_earned_by_user
	end

	if p3.awarded_time ~= nil then
		t4.awardedTime = p3.awarded_time:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 312
	-- upvalues: t2 (copy), timestamp (copy)
	local v63 = t2.new()

	if t5.id ~= nil then
		v63.id = t5.id
	end

	if t5.display_name ~= nil then
		v63.display_name = t5.display_name
	end

	if t5.displayName ~= nil then
		v63.display_name = t5.displayName
	end

	if t5.display_icon_image_id ~= nil then
		v63.display_icon_image_id = t5.display_icon_image_id
	end

	if t5.displayIconImageId ~= nil then
		v63.display_icon_image_id = t5.displayIconImageId
	end

	if t5.display_description ~= nil then
		v63.display_description = t5.display_description
	end

	if t5.displayDescription ~= nil then
		v63.display_description = t5.displayDescription
	end

	if t5.total_awarded_count ~= nil then
		v63.total_awarded_count = t5.total_awarded_count
	end

	if t5.totalAwardedCount ~= nil then
		v63.total_awarded_count = t5.totalAwardedCount
	end

	if t5.past_day_awarded_count ~= nil then
		v63.past_day_awarded_count = t5.past_day_awarded_count
	end

	if t5.pastDayAwardedCount ~= nil then
		v63.past_day_awarded_count = t5.pastDayAwardedCount
	end

	if t5.rarity ~= nil then
		v63.rarity = t5.rarity
	end

	if t5.badge_type_label ~= nil then
		v63.badge_type_label = t5.badge_type_label
	end

	if t5.badgeTypeLabel ~= nil then
		v63.badge_type_label = t5.badgeTypeLabel
	end

	if t5.created_time ~= nil then
		v63.created_time = timestamp.Timestamp.jsonDecode(t5.created_time)
	end

	if t5.createdTime ~= nil then
		v63.created_time = timestamp.Timestamp.jsonDecode(t5.createdTime)
	end

	if t5.updated_time ~= nil then
		v63.updated_time = timestamp.Timestamp.jsonDecode(t5.updated_time)
	end

	if t5.updatedTime ~= nil then
		v63.updated_time = timestamp.Timestamp.jsonDecode(t5.updatedTime)
	end

	if t5.is_earned_by_user ~= nil then
		v63.is_earned_by_user = t5.is_earned_by_user
	end

	if t5.isEarnedByUser ~= nil then
		v63.is_earned_by_user = t5.isEarnedByUser
	end

	if t5.awarded_time ~= nil then
		v63.awarded_time = timestamp.Timestamp.jsonDecode(t5.awarded_time)
	end

	if t5.awardedTime ~= nil then
		v63.awarded_time = timestamp.Timestamp.jsonDecode(t5.awardedTime)
	end

	return v63
end

t2.descriptor = {
	name = "BadgeData",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeData"
}
t1.BadgeData = t2
typeRegistry.default:register(t1.BadgeData)

return {
	BadgeData = t1.BadgeData
}
