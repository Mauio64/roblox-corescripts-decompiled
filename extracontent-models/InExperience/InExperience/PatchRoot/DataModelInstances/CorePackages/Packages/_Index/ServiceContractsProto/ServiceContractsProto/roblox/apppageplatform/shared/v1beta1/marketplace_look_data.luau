local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 39
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else ""
	}, t2))
end
function t2.encode(p1) -- line: 45
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v9, v10, p1.id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 59
	-- upvalues: t2 (copy), proto (copy)
	local v13 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v15, v16

		v15, v16, n2 = proto.readTag(p2, n2)

		if v16 == proto.wireTypes.varint then
			local v17

			v17, n2 = proto.readVarInt(p2, n2)
		elseif v16 == proto.wireTypes.lengthDelimited then
			if v15 == 1 then
				local v18

				v18, n2 = proto.readBuffer(p2, n2)
				v13.id = buffer.tostring(v18)
			else
				local v19, v20 = proto.readVarInt(p2, n2)

				n2 = v20 + v19
			end
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
function t2.jsonEncode(p3) -- line: 102
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 112
	-- upvalues: t2 (copy)
	local v26 = t2.new()

	if t5.id ~= nil then
		v26.id = t5.id
	end

	return v26
end

t2.descriptor = {
	name = "MarketplaceLookData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceLookData"
}
t1.MarketplaceLookData = t2
typeRegistry.default:register(t1.MarketplaceLookData)

return {
	MarketplaceLookData = t1.MarketplaceLookData
}
