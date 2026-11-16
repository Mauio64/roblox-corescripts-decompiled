local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)

local display_location = require(script.Parent.Parent.Parent.shared.v1beta1.display_location)

local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)

local class = {}
class.__index = class

function class.new(p)
	local display_location2

	if p == nil or p.display_location == nil then
		display_location2 = assert(display_location.DisplayLocation.fromNumber(0), "Enum has no 0 default")
	else
		display_location2 = p.display_location
	end

	local v2 = {
		display_location = display_location2,
		roblox_component_to_template_id = (p == nil or p.roblox_component_to_template_id == nil) and {} or p.roblox_component_to_template_id
	}
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if
		self.display_location ~= nil
		and (self.display_location ~= nil and self.display_location ~= 0 or self.display_location ~= display_location.DisplayLocation.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, display_location.DisplayLocation.toNumber(self.display_location))
	end

	if self.roblox_component_to_template_id ~= nil and next(self.roblox_component_to_template_id) ~= nil then
		for k, v4 in self.roblox_component_to_template_id do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeString(v9, v10, v4)
			local v13, v14 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.display_location = display_location.DisplayLocation.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.DisplayLocationTemplateMapping_RobloxComponentToTemplateIdEntry.decode(v5)

				result.roblox_component_to_template_id[decoded.key or ""] = decoded.value or ""
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

	if
		self.display_location ~= nil
		and (self.display_location ~= nil and self.display_location ~= 0 or self.display_location ~= display_location.DisplayLocation.fromNumber(0))
	then
		local displayLocation

		if typeof(self.display_location) == "number" then
			displayLocation = self.display_location
		else
			displayLocation = display_location.DisplayLocation.toNumber(self.display_location)
		end

		v2.displayLocation = displayLocation
	end

	if self.roblox_component_to_template_id == nil or next(self.roblox_component_to_template_id) == nil then
		return v2
	end

	local robloxComponentToTemplateId = {}

	for k, v3 in self.roblox_component_to_template_id do
		robloxComponentToTemplateId[k] = v3
	end

	v2.robloxComponentToTemplateId = robloxComponentToTemplateId

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.display_location ~= nil then
		local display_location2

		if typeof(data.display_location) == "number" then
			display_location2 = display_location.DisplayLocation.fromNumber(data.display_location)
				or data.display_location
		else
			display_location2 = display_location.DisplayLocation.fromName(data.display_location)
				or data.display_location
		end

		v2.display_location = display_location2
	end

	if data.displayLocation ~= nil then
		local display_location2

		if typeof(data.displayLocation) == "number" then
			display_location2 = display_location.DisplayLocation.fromNumber(data.displayLocation)
				or data.displayLocation
		else
			display_location2 = display_location.DisplayLocation.fromName(data.displayLocation) or data.displayLocation
		end

		v2.display_location = display_location2
	end

	if data.roblox_component_to_template_id ~= nil then
		local roblox_component_to_template_id = {}

		for k, v3 in data.roblox_component_to_template_id do
			roblox_component_to_template_id[k] = v3
		end

		v2.roblox_component_to_template_id = roblox_component_to_template_id
	end

	if data.robloxComponentToTemplateId == nil then
		return v2
	end

	local roblox_component_to_template_id = {}

	for k, v3 in data.robloxComponentToTemplateId do
		roblox_component_to_template_id[k] = v3
	end

	v2.roblox_component_to_template_id = roblox_component_to_template_id

	return v2
end

class.descriptor = {
	name = "DisplayLocationTemplateMapping",
	fullName = "roblox.apppageplatform.templates.v1beta1.DisplayLocationTemplateMapping"
}

v.DisplayLocationTemplateMapping = class

typeRegistry.default:register(v.DisplayLocationTemplateMapping)

local class2 = {}
class2.__index = class2

