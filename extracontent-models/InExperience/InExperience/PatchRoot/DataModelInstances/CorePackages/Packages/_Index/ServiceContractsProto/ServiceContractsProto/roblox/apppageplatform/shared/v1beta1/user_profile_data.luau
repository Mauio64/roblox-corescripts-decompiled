local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local user_id

	if not (data == nil or data.user_id == nil) then
		user_id = data.user_id
	end

	local username

	if not (data == nil or data.username == nil) then
		username = data.username
	end

	local display_name

	if not (data == nil or data.display_name == nil) then
		display_name = data.display_name
	end

	local is_verified

	if not (data == nil or data.is_verified == nil) then
		is_verified = data.is_verified
	end

	local v2 = {
		user_id = user_id,
		username = username,
		display_name = display_name,
		is_verified = is_verified,
		previous_usernames = (data == nil or data.previous_usernames == nil) and {} or data.previous_usernames
	}
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.user_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.user_id)
	end

	if data.username ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.username)
	end

	if data.display_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.display_name)
	end

	if data.is_verified ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_verified and 1 or 0)
	end

	if data.previous_usernames ~= nil and #data.previous_usernames > 0 then
		for _, previous_username in data.previous_usernames do
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, previous_username)
		end
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
				local user_id
				user_id, v2 = proto.readVarIntI64(buf, v2)
				result.user_id = user_id
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_verified = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.username = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.display_name = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.previous_usernames, buffer.tostring(v5))
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

	if data.user_id ~= nil then
		v2.userId = data.user_id
	end

	if data.username ~= nil then
		v2.username = data.username
	end

	if data.display_name ~= nil then
		v2.displayName = data.display_name
	end

	if data.is_verified ~= nil then
		v2.isVerified = data.is_verified
	end

	if data.previous_usernames == nil or not (#data.previous_usernames > 0) then
		return v2
	end

	local previous_usernames = {}

	for _, previous_username in data.previous_usernames do
		table.insert(previous_usernames, previous_username)
	end

	v2.previousUsernames = previous_usernames

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.user_id ~= nil then
		v2.user_id = data.user_id
	end

	if data.userId ~= nil then
		v2.user_id = data.userId
	end

	if data.username ~= nil then
		v2.username = data.username
	end

	if data.display_name ~= nil then
		v2.display_name = data.display_name
	end

	if data.displayName ~= nil then
		v2.display_name = data.displayName
	end

	if data.is_verified ~= nil then
		v2.is_verified = data.is_verified
	end

	if data.isVerified ~= nil then
		v2.is_verified = data.isVerified
	end

	if data.previous_usernames ~= nil then
		local previous_usernames = {}

		for _, previous_username in data.previous_usernames do
			table.insert(previous_usernames, previous_username)
		end

		v2.previous_usernames = previous_usernames
	end

	if data.previousUsernames == nil then
		return v2
	end

	local previousUsernames = {}

	for _, previousUsername in data.previousUsernames do
		table.insert(previousUsernames, previousUsername)
	end

	v2.previous_usernames = previousUsernames

	return v2
end

class.descriptor = {
	name = "UserProfileData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserProfileData"
}

v.UserProfileData = class

typeRegistry.default:register(v.UserProfileData)

return { UserProfileData = v.UserProfileData }
