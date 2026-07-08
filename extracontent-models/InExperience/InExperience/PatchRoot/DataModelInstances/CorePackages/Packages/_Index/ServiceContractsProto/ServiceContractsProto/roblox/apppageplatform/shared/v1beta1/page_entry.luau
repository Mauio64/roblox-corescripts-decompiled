local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local surfacing = require(script.Parent.surfacing)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 49
	-- upvalues: t2 (copy)
	return (setmetatable({
		roblox_component = if t3 ~= nil and t3.roblox_component ~= nil then t3.roblox_component else "",
		identifier = if t3 ~= nil and t3.identifier ~= nil then t3.identifier else "",
		title = if t3 ~= nil and t3.title ~= nil then t3.title else "",
		category = if t3 ~= nil and t3.category ~= nil then t3.category else "",
		surfacing = if t3 ~= nil and t3.surfacing ~= nil then t3.surfacing else nil
	}, t2))
end
function t2.encode(p1) -- line: 59
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.roblox_component ~= nil and p1.roblox_component ~= "" then
		local v10, v11 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v10, v11, p1.roblox_component)
	end

	if p1.identifier ~= nil and p1.identifier ~= "" then
		local v12, v13 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v12, v13, p1.identifier)
	end

	if p1.title ~= nil and p1.title ~= "" then
		local v14, v15 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v14, v15, p1.title)
	end

	if p1.category ~= nil and p1.category ~= "" then
		local v16, v17 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v16, v17, p1.category)
	end

	if p1.surfacing ~= nil then
		local v18 = p1.surfacing:encode()
		local v19, v20 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v19, v20, v18, buffer.len(v18))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 94
	-- upvalues: t2 (copy), proto (copy), surfacing (copy)
	local v23 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v25, v26

		v25, v26, n2 = proto.readTag(p2, n2)

		if v26 == proto.wireTypes.varint then
			local v27

			v27, n2 = proto.readVarInt(p2, n2)
		elseif v26 == proto.wireTypes.lengthDelimited then
			if v25 == 1 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v23.roblox_component = buffer.tostring(v28)
			elseif v25 == 2 then
				local v29

				v29, n2 = proto.readBuffer(p2, n2)
				v23.identifier = buffer.tostring(v29)
			elseif v25 == 3 then
				local v30

				v30, n2 = proto.readBuffer(p2, n2)
				v23.title = buffer.tostring(v30)
			elseif v25 == 4 then
				local v31

				v31, n2 = proto.readBuffer(p2, n2)
				v23.category = buffer.tostring(v31)
			elseif v25 == 5 then
				local v32

				v32, n2 = proto.readBuffer(p2, n2)
				v23.surfacing = surfacing.Surfacing.decode(v32)
			else
				local v33, v34 = proto.readVarInt(p2, n2)

				n2 = v34 + v33
			end
		elseif v26 == proto.wireTypes.i32 then
			local v35

			v35, n2 = proto.readFixed32(p2, n2)
		elseif v26 == proto.wireTypes.i64 then
			local v36

			v36, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v26)
		end
	end

	return v23
end
function t2.jsonEncode(p3) -- line: 157
	local t4 = {}

	if p3.roblox_component ~= nil and p3.roblox_component ~= "" then
		t4.robloxComponent = p3.roblox_component
	end

	if p3.identifier ~= nil and p3.identifier ~= "" then
		t4.identifier = p3.identifier
	end

	if p3.title ~= nil and p3.title ~= "" then
		t4.title = p3.title
	end

	if p3.category ~= nil and p3.category ~= "" then
		t4.category = p3.category
	end

	if p3.surfacing ~= nil then
		t4.surfacing = p3.surfacing:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 183
	-- upvalues: t2 (copy), surfacing (copy)
	local v40 = t2.new()

	if t5.roblox_component ~= nil then
		v40.roblox_component = t5.roblox_component
	end

	if t5.robloxComponent ~= nil then
		v40.roblox_component = t5.robloxComponent
	end

	if t5.identifier ~= nil then
		v40.identifier = t5.identifier
	end

	if t5.title ~= nil then
		v40.title = t5.title
	end

	if t5.category ~= nil then
		v40.category = t5.category
	end

	if t5.surfacing ~= nil then
		v40.surfacing = surfacing.Surfacing.jsonDecode(t5.surfacing)
	end

	return v40
end

t2.descriptor = {
	name = "PageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntry"
}
t1.PageEntry = t2
typeRegistry.default:register(t1.PageEntry)

return {
	PageEntry = t1.PageEntry
}
