local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		media_asset_id = (data == nil or data.media_asset_id == nil) and "" or data.media_asset_id,
		title = (data == nil or data.title == nil) and "" or data.title,
		artist = (data == nil or data.artist == nil) and "" or data.artist,
		album = (data == nil or data.album == nil) and "" or data.album,
		album_art_asset_id = (data == nil or data.album_art_asset_id == nil) and 0 or data.album_art_asset_id,
		is_private = data ~= nil and data.is_private ~= nil and data.is_private,
		duration = (data == nil or data.duration == nil) and 0 or data.duration
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

	if data.media_asset_id ~= nil and data.media_asset_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.media_asset_id)
	end

	if data.title ~= nil and data.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.title)
	end

	if data.artist ~= nil and data.artist ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.artist)
	end

	if data.album ~= nil and data.album ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.album)
	end

	if data.album_art_asset_id ~= nil and data.album_art_asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.album_art_asset_id)
	end

	if data.is_private then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_private and 1 or 0)
	end

	if data.duration ~= nil and data.duration ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.i64)
		v2, v3 = proto.writeDouble(v4, v5, data.duration)
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
				local album_art_asset_id
				album_art_asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.album_art_asset_id = album_art_asset_id
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_private = v5 ~= 0
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
				result.media_asset_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.artist = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.album = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			if v3 == 8 then
				local duration
				duration, v2 = proto.readDouble(buf, v2)
				result.duration = duration
			else
				local _
				_, v2 = proto.readFixed64(buf, v2)
			end
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

	if data.media_asset_id ~= nil and data.media_asset_id ~= "" then
		v2.mediaAssetId = data.media_asset_id
	end

	if data.title ~= nil and data.title ~= "" then
		v2.title = data.title
	end

	if data.artist ~= nil and data.artist ~= "" then
		v2.artist = data.artist
	end

	if data.album ~= nil and data.album ~= "" then
		v2.album = data.album
	end

	if data.album_art_asset_id ~= nil and data.album_art_asset_id ~= 0 then
		v2.albumArtAssetId = data.album_art_asset_id
	end

	if data.is_private then
		v2.isPrivate = data.is_private
	end

	if data.duration ~= nil and data.duration ~= 0 then
		v2.duration = proto.json.serializeNumber(data.duration)
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.media_asset_id ~= nil then
		v2.media_asset_id = data.media_asset_id
	end

	if data.mediaAssetId ~= nil then
		v2.media_asset_id = data.mediaAssetId
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.artist ~= nil then
		v2.artist = data.artist
	end

	if data.album ~= nil then
		v2.album = data.album
	end

	if data.album_art_asset_id ~= nil then
		v2.album_art_asset_id = data.album_art_asset_id
	end

	if data.albumArtAssetId ~= nil then
		v2.album_art_asset_id = data.albumArtAssetId
	end

	if data.is_private ~= nil then
		v2.is_private = data.is_private
	end

	if data.isPrivate ~= nil then
		v2.is_private = data.isPrivate
	end

	if data.duration ~= nil then
		v2.duration = proto.json.deserializeNumber(data.duration)
	end

	return v2
end

class.descriptor = {
	name = "SongData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongData"
}

v.SongData = class

typeRegistry.default:register(v.SongData)

return { SongData = v.SongData }
