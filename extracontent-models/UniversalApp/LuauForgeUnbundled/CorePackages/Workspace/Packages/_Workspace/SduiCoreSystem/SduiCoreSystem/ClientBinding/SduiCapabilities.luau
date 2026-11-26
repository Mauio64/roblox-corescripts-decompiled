local SduiCapabilityFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiCapabilityFlags")

local resolveRuntimeFlagValues = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/resolveRuntimeFlagValues")
local fFlagSduiDefineUnreadRuntimeFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiDefineUnreadRuntimeFlags

local v5 = {}

function v5.isEnabled(p2): boolean
	return SduiCapabilityFlags[p2] == true
end

function v5.getEnabledCapabilities()
	local enabledCapabilities = {}

	for k, v6 in SduiCapabilityFlags do
		if v6 then
			table.insert(enabledCapabilities, k)
		end
	end

	return enabledCapabilities
end

local function resolveNamesToNumbers(list)
	if #list == 0 then
		return {}
	end

	local capability = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto").apppageplatform.shared.capability.Capability

	local result = {}

	for k, item in list do
		local v6 = capability.fromName(item)

		if v6 == nil then
			warn(`SduiCapabilities: unknown capability name {item}`)
		else
			table.insert(result, capability.toNumber(v6))
		end
	end

	return result
end

function v5.createQueryValue(p2)
	local namesToNumbers = resolveNamesToNumbers(p2)

	if #namesToNumbers == 0 then
		return nil
	end

	table.sort(namesToNumbers)
	local v6 = table.create(#namesToNumbers)

	for k, namesToNumber in namesToNumbers do
		table.insert(v6, (tostring(namesToNumber)))
	end

	return table.concat(v6, ",")
end

function v5:addToQueryParams(items)
	local v6 = {}

	for k, item in items do
		if v5.isEnabled(item) then
			table.insert(v6, item)
		end
	end

	local queryValue = v5.createQueryValue(v6)

	if queryValue ~= nil then
		self.enabledCapabilities = queryValue
	end
end

function v5.getEnabledCapabilityNumbers(items)
	local v6 = {}

	for k, item in items do
		if v5.isEnabled(item) then
			table.insert(v6, item)
		end
	end

	local namesToNumbers = resolveNamesToNumbers(v6)
	table.sort(namesToNumbers)
	return namesToNumbers
end

function v5.getEnabledCapabilityNumbersWithoutExtendedMarker()
	local v6 = {}

	for k, v7 in v5.getEnabledCapabilities() do
		if v7 ~= "CAPABILITY_SUPPORTS_EXTENDED_CLIENT_CAPABILITIES" then
			table.insert(v6, v7)
		end
	end

	return v5.getEnabledCapabilityNumbers(v6)
end

function v5:addAllToQueryParams()
	local queryValue = v5.createQueryValue(v5.getEnabledCapabilities())

	if queryValue ~= nil then
		self.enabledCapabilities = queryValue
	end
end

local function resolveRuntimeSupportNumbers(items, p2, p3)
	local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/ProtoVariableMapper")
	local runtimeSupportNumbers = {}

	for k, item in items do
		local mapLuaEnumFormatToProto = module3.mapLuaEnumFormatToProto(item, p3, p2)

		if mapLuaEnumFormatToProto == nil then
			continue
		end

		local number = p2.toNumber(mapLuaEnumFormatToProto)

		if number ~= 0 then
			table.insert(runtimeSupportNumbers, number)
		end
	end

	table.sort(runtimeSupportNumbers)
	return runtimeSupportNumbers
end

local v6 = false

local function readRuntimeFlag(p2)
	local success, fastFlag = pcall(game.GetFastFlag, game, p2)

	if success and type(fastFlag) == "boolean" then
		return true, fastFlag
	end

	return pcall(game.DefineFastFlag, game, p2, false)
end

local function getRuntimeFlagValues()
	local runtimeFlagValues, v7, v8 = resolveRuntimeFlagValues(not fFlagSduiDefineUnreadRuntimeFlags and function(p2)
		return pcall(game.GetFastFlag, game, p2)
	end or readRuntimeFlag)

	if not v6 and v7 + v8 > 0 then
		v6 = true
		warn(`SduiCapabilities: ignored {v7} invalid runtime flag names and {v8} unreadable flags`)
	end

	return runtimeFlagValues
end

local function getRuntimeSupportFields()
	local Shared = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto").apppageplatform.shared
	return {
		registered_ui_component_types = resolveRuntimeSupportNumbers(
			require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiComponentRegistry")().getRegisteredComponentTypes(),
			Shared.ui_component_type.UiComponentType,
			"UI_COMPONENT_TYPE_"
		),
		registered_action_types = resolveRuntimeSupportNumbers(
			require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiActionHandlerRegistry")().getRegisteredActionTypes(),
			Shared.actions.ActionType,
			"ACTION_TYPE_"
		),
		runtime_flag_values = getRuntimeFlagValues()
	}
end

function v5.buildClientCapabilities()
	local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
	local clientCapabilities = module3.apppageplatform.shared.client_capabilities.ClientCapabilities
	local platform = module3.apppageplatform.shared.client_capabilities.Platform
	local v7 = {
		enabled_capabilities = v5.getEnabledCapabilityNumbers(v5.getEnabledCapabilities()),
		platform = platform.toNumber("PLATFORM_APP")
	}

	for k, v8 in getRuntimeSupportFields() do
		v7[k] = v8
	end

	return clientCapabilities.new(v7)
end

return v5
