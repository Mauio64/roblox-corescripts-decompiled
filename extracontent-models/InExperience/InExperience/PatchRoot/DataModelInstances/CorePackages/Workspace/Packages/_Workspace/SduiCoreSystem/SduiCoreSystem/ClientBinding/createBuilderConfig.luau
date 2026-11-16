local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
require(parent.ServiceContractsProto)

local getPropBuilder = require(SduiCoreSystem.ClientBinding.PropBuilder.getPropBuilder)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local addSduiErrorContextFields = require(SduiCoreSystem.addSduiErrorContextFields)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSharedLocalizedLiterals = SharedFlags.FFlagSduiSharedLocalizedLiterals
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags2.FFlagSduiErrorPaths

local function getLocalizedLiteralResolver(localizedLiterals, appPage: string, callback) -- 1 equivalent call inferred from this helper
	return function(data, p)
		if typeof(data) == "table" and data.map_key then
			local map_key = data.map_key
			local v

			if FFlagSduiSharedLocalizedLiterals then
				v = callback(map_key)
			else
				v = localizedLiterals and localizedLiterals[map_key]
			end

			if v ~= nil then
				return v
			end

			local v2 = {
				message = `Could not find localized literal for mapKey: {tostring(map_key)}, namespace: {data.namespace}, key: {data.key}`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v2, p)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v2, appPage)

			return v
		else
			local v = {
				message = `Invalid translationRef: expected table with map_key, got {typeof(data)}`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v, p)
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, v, appPage)
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
	local getTemplateIdForRCT

	if FFlagSduiErrorPaths then
		getTemplateIdForRCT = data.getTemplateIdForRCT
	end

	builderConfig.getTemplateIdForRCT = getTemplateIdForRCT

	builderConfig.getPropBuilder = getPropBuilder

	local localizedLiterals = data.localizedLiterals
	local appPage = data.appPage
	local v

	if FFlagSduiSharedLocalizedLiterals then
		v = data.getLocalizedLiteral
	end

	builderConfig.resolveLocalizedLiteral = getLocalizedLiteralResolver(localizedLiterals, appPage, v) -- inferred equivalent call

	builderConfig.configKey = data.configKey
	return builderConfig
end

return createBuilderConfig
