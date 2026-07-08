local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationManager = require(ParentParent.validationSystem.ValidationManager)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local t1 = {
	LegacyValidator = "LegacyValidator"
}

local function fallbackLocalizationFunction(p1, t2: {[any]: any}?) -- line: 15
	-- upvalues: ErrorSourceStrings (copy)
	local v11 = if not t2 then nil else t2[p1.key]

	if v11 == nil then
		local parts = p1.key:split(".")
		local v13 = parts[#parts]

		v11 = ErrorSourceStrings.Values[v13]
	end

	if v11 == nil then
		return p1.key
	end

	local t3 = {}
	local t4 = nil

	for i = 1, #v11 do
		local v17 = string.sub(v11, i, i)

		if v17 == "{" then
			t4 = {}
		elseif v17 == "}" then
			if t4 ~= nil then
				local v18 = table.concat(t4)

				if p1.params[v18] ~= nil then
					table.insert(t3, (tostring(p1.params[v18])))
				end

				t4 = nil
			end
		elseif t4 ~= nil then
			table.insert(t4, v17)
		else
			table.insert(t3, v17)
		end
	end

	return table.concat(t3)
end

function t1.getPrecomputedEditables(p2, p3) -- line: 59
	local t5 = {
		{},
		{}
	}

	for v22, v23 in {
		p2,
		p3
	} do
		for v24, v25 in v23 do
			for v26, v27 in v25 do
				pcall(function() -- line: 68
					-- upvalues: v24 (copy), v26 (copy), t5 (copy), v22 (copy), v27 (copy)
					local v71 = v24[v26]

					if v71 ~= nil and v71 ~= "" then
						t5[v22][v71] = v27.instance
					end
				end)
			end
		end
	end

	return t5[1], t5[2]
end

local function fetchString(p4: ((...any) -> ...any)?, p5, t6: {[any]: any}?) -- line: 81
	-- upvalues: t1 (copy), fallbackLocalizationFunction (copy)
	if p5.key == t1.LegacyValidator then
		return p5.params.Message or ""
	end

	local ok = nil
	local result = nil

	if p4 then
		ok, result = pcall(function() -- line: 92
			-- upvalues: p4 (copy), p5 (copy)
			return p4(p5)
		end)
	end

	if ok and result ~= p5.key then
		return result
	end

	return fallbackLocalizationFunction(p5, t6)
end

function t1.combineResultsIntoLegacy(b1: boolean, t7: {[any]: any}?, p6, p7: ((...any) -> ...any)?) -- line: 105
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), fetchString (copy), ErrorSourceStrings (copy)
	local v37 = b1 and p6.pass

	if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
		if next(p6.failureMap) ~= nil then
			if t7 == nil then
				t7 = {}
			end

			for _, v39 in p6.failureMap do
				for _, v41 in v39 do
					table.insert(t7, fetchString(p7, {
						key = v41.failureStringKey,
						params = v41.failureStringParams
					}, p6.relevantSourceStrings))
				end
			end
		end
	else
		local errorTranslationContexts = p6.errorTranslationContexts

		if errorTranslationContexts and #errorTranslationContexts > 0 then
			if t7 == nil then
				t7 = {}
			end

			for _, v44 in errorTranslationContexts do
				table.insert(t7, fetchString(p7, v44))
			end
		end
	end

	if not v37 and (t7 == nil or #t7 == 0) then
		if t7 == nil then
			t7 = {}
		end

		if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
			table.insert(t7, fetchString(p7, {
				key = ErrorSourceStrings.Keys.InternalError,
				params = {
					ValidationJobId = p6.validationJobId
				}
			}, p6.relevantSourceStrings))

			return v37, t7
		end

		table.insert(t7, fetchString(p7, {
			key = ErrorSourceStrings.Keys.FailureWithoutReason,
			params = {}
		}))
	end

	return v37, t7
end
function t1.mergeLegacyIntoModern(b2: boolean, t8: {[any]: any}?, p8) -- line: 172
	-- upvalues: getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), t1 (copy)
	assert(getEngineFeatureEngineUGCValidationExpandReturnSchema(), "mergeLegacyIntoModern requires EngineUGCValidationExpandReturnSchema")
	p8.pass = p8.pass and b2

	if t8 and #t8 > 0 then
		local t9 = {}

		for _, v50 in t8 do
			if v50 ~= "" then
				table.insert(t9, {
					instancePath = "",
					failureStringKey = t1.LegacyValidator,
					failureStringParams = {
						Message = v50
					}
				})
			end
		end

		if #t9 > 0 then
			p8.failureMap[t1.LegacyValidator] = t9
			p8.numFailures = p8.numFailures + #t9
		end
	end
end
function t1.studioRFUAssetValidation(p9, s1: string, b3: boolean, t10: {[any]: any}?) -- line: 204
	-- upvalues: t1 (copy), ValidationManager (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local s2 = "Toolbox"
	local v56 = not not p9.bypassFlags and (p9.bypassFlags.enforceShadowValidations or false)

	if p9.bypassFlags and p9.bypassFlags.studioPluginName then
		s2 = p9.bypassFlags.studioPluginName
	end

	local v57, v58 = t1.getPrecomputedEditables(p9.editableMeshes or {}, p9.editableImages or {})
	local v59 = ValidationManager.ValidateAsset(p9.instances, p9.assetTypeEnum, {
		source = s2,
		enforceR15FolderStructure = p9.requireAllFolders or false,
		enforceShadowValidations = v56,
		telemetryBundleId = s1,
		preloadedEditableMeshes = v57,
		preloadedEditableImages = v58,
		backendConfigs = if not p9.restrictedUserIds then nil else {
			restrictedUserIds = p9.restrictedUserIds
		},
		iecConfigs = if not p9.token then nil else {
			token = p9.token,
			universeId = p9.universeId
		}
	})

	if getFFlagUGCValidationCombineEntrypointResults() then
		return t1.combineResultsIntoLegacy(b3, t10, v59, if p9.bypassFlags == nil then nil else p9.bypassFlags.localizationCallback)
	end

	return b3, t10
end
function t1.studioRFUBundleValidation(p10, p11, p12, s3: string, b4: boolean, t11: {[any]: any}?) -- line: 257
	-- upvalues: t1 (copy), ValidationManager (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local s4 = "Toolbox"

	if p12.bypassFlags and p12.bypassFlags.studioPluginName then
		s4 = p12.bypassFlags.studioPluginName
	end

	local v67 = not not p12.bypassFlags and (p12.bypassFlags.enforceShadowValidations or false)
	local v68, v69 = t1.getPrecomputedEditables(p12.editableMeshes or {}, p12.editableImages or {})
	local v70 = ValidationManager.ValidateFinalizedBundle(p10, p11, {
		source = s4,
		enforceR15FolderStructure = p12.requireAllFolders or false,
		enforceShadowValidations = v67,
		telemetryBundleId = s3,
		preloadedEditableMeshes = v68,
		preloadedEditableImages = v69,
		backendConfigs = if not p12.restrictedUserIds then nil else {
			restrictedUserIds = p12.restrictedUserIds
		},
		iecConfigs = if not p12.token then nil else {
			token = p12.token,
			universeId = p12.universeId
		}
	})

	if getFFlagUGCValidationCombineEntrypointResults() then
		assert(p12.bypassFlags)
		assert(p12.bypassFlags.localizationCallback)

		return t1.combineResultsIntoLegacy(b4, t11, v70, if p12.bypassFlags == nil then nil else p12.bypassFlags.localizationCallback)
	end

	return b4, t11
end

return t1
