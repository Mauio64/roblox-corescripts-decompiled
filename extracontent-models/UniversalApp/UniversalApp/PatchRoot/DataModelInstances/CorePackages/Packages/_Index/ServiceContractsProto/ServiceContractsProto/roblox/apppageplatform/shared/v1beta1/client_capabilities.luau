local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local capability = require(script.Parent.capability)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 43
	-- upvalues: t2 (copy)
	return (setmetatable({
		enabled_capabilities = if t3 ~= nil and t3.enabled_capabilities ~= nil then t3.enabled_capabilities else {},
		proto_version = if t3 ~= nil and t3.proto_version ~= nil then t3.proto_version else ""
	}, t2))
end
function t2.encode(p1) -- line: 52
	-- upvalues: proto (copy), capability (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.enabled_capabilities ~= nil and #p1.enabled_capabilities > 0 then
		for _, v11 in p1.enabled_capabilities do
			local v12, v13 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

			buf, n1 = proto.writeVarInt(v12, v13, capability.Capability.toNumber(v11))
		end
	end

	if p1.proto_version ~= nil and p1.proto_version ~= "" then
		local v14, v15 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v14, v15, p1.proto_version)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 77
	-- upvalues: t2 (copy), proto (copy), capability (copy)
	local v18 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v20, v21

		v20, v21, n2 = proto.readTag(p2, n2)

		if v21 == proto.wireTypes.varint then
			if v20 == 1 then
				local v22

				v22, n2 = proto.readVarIntI32(p2, n2)
				table.insert(v18.enabled_capabilities, capability.Capability.fromNumber(v22) or v22)
			else
				local v23

				v23, n2 = proto.readVarInt(p2, n2)
			end
		elseif v21 == proto.wireTypes.lengthDelimited then
			if v20 == 2 then
				local v24

				v24, n2 = proto.readBuffer(p2, n2)
				v18.proto_version = buffer.tostring(v24)
			else
				local v25, v26 = proto.readVarInt(p2, n2)

				n2 = v26 + v25
			end
		elseif v21 == proto.wireTypes.i32 then
			local v27

			v27, n2 = proto.readFixed32(p2, n2)
		elseif v21 == proto.wireTypes.i64 then
			local v28

			v28, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v21)
		end
	end

	return v18
end
function t2.jsonEncode(p3) -- line: 128
	-- upvalues: capability (copy)
	local t4 = {}

	if p3.enabled_capabilities ~= nil and #p3.enabled_capabilities > 0 then
		local t5 = {}

		for _, v33 in p3.enabled_capabilities do
			table.insert(t5, if typeof(v33) ~= "number" then capability.Capability.toNumber(v33) else v33)
		end

		t4.enabledCapabilities = t5
	end

	if p3.proto_version ~= nil and p3.proto_version ~= "" then
		t4.protoVersion = p3.proto_version
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 151
	-- upvalues: t2 (copy), capability (copy)
	local v35 = t2.new()

	if t6.enabled_capabilities ~= nil then
		local t7 = {}

		for _, v38 in t6.enabled_capabilities do
			table.insert(t7, if typeof(v38) ~= "number" then capability.Capability.fromName(v38) or v38 else capability.Capability.fromNumber(v38) or v38)
		end

		v35.enabled_capabilities = t7
	end

	if t6.enabledCapabilities ~= nil then
		local t8 = {}

		for _, v41 in t6.enabledCapabilities do
			table.insert(t8, if typeof(v41) ~= "number" then capability.Capability.fromName(v41) or v41 else capability.Capability.fromNumber(v41) or v41)
		end

		v35.enabled_capabilities = t8
	end

	if t6.proto_version ~= nil then
		v35.proto_version = t6.proto_version
	end

	if t6.protoVersion ~= nil then
		v35.proto_version = t6.protoVersion
	end

	return v35
end

t2.descriptor = {
	name = "ClientCapabilities",
	fullName = "roblox.apppageplatform.shared.v1beta1.ClientCapabilities"
}
t1.ClientCapabilities = t2
typeRegistry.default:register(t1.ClientCapabilities)

return {
	ClientCapabilities = t1.ClientCapabilities
}
