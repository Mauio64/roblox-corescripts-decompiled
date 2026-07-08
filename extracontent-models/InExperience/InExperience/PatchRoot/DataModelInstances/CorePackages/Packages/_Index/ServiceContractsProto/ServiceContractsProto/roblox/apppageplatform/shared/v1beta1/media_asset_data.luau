local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 47
	-- upvalues: t2 (copy)
	return (setmetatable({
		image_id = if t3 ~= nil and t3.image_id ~= nil then t3.image_id else "",
		asset_type_id = if t3 ~= nil and t3.asset_type_id ~= nil then t3.asset_type_id else 0,
		video_hash = if t3 ~= nil and t3.video_hash ~= nil then t3.video_hash else "",
		video_id = if t3 ~= nil and t3.video_id ~= nil then t3.video_id else "",
		video_title = if t3 ~= nil and t3.video_title ~= nil then t3.video_title else ""
	}, t2))
end
function t2.encode(p1) -- line: 57
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.image_id ~= nil and p1.image_id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.image_id)
	end

	if p1.asset_type_id ~= nil and p1.asset_type_id ~= 0 then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, p1.asset_type_id)
	end

	if p1.video_hash ~= nil and p1.video_hash ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.video_hash)
	end

	if p1.video_id ~= nil and p1.video_id ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.video_id)
	end

	if p1.video_title ~= nil and p1.video_title ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.video_title)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 91
	-- upvalues: t2 (copy), proto (copy)
	local v21 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v23, v24

		v23, v24, n2 = proto.readTag(p2, n2)

		if v24 == proto.wireTypes.varint then
			if v23 == 2 then
				local v25

				v25, n2 = proto.readVarIntI64(p2, n2)
				v21.asset_type_id = v25
			else
				local v26

				v26, n2 = proto.readVarInt(p2, n2)
			end
		elseif v24 == proto.wireTypes.lengthDelimited then
			if v23 == 1 then
				local v27

				v27, n2 = proto.readBuffer(p2, n2)
				v21.image_id = buffer.tostring(v27)
			elseif v23 == 3 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v21.video_hash = buffer.tostring(v28)
			elseif v23 == 4 then
				local v29

				v29, n2 = proto.readBuffer(p2, n2)
				v21.video_id = buffer.tostring(v29)
			elseif v23 == 5 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v21.video_title = buffer.tostring(v30)
			else
				local v31, v32 = proto.readVarInt(p2, n2)

				n2 = v32 + v31
			end
		elseif v24 == proto.wireTypes.i32 then
			local v33

			v33, n2 = proto.readFixed32(p2, n2)
		elseif v24 == proto.wireTypes.i64 then
			local v34

			v34, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v24)
		end
	end

	return v21
end
function t2.jsonEncode(p3) -- line: 154
	local t4 = {}

	if p3.image_id ~= nil and p3.image_id ~= "" then
		t4.imageId = p3.image_id
	end

	if p3.asset_type_id ~= nil and p3.asset_type_id ~= 0 then
		t4.assetTypeId = p3.asset_type_id
	end

	if p3.video_hash ~= nil and p3.video_hash ~= "" then
		t4.videoHash = p3.video_hash
	end

	if p3.video_id ~= nil and p3.video_id ~= "" then
		t4.videoId = p3.video_id
	end

	if p3.video_title ~= nil and p3.video_title ~= "" then
		t4.videoTitle = p3.video_title
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 180
	-- upvalues: t2 (copy)
	local v38 = t2.new()

	if t5.image_id ~= nil then
		v38.image_id = t5.image_id
	end

	if t5.imageId ~= nil then
		v38.image_id = t5.imageId
	end

	if t5.asset_type_id ~= nil then
		v38.asset_type_id = t5.asset_type_id
	end

	if t5.assetTypeId ~= nil then
		v38.asset_type_id = t5.assetTypeId
	end

	if t5.video_hash ~= nil then
		v38.video_hash = t5.video_hash
	end

	if t5.videoHash ~= nil then
		v38.video_hash = t5.videoHash
	end

	if t5.video_id ~= nil then
		v38.video_id = t5.video_id
	end

	if t5.videoId ~= nil then
		v38.video_id = t5.videoId
	end

	if t5.video_title ~= nil then
		v38.video_title = t5.video_title
	end

	if t5.videoTitle ~= nil then
		v38.video_title = t5.videoTitle
	end

	return v38
end

t2.descriptor = {
	name = "MediaAssetData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaAssetData"
}
t1.MediaAssetData = t2
typeRegistry.default:register(t1.MediaAssetData)

return {
	MediaAssetData = t1.MediaAssetData
}
