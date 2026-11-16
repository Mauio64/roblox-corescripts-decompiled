local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local v2 = {
		is_favorited = p ~= nil and p.is_favorited ~= nil and p.is_favorited
	}
	return (setmetatable(v2, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.is_favorited then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.is_favorited and 1 or 0)
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
				result.is_favorited = v5 ~= 0
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

function class.jsonEncode(p)
	local v2 = {}

	if p.is_favorited then
		v2.isFavorited = p.is_favorited
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.is_favorited ~= nil then
		v2.is_favorited = p.is_favorited
	end

	if p.isFavorited ~= nil then
		v2.is_favorited = p.isFavorited
	end

	return v2
end

class.descriptor = {
	name = "UniverseUserFavoriteData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFavoriteData"
}

v.UniverseUserFavoriteData = class

typeRegistry.default:register(v.UniverseUserFavoriteData)

return { UniverseUserFavoriteData = v.UniverseUserFavoriteData }