function class2.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.value)
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buffer.tostring(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class2.descriptor = {
	name = "DisplayLocationTemplateMapping_RobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.templates.v1beta1.RobloxComponentToTemplateIdEntry"
}

v.DisplayLocationTemplateMapping_RobloxComponentToTemplateIdEntry = class2

typeRegistry.default:register(v.DisplayLocationTemplateMapping_RobloxComponentToTemplateIdEntry)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local v2 = {
		display_locations = (data == nil or data.display_locations == nil) and {} or data.display_locations,
		client_capabilities = 0,
		cached_component_mappings = 0,
		locale = 0
	}
	local client_capabilities2

	if not (data == nil or data.client_capabilities == nil) then
		client_capabilities2 = data.client_capabilities
	end

	v2.client_capabilities = client_capabilities2

	v2.cached_component_mappings = (data == nil or data.cached_component_mappings == nil) and {}
		or data.cached_component_mappings
	v2.locale = (data == nil or data.locale == nil) and "" or data.locale
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.display_locations ~= nil and #self.display_locations > 0 then
		for _, display_location2 in self.display_locations do
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, display_location.DisplayLocation.toNumber(display_location2))
		end
	end

	if self.client_capabilities ~= nil then
		local encoded = self.client_capabilities:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.cached_component_mappings ~= nil and #self.cached_component_mappings > 0 then
		for _, cached_component_mapping in self.cached_component_mappings do
			local encoded = cached_component_mapping:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.locale ~= nil and self.locale ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.locale)
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
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				table.insert(result.display_locations, display_location.DisplayLocation.fromNumber(v5) or v5)
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.client_capabilities = client_capabilities.ClientCapabilities.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.cached_component_mappings, v.DisplayLocationTemplateMapping.decode(v5))
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.locale = buffer.tostring(v5)
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

	if self.display_locations ~= nil and #self.display_locations > 0 then
		local display_locations = {}

		for _, display_location2 in self.display_locations do
			if typeof(display_location2) ~= "number" then
				display_location2 = display_location.DisplayLocation.toNumber(display_location2)
			end

			table.insert(display_locations, display_location2)
		end

		v2.displayLocations = display_locations
	end

	if self.client_capabilities ~= nil then
		v2.clientCapabilities = self.client_capabilities:jsonEncode()
	end

	if self.cached_component_mappings ~= nil and #self.cached_component_mappings > 0 then
		local cachedComponentMappings = {}

		for _, cached_component_mapping in self.cached_component_mappings do
			table.insert(cachedComponentMappings, cached_component_mapping:jsonEncode())
		end

		v2.cachedComponentMappings = cachedComponentMappings
	end

	if self.locale ~= nil and self.locale ~= "" then
		v2.locale = self.locale
	end

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.display_locations ~= nil then
		local display_locations = {}

		for _, display_location2 in data.display_locations do
			local v3

			if typeof(display_location2) == "number" then
				v3 = display_location.DisplayLocation.fromNumber(display_location2) or display_location2
			else
				v3 = display_location.DisplayLocation.fromName(display_location2) or display_location2
			end

			table.insert(display_locations, v3)
		end

		v2.display_locations = display_locations
	end

	if data.displayLocations ~= nil then
		local display_locations = {}

		for _, displayLocation in data.displayLocations do
			local v3

			if typeof(displayLocation) == "number" then
				v3 = display_location.DisplayLocation.fromNumber(displayLocation) or displayLocation
			else
				v3 = display_location.DisplayLocation.fromName(displayLocation) or displayLocation
			end

			table.insert(display_locations, v3)
		end

		v2.display_locations = display_locations
	end

	if data.client_capabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.client_capabilities)
	end

	if data.clientCapabilities ~= nil then
		v2.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(data.clientCapabilities)
	end

	if data.cached_component_mappings ~= nil then
		local cached_component_mappings = {}

		for _, cached_component_mapping in data.cached_component_mappings do
			table.insert(
				cached_component_mappings,
				v.DisplayLocationTemplateMapping.jsonDecode(cached_component_mapping)
			)
		end

		v2.cached_component_mappings = cached_component_mappings
	end

	if data.cachedComponentMappings ~= nil then
		local cached_component_mappings = {}

		for _, cachedComponentMapping in data.cachedComponentMappings do
			table.insert(cached_component_mappings, v.DisplayLocationTemplateMapping.jsonDecode(cachedComponentMapping))
		end

		v2.cached_component_mappings = cached_component_mappings
	end

	if data.locale ~= nil then
		v2.locale = data.locale
	end

	return v2
