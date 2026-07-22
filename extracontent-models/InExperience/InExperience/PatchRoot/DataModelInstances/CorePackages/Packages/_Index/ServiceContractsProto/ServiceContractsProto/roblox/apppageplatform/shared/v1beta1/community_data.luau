local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 47
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		name = if t3 ~= nil and t3.name ~= nil then t3.name else "",
		member_count = if t3 ~= nil and t3.member_count ~= nil then t3.member_count else 0,
		description = if t3 ~= nil and t3.description ~= nil then t3.description else "",
		is_verified = t3 ~= nil and (t3.is_verified ~= nil and t3.is_verified)
	}, t2))
end
function t2.encode(p1) -- line: 57
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	if p1.name ~= nil and p1.name ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.name)
	end

	if p1.member_count ~= nil and p1.member_count ~= 0 then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v13, v14, p1.member_count)
	end

	if p1.description ~= nil and p1.description ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.description)
	end

	if p1.is_verified then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v17, v18, not p1.is_verified and 0 or 1)
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
			if v23 == 3 then
				local v25

				v25, n2 = proto.readVarIntI64(p2, n2)
				v21.member_count = v25
			elseif v23 == 5 then
				local v26

				v26, n2 = proto.readVarInt(p2, n2)
				v21.is_verified = v26 ~= 0
			else
				local v27

				v27, n2 = proto.readVarInt(p2, n2)
			end
		elseif v24 == proto.wireTypes.lengthDelimited then
			if v23 == 1 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v21.id = buffer.tostring(v28)
			elseif v23 == 2 then
				local v29

				v29, n2 = proto.readBuffer(p2, n2)
				v21.name = buffer.tostring(v29)
			elseif v23 == 4 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v21.description = buffer.tostring(v30)
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

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.name ~= nil and p3.name ~= "" then
		t4.name = p3.name
	end

	if p3.member_count ~= nil and p3.member_count ~= 0 then
		t4.memberCount = p3.member_count
	end

	if p3.description ~= nil and p3.description ~= "" then
		t4.description = p3.description
	end

	if p3.is_verified then
		t4.isVerified = p3.is_verified
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 180
	-- upvalues: t2 (copy)
	local v38 = t2.new()

	if t5.id ~= nil then
		v38.id = t5.id
	end

	if t5.name ~= nil then
		v38.name = t5.name
	end

	if t5.member_count ~= nil then
		v38.member_count = t5.member_count
	end

	if t5.memberCount ~= nil then
		v38.member_count = t5.memberCount
	end

	if t5.description ~= nil then
		v38.description = t5.description
	end

	if t5.is_verified ~= nil then
		v38.is_verified = t5.is_verified
	end

	if t5.isVerified ~= nil then
		v38.is_verified = t5.isVerified
	end

	return v38
end

t2.descriptor = {
	name = "CommunityData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityData"
}
t1.CommunityData = t2
typeRegistry.default:register(t1.CommunityData)

return {
	CommunityData = t1.CommunityData
}
