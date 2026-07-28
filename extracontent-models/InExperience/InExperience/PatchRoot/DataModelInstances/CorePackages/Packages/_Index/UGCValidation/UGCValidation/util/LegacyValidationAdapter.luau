local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local ValidationManager = require(ParentParent.validationSystem.ValidationManager)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local t1 = {
	LegacyValidator = "LegacyValidator"
}

local function fallbackLocalizationFunction(p1, t2: {[any]: any}?) -- line: 13
	-- upvalues: ErrorSourceStrings (copy)
	local v10 = if not t2 then nil else t2[p1.key]

	if v10 == nil then
		local parts = p1.key:split(".")
		local v12 = parts[#parts]

		v10 = ErrorSourceStrings.Values[v12]
	end

	if v10 == nil then
		return p1.key
	end

	local t3 = {}
	local t4 = nil

	for i = 1, #v10 do
		local v16 = string.sub(v10, i, i)

		if v16 == "{" then
			t4 = {}
		elseif v16 == "}" then
			if t4 ~= nil then
				local v17 = table.concat(t4)

				if p1.params[v17] ~= nil then
					table.insert(t3, (tostring(p1.params[v17])))
				end

				t4 = nil
			end
		elseif t4 ~= nil then
			table.insert(t4, v16)
		else
			table.insert(t3, v16)
		end
	end

	return table.concat(t3)
end

function t1.getPrecomputedEditables(p2, p3) -- line: 57
	local t5 = {
		{},
		{}
	}

	for v21, v22 in {
		p2,
		p3
	} do
		for v23, v24 in v22 do
			for v25, v26 in v24 do
				pcall(function() -- line: 66
					-- upvalues: v23 (copy), v25 (copy), t5 (copy), v21 (copy), v26 (copy)
					local v67 = v23[v25]

					if v67 ~= nil and v67 ~= "" then
						t5[v21][v67] = v26.instance
					end
				end)
			end
		end
	end

	return t5[1], t5[2]
end

local function fetchString(p4: ((...any) -> ...any)?, p5, t6: {[any]: any}?) -- line: 79
	-- upvalues: t1 (copy), fallbackLocalizationFunction (copy)
	if p5.key == t1.LegacyValidator then
		return p5.params.Message or ""
	end

	local ok = nil
	local result = nil

	if p4 then
		ok, result = pcall(function() -- line: 90
			-- upvalues: p4 (copy), p5 (copy)
			return p4(p5)
		end)
	end

	if ok and result ~= p5.key then
		return result
	end

	return fallbackLocalizationFunction(p5, t6)
end

function t1.combineResultsIntoLegacy(b1: boolean, t7: {[any]: any}?, p6, p7: ((...any) -> ...any)?) -- line: 103
	-- upvalues: fetchString (copy), ErrorSourceStrings (copy)
	local v36 = b1 and p6.pass

	if next(p6.failureMap) ~= nil then
		if t7 == nil then
			t7 = {}
		end

		for _, v38 in p6.failureMap do
			for _, v40 in v38 do
				table.insert(t7, fetchString(p7, {
					key = v40.failureStringKey,
					params = v40.failureStringParams
				}, p6.relevantSourceStrings))
			end
		end
	end

	if not v36 and (t7 == nil or #t7 == 0) then
		if t7 == nil then
			t7 = {}
		end

		table.insert(t7, fetchString(p7, {
			key = ErrorSourceStrings.Keys.InternalError,
			params = {
				ValidationJobId = p6.validationJobId
			}
		}, p6.relevantSourceStrings))
	end

	return v36, t7
end
function t1.mergeLegacyIntoModern(b2: boolean, t8: {[any]: any}?, p8) -- line: 147
	-- upvalues: t1 (copy)
	p8.pass = p8.pass and b2

	if t8 and #t8 > 0 then
		local t9 = {}

		for _, v46 in t8 do
			if v46 ~= "" then
				table.insert(t9, {
					instancePath = "",
					failureStringKey = t1.LegacyValidator,
					failureStringParams = {
						Message = v46
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
function t1.studioRFUAssetValidation(p9, s1: string, b3: boolean, t10: {[any]: any}?) -- line: 174
	-- upvalues: t1 (copy), ValidationManager (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local s2 = "Toolbox"
	local v52 = not not p9.bypassFlags and (p9.bypassFlags.enforceShadowValidations or false)

	if p9.bypassFlags and p9.bypassFlags.studioPluginName then
		s2 = p9.bypassFlags.studioPluginName
	end

	local v53, v54 = t1.getPrecomputedEditables(p9.editableMeshes or {}, p9.editableImages or {})
	local v55 = ValidationManager.ValidateAsset(p9.instances, p9.assetTypeEnum, {
		source = s2,
		enforceR15FolderStructure = p9.requireAllFolders or false,
		enforceShadowValidations = v52,
		telemetryBundleId = s1,
		preloadedEditableMeshes = v53,
		preloadedEditableImages = v54,
		backendConfigs = if not p9.restrictedUserIds then nil else {
			restrictedUserIds = p9.restrictedUserIds
		},
		iecConfigs = if not p9.token then nil else {
			token = p9.token,
			universeId = p9.universeId
		}
	})

	if getFFlagUGCValidationCombineEntrypointResults() then
		return t1.combineResultsIntoLegacy(b3, t10, v55, if p9.bypassFlags == nil then nil else p9.bypassFlags.localizationCallback)
	end

	return b3, t10
end
function t1.studioRFUBundleValidation(p10, p11, p12, s3: string, b4: boolean, t11: {[any]: any}?) -- line: 227
	-- upvalues: t1 (copy), ValidationManager (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local s4 = "Toolbox"

	if p12.bypassFlags and p12.bypassFlags.studioPluginName then
		s4 = p12.bypassFlags.studioPluginName
	end

	local v63 = not not p12.bypassFlags and (p12.bypassFlags.enforceShadowValidations or false)
	local v64, v65 = t1.getPrecomputedEditables(p12.editableMeshes or {}, p12.editableImages or {})
	local v66 = ValidationManager.ValidateFinalizedBundle(p10, p11, {
		source = s4,
		enforceR15FolderStructure = p12.requireAllFolders or false,
		enforceShadowValidations = v63,
		telemetryBundleId = s3,
		preloadedEditableMeshes = v64,
		preloadedEditableImages = v65,
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

		return t1.combineResultsIntoLegacy(b4, t11, v66, if p12.bypassFlags == nil then nil else p12.bypassFlags.localizationCallback)
	end

	return b4, t11
end

return t1