end

class3.descriptor = {
	name = "GetTemplatesRequest",
	fullName = "roblox.apppageplatform.templates.v1beta1.GetTemplatesRequest"
}

v.GetTemplatesRequest = class3

typeRegistry.default:register(v.GetTemplatesRequest)

local class4 = {}
class4.__index = class4

function class4.new(data)
	return (setmetatable({
		templates = (data == nil or data.templates == nil) and {} or data.templates,
		component_mappings = (data == nil or data.component_mappings == nil) and {} or data.component_mappings,
		valid_cached_component_mappings = (data == nil or data.valid_cached_component_mappings == nil) and {} or data.valid_cached_component_mappings,
		localized_literals = (data == nil or data.localized_literals == nil) and {} or data.localized_literals
	}, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.templates ~= nil and next(self.templates) ~= nil then
		for k, template in self.templates do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local encoded = template:encode()
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeBuffer(v8, v9, encoded, buffer.len(encoded))
			local v12, v13 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	if self.component_mappings ~= nil and #self.component_mappings > 0 then
		for _, component_mapping in self.component_mappings do
			local encoded = component_mapping:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.valid_cached_component_mappings ~= nil and #self.valid_cached_component_mappings > 0 then
		for _, valid_cached_component_mapping in self.valid_cached_component_mappings do
			local encoded = valid_cached_component_mapping:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	if self.localized_literals ~= nil and next(self.localized_literals) ~= nil then
		for k, localized_literal in self.localized_literals do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeString(v8, v9, localized_literal)
			local v12, v13 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local v2 = class4.new()
	local v3 = 0

	while v3 < buffer.len(buf) do
		local v4, v5
		v4, v5, v3 = proto.readTag(buf, v3)

		if v5 == proto.wireTypes.varint then
			local _
			_, v3 = proto.readVarInt(buf, v3)
		elseif v5 == proto.wireTypes.lengthDelimited then
			if v4 == 1 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.GetTemplatesResponse_TemplatesEntry.decode(v6)

				local templateEntry = template_entry.TemplateEntry.new()

				v2.templates[decoded.key or ""] = decoded.value or templateEntry
			elseif v4 == 2 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)
				table.insert(v2.component_mappings, v.DisplayLocationTemplateMapping.decode(v6))
			elseif v4 == 3 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)
				table.insert(v2.valid_cached_component_mappings, v.DisplayLocationTemplateMapping.decode(v6))
			elseif v4 == 4 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.GetTemplatesResponse_LocalizedLiteralsEntry.decode(v6)

				v2.localized_literals[decoded.key or ""] = decoded.value or ""
			else
				local varInt, v6 = proto.readVarInt(buf, v3)

				v3 = v6 + varInt
			end
		elseif v5 == proto.wireTypes.i32 then
			local _
			_, v3 = proto.readFixed32(buf, v3)
		elseif v5 == proto.wireTypes.i64 then
			local _
			_, v3 = proto.readFixed64(buf, v3)
		else
			error("Unsupported wire type: " .. v5)
		end
	end

	return v2
end

