local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		total_up_votes = (data == nil or data.total_up_votes == nil) and 0 or data.total_up_votes,
		total_down_votes = (data == nil or data.total_down_votes == nil) and 0 or data.total_down_votes,
		user_vote = 0
	}
	local user_vote

	if not (data == nil or data.user_vote == nil) then
		user_vote = data.user_vote
	end

	v2.user_vote = user_vote
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.total_up_votes ~= nil and data.total_up_votes ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.total_up_votes)
	end

	if data.total_down_votes ~= nil and data.total_down_votes ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.total_down_votes)
	end

	if data.user_vote ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.user_vote and 1 or 0)
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
				local total_up_votes
				total_up_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_up_votes = total_up_votes
			elseif v3 == 2 then
				local total_down_votes
				total_down_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_down_votes = total_down_votes
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.user_vote = v5 ~= 0
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

function class.jsonEncode(data)
	local v2 = {}

	if data.total_up_votes ~= nil and data.total_up_votes ~= 0 then
		v2.totalUpVotes = data.total_up_votes
	end

	if data.total_down_votes ~= nil and data.total_down_votes ~= 0 then
		v2.totalDownVotes = data.total_down_votes
	end

	if data.user_vote ~= nil then
		v2.userVote = data.user_vote
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.total_up_votes ~= nil then
		v2.total_up_votes = data.total_up_votes
	end

	if data.totalUpVotes ~= nil then
		v2.total_up_votes = data.totalUpVotes
	end

	if data.total_down_votes ~= nil then
		v2.total_down_votes = data.total_down_votes
	end

	if data.totalDownVotes ~= nil then
		v2.total_down_votes = data.totalDownVotes
	end

	if data.user_vote ~= nil then
		v2.user_vote = data.user_vote
	end

	if data.userVote ~= nil then
		v2.user_vote = data.userVote
	end

	return v2
end

class.descriptor = {
	name = "VoteData",
	fullName = "roblox.apppageplatform.shared.v1beta1.VoteData"
}

v.VoteData = class

typeRegistry.default:register(v.VoteData)

return { VoteData = v.VoteData }
