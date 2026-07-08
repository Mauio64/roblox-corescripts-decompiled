local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 47
	-- upvalues: t2 (copy)
	return (setmetatable({
		following_count_by_type = if t3 ~= nil and t3.following_count_by_type ~= nil then t3.following_count_by_type else 0,
		following_limit_by_type = if t3 ~= nil and t3.following_limit_by_type ~= nil then t3.following_limit_by_type else 0
	}, t2))
end
function t2.encode(p1) -- line: 60
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.following_count_by_type ~= nil and p1.following_count_by_type ~= 0 then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, p1.following_count_by_type)
	end

	if p1.following_limit_by_type ~= nil and p1.following_limit_by_type ~= 0 then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, p1.following_limit_by_type)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 79
	-- upvalues: t2 (copy), proto (copy)
	local v15 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v17, v18

		v17, v18, n2 = proto.readTag(p2, n2)

		if v18 == proto.wireTypes.varint then
			if v17 == 1 then
				local v19

				v19, n2 = proto.readVarIntI32(p2, n2)
				v15.following_count_by_type = v19
			elseif v17 == 2 then
				local v20

				v20, n2 = proto.readVarIntI32(p2, n2)
				v15.following_limit_by_type = v20
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
function t2.jsonEncode(p3) -- line: 127
	local t4 = {}

	if p3.following_count_by_type ~= nil and p3.following_count_by_type ~= 0 then
		t4.followingCountByType = p3.following_count_by_type
	end

	if p3.following_limit_by_type ~= nil and p3.following_limit_by_type ~= 0 then
		t4.followingLimitByType = p3.following_limit_by_type
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 141
	-- upvalues: t2 (copy)
	local v29 = t2.new()

	if t5.following_count_by_type ~= nil then
		v29.following_count_by_type = t5.following_count_by_type
	end

	if t5.followingCountByType ~= nil then
		v29.following_count_by_type = t5.followingCountByType
	end

	if t5.following_limit_by_type ~= nil then
		v29.following_limit_by_type = t5.following_limit_by_type
	end

	if t5.followingLimitByType ~= nil then
		v29.following_limit_by_type = t5.followingLimitByType
	end

	return v29
end

t2.descriptor = {
	name = "UniverseUserFollowLimitData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowLimitData"
}
t1.UniverseUserFollowLimitData = t2
typeRegistry.default:register(t1.UniverseUserFollowLimitData)

return {
	UniverseUserFollowLimitData = t1.UniverseUserFollowLimitData
}
