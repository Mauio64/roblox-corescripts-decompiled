local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 47
	-- upvalues: t2 (copy)
	return (setmetatable({
		user_id = if t3 ~= nil and t3.user_id ~= nil then t3.user_id else nil,
		username = if t3 ~= nil and t3.username ~= nil then t3.username else nil,
		display_name = if t3 ~= nil and t3.display_name ~= nil then t3.display_name else nil,
		is_verified = if t3 ~= nil and t3.is_verified ~= nil then t3.is_verified else nil,
		previous_usernames = if t3 ~= nil and t3.previous_usernames ~= nil then t3.previous_usernames else {}
	}, t2))
end
function t2.encode(p1) -- line: 57
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.user_id ~= nil then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, p1.user_id)
	end

	if p1.username ~= nil then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.username)
	end

	if p1.display_name ~= nil then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.display_name)
	end

	if p1.is_verified ~= nil then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, not p1.is_verified and 0 or 1)
	end

	if p1.previous_usernames ~= nil and #p1.previous_usernames > 0 then
		for _, v18 in p1.previous_usernames do
			local v19, v20 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v19, v20, v18)
		end
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 93
	-- upvalues: t2 (copy), proto (copy)
	local v23 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v25, v26

		v25, v26, n2 = proto.readTag(p2, n2)

		if v26 == proto.wireTypes.varint then
			if v25 == 1 then
				local v27

				v27, n2 = proto.readVarIntI64(p2, n2)
				v23.user_id = v27
			elseif v25 == 4 then
				local v28

				v28, n2 = proto.readVarInt(p2, n2)
				v23.is_verified = v28 ~= 0
			else
				local v29

				v29, n2 = proto.readVarInt(p2, n2)
			end
		elseif v26 == proto.wireTypes.lengthDelimited then
			if v25 == 2 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v23.username = buffer.tostring(v30)
			elseif v25 == 3 then
				local v31

				v31, n2 = proto.readBuffer(p2, n2)
				v23.display_name = buffer.tostring(v31)
			elseif v25 == 5 then
				local v32

				v32, n2 = proto.readBuffer(p2, n2)
				table.insert(v23.previous_usernames, buffer.tostring(v32))
			else
				local v33, v34 = proto.readVarInt(p2, n2)

				n2 = v34 + v33
			end
		elseif v26 == proto.wireTypes.i32 then
			local v35

			v35, n2 = proto.readFixed32(p2, n2)
		elseif v26 == proto.wireTypes.i64 then
			local v36

			v36, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v26)
		end
	end

	return v23
end
function t2.jsonEncode(p3) -- line: 156
	local t4 = {}

	if p3.user_id ~= nil then
		t4.userId = p3.user_id
	end

	if p3.username ~= nil then
		t4.username = p3.username
	end

	if p3.display_name ~= nil then
		t4.displayName = p3.display_name
	end

	if p3.is_verified ~= nil then
		t4.isVerified = p3.is_verified
	end

	if p3.previous_usernames ~= nil and #p3.previous_usernames > 0 then
		local t5 = {}

		for _, v41 in p3.previous_usernames do
			table.insert(t5, v41)
		end

		t4.previousUsernames = t5
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 186
	-- upvalues: t2 (copy)
	local v43 = t2.new()

	if t6.user_id ~= nil then
		v43.user_id = t6.user_id
	end

	if t6.userId ~= nil then
		v43.user_id = t6.userId
	end

	if t6.username ~= nil then
		v43.username = t6.username
	end

	if t6.display_name ~= nil then
		v43.display_name = t6.display_name
	end

	if t6.displayName ~= nil then
		v43.display_name = t6.displayName
	end

	if t6.is_verified ~= nil then
		v43.is_verified = t6.is_verified
	end

	if t6.isVerified ~= nil then
		v43.is_verified = t6.isVerified
	end

	if t6.previous_usernames ~= nil then
		local t7 = {}

		for _, v46 in t6.previous_usernames do
			table.insert(t7, v46)
		end

		v43.previous_usernames = t7
	end

	if t6.previousUsernames ~= nil then
		local t8 = {}

		for _, v49 in t6.previousUsernames do
			table.insert(t8, v49)
		end

		v43.previous_usernames = t8
	end

	return v43
end

t2.descriptor = {
	name = "UserProfileData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserProfileData"
}
t1.UserProfileData = t2
typeRegistry.default:register(t1.UserProfileData)

return {
	UserProfileData = t1.UserProfileData
}
