local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil then
		if self.kind.type == "peek_view" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.kind.type == "full_page" then
			local encoded = self.kind.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
				result.kind = { type = "peek_view", value = v.PeekView.decode(v5) }
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = { type = "full_page", value = v.FullPage.decode(v5) }
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

	if self.kind == nil then
		return v2
	end

	if self.kind.type == "peek_view" then
		v2.peekView = self.kind.value:jsonEncode()
		return v2
	end

	if self.kind.type == "full_page" then
		v2.fullPage = self.kind.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.peek_view ~= nil then
		v2.kind = {
			type = "peek_view",
			value = v.PeekView.jsonDecode(data.peek_view)
		}
	end

	if data.peekView ~= nil then
		v2.kind = {
			type = "peek_view",
			value = v.PeekView.jsonDecode(data.peekView)
		}
	end

	if data.full_page ~= nil then
		v2.kind = {
			type = "full_page",
			value = v.FullPage.jsonDecode(data.full_page)
		}
	end

	if data.fullPage ~= nil then
		v2.kind = {
			type = "full_page",
			value = v.FullPage.jsonDecode(data.fullPage)
		}
	end

	return v2
end

class.descriptor = {
	name = "Surfacing",
	fullName = "roblox.apppageplatform.shared.v1beta1.Surfacing"
}

v.Surfacing = class

typeRegistry.default:register(v.Surfacing)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local height_offset

	if not (p == nil or p.height_offset == nil) then
		height_offset = p.height_offset
	end

	return (setmetatable({ height_offset = height_offset }, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.height_offset ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.height_offset)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local height_offset
				height_offset, v2 = proto.readVarIntI32(buf, v2)
				result.height_offset = height_offset
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

function class2:jsonEncode()
	local v2 = {}

	if self.height_offset ~= nil then
		v2.heightOffset = self.height_offset
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.height_offset ~= nil then
		v2.height_offset = p.height_offset
	end

	if p.heightOffset ~= nil then
		v2.height_offset = p.heightOffset
	end

	return v2
end

class2.descriptor = {
	name = "PeekView",
	fullName = "roblox.apppageplatform.shared.v1beta1.PeekView"
}

v.PeekView = class2

typeRegistry.default:register(v.PeekView)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local content_top_padding

	if not (p == nil or p.content_top_padding == nil) then
		content_top_padding = p.content_top_padding
	end

	return (setmetatable({ content_top_padding = content_top_padding }, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.content_top_padding ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.content_top_padding)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local content_top_padding
				content_top_padding, v2 = proto.readVarIntI32(buf, v2)
				result.content_top_padding = content_top_padding
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
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

function class3:jsonEncode()
	local v2 = {}

	if self.content_top_padding ~= nil then
		v2.contentTopPadding = self.content_top_padding
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.content_top_padding ~= nil then
		v2.content_top_padding = p.content_top_padding
	end

	if p.contentTopPadding ~= nil then
		v2.content_top_padding = p.contentTopPadding
	end

	return v2
end

class3.descriptor = {
	name = "FullPage",
	fullName = "roblox.apppageplatform.shared.v1beta1.FullPage"
}

v.FullPage = class3

typeRegistry.default:register(v.FullPage)

return { Surfacing = v.Surfacing, PeekView = v.PeekView, FullPage = v.FullPage }
