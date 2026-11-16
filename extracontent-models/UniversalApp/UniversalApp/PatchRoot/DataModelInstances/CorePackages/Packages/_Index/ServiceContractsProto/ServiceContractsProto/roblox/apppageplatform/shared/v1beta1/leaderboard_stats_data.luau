local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		id = (data == nil or data.id == nil) and "" or data.id,
		rank = 0,
		score = 0
	}
	local rank

	if not (data == nil or data.rank == nil) then
		rank = data.rank
	end

	v2.rank = rank
	v2.score = (data == nil or data.score == nil) and 0 or data.score
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil and data.id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.id)
	end

	if data.rank ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.rank)
	end

	if data.score ~= nil and data.score ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.score)
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
			if v3 == 2 then
				local rank
				rank, v2 = proto.readVarIntI64(buf, v2)
				result.rank = rank
			elseif v3 == 3 then
				local score
				score, v2 = proto.readVarIntI64(buf, v2)
				result.score = score
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.id = buffer.tostring(v5)
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

	if data.id ~= nil and data.id ~= "" then
		v2.id = data.id
	end

	if data.rank ~= nil then
		v2.rank = data.rank
	end

	if data.score ~= nil and data.score ~= 0 then
		v2.score = data.score
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.rank ~= nil then
		v2.rank = data.rank
	end

	if data.score ~= nil then
		v2.score = data.score
	end

	return v2
end

class.descriptor = {
	name = "LeaderboardStatsData",
	fullName = "roblox.apppageplatform.shared.v1beta1.LeaderboardStatsData"
}

v.LeaderboardStatsData = class

typeRegistry.default:register(v.LeaderboardStatsData)

return { LeaderboardStatsData = v.LeaderboardStatsData }
