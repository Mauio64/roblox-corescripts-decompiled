local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	return (setmetatable({
		id = (data == nil or data.id == nil) and 0 or data.id,
		title = (data == nil or data.title == nil) and "" or data.title,
		url = (data == nil or data.url == nil) and "" or data.url,
		type = (data == nil or data.type == nil) and "" or data.type,
		community_id = (data == nil or data.community_id == nil) and 0 or data.community_id
	}, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.id)
	end

	if data.title ~= nil and data.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.title)
	end

	if data.url ~= nil and data.url ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.url)
	end

	if data.type ~= nil and data.type ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.type)
	end

	if data.community_id ~= nil and data.community_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.community_id)
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
			elseif v3 == 5 then
				local community_id
				community_id, v2 = proto.readVarIntI64(buf, v2)
				result.community_id = community_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.url = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.type = buffer.tostring(v5)
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

	if data.id ~= nil and data.id ~= 0 then
		v2.id = data.id
	end

	if data.title ~= nil and data.title ~= "" then
		v2.title = data.title
	end

	if data.url ~= nil and data.url ~= "" then
		v2.url = data.url
	end

	if data.type ~= nil and data.type ~= "" then
		v2.type = data.type
	end

	if data.community_id ~= nil and data.community_id ~= 0 then
		v2.communityId = data.community_id
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

	if data.url ~= nil then
		v2.url = data.url
	end

	if data.type ~= nil then
		v2.type = data.type
	end

	if data.community_id ~= nil then
		v2.community_id = data.community_id
	end

	if data.communityId ~= nil then
		v2.community_id = data.communityId
	end

	return v2
end

class.descriptor = {
	name = "SocialLinkData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkData"
}

v.SocialLinkData = class

typeRegistry.default:register(v.SocialLinkData)

return { SocialLinkData = v.SocialLinkData }
