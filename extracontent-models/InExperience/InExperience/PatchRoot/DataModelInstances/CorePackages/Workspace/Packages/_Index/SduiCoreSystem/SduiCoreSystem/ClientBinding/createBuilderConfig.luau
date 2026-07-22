local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local getPropBuilder = require(SduiCoreSystem.ClientBinding.PropBuilder.getPropBuilder)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEventDetailsSupport

local function getLocalizedLiteralResolver(t1: {[any]: any}?, s1: string) -- line: 16
	-- upvalues: SduiLogger (copy), SduiErrors (copy)
	return function(t2: {[any]: any}?) -- line: 17
		-- upvalues: SduiLogger (copy), SduiErrors (copy), s1 (copy), t1 (copy)
		if typeof(t2) ~= "table" or not t2.map_key then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Invalid translationRef: expected table with map_key, got { typeof(t2) }`
			}, s1)

			return nil
		end

		local map_key = t2.map_key
		local v18 = t1 and t1[map_key]

		if v18 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Could not find localized literal for mapKey: { tostring(map_key) }, namespace: { t2.namespace }, key: { t2.key }`
			}, s1)
		end

		return v18
	end
end
local function createBuilderConfig(t3: {[any]: any}) -- line: 49
	-- upvalues: getPropBuilder (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
	local t4 = {
		appPage = t3.appPage,
		debugName = t3.debugName,
		getTemplateForRobloxComponent = t3.getTemplateForRobloxComponent,
		getPropBuilder = getPropBuilder
	}
	local localizedLiterals = t3.localizedLiterals
	local appPage = t3.appPage

	function t4.resolveLocalizedLiteral(t5: {[any]: any}?) -- line: 17
		-- upvalues: SduiLogger (copy), SduiErrors (copy), appPage (copy), localizedLiterals (copy)
		if typeof(t5) ~= "table" or not t5.map_key then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Invalid translationRef: expected table with map_key, got { typeof(t5) }`
			}, appPage)

			return nil
		end

		local map_key = t5.map_key
		local v21 = localizedLiterals and localizedLiterals[map_key]

		if v21 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Could not find localized literal for mapKey: { tostring(map_key) }, namespace: { t5.namespace }, key: { t5.key }`
			}, appPage)
		end

		return v21
	end

	t4.configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else t3.configKey

	return t4
end

return createBuilderConfig
