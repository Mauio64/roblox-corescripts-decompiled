local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local ui_component_schema = require(script.Parent.ui_component_schema)

local class = {}
class.__index = class

function class.new(p)
	local template

	if not (p == nil or p.template == nil) then
		template = p.template
	end

	local v2 = {
		template = template,
		roblox_component = (p == nil or p.roblox_component == nil) and "" or p.roblox_component
	}
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.template ~= nil then
		local encoded = self.template:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.roblox_component ~= nil and self.roblox_component ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.roblox_component)
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
				result.template = ui_component_schema.UiComponentSchema.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.roblox_component = buffer.tostring(v5)
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

	if self.template ~= nil then
		v2.template = self.template:jsonEncode()
	end

	if self.roblox_component ~= nil and self.roblox_component ~= "" then
		v2.robloxComponent = self.roblox_component
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.template ~= nil then
		v2.template = ui_component_schema.UiComponentSchema.jsonDecode(data.template)
	end

	if data.roblox_component ~= nil then
		v2.roblox_component = data.roblox_component
	end

	if data.robloxComponent ~= nil then
		v2.roblox_component = data.robloxComponent
	end

	return v2
end

class.descriptor = {
	name = "TemplateEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.TemplateEntry"
}

v.TemplateEntry = class

typeRegistry.default:register(v.TemplateEntry)

return { TemplateEntry = v.TemplateEntry }