function class4:jsonEncode()
	local v2 = {}

	if self.templates ~= nil and next(self.templates) ~= nil then
		local templates = {}

		for k, template in self.templates do
			templates[k] = template:jsonEncode()
		end

		v2.templates = templates
	end

	if self.component_mappings ~= nil and #self.component_mappings > 0 then
		local componentMappings = {}

		for _, component_mapping in self.component_mappings do
			table.insert(componentMappings, component_mapping:jsonEncode())
		end

		v2.componentMappings = componentMappings
	end

	if self.valid_cached_component_mappings ~= nil and #self.valid_cached_component_mappings > 0 then
		local validCachedComponentMappings = {}

		for _, valid_cached_component_mapping in self.valid_cached_component_mappings do
			table.insert(validCachedComponentMappings, valid_cached_component_mapping:jsonEncode())
		end

		v2.validCachedComponentMappings = validCachedComponentMappings
	end

	if self.localized_literals == nil or next(self.localized_literals) == nil then
		return v2
	end

	local localized_literals = {}

	for k, localized_literal in self.localized_literals do
		localized_literals[k] = localized_literal
	end

	v2.localizedLiterals = localized_literals

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.templates ~= nil then
		local templates = {}

		for k, template in data.templates do
			templates[k] = template_entry.TemplateEntry.jsonDecode(template)
		end

		v2.templates = templates
	end

	if data.component_mappings ~= nil then
		local component_mappings = {}

		for _, component_mapping in data.component_mappings do
			table.insert(component_mappings, v.DisplayLocationTemplateMapping.jsonDecode(component_mapping))
		end

		v2.component_mappings = component_mappings
	end

	if data.componentMappings ~= nil then
		local component_mappings = {}

		for _, componentMapping in data.componentMappings do
			table.insert(component_mappings, v.DisplayLocationTemplateMapping.jsonDecode(componentMapping))
		end

		v2.component_mappings = component_mappings
	end

	if data.valid_cached_component_mappings ~= nil then
		local valid_cached_component_mappings = {}

		for _, valid_cached_component_mapping in data.valid_cached_component_mappings do
			table.insert(
				valid_cached_component_mappings,
				v.DisplayLocationTemplateMapping.jsonDecode(valid_cached_component_mapping)
			)
		end

		v2.valid_cached_component_mappings = valid_cached_component_mappings
	end

	if data.validCachedComponentMappings ~= nil then
		local valid_cached_component_mappings = {}

		for _, validCachedComponentMapping in data.validCachedComponentMappings do
			table.insert(
				valid_cached_component_mappings,
				v.DisplayLocationTemplateMapping.jsonDecode(validCachedComponentMapping)
			)
		end

		v2.valid_cached_component_mappings = valid_cached_component_mappings
	end

	if data.localized_literals ~= nil then
		local localized_literals = {}

		for k, localized_literal in data.localized_literals do
			localized_literals[k] = localized_literal
		end

		v2.localized_literals = localized_literals
	end

	if data.localizedLiterals == nil then
		return v2
	end

	local localizedLiterals = {}

	for k, localizedLiteral in data.localizedLiterals do
		localizedLiterals[k] = localizedLiteral
	end

	v2.localized_literals = localizedLiterals

	return v2
end

class4.descriptor = {
	name = "GetTemplatesResponse",
	fullName = "roblox.apppageplatform.templates.v1beta1.GetTemplatesResponse"
}

v.GetTemplatesResponse = class4

typeRegistry.default:register(v.GetTemplatesResponse)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = template_entry.TemplateEntry.decode(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = template_entry.TemplateEntry.jsonDecode(p.value)
	end

	return v2
end

class5.descriptor = {
	name = "GetTemplatesResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.templates.v1beta1.TemplatesEntry"
}

v.GetTemplatesResponse_TemplatesEntry = class5

typeRegistry.default:register(v.GetTemplatesResponse_TemplatesEntry)

local class6 = {}
class6.__index = class6

function class6.new(p)
	return (setmetatable({
		key = (p == nil or p.key == nil) and "" or p.key,
		value = (p == nil or p.value == nil) and "" or p.value
	}, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil and self.value ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.value)
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
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buffer.tostring(v5)
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

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil and self.value ~= "" then
		v2.value = self.value
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = p.value
	end

	return v2
end

class6.descriptor = {
	name = "GetTemplatesResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.templates.v1beta1.LocalizedLiteralsEntry"
}

v.GetTemplatesResponse_LocalizedLiteralsEntry = class6

typeRegistry.default:register(v.GetTemplatesResponse_LocalizedLiteralsEntry)

return {
	DisplayLocationTemplateMapping = v.DisplayLocationTemplateMapping,
	GetTemplatesRequest = v.GetTemplatesRequest,
	GetTemplatesResponse = v.GetTemplatesResponse
}
