local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 42
	-- upvalues: t2 (copy)
	return (setmetatable({
		is_favorited = t3 ~= nil and (t3.is_favorited ~= nil and t3.is_favorited)
	}, t2))
end
function t2.encode(p1) -- line: 48
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.is_favorited then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, not p1.is_favorited and 0 or 1)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 62
	-- upvalues: t2 (copy), proto (copy)
	local v13 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v15, v16

		v15, v16, n2 = proto.readTag(p2, n2)

		if v16 == proto.wireTypes.varint then
			if v15 == 1 then
				local v17

				v17, n2 = proto.readVarInt(p2, n2)
				v13.is_favorited = v17 ~= 0
			else
				local v18

				v18, n2 = proto.readVarInt(p2, n2)
			end
		elseif v16 == proto.wireTypes.lengthDelimited then
			local v19, v20 = proto.readVarInt(p2, n2)

			n2 = v20 + v19
		elseif v16 == proto.wireTypes.i32 then
			local v21

			v21, n2 = proto.readFixed32(p2, n2)
		elseif v16 == proto.wireTypes.i64 then
			local v22

			v22, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v16)
		end
	end

	return v13
end
function t2.jsonEncode(p3) -- line: 105
	local t4 = {}

	if p3.is_favorited then
		t4.isFavorited = p3.is_favorited
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 115
	-- upvalues: t2 (copy)
	local v26 = t2.new()

	if t5.is_favorited ~= nil then
		v26.is_favorited = t5.is_favorited
	end

	if t5.isFavorited ~= nil then
		v26.is_favorited = t5.isFavorited
	end

	return v26
end

t2.descriptor = {
	name = "UniverseUserFavoriteData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFavoriteData"
}
t1.UniverseUserFavoriteData = t2
typeRegistry.default:register(t1.UniverseUserFavoriteData)

return {
	UniverseUserFavoriteData = t1.UniverseUserFavoriteData
}
