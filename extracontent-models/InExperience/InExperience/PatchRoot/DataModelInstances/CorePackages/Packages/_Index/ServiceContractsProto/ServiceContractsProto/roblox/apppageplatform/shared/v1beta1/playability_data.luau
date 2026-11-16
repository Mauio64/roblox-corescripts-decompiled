local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local v2 = {
		is_playable = p ~= nil and p.is_playable ~= nil and p.is_playable,
		playability_status = (p == nil or p.playability_status == nil) and "" or p.playability_status
	}
	return (setmetatable(v2, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.is_playable then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.is_playable and 1 or 0)
	end

	if p.playability_status ~= nil and p.playability_status ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.playability_status)
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
				result.is_playable = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.playability_status = buffer.tostring(v5)
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

function class.jsonEncode(p)
	local v2 = {}

	if p.is_playable then
		v2.isPlayable = p.is_playable
	end

	if p.playability_status ~= nil and p.playability_status ~= "" then
		v2.playabilityStatus = p.playability_status
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.is_playable ~= nil then
		v2.is_playable = data.is_playable
	end

	if data.isPlayable ~= nil then
		v2.is_playable = data.isPlayable
	end

	if data.playability_status ~= nil then
		v2.playability_status = data.playability_status
	end

	if data.playabilityStatus ~= nil then
		v2.playability_status = data.playabilityStatus
	end

	return v2
end

class.descriptor = {
	name = "PlayabilityData",
	fullName = "roblox.apppageplatform.shared.v1beta1.PlayabilityData"
}

v.PlayabilityData = class

typeRegistry.default:register(v.PlayabilityData)

return { PlayabilityData = v.PlayabilityData }
