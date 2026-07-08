local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 47
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else 0,
		title = if t3 ~= nil and t3.title ~= nil then t3.title else "",
		url = if t3 ~= nil and t3.url ~= nil then t3.url else "",
		type = if t3 ~= nil and t3.type ~= nil then t3.type else "",
		community_id = if t3 ~= nil and t3.community_id ~= nil then t3.community_id else 0
	}, t2))
end
function t2.encode(p1) -- line: 57
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= 0 then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, p1.id)
	end

	if p1.title ~= nil and p1.title ~= "" then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.title)
	end

	if p1.url ~= nil and p1.url ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.url)
	end

	if p1.type ~= nil and p1.type ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.type)
	end

	if p1.community_id ~= nil and p1.community_id ~= 0 then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v17, v18, p1.community_id)
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
			if v23 == 1 then
				local v25

				v25, n2 = proto.readVarIntI64(p2, n2)
				v21.id = v25
			elseif v23 == 5 then
				local v26

				v26, n2 = proto.readVarIntI64(p2, n2)
				v21.community_id = v26
			else
				local v27

				v27, n2 = proto.readVarInt(p2, n2)
			end
		elseif v24 == proto.wireTypes.lengthDelimited then
			if v23 == 2 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v21.title = buffer.tostring(v28)
			elseif v23 == 3 then
				local v29

				v29, n2 = proto.readBuffer(p2, n2)
				v21.url = buffer.tostring(v29)
			elseif v23 == 4 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v21.type = buffer.tostring(v30)
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

	if p3.id ~= nil and p3.id ~= 0 then
		t4.id = p3.id
	end

	if p3.title ~= nil and p3.title ~= "" then
		t4.title = p3.title
	end

	if p3.url ~= nil and p3.url ~= "" then
		t4.url = p3.url
	end

	if p3.type ~= nil and p3.type ~= "" then
		t4.type = p3.type
	end

	if p3.community_id ~= nil and p3.community_id ~= 0 then
		t4.communityId = p3.community_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 180
	-- upvalues: t2 (copy)
	local v38 = t2.new()

	if t5.id ~= nil then
		v38.id = t5.id
	end

	if t5.title ~= nil then
		v38.title = t5.title
	end

	if t5.url ~= nil then
		v38.url = t5.url
	end

	if t5.type ~= nil then
		v38.type = t5.type
	end

	if t5.community_id ~= nil then
		v38.community_id = t5.community_id
	end

	if t5.communityId ~= nil then
		v38.community_id = t5.communityId
	end

	return v38
end

t2.descriptor = {
	name = "SocialLinkData",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkData"
}
t1.SocialLinkData = t2
typeRegistry.default:register(t1.SocialLinkData)

return {
	SocialLinkData = t1.SocialLinkData
}
