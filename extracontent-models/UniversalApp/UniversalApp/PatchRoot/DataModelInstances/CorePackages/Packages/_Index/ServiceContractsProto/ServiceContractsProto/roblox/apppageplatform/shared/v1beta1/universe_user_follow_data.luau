local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local v2 = {
		can_follow = p ~= nil and p.can_follow ~= nil and p.can_follow,
		is_following = p ~= nil and p.is_following ~= nil and p.is_following
	}
	return (setmetatable(v2, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.can_follow then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.can_follow and 1 or 0)
	end

	if p.is_following then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.is_following and 1 or 0)
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
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_follow = v5 ~= 0
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_following = v5 ~= 0
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

	if p.can_follow then
		v2.canFollow = p.can_follow
	end

	if p.is_following then
		v2.isFollowing = p.is_following
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.can_follow ~= nil then
		v2.can_follow = data.can_follow
	end

	if data.canFollow ~= nil then
		v2.can_follow = data.canFollow
	end

	if data.is_following ~= nil then
		v2.is_following = data.is_following
	end

	if data.isFollowing ~= nil then
		v2.is_following = data.isFollowing
	end

	return v2
end

class.descriptor = {
	name = "UniverseUserFollowData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowData"
}

v.UniverseUserFollowData = class

typeRegistry.default:register(v.UniverseUserFollowData)

return { UniverseUserFollowData = v.UniverseUserFollowData }
