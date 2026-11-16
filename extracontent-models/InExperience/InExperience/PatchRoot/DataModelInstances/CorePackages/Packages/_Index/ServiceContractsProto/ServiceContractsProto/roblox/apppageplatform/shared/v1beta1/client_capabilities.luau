local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local actions = require(script.Parent.actions)
local capability = require(script.Parent.capability)
local ui_component_type = require(script.Parent.ui_component_type)

local class = {}
class.__index = class

function class.new(data)
	local v2 = {
		enabled_capabilities = (data == nil or data.enabled_capabilities == nil) and {} or data.enabled_capabilities,
		proto_version = (data == nil or data.proto_version == nil) and "" or data.proto_version,
		platform = 0,
		registered_ui_component_types = 0,
		registered_action_types = 0,
		runtime_flag_values = 0
	}
	local platform

	if data == nil or data.platform == nil then
		platform = assert(v.Platform.fromNumber(0), "Enum has no 0 default")
	else
		platform = data.platform
	end

	v2.platform = platform

	v2.registered_ui_component_types = (data == nil or data.registered_ui_component_types == nil) and {}
		or data.registered_ui_component_types
	v2.registered_action_types = (data == nil or data.registered_action_types == nil) and {}
		or data.registered_action_types
	v2.runtime_flag_values = (data == nil or data.runtime_flag_values == nil) and {} or data.runtime_flag_values
	return (setmetatable(v2, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.enabled_capabilities ~= nil and #data.enabled_capabilities > 0 then
		for _, enabled_capability in data.enabled_capabilities do
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, capability.Capability.toNumber(enabled_capability))
		end
	end

	if data.proto_version ~= nil and data.proto_version ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.proto_version)
	end

	if
		data.platform ~= nil
		and (data.platform ~= nil and data.platform ~= 0 or data.platform ~= v.Platform.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.Platform.toNumber(data.platform))
	end

	if data.registered_ui_component_types ~= nil and #data.registered_ui_component_types > 0 then
		for _, registered_ui_component_type in data.registered_ui_component_types do
			local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, ui_component_type.UiComponentType.toNumber(registered_ui_component_type))
		end
	end

	if data.registered_action_types ~= nil and #data.registered_action_types > 0 then
		for _, registered_action_type in data.registered_action_types do
			local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, actions.ActionType.toNumber(registered_action_type))
		end
	end

	if data.runtime_flag_values ~= nil and next(data.runtime_flag_values) ~= nil then
		for k, runtime_flag_value in data.runtime_flag_values do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.varint)
			local v10, v11 = proto.writeVarInt(v8, v9, runtime_flag_value and 1 or 0)
			local v12, v13 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
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
				table.insert(result.enabled_capabilities, capability.Capability.fromNumber(v5) or v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.platform = v.Platform.fromNumber(v5) or v5
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				table.insert(
					result.registered_ui_component_types,
					ui_component_type.UiComponentType.fromNumber(v5) or v5
				)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				table.insert(result.registered_action_types, actions.ActionType.fromNumber(v5) or v5)
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.proto_version = buffer.tostring(v5)
			elseif v3 == 7 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)

				local decoded = v.ClientCapabilities_RuntimeFlagValuesEntry.decode(v5)

				result.runtime_flag_values[decoded.key or ""] = decoded.value or false
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

