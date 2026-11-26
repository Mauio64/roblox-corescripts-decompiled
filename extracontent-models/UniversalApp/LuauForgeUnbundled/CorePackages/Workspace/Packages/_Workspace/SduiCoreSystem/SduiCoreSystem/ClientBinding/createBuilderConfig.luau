require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/getPropBuilder")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local addSduiErrorContextFields = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/addSduiErrorContextFields")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local fFlagSduiSharedLocalizedLiterals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiSharedLocalizedLiterals
local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

local function getLocalizedLiteralResolver(p2, p3, callback)
	return function(data, p4)
		if typeof(data) == "table" and data.map_key then
			local map_key = data.map_key

			local v5 = if fFlagSduiSharedLocalizedLiterals then callback(map_key) else p2 and p2[map_key]

			if v5 ~= nil then
				return v5
			end

			local v6 = {
				message = `Could not find localized literal for mapKey: {tostring(map_key)}, namespace: {data.namespace}, key: {data.key}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v6, p3)

			return v5
		else
			local v5 = {
				message = `Invalid translationRef: expected table with map_key, got {typeof(data)}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v5, p4)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v5, p3)
			return nil
		end
	end
end

local function createBuilderConfig(data)
	local builderConfig = {
		appPage = data.appPage,
		debugName = data.debugName,
		getTemplateForRobloxComponent = data.getTemplateForRobloxComponent,
		getTemplateIdForRCT = 0,
		getPropBuilder = 0,
		resolveLocalizedLiteral = 0,
		configKey = 0
	}
	local v5 = if fFlagSduiErrorPaths then data.getTemplateIdForRCT else nil
	builderConfig.getTemplateIdForRCT = v5

	builderConfig.getPropBuilder = module

	local localizedLiterals = data.localizedLiterals
	local appPage = data.appPage
	local getLocalizedLiteral = if fFlagSduiSharedLocalizedLiterals then data.getLocalizedLiteral else nil

	function builderConfig.resolveLocalizedLiteral(data2, p2)
		if typeof(data2) == "table" and data2.map_key then
			local map_key = data2.map_key
			local v6

			if fFlagSduiSharedLocalizedLiterals then
				v6 = getLocalizedLiteral(map_key)
			else
				v6 = localizedLiterals and localizedLiterals[map_key]
			end

			if v6 ~= nil then
				return v6
			end

			local v7 = {
				message = `Could not find localized literal for mapKey: {tostring(map_key)}, namespace: {data2.namespace}, key: {data2.key}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v7, p2)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v7, appPage)

			return v6
		else
			local v6 = {
				message = `Invalid translationRef: expected table with map_key, got {typeof(data2)}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v6, p2)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v6, appPage)
			return nil
		end
	end

	builderConfig.configKey = data.configKey
	return builderConfig
end

return createBuilderConfig
