local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 57
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		title = if t3 ~= nil and t3.title ~= nil then t3.title else "",
		subtitle = if t3 ~= nil and t3.subtitle ~= nil then t3.subtitle else "",
		event_start = if t3 ~= nil and t3.event_start ~= nil then t3.event_start else "",
		event_end = if t3 ~= nil and t3.event_end ~= nil then t3.event_end else "",
		user_rsvp = t3 ~= nil and (t3.user_rsvp ~= nil and t3.user_rsvp),
		media_asset_id = if t3 ~= nil and t3.media_asset_id ~= nil then t3.media_asset_id else 0,
		description = if t3 ~= nil and t3.description ~= nil then t3.description else "",
		rsvp_count = if t3 ~= nil and t3.rsvp_count ~= nil then t3.rsvp_count else 0,
		place_id = if t3 ~= nil and t3.place_id ~= nil then t3.place_id else ""
	}, t2))
end
function t2.encode(p1) -- line: 72
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	if p1.title ~= nil and p1.title ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.title)
	end

	if p1.subtitle ~= nil and p1.subtitle ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.subtitle)
	end

	if p1.event_start ~= nil and p1.event_start ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.event_start)
	end

	if p1.event_end ~= nil and p1.event_end ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.event_end)
	end

	if p1.user_rsvp then
		local v19, v20 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, not p1.user_rsvp and 0 or 1)
	end

	if p1.media_asset_id ~= nil and p1.media_asset_id ~= 0 then
		local v21, v22 = proto.writeTag(buf, n1, 7, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v21, v22, p1.media_asset_id)
	end

	if p1.description ~= nil and p1.description ~= "" then
		local v23, v24 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v23, v24, p1.description)
	end

	if p1.rsvp_count ~= nil and p1.rsvp_count ~= 0 then
		local v25, v26 = proto.writeTag(buf, n1, 9, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v25, v26, p1.rsvp_count)
	end

	if p1.place_id ~= nil and p1.place_id ~= "" then
		local v27, v28 = proto.writeTag(buf, n1, 10, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v27, v28, p1.place_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 131
	-- upvalues: t2 (copy), proto (copy)
	local v31 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v33, v34

		v33, v34, n2 = proto.readTag(p2, n2)

		if v34 == proto.wireTypes.varint then
			if v33 == 6 then
				local v35

				v35, n2 = proto.readVarInt(p2, n2)
				v31.user_rsvp = v35 ~= 0
			elseif v33 == 7 then
				local v36

				v36, n2 = proto.readVarIntI64(p2, n2)
				v31.media_asset_id = v36
			elseif v33 == 9 then
				local v37

				v37, n2 = proto.readVarIntI64(p2, n2)
				v31.rsvp_count = v37
			else
				local v38

				v38, n2 = proto.readVarInt(p2, n2)
			end
		elseif v34 == proto.wireTypes.lengthDelimited then
			if v33 == 1 then
				local v39

				v39, n2 = proto.readBuffer(p2, n2)
				v31.id = buffer.tostring(v39)
			elseif v33 == 2 then
				local v40

				v40, n2 = proto.readBuffer(p2, n2)
				v31.title = buffer.tostring(v40)
			elseif v33 == 3 then
				local v41

				v41, n2 = proto.readBuffer(p2, n2)
				v31.subtitle = buffer.tostring(v41)
			elseif v33 == 4 then
				local v42

				v42, n2 = proto.readBuffer(p2, n2)
				v31.event_start = buffer.tostring(v42)
			elseif v33 == 5 then
				local v43

				v43, n2 = proto.readBuffer(p2, n2)
				v31.event_end = buffer.tostring(v43)
			elseif v33 == 8 then
				local v44

				v44, n2 = proto.readBuffer(p2, n2)
				v31.description = buffer.tostring(v44)
			elseif v33 == 10 then
				local v45

				v45, n2 = proto.readBuffer(p2, n2)
				v31.place_id = buffer.tostring(v45)
			else
				local v46, v47 = proto.readVarInt(p2, n2)

				n2 = v47 + v46
			end
		elseif v34 == proto.wireTypes.i32 then
			local v48

			v48, n2 = proto.readFixed32(p2, n2)
		elseif v34 == proto.wireTypes.i64 then
			local v49

			v49, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v34)
		end
	end

	return v31
end
function t2.jsonEncode(p3) -- line: 219
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.title ~= nil and p3.title ~= "" then
		t4.title = p3.title
	end

	if p3.subtitle ~= nil and p3.subtitle ~= "" then
		t4.subtitle = p3.subtitle
	end

	if p3.event_start ~= nil and p3.event_start ~= "" then
		t4.eventStart = p3.event_start
	end

	if p3.event_end ~= nil and p3.event_end ~= "" then
		t4.eventEnd = p3.event_end
	end

	if p3.user_rsvp then
		t4.userRsvp = p3.user_rsvp
	end

	if p3.media_asset_id ~= nil and p3.media_asset_id ~= 0 then
		t4.mediaAssetId = p3.media_asset_id
	end

	if p3.description ~= nil and p3.description ~= "" then
		t4.description = p3.description
	end

	if p3.rsvp_count ~= nil and p3.rsvp_count ~= 0 then
		t4.rsvpCount = p3.rsvp_count
	end

	if p3.place_id ~= nil and p3.place_id ~= "" then
		t4.placeId = p3.place_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 265
	-- upvalues: t2 (copy)
	local v53 = t2.new()

	if t5.id ~= nil then
		v53.id = t5.id
	end

	if t5.title ~= nil then
		v53.title = t5.title
	end

	if t5.subtitle ~= nil then
		v53.subtitle = t5.subtitle
	end

	if t5.event_start ~= nil then
		v53.event_start = t5.event_start
	end

	if t5.eventStart ~= nil then
		v53.event_start = t5.eventStart
	end

	if t5.event_end ~= nil then
		v53.event_end = t5.event_end
	end

	if t5.eventEnd ~= nil then
		v53.event_end = t5.eventEnd
	end

	if t5.user_rsvp ~= nil then
		v53.user_rsvp = t5.user_rsvp
	end

	if t5.userRsvp ~= nil then
		v53.user_rsvp = t5.userRsvp
	end

	if t5.media_asset_id ~= nil then
		v53.media_asset_id = t5.media_asset_id
	end

	if t5.mediaAssetId ~= nil then
		v53.media_asset_id = t5.mediaAssetId
	end

	if t5.description ~= nil then
		v53.description = t5.description
	end

	if t5.rsvp_count ~= nil then
		v53.rsvp_count = t5.rsvp_count
	end

	if t5.rsvpCount ~= nil then
		v53.rsvp_count = t5.rsvpCount
	end

	if t5.place_id ~= nil then
		v53.place_id = t5.place_id
	end

	if t5.placeId ~= nil then
		v53.place_id = t5.placeId
	end

	return v53
end

t2.descriptor = {
	name = "EventData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventData"
}
t1.EventData = t2
typeRegistry.default:register(t1.EventData)

return {
	EventData = t1.EventData
}
