local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local user_vote

	if not (data == nil or data.user_vote == nil) then
		user_vote = data.user_vote
	end

	local v2 = {
		user_vote = user_vote,
		can_vote = data ~= nil and data.can_vote ~= nil and data.can_vote,
		reason_for_not_voteable = (data == nil or data.reason_for_not_voteable == nil) and "" or data.reason_for_not_voteable
	}
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.user_vote ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.user_vote and 1 or 0)
	end

	if data.can_vote then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.can_vote and 1 or 0)
	end

	if data.reason_for_not_voteable ~= nil and data.reason_for_not_voteable ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.reason_for_not_voteable)
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
				result.user_vote = v5 ~= 0
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.can_vote = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.reason_for_not_voteable = buffer.tostring(v5)
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

	if data.user_vote ~= nil then
		v2.userVote = data.user_vote
	end

	if data.can_vote then
		v2.canVote = data.can_vote
	end

	if data.reason_for_not_voteable ~= nil and data.reason_for_not_voteable ~= "" then
		v2.reasonForNotVoteable = data.reason_for_not_voteable
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.user_vote ~= nil then
		v2.user_vote = data.user_vote
	end

	if data.userVote ~= nil then
		v2.user_vote = data.userVote
	end

	if data.can_vote ~= nil then
		v2.can_vote = data.can_vote
	end

	if data.canVote ~= nil then
		v2.can_vote = data.canVote
	end

	if data.reason_for_not_voteable ~= nil then
		v2.reason_for_not_voteable = data.reason_for_not_voteable
	end

	if data.reasonForNotVoteable ~= nil then
		v2.reason_for_not_voteable = data.reasonForNotVoteable
	end

	return v2
end

class.descriptor = {
	name = "UniverseUserVoteData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteData"
}

v.UniverseUserVoteData = class

typeRegistry.default:register(v.UniverseUserVoteData)

return { UniverseUserVoteData = v.UniverseUserVoteData }
