local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local ui_component_schema = require(script.Parent.ui_component_schema)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 43
	-- upvalues: t2 (copy)
	return (setmetatable({
		template = if t3 ~= nil and t3.template ~= nil then t3.template else nil,
		roblox_component = if t3 ~= nil and t3.roblox_component ~= nil then t3.roblox_component else ""
	}, t2))
end
function t2.encode(p1) -- line: 50
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.template ~= nil then
		local v10 = p1.template:encode()
		local v11, v12 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v11, v12, v10, buffer.len(v10))
	end

	if p1.roblox_component ~= nil and p1.roblox_component ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.roblox_component)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 70
	-- upvalues: t2 (copy), proto (copy), ui_component_schema (copy)
	local v17 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v19, v20

		v19, v20, n2 = proto.readTag(p2, n2)

		if v20 == proto.wireTypes.varint then
			local v21

			v21, n2 = proto.readVarInt(p2, n2)
		elseif v20 == proto.wireTypes.lengthDelimited then
			if v19 == 1 then
				local v22

				v22, n2 = proto.readBuffer(p2, n2)
				v17.template = ui_component_schema.UiComponentSchema.decode(v22)
			elseif v19 == 2 then
				local v23

				v23, n2 = proto.readBuffer(p2, n2)
				v17.roblox_component = buffer.tostring(v23)
			else
				local v24, v25 = proto.readVarInt(p2, n2)

				n2 = v25 + v24
			end
		elseif v20 == proto.wireTypes.i32 then
			local v26

			v26, n2 = proto.readFixed32(p2, n2)
		elseif v20 == proto.wireTypes.i64 then
			local v27

			v27, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v20)
		end
	end

	return v17
end
function t2.jsonEncode(p3) -- line: 119
	local t4 = {}

	if p3.template ~= nil then
		t4.template = p3.template:jsonEncode()
	end

	if p3.roblox_component ~= nil and p3.roblox_component ~= "" then
		t4.robloxComponent = p3.roblox_component
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 133
	-- upvalues: t2 (copy), ui_component_schema (copy)
	local v31 = t2.new()

	if t5.template ~= nil then
		v31.template = ui_component_schema.UiComponentSchema.jsonDecode(t5.template)
	end

	if t5.roblox_component ~= nil then
		v31.roblox_component = t5.roblox_component
	end

	if t5.robloxComponent ~= nil then
		v31.roblox_component = t5.robloxComponent
	end

	return v31
end

t2.descriptor = {
	name = "TemplateEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.TemplateEntry"
}
t1.TemplateEntry = t2
typeRegistry.default:register(t1.TemplateEntry)

return {
	TemplateEntry = t1.TemplateEntry
}
