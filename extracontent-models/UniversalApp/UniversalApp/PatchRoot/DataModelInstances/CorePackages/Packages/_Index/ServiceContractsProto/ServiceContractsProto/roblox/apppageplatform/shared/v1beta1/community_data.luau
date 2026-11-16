local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		name = (data == nil or data.name == nil) and "" or data.name,
		member_count = (data == nil or data.member_count == nil) and 0 or data.member_count,
		description = (data == nil or data.description == nil) and "" or data.description,
		is_verified = data ~= nil and data.is_verified ~= nil and data.is_verified
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

	if data.name ~= nil and data.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.name)
	end

	if data.member_count ~= nil and data.member_count ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.member_count)
	end

	if data.description ~= nil and data.description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.description)
	end

	if data.is_verified then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_verified and 1 or 0)
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
			if v3 == 3 then
				local member_count
				member_count, v2 = proto.readVarIntI64(buf, v2)
				result.member_count = member_count
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_verified = v5 ~= 0
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
				result.name = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
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

	if data.name ~= nil and data.name ~= "" then
		v2.name = data.name
	end

	if data.member_count ~= nil and data.member_count ~= 0 then
		v2.memberCount = data.member_count
	end

	if data.description ~= nil and data.description ~= "" then
		v2.description = data.description
	end

	if data.is_verified then
		v2.isVerified = data.is_verified
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.member_count ~= nil then
		v2.member_count = data.member_count
	end

	if data.memberCount ~= nil then
		v2.member_count = data.memberCount
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.is_verified ~= nil then
		v2.is_verified = data.is_verified
	end

	if data.isVerified ~= nil then
		v2.is_verified = data.isVerified
	end

	return v2
end

class.descriptor = {
	name = "CommunityData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityData"
}

v.CommunityData = class

typeRegistry.default:register(v.CommunityData)

return { CommunityData = v.CommunityData }
