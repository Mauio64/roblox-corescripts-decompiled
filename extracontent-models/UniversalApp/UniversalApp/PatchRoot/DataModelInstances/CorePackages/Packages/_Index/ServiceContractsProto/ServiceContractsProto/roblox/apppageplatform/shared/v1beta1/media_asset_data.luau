local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	return (setmetatable({
		image_id = (data == nil or data.image_id == nil) and "" or data.image_id,
		asset_type_id = (data == nil or data.asset_type_id == nil) and 0 or data.asset_type_id,
		video_hash = (data == nil or data.video_hash == nil) and "" or data.video_hash,
		video_id = (data == nil or data.video_id == nil) and "" or data.video_id,
		video_title = (data == nil or data.video_title == nil) and "" or data.video_title
	}, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.image_id ~= nil and data.image_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.image_id)
	end

	if data.asset_type_id ~= nil and data.asset_type_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.asset_type_id)
	end

	if data.video_hash ~= nil and data.video_hash ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.video_hash)
	end

	if data.video_id ~= nil and data.video_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.video_id)
	end

	if data.video_title ~= nil and data.video_title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.video_title)
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
			if v3 == 2 then
				local asset_type_id
				asset_type_id, v2 = proto.readVarIntI64(buf, v2)
				result.asset_type_id = asset_type_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.image_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.video_hash = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.video_id = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.video_title = buffer.tostring(v5)
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

	if data.image_id ~= nil and data.image_id ~= "" then
		v2.imageId = data.image_id
	end

	if data.asset_type_id ~= nil and data.asset_type_id ~= 0 then
		v2.assetTypeId = data.asset_type_id
	end

	if data.video_hash ~= nil and data.video_hash ~= "" then
		v2.videoHash = data.video_hash
	end

	if data.video_id ~= nil and data.video_id ~= "" then
		v2.videoId = data.video_id
	end

	if data.video_title ~= nil and data.video_title ~= "" then
		v2.videoTitle = data.video_title
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.image_id ~= nil then
		v2.image_id = data.image_id
	end

	if data.imageId ~= nil then
		v2.image_id = data.imageId
	end

	if data.asset_type_id ~= nil then
		v2.asset_type_id = data.asset_type_id
	end

	if data.assetTypeId ~= nil then
		v2.asset_type_id = data.assetTypeId
	end

	if data.video_hash ~= nil then
		v2.video_hash = data.video_hash
	end

	if data.videoHash ~= nil then
		v2.video_hash = data.videoHash
	end

	if data.video_id ~= nil then
		v2.video_id = data.video_id
	end

	if data.videoId ~= nil then
		v2.video_id = data.videoId
	end

	if data.video_title ~= nil then
		v2.video_title = data.video_title
	end

	if data.videoTitle ~= nil then
		v2.video_title = data.videoTitle
	end

	return v2
end

class.descriptor = {
	name = "MediaAssetData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaAssetData"
}

v.MediaAssetData = class

typeRegistry.default:register(v.MediaAssetData)

return { MediaAssetData = v.MediaAssetData }
