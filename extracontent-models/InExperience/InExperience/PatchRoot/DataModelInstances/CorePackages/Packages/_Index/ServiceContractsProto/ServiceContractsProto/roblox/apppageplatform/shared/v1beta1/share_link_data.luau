local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local prop_types = require(script.Parent.prop_types)

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

	if self.kind ~= nil and self.kind.type == "literal" then
		local encoded = self.kind.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
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
				result.kind = {
					type = "literal",
					value = v.GenericShareLinkData_GenericShareLinkLiteralData.decode(v5)
				}
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

	if self.kind ~= nil and self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
	end

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.GenericShareLinkData_GenericShareLinkLiteralData.jsonDecode(p.literal)
		}
	end

	return v2
end

class.descriptor = {
	name = "GenericShareLinkData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GenericShareLinkData"
}

v.GenericShareLinkData = class

typeRegistry.default:register(v.GenericShareLinkData)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local url

	if not (p == nil or p.url == nil) then
		url = p.url
	end

	local share_url_context

	if not (p == nil or p.share_url_context == nil) then
		share_url_context = p.share_url_context
	end

	return (setmetatable({ url = url, share_url_context = share_url_context }, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.url ~= nil then
		local encoded = self.url:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.share_url_context ~= nil then
		local encoded = self.share_url_context:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.url = prop_types.StringProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.share_url_context = prop_types.StringProp.decode(v5)
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

function class2:jsonEncode()
	local v2 = {}

	if self.url ~= nil then
		v2.url = self.url:jsonEncode()
	end

	if self.share_url_context ~= nil then
		v2.shareUrlContext = self.share_url_context:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.url ~= nil then
		v2.url = prop_types.StringProp.jsonDecode(data.url)
	end

	if data.share_url_context ~= nil then
		v2.share_url_context = prop_types.StringProp.jsonDecode(data.share_url_context)
	end

	if data.shareUrlContext ~= nil then
		v2.share_url_context = prop_types.StringProp.jsonDecode(data.shareUrlContext)
	end

	return v2
end

class2.descriptor = {
	name = "GenericShareLinkData_GenericShareLinkLiteralData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GenericShareLinkLiteralData"
}

v.GenericShareLinkData_GenericShareLinkLiteralData = class2

typeRegistry.default:register(v.GenericShareLinkData_GenericShareLinkLiteralData)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil and self.kind.type == "literal" then
		local encoded = self.kind.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.kind = {
					type = "literal",
					value = v.ShareLinkFetchData_ShareLinkFetchLiteralData.decode(v5)
				}
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

function class3:jsonEncode()
	local v2 = {}

	if self.kind ~= nil and self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ShareLinkFetchData_ShareLinkFetchLiteralData.jsonDecode(p.literal)
		}
	end

	return v2
end

class3.descriptor = {
	name = "ShareLinkFetchData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ShareLinkFetchData"
}

v.ShareLinkFetchData = class3

typeRegistry.default:register(v.ShareLinkFetchData)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local share_url_context

	if not (data == nil or data.share_url_context == nil) then
		share_url_context = data.share_url_context
	end

	local link_type

	if not (data == nil or data.link_type == nil) then
		link_type = data.link_type
	end

	local link_data

	if not (data == nil or data.link_data == nil) then
		link_data = data.link_data
	end

	return (setmetatable(
		{ share_url_context = share_url_context, link_type = link_type, link_data = link_data },
		class4
	))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.share_url_context ~= nil then
		local encoded = self.share_url_context:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.link_type ~= nil then
		local encoded = self.link_type:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.link_data ~= nil then
		local encoded = self.link_data:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
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
				result.share_url_context = prop_types.StringProp.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.link_type = prop_types.StringProp.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.link_data = v.ShareLinkPayload.decode(v5)
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

function class4:jsonEncode()
	local v2 = {}

	if self.share_url_context ~= nil then
		v2.shareUrlContext = self.share_url_context:jsonEncode()
	end

	if self.link_type ~= nil then
		v2.linkType = self.link_type:jsonEncode()
	end

	if self.link_data ~= nil then
		v2.linkData = self.link_data:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.share_url_context ~= nil then
		v2.share_url_context = prop_types.StringProp.jsonDecode(data.share_url_context)
	end

	if data.shareUrlContext ~= nil then
		v2.share_url_context = prop_types.StringProp.jsonDecode(data.shareUrlContext)
	end

	if data.link_type ~= nil then
		v2.link_type = prop_types.StringProp.jsonDecode(data.link_type)
	end

	if data.linkType ~= nil then
		v2.link_type = prop_types.StringProp.jsonDecode(data.linkType)
	end

	if data.link_data ~= nil then
		v2.link_data = v.ShareLinkPayload.jsonDecode(data.link_data)
	end

	if data.linkData ~= nil then
		v2.link_data = v.ShareLinkPayload.jsonDecode(data.linkData)
	end

	return v2
end

class4.descriptor = {
	name = "ShareLinkFetchData_ShareLinkFetchLiteralData",
	fullName = "roblox.apppageplatform.shared.v1beta1.ShareLinkFetchLiteralData"
}

v.ShareLinkFetchData_ShareLinkFetchLiteralData = class4

typeRegistry.default:register(v.ShareLinkFetchData_ShareLinkFetchLiteralData)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local oneof_prop

	if not (p == nil or p.oneof_prop == nil) then
		oneof_prop = p.oneof_prop
	end

	return (setmetatable({ oneof_prop = oneof_prop }, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.oneof_prop ~= nil then
		if self.oneof_prop.type == "experience_share_link_payload" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.oneof_prop.type == "event_share_link_payload" then
			local encoded = self.oneof_prop.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
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
				result.oneof_prop = {
					type = "experience_share_link_payload",
					value = v.ExperienceShareLinkPayload.decode(v5)
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.oneof_prop = {
					type = "event_share_link_payload",
					value = v.EventShareLinkPayload.decode(v5)
				}
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

function class5:jsonEncode()
	local v2 = {}

	if self.oneof_prop == nil then
		return v2
	end

	if self.oneof_prop.type == "experience_share_link_payload" then
		v2.experienceShareLinkPayload = self.oneof_prop.value:jsonEncode()
		return v2
	end

	if self.oneof_prop.type == "event_share_link_payload" then
		v2.eventShareLinkPayload = self.oneof_prop.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.experience_share_link_payload ~= nil then
		v2.oneof_prop = {
			type = "experience_share_link_payload",
			value = v.ExperienceShareLinkPayload.jsonDecode(data.experience_share_link_payload)
		}
	end

	if data.experienceShareLinkPayload ~= nil then
		v2.oneof_prop = {
			type = "experience_share_link_payload",
			value = v.ExperienceShareLinkPayload.jsonDecode(data.experienceShareLinkPayload)
		}
	end

	if data.event_share_link_payload ~= nil then
		v2.oneof_prop = {
			type = "event_share_link_payload",
			value = v.EventShareLinkPayload.jsonDecode(data.event_share_link_payload)
		}
	end

	if data.eventShareLinkPayload ~= nil then
		v2.oneof_prop = {
			type = "event_share_link_payload",
			value = v.EventShareLinkPayload.jsonDecode(data.eventShareLinkPayload)
		}
	end

	return v2
end

class5.descriptor = {
	name = "ShareLinkPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.ShareLinkPayload"
}

v.ShareLinkPayload = class5

typeRegistry.default:register(v.ShareLinkPayload)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil and self.kind.type == "literal" then
		local encoded = self.kind.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
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
				result.kind = {
					type = "literal",
					value = v.ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload.decode(v5)
				}
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

function class6:jsonEncode()
	local v2 = {}

	if self.kind ~= nil and self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload.jsonDecode(p.literal)
		}
	end

	return v2
end

class6.descriptor = {
	name = "ExperienceShareLinkPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceShareLinkPayload"
}

v.ExperienceShareLinkPayload = class6

typeRegistry.default:register(v.ExperienceShareLinkPayload)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local universe_id

	if not (p == nil or p.universe_id == nil) then
		universe_id = p.universe_id
	end

	return (setmetatable({ universe_id = universe_id }, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.universe_id ~= nil then
		local encoded = self.universe_id:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local result = class7.new()
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
				result.universe_id = prop_types.StringProp.decode(v5)
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

function class7:jsonEncode()
	local v2 = {}

	if self.universe_id ~= nil then
		v2.universeId = self.universe_id:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.universe_id ~= nil then
		v2.universe_id = prop_types.StringProp.jsonDecode(p.universe_id)
	end

	if p.universeId ~= nil then
		v2.universe_id = prop_types.StringProp.jsonDecode(p.universeId)
	end

	return v2
end

class7.descriptor = {
	name = "ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.ExperienceShareLinkLiteralPayload"
}

v.ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload = class7

typeRegistry.default:register(v.ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload)

local class8 = {}
class8.__index = class8

function class8.new(p)
	local kind

	if not (p == nil or p.kind == nil) then
		kind = p.kind
	end

	return (setmetatable({ kind = kind }, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.kind ~= nil and self.kind.type == "literal" then
		local encoded = self.kind.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local result = class8.new()
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
				result.kind = {
					type = "literal",
					value = v.EventShareLinkPayload_EventShareLinkLiteralPayload.decode(v5)
				}
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

function class8:jsonEncode()
	local v2 = {}

	if self.kind ~= nil and self.kind.type == "literal" then
		v2.literal = self.kind.value:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(p)
	local v2 = class8.new()

	if p.literal ~= nil then
		v2.kind = {
			type = "literal",
			value = v.EventShareLinkPayload_EventShareLinkLiteralPayload.jsonDecode(p.literal)
		}
	end

	return v2
end

class8.descriptor = {
	name = "EventShareLinkPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventShareLinkPayload"
}

v.EventShareLinkPayload = class8

typeRegistry.default:register(v.EventShareLinkPayload)

local class9 = {}
class9.__index = class9

function class9.new(p)
	local event_id

	if not (p == nil or p.event_id == nil) then
		event_id = p.event_id
	end

	return (setmetatable({ event_id = event_id }, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.event_id ~= nil then
		local encoded = self.event_id:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class9.decode(buf: buffer)
	local result = class9.new()
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
				result.event_id = prop_types.StringProp.decode(v5)
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

function class9:jsonEncode()
	local v2 = {}

	if self.event_id ~= nil then
		v2.eventId = self.event_id:jsonEncode()
	end

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.event_id ~= nil then
		v2.event_id = prop_types.StringProp.jsonDecode(p.event_id)
	end

	if p.eventId ~= nil then
		v2.event_id = prop_types.StringProp.jsonDecode(p.eventId)
	end

	return v2
end

class9.descriptor = {
	name = "EventShareLinkPayload_EventShareLinkLiteralPayload",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventShareLinkLiteralPayload"
}

v.EventShareLinkPayload_EventShareLinkLiteralPayload = class9

typeRegistry.default:register(v.EventShareLinkPayload_EventShareLinkLiteralPayload)

return {
	GenericShareLinkData = v.GenericShareLinkData,
	GenericShareLinkData_GenericShareLinkLiteralData = v.GenericShareLinkData_GenericShareLinkLiteralData,
	ShareLinkFetchData = v.ShareLinkFetchData,
	ShareLinkFetchData_ShareLinkFetchLiteralData = v.ShareLinkFetchData_ShareLinkFetchLiteralData,
	ShareLinkPayload = v.ShareLinkPayload,
	ExperienceShareLinkPayload = v.ExperienceShareLinkPayload,
	ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload = v.ExperienceShareLinkPayload_ExperienceShareLinkLiteralPayload,
	EventShareLinkPayload = v.EventShareLinkPayload,
	EventShareLinkPayload_EventShareLinkLiteralPayload = v.EventShareLinkPayload_EventShareLinkLiteralPayload
}
