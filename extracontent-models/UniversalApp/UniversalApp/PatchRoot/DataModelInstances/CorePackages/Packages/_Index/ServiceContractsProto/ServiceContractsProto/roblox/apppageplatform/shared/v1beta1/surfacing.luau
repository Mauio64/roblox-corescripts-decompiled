local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 61
	-- upvalues: t2 (copy)
	return (setmetatable({
		kind = if t3 ~= nil and t3.kind ~= nil then t3.kind else nil
	}, t2))
end
function t2.encode(p1) -- line: 67
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.kind ~= nil and p1.kind.type == "peek_view" then
		local v10 = p1.kind.value:encode()
		local v11, v12 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v11, v12, v10, buffer.len(v10))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 84
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v15 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v17, v18

		v17, v18, n2 = proto.readTag(p2, n2)

		if v18 == proto.wireTypes.varint then
			local v19

			v19, n2 = proto.readVarInt(p2, n2)
		elseif v18 == proto.wireTypes.lengthDelimited then
			if v17 == 1 then
				local v20

				v20, n2 = proto.readBuffer(p2, n2)
				v15.kind = {
					type = "peek_view",
					value = t1.PeekView.decode(v20)
				}
			else
				local v21, v22 = proto.readVarInt(p2, n2)

				n2 = v22 + v21
			end
		elseif v18 == proto.wireTypes.i32 then
			local v23

			v23, n2 = proto.readFixed32(p2, n2)
		elseif v18 == proto.wireTypes.i64 then
			local v24

			v24, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v18)
		end
	end

	return v15
end
function t2.jsonEncode(p3) -- line: 127
	local t4 = {}

	if p3.kind ~= nil and p3.kind.type == "peek_view" then
		t4.peekView = p3.kind.value:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 139
	-- upvalues: t2 (copy), t1 (copy)
	local v28 = t2.new()

	if t5.peek_view ~= nil then
		v28.kind = {
			type = "peek_view",
			value = t1.PeekView.jsonDecode(t5.peek_view)
		}
	end

	if t5.peekView ~= nil then
		v28.kind = {
			type = "peek_view",
			value = t1.PeekView.jsonDecode(t5.peekView)
		}
	end

	return v28
end

t2.descriptor = {
	name = "Surfacing",
	fullName = "roblox.apppageplatform.shared.v1beta1.Surfacing"
}
t1.Surfacing = t2
typeRegistry.default:register(t1.Surfacing)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 167
	-- upvalues: t6 (copy)
	return (setmetatable({
		height_offset = if t7 ~= nil and t7.height_offset ~= nil then t7.height_offset else nil
	}, t6))
end
function t6.encode(p4) -- line: 173
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.height_offset ~= nil then
		local v33, v34 = proto.writeTag(buf, n3, 1, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v33, v34, p4.height_offset)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 187
	-- upvalues: t6 (copy), proto (copy)
	local v37 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v39, v40

		v39, v40, n4 = proto.readTag(p5, n4)

		if v40 == proto.wireTypes.varint then
			if v39 == 1 then
				local v41

				v41, n4 = proto.readVarIntI32(p5, n4)
				v37.height_offset = v41
			else
				local v42

				v42, n4 = proto.readVarInt(p5, n4)
			end
		elseif v40 == proto.wireTypes.lengthDelimited then
			local v43, v44 = proto.readVarInt(p5, n4)

			n4 = v44 + v43
		elseif v40 == proto.wireTypes.i32 then
			local v45

			v45, n4 = proto.readFixed32(p5, n4)
		elseif v40 == proto.wireTypes.i64 then
			local v46

			v46, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v40)
		end
	end

	return v37
end
function t6.jsonEncode(p6) -- line: 230
	local t8 = {}

	if p6.height_offset ~= nil then
		t8.heightOffset = p6.height_offset
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 240
	-- upvalues: t6 (copy)
	local v50 = t6.new()

	if t9.height_offset ~= nil then
		v50.height_offset = t9.height_offset
	end

	if t9.heightOffset ~= nil then
		v50.height_offset = t9.heightOffset
	end

	return v50
end

t6.descriptor = {
	name = "PeekView",
	fullName = "roblox.apppageplatform.shared.v1beta1.PeekView"
}
t1.PeekView = t6
typeRegistry.default:register(t1.PeekView)

return {
	Surfacing = t1.Surfacing,
	PeekView = t1.PeekView
}
