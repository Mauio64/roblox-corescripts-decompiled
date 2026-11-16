local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		title = (data == nil or data.title == nil) and "" or data.title,
		subtitle = (data == nil or data.subtitle == nil) and "" or data.subtitle,
		event_start = (data == nil or data.event_start == nil) and "" or data.event_start,
		event_end = (data == nil or data.event_end == nil) and "" or data.event_end,
		user_rsvp = data ~= nil and data.user_rsvp ~= nil and data.user_rsvp,
		media_asset_id = (data == nil or data.media_asset_id == nil) and 0 or data.media_asset_id,
		description = (data == nil or data.description == nil) and "" or data.description,
		rsvp_count = (data == nil or data.rsvp_count == nil) and 0 or data.rsvp_count,
		place_id = (data == nil or data.place_id == nil) and "" or data.place_id
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

	if data.title ~= nil and data.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.title)
	end

	if data.subtitle ~= nil and data.subtitle ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.subtitle)
	end

	if data.event_start ~= nil and data.event_start ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.event_start)
	end

	if data.event_end ~= nil and data.event_end ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.event_end)
	end

	if data.user_rsvp then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.user_rsvp and 1 or 0)
	end

	if data.media_asset_id ~= nil and data.media_asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.media_asset_id)
	end

	if data.description ~= nil and data.description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.description)
	end

	if data.rsvp_count ~= nil and data.rsvp_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.rsvp_count)
	end

	if data.place_id ~= nil and data.place_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.place_id)
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
			if v3 == 6 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.user_rsvp = v5 ~= 0
			elseif v3 == 7 then
				local media_asset_id
				media_asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.media_asset_id = media_asset_id
			elseif v3 == 9 then
				local rsvp_count
				rsvp_count, v2 = proto.readVarIntI64(buf, v2)
				result.rsvp_count = rsvp_count
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
				result.title = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.subtitle = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.event_start = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.event_end = buffer.tostring(v5)
			elseif v3 == 8 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.place_id = buffer.tostring(v5)
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

	if data.title ~= nil and data.title ~= "" then
		v2.title = data.title
	end

	if data.subtitle ~= nil and data.subtitle ~= "" then
		v2.subtitle = data.subtitle
	end

	if data.event_start ~= nil and data.event_start ~= "" then
		v2.eventStart = data.event_start
	end

	if data.event_end ~= nil and data.event_end ~= "" then
		v2.eventEnd = data.event_end
	end

	if data.user_rsvp then
		v2.userRsvp = data.user_rsvp
	end

	if data.media_asset_id ~= nil and data.media_asset_id ~= 0 then
		v2.mediaAssetId = data.media_asset_id
	end

	if data.description ~= nil and data.description ~= "" then
		v2.description = data.description
	end

	if data.rsvp_count ~= nil and data.rsvp_count ~= 0 then
		v2.rsvpCount = data.rsvp_count
	end

	if data.place_id ~= nil and data.place_id ~= "" then
		v2.placeId = data.place_id
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.subtitle ~= nil then
		v2.subtitle = data.subtitle
	end

	if data.event_start ~= nil then
		v2.event_start = data.event_start
	end

	if data.eventStart ~= nil then
		v2.event_start = data.eventStart
	end

	if data.event_end ~= nil then
		v2.event_end = data.event_end
	end

	if data.eventEnd ~= nil then
		v2.event_end = data.eventEnd
	end

	if data.user_rsvp ~= nil then
		v2.user_rsvp = data.user_rsvp
	end

	if data.userRsvp ~= nil then
		v2.user_rsvp = data.userRsvp
	end

	if data.media_asset_id ~= nil then
		v2.media_asset_id = data.media_asset_id
	end

	if data.mediaAssetId ~= nil then
		v2.media_asset_id = data.mediaAssetId
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.rsvp_count ~= nil then
		v2.rsvp_count = data.rsvp_count
	end

	if data.rsvpCount ~= nil then
		v2.rsvp_count = data.rsvpCount
	end

	if data.place_id ~= nil then
		v2.place_id = data.place_id
	end

	if data.placeId ~= nil then
		v2.place_id = data.placeId
	end

	return v2
end

class.descriptor = {
	name = "EventData",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventData"
}

v.EventData = class

typeRegistry.default:register(v.EventData)

return { EventData = v.EventData }
