local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SduiCapabilityFlags = require(SduiCoreSystem.ClientBinding.SduiCapabilityFlags)

local resolveRuntimeFlagValues = require(SduiCoreSystem.ClientBinding.resolveRuntimeFlagValues)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDefineUnreadRuntimeFlags = SharedFlags.FFlagSduiDefineUnreadRuntimeFlags

local SduiCapabilities = {}

function SduiCapabilities.isEnabled(p: string): boolean
	return SduiCapabilityFlags[p] == true
end

function SduiCapabilities.getEnabledCapabilities()
	local enabledCapabilities = {}

	for k, sduiCapabilityFlag in SduiCapabilityFlags do
		if sduiCapabilityFlag then
			table.insert(enabledCapabilities, k)
		end
	end

	return enabledCapabilities
end

local function resolveNamesToNumbers(list)
	if #list == 0 then
		return {}
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local capability = ServiceContractsProto.apppageplatform.shared.capability.Capability

	local result = {}

	for _, item in list do
		local v = capability.fromName(item)

		if v == nil then
			warn(`SduiCapabilities: unknown capability name {item}`)
		else
			table.insert(result, capability.toNumber(v))
		end
	end

	return result
end

function SduiCapabilities.createQueryValue(p)
	local namesToNumbers = resolveNamesToNumbers(p)

	if #namesToNumbers == 0 then
		return nil
	end

	table.sort(namesToNumbers)
	local v = table.create(#namesToNumbers)

	for _, namesToNumber in namesToNumbers do
		table.insert(v, (tostring(namesToNumber)))
	end

	return table.concat(v, ",")
end

function SduiCapabilities:addToQueryParams(items)
	local v = {}

	for _, item in items do
		if SduiCapabilities.isEnabled(item) then
			table.insert(v, item)
		end
	end

	local queryValue = SduiCapabilities.createQueryValue(v)

	if queryValue ~= nil then
		self.enabledCapabilities = queryValue
	end
end

function SduiCapabilities.getEnabledCapabilityNumbers(items)
	local v = {}

	for _, item in items do
		if SduiCapabilities.isEnabled(item) then
			table.insert(v, item)
		end
	end

	local namesToNumbers = resolveNamesToNumbers(v)
	table.sort(namesToNumbers)
	return namesToNumbers
end

function SduiCapabilities.getEnabledCapabilityNumbersWithoutExtendedMarker()
	local v = {}

	for _, v2 in SduiCapabilities.getEnabledCapabilities() do
		if v2 ~= "CAPABILITY_SUPPORTS_EXTENDED_CLIENT_CAPABILITIES" then
			table.insert(v, v2)
		end
	end

	return SduiCapabilities.getEnabledCapabilityNumbers(v)
end

function SduiCapabilities:addAllToQueryParams()
	local queryValue = SduiCapabilities.createQueryValue(SduiCapabilities.getEnabledCapabilities())

	if queryValue ~= nil then
		self.enabledCapabilities = queryValue
	end
end

local function resolveRuntimeSupportNumbers(items, p, p2: string)
	local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
	local runtimeSupportNumbers = {}

	for _, item in items do
		local mapLuaEnumFormatToProto = ProtoVariableMapper.mapLuaEnumFormatToProto(item, p2, p)

		if mapLuaEnumFormatToProto == nil then
			continue
		end

		local number = p.toNumber(mapLuaEnumFormatToProto)

		if number ~= 0 then
			table.insert(runtimeSupportNumbers, number)
		end
	end

	table.sort(runtimeSupportNumbers)
	return runtimeSupportNumbers
end

local v = false

local function readRuntimeFlag(p: string)
	local success, fastFlag = pcall(game.GetFastFlag, game, p)

	if success and type(fastFlag) == "boolean" then
		return true, fastFlag
	end

	return pcall(game.DefineFastFlag, game, p, false)
end

local function getRuntimeFlagValues()
	local runtimeFlagValues, v2, v3 = resolveRuntimeFlagValues(not FFlagSduiDefineUnreadRuntimeFlags and function(p: string)
		return pcall(game.GetFastFlag, game, p)
	end or readRuntimeFlag)

	if not v and v2 + v3 > 0 then
		v = true
		warn(`SduiCapabilities: ignored {v2} invalid runtime flag names and {v3} unreadable flags`)
	end

	return runtimeFlagValues
end

local function getRuntimeSupportFields()
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local Shared = ServiceContractsProto.apppageplatform.shared

	local getSduiComponentRegistry = require(SduiCoreSystem.getSduiComponentRegistry)
	local runtimeSupportFields = {
		registered_ui_component_types = resolveRuntimeSupportNumbers(
			getSduiComponentRegistry().getRegisteredComponentTypes(),
			Shared.ui_component_type.UiComponentType,
			"UI_COMPONENT_TYPE_"
		),
		registered_action_types = 0,
		runtime_flag_values = 0
	}

	local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
	runtimeSupportFields.registered_action_types = resolveRuntimeSupportNumbers(
		getSduiActionHandlerRegistry().getRegisteredActionTypes(),
		Shared.actions.ActionType,
		"ACTION_TYPE_"
	)

	runtimeSupportFields.runtime_flag_values = getRuntimeFlagValues()
	return runtimeSupportFields
end

function SduiCapabilities.buildClientCapabilities()
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local platform = ServiceContractsProto.apppageplatform.shared.client_capabilities.Platform
	local v2 = {
		enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers(SduiCapabilities.getEnabledCapabilities()),
		platform = platform.toNumber("PLATFORM_APP")
	}

	for k, v3 in getRuntimeSupportFields() do
		v2[k] = v3
	end

	return clientCapabilities.new(v2)
end

return SduiCapabilities
