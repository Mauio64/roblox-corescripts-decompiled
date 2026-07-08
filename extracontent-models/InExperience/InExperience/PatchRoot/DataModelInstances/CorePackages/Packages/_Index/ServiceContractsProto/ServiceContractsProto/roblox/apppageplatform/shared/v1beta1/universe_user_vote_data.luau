local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 46
	-- upvalues: t2 (copy)
	return (setmetatable({
		user_vote = if t3 ~= nil and t3.user_vote ~= nil then t3.user_vote else nil,
		can_vote = t3 ~= nil and (t3.can_vote ~= nil and t3.can_vote),
		reason_for_not_voteable = if t3 ~= nil and t3.reason_for_not_voteable ~= nil then t3.reason_for_not_voteable else ""
	}, t2))
end
function t2.encode(p1) -- line: 56
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.user_vote ~= nil then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, not p1.user_vote and 0 or 1)
	end

	if p1.can_vote then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, not p1.can_vote and 0 or 1)
	end

	if p1.reason_for_not_voteable ~= nil and p1.reason_for_not_voteable ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.reason_for_not_voteable)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 80
	-- upvalues: t2 (copy), proto (copy)
	local v17 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v19, v20

		v19, v20, n2 = proto.readTag(p2, n2)

		if v20 == proto.wireTypes.varint then
			if v19 == 1 then
				local v21

				v21, n2 = proto.readVarInt(p2, n2)
				v17.user_vote = v21 ~= 0
			elseif v19 == 2 then
				local v22

				v22, n2 = proto.readVarInt(p2, n2)
				v17.can_vote = v22 ~= 0
			else
				local v23

				v23, n2 = proto.readVarInt(p2, n2)
			end
		elseif v20 == proto.wireTypes.lengthDelimited then
			if v19 == 3 then
				local v24

				v24, n2 = proto.readBuffer(p2, n2)
				v17.reason_for_not_voteable = buffer.tostring(v24)
			else
				local v25, v26 = proto.readVarInt(p2, n2)

				n2 = v26 + v25
			end
		elseif v20 == proto.wireTypes.i32 then
			local v27

			v27, n2 = proto.readFixed32(p2, n2)
		elseif v20 == proto.wireTypes.i64 then
			local v28

			v28, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v20)
		end
	end

	return v17
end
function t2.jsonEncode(p3) -- line: 133
	local t4 = {}

	if p3.user_vote ~= nil then
		t4.userVote = p3.user_vote
	end

	if p3.can_vote then
		t4.canVote = p3.can_vote
	end

	if p3.reason_for_not_voteable ~= nil and p3.reason_for_not_voteable ~= "" then
		t4.reasonForNotVoteable = p3.reason_for_not_voteable
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 151
	-- upvalues: t2 (copy)
	local v32 = t2.new()

	if t5.user_vote ~= nil then
		v32.user_vote = t5.user_vote
	end

	if t5.userVote ~= nil then
		v32.user_vote = t5.userVote
	end

	if t5.can_vote ~= nil then
		v32.can_vote = t5.can_vote
	end

	if t5.canVote ~= nil then
		v32.can_vote = t5.canVote
	end

	if t5.reason_for_not_voteable ~= nil then
		v32.reason_for_not_voteable = t5.reason_for_not_voteable
	end

	if t5.reasonForNotVoteable ~= nil then
		v32.reason_for_not_voteable = t5.reasonForNotVoteable
	end

	return v32
end

t2.descriptor = {
	name = "UniverseUserVoteData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteData"
}
t1.UniverseUserVoteData = t2
typeRegistry.default:register(t1.UniverseUserVoteData)

return {
	UniverseUserVoteData = t1.UniverseUserVoteData
}