function class.jsonEncode(data)
	local v2 = {}

	if data.enabled_capabilities ~= nil and #data.enabled_capabilities > 0 then
		local enabled_capabilities = {}

		for _, enabled_capability in data.enabled_capabilities do
			if typeof(enabled_capability) ~= "number" then
				enabled_capability = capability.Capability.toNumber(enabled_capability)
			end

			table.insert(enabled_capabilities, enabled_capability)
		end

		v2.enabledCapabilities = enabled_capabilities
	end

	if data.proto_version ~= nil and data.proto_version ~= "" then
		v2.protoVersion = data.proto_version
	end

	if
		data.platform ~= nil
		and (data.platform ~= nil and data.platform ~= 0 or data.platform ~= v.Platform.fromNumber(0))
	then
		local platform

		if typeof(data.platform) == "number" then
			platform = data.platform
		else
			platform = v.Platform.toNumber(data.platform)
		end

		v2.platform = platform
	end

	if data.registered_ui_component_types ~= nil and #data.registered_ui_component_types > 0 then
		local registered_ui_component_types = {}

		for _, registered_ui_component_type in data.registered_ui_component_types do
			if typeof(registered_ui_component_type) ~= "number" then
				registered_ui_component_type = ui_component_type.UiComponentType.toNumber(registered_ui_component_type)
			end

			table.insert(registered_ui_component_types, registered_ui_component_type)
		end

		v2.registeredUiComponentTypes = registered_ui_component_types
	end

	if data.registered_action_types ~= nil and #data.registered_action_types > 0 then
		local registered_action_types = {}

		for _, registered_action_type in data.registered_action_types do
			if typeof(registered_action_type) ~= "number" then
				registered_action_type = actions.ActionType.toNumber(registered_action_type)
			end

			table.insert(registered_action_types, registered_action_type)
		end

		v2.registeredActionTypes = registered_action_types
	end

	if data.runtime_flag_values == nil or next(data.runtime_flag_values) == nil then
		return v2
	end

	local runtime_flag_values = {}

	for k, runtime_flag_value in data.runtime_flag_values do
		runtime_flag_values[k] = runtime_flag_value
	end

	v2.runtimeFlagValues = runtime_flag_values

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.enabled_capabilities ~= nil then
		local enabled_capabilities = {}

		for _, enabled_capability in data.enabled_capabilities do
			local v3

			if typeof(enabled_capability) == "number" then
				v3 = capability.Capability.fromNumber(enabled_capability) or enabled_capability
			else
				v3 = capability.Capability.fromName(enabled_capability) or enabled_capability
			end

			table.insert(enabled_capabilities, v3)
		end

		v2.enabled_capabilities = enabled_capabilities
	end

	if data.enabledCapabilities ~= nil then
		local enabled_capabilities = {}

		for _, enabledCapability in data.enabledCapabilities do
			local v3

			if typeof(enabledCapability) == "number" then
				v3 = capability.Capability.fromNumber(enabledCapability) or enabledCapability
			else
				v3 = capability.Capability.fromName(enabledCapability) or enabledCapability
			end

			table.insert(enabled_capabilities, v3)
		end

		v2.enabled_capabilities = enabled_capabilities
	end

	if data.proto_version ~= nil then
		v2.proto_version = data.proto_version
	end

	if data.protoVersion ~= nil then
		v2.proto_version = data.protoVersion
	end

	if data.platform ~= nil then
		local platform

		if typeof(data.platform) == "number" then
			platform = v.Platform.fromNumber(data.platform) or data.platform
		else
			platform = v.Platform.fromName(data.platform) or data.platform
		end

		v2.platform = platform
	end

	if data.registered_ui_component_types ~= nil then
		local registered_ui_component_types = {}

		for _, registered_ui_component_type in data.registered_ui_component_types do
			local v3

			if typeof(registered_ui_component_type) == "number" then
				v3 = ui_component_type.UiComponentType.fromNumber(registered_ui_component_type)
					or registered_ui_component_type
			else
				v3 = ui_component_type.UiComponentType.fromName(registered_ui_component_type)
					or registered_ui_component_type
			end

			table.insert(registered_ui_component_types, v3)
		end

		v2.registered_ui_component_types = registered_ui_component_types
	end

	if data.registeredUiComponentTypes ~= nil then
		local registered_ui_component_types = {}

		for _, registeredUiComponentType in data.registeredUiComponentTypes do
			local v3

			if typeof(registeredUiComponentType) == "number" then
				v3 = ui_component_type.UiComponentType.fromNumber(registeredUiComponentType)
					or registeredUiComponentType
			else
				v3 = ui_component_type.UiComponentType.fromName(registeredUiComponentType) or registeredUiComponentType
			end

			table.insert(registered_ui_component_types, v3)
		end

		v2.registered_ui_component_types = registered_ui_component_types
	end

	if data.registered_action_types ~= nil then
		local registered_action_types = {}

		for _, registered_action_type in data.registered_action_types do
			local v3

			if typeof(registered_action_type) == "number" then
				v3 = actions.ActionType.fromNumber(registered_action_type) or registered_action_type
			else
				v3 = actions.ActionType.fromName(registered_action_type) or registered_action_type
			end

			table.insert(registered_action_types, v3)
		end

		v2.registered_action_types = registered_action_types
	end

	if data.registeredActionTypes ~= nil then
		local registered_action_types = {}

		for _, registeredActionType in data.registeredActionTypes do
			local v3

			if typeof(registeredActionType) == "number" then
				v3 = actions.ActionType.fromNumber(registeredActionType) or registeredActionType
			else
				v3 = actions.ActionType.fromName(registeredActionType) or registeredActionType
			end

			table.insert(registered_action_types, v3)
		end

		v2.registered_action_types = registered_action_types
	end

	if data.runtime_flag_values ~= nil then
		local runtime_flag_values = {}

		for k, runtime_flag_value in data.runtime_flag_values do
			runtime_flag_values[k] = runtime_flag_value
		end

		v2.runtime_flag_values = runtime_flag_values
	end

	if data.runtimeFlagValues == nil then
		return v2
	end

	local runtimeFlagValues = {}

	for k, runtimeFlagValue in data.runtimeFlagValues do
		runtimeFlagValues[k] = runtimeFlagValue
	end

	v2.runtime_flag_values = runtimeFlagValues

	return v2
end

class.descriptor = {
	name = "ClientCapabilities",
	fullName = "roblox.apppageplatform.shared.v1beta1.ClientCapabilities"
}

v.ClientCapabilities = class

typeRegistry.default:register(v.ClientCapabilities)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = p ~= nil and p.value ~= nil and p.value
	}
	return (setmetatable(v2, class2))
end

function class2.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.key ~= nil and p.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, p.key)
	end

	if p.value then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.value and 1 or 0)
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
			if v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.value = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
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

function class2.jsonEncode(p)
	local v2 = {}

	if p.key ~= nil and p.key ~= "" then
		v2.key = p.key
	end

	if p.value then
		v2.value = p.value
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
	name = "ClientCapabilities_RuntimeFlagValuesEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.RuntimeFlagValuesEntry"
}

v.ClientCapabilities_RuntimeFlagValuesEntry = class2

typeRegistry.default:register(v.ClientCapabilities_RuntimeFlagValuesEntry)

v.Platform = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "PLATFORM_INVALID"
		elseif p == 1 then
			return "PLATFORM_WEB"
		elseif p == 2 then
			return "PLATFORM_APP"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "PLATFORM_INVALID" then
			return 0
		elseif p == "PLATFORM_WEB" then
			return 1
		elseif p == "PLATFORM_APP" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "PLATFORM_INVALID" then
			return "PLATFORM_INVALID"
		elseif p == "PLATFORM_WEB" then
			return "PLATFORM_WEB"
		elseif p == "PLATFORM_APP" then
			return "PLATFORM_APP"
		end

		return nil
	end
}

return { ClientCapabilities = v.ClientCapabilities, Platform = v.Platform }
