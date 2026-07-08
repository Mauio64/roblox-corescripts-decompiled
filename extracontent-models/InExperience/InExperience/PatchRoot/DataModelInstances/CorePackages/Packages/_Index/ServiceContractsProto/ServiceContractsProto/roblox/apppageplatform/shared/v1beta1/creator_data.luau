local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 45
	-- upvalues: t2 (copy)
	return (setmetatable({
		creator_type = if t3 ~= nil and t3.creator_type ~= nil then t3.creator_type else "",
		creator_id = if t3 ~= nil and t3.creator_id ~= nil then t3.creator_id else 0,
		creator_name = if t3 ~= nil and t3.creator_name ~= nil then t3.creator_name else "",
		is_verified = t3 ~= nil and (t3.is_verified ~= nil and t3.is_verified)
	}, t2))
end
function t2.encode(p1) -- line: 54
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.creator_type ~= nil and p1.creator_type ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.creator_type)
	end

	if p1.creator_id ~= nil and p1.creator_id ~= 0 then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, p1.creator_id)
	end

	if p1.creator_name ~= nil and p1.creator_name ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.creator_name)
	end

	if p1.is_verified then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, not p1.is_verified and 0 or 1)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 83
	-- upvalues: t2 (copy), proto (copy)
	local v19 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v21, v22

		v21, v22, n2 = proto.readTag(p2, n2)

		if v22 == proto.wireTypes.varint then
			if v21 == 2 then
				local v23

				v23, n2 = proto.readVarIntI64(p2, n2)
				v19.creator_id = v23
			elseif v21 == 4 then
				local v24

				v24, n2 = proto.readVarInt(p2, n2)
				v19.is_verified = v24 ~= 0
			else
				local v25

				v25, n2 = proto.readVarInt(p2, n2)
			end
		elseif v22 == proto.wireTypes.lengthDelimited then
			if v21 == 1 then
				local v26

				v26, n2 = proto.readBuffer(p2, n2)
				v19.creator_type = buffer.tostring(v26)
			elseif v21 == 3 then
				local v27

				v27, n2 = proto.readBuffer(p2, n2)
				v19.creator_name = buffer.tostring(v27)
			else
				local v28, v29 = proto.readVarInt(p2, n2)

				n2 = v29 + v28
			end
		elseif v22 == proto.wireTypes.i32 then
			local v30

			v30, n2 = proto.readFixed32(p2, n2)
		elseif v22 == proto.wireTypes.i64 then
			local v31

			v31, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v22)
		end
	end

	return v19
end
function t2.jsonEncode(p3) -- line: 141
	local t4 = {}

	if p3.creator_type ~= nil and p3.creator_type ~= "" then
		t4.creatorType = p3.creator_type
	end

	if p3.creator_id ~= nil and p3.creator_id ~= 0 then
		t4.creatorId = p3.creator_id
	end

	if p3.creator_name ~= nil and p3.creator_name ~= "" then
		t4.creatorName = p3.creator_name
	end

	if p3.is_verified then
		t4.isVerified = p3.is_verified
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 163
	-- upvalues: t2 (copy)
	local v35 = t2.new()

	if t5.creator_type ~= nil then
		v35.creator_type = t5.creator_type
	end

	if t5.creatorType ~= nil then
		v35.creator_type = t5.creatorType
	end

	if t5.creator_id ~= nil then
		v35.creator_id = t5.creator_id
	end

	if t5.creatorId ~= nil then
		v35.creator_id = t5.creatorId
	end

	if t5.creator_name ~= nil then
		v35.creator_name = t5.creator_name
	end

	if t5.creatorName ~= nil then
		v35.creator_name = t5.creatorName
	end

	if t5.is_verified ~= nil then
		v35.is_verified = t5.is_verified
	end

	if t5.isVerified ~= nil then
		v35.is_verified = t5.isVerified
	end

	return v35
end

t2.descriptor = {
	name = "CreatorData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CreatorData"
}
t1.CreatorData = t2
typeRegistry.default:register(t1.CreatorData)

return {
	CreatorData = t1.CreatorData
}
