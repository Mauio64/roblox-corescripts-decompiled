local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local struct = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.struct)

local class = {}
class.__index = class

function class.new(data)
	local saved

	if not (data == nil or data.saved == nil) then
		saved = data.saved
	end

	local catalogs

	if not (data == nil or data.catalogs == nil) then
		catalogs = data.catalogs
	end

	local capabilities

	if not (data == nil or data.capabilities == nil) then
		capabilities = data.capabilities
	end

	return (setmetatable({ saved = saved, catalogs = catalogs, capabilities = capabilities }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.saved ~= nil then
		local encoded = self.saved:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.catalogs ~= nil then
		local encoded = self.catalogs:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.capabilities ~= nil then
		local encoded = self.capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.saved = struct.Struct.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.catalogs = struct.Struct.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.capabilities = struct.Struct.decode(v5)
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

function class:jsonEncode()
	local v2 = {}

	if self.saved ~= nil then
		v2.saved = self.saved:jsonEncode()
	end

	if self.catalogs ~= nil then
		v2.catalogs = self.catalogs:jsonEncode()
	end

	if self.capabilities ~= nil then
		v2.capabilities = self.capabilities:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.saved ~= nil then
		v2.saved = struct.Struct.jsonDecode(data.saved)
	end

	if data.catalogs ~= nil then
		v2.catalogs = struct.Struct.jsonDecode(data.catalogs)
	end

	if data.capabilities ~= nil then
		v2.capabilities = struct.Struct.jsonDecode(data.capabilities)
	end

	return v2
end

class.descriptor = {
	name = "ConfigDrivenFormInputData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConfigDrivenFormInputData"
}

v.ConfigDrivenFormInputData = class

typeRegistry.default:register(v.ConfigDrivenFormInputData)

return { ConfigDrivenFormInputData = v.ConfigDrivenFormInputData }
