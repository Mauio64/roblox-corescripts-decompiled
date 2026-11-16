local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local surfacing = require(script.Parent.surfacing)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		roblox_component = (data == nil or data.roblox_component == nil) and "" or data.roblox_component,
		identifier = (data == nil or data.identifier == nil) and "" or data.identifier,
		title = (data == nil or data.title == nil) and "" or data.title,
		category = (data == nil or data.category == nil) and "" or data.category,
		surfacing = 0
	}
	local surfacing2

	if not (data == nil or data.surfacing == nil) then
		surfacing2 = data.surfacing
	end

	v2.surfacing = surfacing2
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.roblox_component ~= nil and self.roblox_component ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.roblox_component)
	end

	if self.identifier ~= nil and self.identifier ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.identifier)
	end

	if self.title ~= nil and self.title ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.title)
	end

	if self.category ~= nil and self.category ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.category)
	end

	if self.surfacing ~= nil then
		local encoded = self.surfacing:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
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
				result.roblox_component = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.identifier = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.title = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.category = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.surfacing = surfacing.Surfacing.decode(v5)
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

	if self.roblox_component ~= nil and self.roblox_component ~= "" then
		v2.robloxComponent = self.roblox_component
	end

	if self.identifier ~= nil and self.identifier ~= "" then
		v2.identifier = self.identifier
	end

	if self.title ~= nil and self.title ~= "" then
		v2.title = self.title
	end

	if self.category ~= nil and self.category ~= "" then
		v2.category = self.category
	end

	if self.surfacing ~= nil then
		v2.surfacing = self.surfacing:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.roblox_component ~= nil then
		v2.roblox_component = data.roblox_component
	end

	if data.robloxComponent ~= nil then
		v2.roblox_component = data.robloxComponent
	end

	if data.identifier ~= nil then
		v2.identifier = data.identifier
	end

	if data.title ~= nil then
		v2.title = data.title
	end

	if data.category ~= nil then
		v2.category = data.category
	end

	if data.surfacing ~= nil then
		v2.surfacing = surfacing.Surfacing.jsonDecode(data.surfacing)
	end

	return v2
end

class.descriptor = {
	name = "PageEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.PageEntry"
}

v.PageEntry = class

typeRegistry.default:register(v.PageEntry)

return { PageEntry = v.PageEntry }
