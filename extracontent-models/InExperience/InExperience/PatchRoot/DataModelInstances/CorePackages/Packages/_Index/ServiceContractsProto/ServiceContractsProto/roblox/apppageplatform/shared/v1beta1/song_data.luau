local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 53
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		media_asset_id = if t3 ~= nil and t3.media_asset_id ~= nil then t3.media_asset_id else "",
		title = if t3 ~= nil and t3.title ~= nil then t3.title else "",
		artist = if t3 ~= nil and t3.artist ~= nil then t3.artist else "",
		album = if t3 ~= nil and t3.album ~= nil then t3.album else "",
		album_art_asset_id = if t3 ~= nil and t3.album_art_asset_id ~= nil then t3.album_art_asset_id else 0,
		is_private = t3 ~= nil and (t3.is_private ~= nil and t3.is_private),
		duration = if t3 ~= nil and t3.duration ~= nil then t3.duration else 0
	}, t2))
end
function t2.encode(p1) -- line: 66
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	if p1.media_asset_id ~= nil and p1.media_asset_id ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.media_asset_id)
	end

	if p1.title ~= nil and p1.title ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.title)
	end

	if p1.artist ~= nil and p1.artist ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.artist)
	end

	if p1.album ~= nil and p1.album ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.album)
	end

	if p1.album_art_asset_id ~= nil and p1.album_art_asset_id ~= 0 then
		local v19, v20 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, p1.album_art_asset_id)
	end

	if p1.is_private then
		local v21, v22 = proto.writeTag(buf, n1, 7, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v21, v22, not p1.is_private and 0 or 1)
	end

	if p1.duration ~= nil and p1.duration ~= 0 then
		local v23, v24 = proto.writeTag(buf, n1, 8, proto.wireTypes.i64)

		buf, n1 = proto.writeDouble(v23, v24, p1.duration)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 115
	-- upvalues: t2 (copy), proto (copy)
	local v27 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v29, v30

		v29, v30, n2 = proto.readTag(p2, n2)

		if v30 == proto.wireTypes.varint then
			if v29 == 6 then
				local v31

				v31, n2 = proto.readVarIntI64(p2, n2)
				v27.album_art_asset_id = v31
			elseif v29 == 7 then
				local v32

				v32, n2 = proto.readVarInt(p2, n2)
				v27.is_private = v32 ~= 0
			else
				local v33

				v33, n2 = proto.readVarInt(p2, n2)
			end
		elseif v30 == proto.wireTypes.lengthDelimited then
			if v29 == 1 then
				local v34

				v34, n2 = proto.readBuffer(p2, n2)
				v27.id = buffer.tostring(v34)
			elseif v29 == 2 then
				local v35

				v35, n2 = proto.readBuffer(p2, n2)
				v27.media_asset_id = buffer.tostring(v35)
			elseif v29 == 3 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				v27.title = buffer.tostring(v36)
			elseif v29 == 4 then
				local v37

				v37, n2 = proto.readBuffer(p2, n2)
				v27.artist = buffer.tostring(v37)
			elseif v29 == 5 then
				local v38

				v38, n2 = proto.readBuffer(p2, n2)
				v27.album = buffer.tostring(v38)
			else
				local v39, v40 = proto.readVarInt(p2, n2)

				n2 = v40 + v39
			end
		elseif v30 == proto.wireTypes.i32 then
			local v41

			v41, n2 = proto.readFixed32(p2, n2)
		elseif v30 == proto.wireTypes.i64 then
			if v29 == 8 then
				local v42

				v42, n2 = proto.readDouble(p2, n2)
				v27.duration = v42
			else
				local v43

				v43, n2 = proto.readFixed64(p2, n2)
			end
		else
			error("Unsupported wire type: " .. v30)
		end
	end

	return v27
end
function t2.jsonEncode(p3) -- line: 193
	-- upvalues: proto (copy)
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.media_asset_id ~= nil and p3.media_asset_id ~= "" then
		t4.mediaAssetId = p3.media_asset_id
	end

	if p3.title ~= nil and p3.title ~= "" then
		t4.title = p3.title
	end

	if p3.artist ~= nil and p3.artist ~= "" then
		t4.artist = p3.artist
	end

	if p3.album ~= nil and p3.album ~= "" then
		t4.album = p3.album
	end

	if p3.album_art_asset_id ~= nil and p3.album_art_asset_id ~= 0 then
		t4.albumArtAssetId = p3.album_art_asset_id
	end

	if p3.is_private then
		t4.isPrivate = p3.is_private
	end

	if p3.duration ~= nil and p3.duration ~= 0 then
		t4.duration = proto.json.serializeNumber(p3.duration)
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 231
	-- upvalues: t2 (copy), proto (copy)
	local v47 = t2.new()

	if t5.id ~= nil then
		v47.id = t5.id
	end

	if t5.media_asset_id ~= nil then
		v47.media_asset_id = t5.media_asset_id
	end

	if t5.mediaAssetId ~= nil then
		v47.media_asset_id = t5.mediaAssetId
	end

	if t5.title ~= nil then
		v47.title = t5.title
	end

	if t5.artist ~= nil then
		v47.artist = t5.artist
	end

	if t5.album ~= nil then
		v47.album = t5.album
	end

	if t5.album_art_asset_id ~= nil then
		v47.album_art_asset_id = t5.album_art_asset_id
	end

	if t5.albumArtAssetId ~= nil then
		v47.album_art_asset_id = t5.albumArtAssetId
	end

	if t5.is_private ~= nil then
		v47.is_private = t5.is_private
	end

	if t5.isPrivate ~= nil then
		v47.is_private = t5.isPrivate
	end

	if t5.duration ~= nil then
		v47.duration = proto.json.deserializeNumber(t5.duration)
	end

	return v47
end

t2.descriptor = {
	name = "SongData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongData"
}
t1.SongData = t2
typeRegistry.default:register(t1.SongData)

return {
	SongData = t1.SongData
}
