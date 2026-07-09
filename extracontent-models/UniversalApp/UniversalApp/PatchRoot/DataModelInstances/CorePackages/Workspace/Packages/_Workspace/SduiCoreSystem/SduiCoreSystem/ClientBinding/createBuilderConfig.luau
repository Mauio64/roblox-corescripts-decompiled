local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)

local getPropBuilder = require(SduiCoreSystem.ClientBinding.PropBuilder.getPropBuilder)

require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiExperienceDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiEventDetailsSupport

local function getLocalizedLiteralResolver(t1: {[any]: any}?, s1: string) -- line: 17
	-- upvalues: SduiLogger (copy), SduiErrors (copy)
	return function(t2: {[any]: any}?) -- line: 18
		-- upvalues: SduiLogger (copy), SduiErrors (copy), s1 (copy), t1 (copy)
		if typeof(t2) ~= "table" or not t2.map_key then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Invalid translationRef: expected table with map_key, got { typeof(t2) }`
			}, s1)

			return nil
		end

		local map_key = t2.map_key
		local v20 = t1 and t1[map_key]

		if v20 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
				message = `Could not find localized literal for mapKey: { tostring(map_key) }, namespace: { t2.namespace }, key: { t2.key }`
			}, s1)
		end

		return v20
	end
end
local function createBuilderConfig(t3: {[any]: any}) -- line: 50
	-- upvalues: getPropBuilder (copy), FFlagSduiLocalizedLiterals (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagSduiEventDetailsSupport (copy)
	local t4 = {
		appPage = t3.appPage,
		debugName = t3.debugName,
		getTemplateForRobloxComponent = t3.getTemplateForRobloxComponent,
		getPropBuilder = getPropBuilder
	}
	local v17

	if FFlagSduiLocalizedLiterals then
		local localizedLiterals = t3.localizedLiterals
		local appPage = t3.appPage

		function v17(t5: {[any]: any}?) -- line: 18
			-- upvalues: SduiLogger (copy), SduiErrors (copy), appPage (copy), localizedLiterals (copy)
			if typeof(t5) ~= "table" or not t5.map_key then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
					message = `Invalid translationRef: expected table with map_key, got { typeof(t5) }`
				}, appPage)

				return nil
			end

			local map_key = t5.map_key
			local v23 = localizedLiterals and localizedLiterals[map_key]

			if v23 == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToResolveLocalizedLiteral, {
					message = `Could not find localized literal for mapKey: { tostring(map_key) }, namespace: { t5.namespace }, key: { t5.key }`
				}, appPage)
			end

			return v23
		end
	else
		v17 = nil
	end

	t4.resolveLocalizedLiteral = v17
	t4.configKey = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else t3.configKey

	return t4
end

return createBuilderConfig
