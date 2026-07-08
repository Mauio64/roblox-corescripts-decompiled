local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 44
	-- upvalues: t2 (copy)
	return (setmetatable({
		can_follow = t3 ~= nil and (t3.can_follow ~= nil and t3.can_follow),
		is_following = t3 ~= nil and (t3.is_following ~= nil and t3.is_following)
	}, t2))
end
function t2.encode(p1) -- line: 51
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.can_follow then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, not p1.can_follow and 0 or 1)
	end

	if p1.is_following then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, not p1.is_following and 0 or 1)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 70
	-- upvalues: t2 (copy), proto (copy)
	local v15 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v17, v18

		v17, v18, n2 = proto.readTag(p2, n2)

		if v18 == proto.wireTypes.varint then
			if v17 == 1 then
				local v19

				v19, n2 = proto.readVarInt(p2, n2)
				v15.can_follow = v19 ~= 0
			elseif v17 == 2 then
				local v20

				v20, n2 = proto.readVarInt(p2, n2)
				v15.is_following = v20 ~= 0
			else
				local v21

				v21, n2 = proto.readVarInt(p2, n2)
			end
		elseif v18 == proto.wireTypes.lengthDelimited then
			local v22, v23 = proto.readVarInt(p2, n2)

			n2 = v23 + v22
		elseif v18 == proto.wireTypes.i32 then
			local v24

			v24, n2 = proto.readFixed32(p2, n2)
		elseif v18 == proto.wireTypes.i64 then
			local v25

			v25, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v18)
		end
	end

	return v15
end
function t2.jsonEncode(p3) -- line: 118
	local t4 = {}

	if p3.can_follow then
		t4.canFollow = p3.can_follow
	end

	if p3.is_following then
		t4.isFollowing = p3.is_following
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 132
	-- upvalues: t2 (copy)
	local v29 = t2.new()

	if t5.can_follow ~= nil then
		v29.can_follow = t5.can_follow
	end

	if t5.canFollow ~= nil then
		v29.can_follow = t5.canFollow
	end

	if t5.is_following ~= nil then
		v29.is_following = t5.is_following
	end

	if t5.isFollowing ~= nil then
		v29.is_following = t5.isFollowing
	end

	return v29
end

t2.descriptor = {
	name = "UniverseUserFollowData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowData"
}
t1.UniverseUserFollowData = t2
typeRegistry.default:register(t1.UniverseUserFollowData)

return {
	UniverseUserFollowData = t1.UniverseUserFollowData
}
