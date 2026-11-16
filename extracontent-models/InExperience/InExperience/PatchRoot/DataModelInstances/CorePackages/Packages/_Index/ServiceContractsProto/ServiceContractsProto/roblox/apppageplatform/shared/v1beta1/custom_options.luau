local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		name = (p == nil or p.name == nil) and "" or p.name,
		description = (p == nil or p.description == nil) and "" or p.description
	}, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.name ~= nil and p.name ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.name)
	end

	if p.description ~= nil and p.description ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.description)
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
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

	if p.name ~= nil and p.name ~= "" then
		v2.name = p.name
	end

	if p.description ~= nil and p.description ~= "" then
		v2.description = p.description
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.name ~= nil then
		v2.name = p.name
	end

	if p.description ~= nil then
		v2.description = p.description
	end

	return v2
end

class.descriptor = {
	name = "ClientSideHydrationField",
	fullName = "roblox.apppageplatform.shared.v1beta1.ClientSideHydrationField"
}

v.ClientSideHydrationField = class

typeRegistry.default:register(v.ClientSideHydrationField)

return { ClientSideHydrationField = v.ClientSideHydrationField }
