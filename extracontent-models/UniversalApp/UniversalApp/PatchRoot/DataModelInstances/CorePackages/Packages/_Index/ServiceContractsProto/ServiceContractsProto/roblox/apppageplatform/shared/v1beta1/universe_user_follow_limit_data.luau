local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		following_count_by_type = (p == nil or p.following_count_by_type == nil) and 0 or p.following_count_by_type,
		following_limit_by_type = (p == nil or p.following_limit_by_type == nil) and 0 or p.following_limit_by_type
	}, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.following_count_by_type ~= nil and p.following_count_by_type ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.following_count_by_type)
	end

	if p.following_limit_by_type ~= nil and p.following_limit_by_type ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.following_limit_by_type)
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
				local following_count_by_type
				following_count_by_type, v2 = proto.readVarIntI32(buf, v2)
				result.following_count_by_type = following_count_by_type
			elseif v3 == 2 then
				local following_limit_by_type
				following_limit_by_type, v2 = proto.readVarIntI32(buf, v2)
				result.following_limit_by_type = following_limit_by_type
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

function class.jsonEncode(p)
	local v2 = {}

	if p.following_count_by_type ~= nil and p.following_count_by_type ~= 0 then
		v2.followingCountByType = p.following_count_by_type
	end

	if p.following_limit_by_type ~= nil and p.following_limit_by_type ~= 0 then
		v2.followingLimitByType = p.following_limit_by_type
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.following_count_by_type ~= nil then
		v2.following_count_by_type = data.following_count_by_type
	end

	if data.followingCountByType ~= nil then
		v2.following_count_by_type = data.followingCountByType
	end

	if data.following_limit_by_type ~= nil then
		v2.following_limit_by_type = data.following_limit_by_type
	end

	if data.followingLimitByType ~= nil then
		v2.following_limit_by_type = data.followingLimitByType
	end

	return v2
end

class.descriptor = {
	name = "UniverseUserFollowLimitData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowLimitData"
}

v.UniverseUserFollowLimitData = class

typeRegistry.default:register(v.UniverseUserFollowLimitData)

return { UniverseUserFollowLimitData = v.UniverseUserFollowLimitData }
