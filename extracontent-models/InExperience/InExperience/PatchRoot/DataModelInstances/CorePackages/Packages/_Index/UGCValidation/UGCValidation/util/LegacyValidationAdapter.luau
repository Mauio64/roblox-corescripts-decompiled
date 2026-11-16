local parent = script.Parent.Parent
require(parent.util.Types)
local ValidationManager = require(parent.validationSystem.ValidationManager)

local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local LegacyValidationAdapter = {}
LegacyValidationAdapter.LegacyValidator = "LegacyValidator"

local function fallbackLocalizationFunction(p, p2)
	local v

	if p2 then
		v = p2[p.key]
	end

	if v == nil then
		local parts = p.key:split(".")
		local part = parts[#parts]
		v = ErrorSourceStrings.Values[part]
	end

	if v == nil then
		return p.key
	end

	local v2 = nil
	local v3 = {}

	for i = 1, #v do
		local v4 = string.sub(v, i, i)

		if v4 == "{" then
			v2 = {}
		elseif v4 == "}" then
			if v2 ~= nil then
				local joined = table.concat(v2)

				if p.params[joined] ~= nil then
					table.insert(v3, (tostring(p.params[joined])))
				end

				v2 = nil
			end
		elseif v2 == nil then
			table.insert(v3, v4)
		else
			table.insert(v2, v4)
		end
	end

	return table.concat(v3)
end

function LegacyValidationAdapter.getPrecomputedEditables(p, p2)
	local v = { {}, {} }

	for k, v2 in { p, p2 } do
		for k2, v3 in v2 do
			for k3, v4 in v3 do
				local v5 = k2
				local v6 = k3
				local v7 = v4
				pcall(function()
					local v8 = v5[v6]

					if v8 ~= nil and v8 ~= "" then
						v[k][v8] = v7.instance
					end
				end)
			end
		end
	end

	return v[1], v[2]
end

local function fetchString(callback, p, relevantSourceStrings)
	if p.key == LegacyValidationAdapter.LegacyValidator then
		return p.params.Message or ""
	end

	local success, result

	if callback then
		success, result = pcall(function()
			return callback(p)
		end)
	end

	if success and result ~= p.key then
		return result
	end

	return fallbackLocalizationFunction(p, relevantSourceStrings)
end

function LegacyValidationAdapter.combineResultsIntoLegacy(flag: boolean, list, data, callback)
	local pass = flag and data.pass

	if next(data.failureMap) ~= nil then
		list = list == nil and {} or list

		for _, failure in data.failureMap do
			for _, v in failure do
				table.insert(
					list,
					fetchString(
						callback,
						{ key = v.failureStringKey, params = v.failureStringParams },
						data.relevantSourceStrings
					)
				)
			end
		end
	end

	if not pass and (list == nil or #list == 0) then
		list = list == nil and {} or list

		table.insert(list, fetchString(callback, {
			key = ErrorSourceStrings.Keys.InternalError,
			params = { ValidationJobId = data.validationJobId }
		}, data.relevantSourceStrings))
	end

	return pass, list
end

function LegacyValidationAdapter.mergeLegacyIntoModern(flag: boolean, list, state)
	state.pass = state.pass and flag

	if list and #list > 0 then
		local failureStringEntries = {}

		for _, item in list do
			if item ~= "" then
				table.insert(failureStringEntries, {
					failureStringKey = LegacyValidationAdapter.LegacyValidator,
					failureStringParams = { Message = item },
					instancePath = ""
				})
			end
		end

		if #failureStringEntries > 0 then
			state.failureMap[LegacyValidationAdapter.LegacyValidator] = failureStringEntries
			state.numFailures += #failureStringEntries
		end
	end
end

function LegacyValidationAdapter.studioRFUAssetValidation(data, telemetryBundleId: string, flag: boolean, p)
	local source = "Toolbox"
	local enforceShadowValidations

	if data.bypassFlags then
		enforceShadowValidations = data.bypassFlags.enforceShadowValidations or false
	else
		enforceShadowValidations = false
	end

	if data.bypassFlags and data.bypassFlags.studioPluginName then
		source = data.bypassFlags.studioPluginName
	end

	local precomputedEditables, preloadedEditableImages = LegacyValidationAdapter.getPrecomputedEditables(
		data.editableMeshes or {},
		data.editableImages or {}
	)

	local v = ValidationManager.ValidateAsset(data.instances, data.assetTypeEnum, {
		source = source,
		enforceR15FolderStructure = data.requireAllFolders or false,
		enforceShadowValidations = enforceShadowValidations,
		telemetryBundleId = telemetryBundleId,
		preloadedEditableMeshes = precomputedEditables,
		preloadedEditableImages = preloadedEditableImages,
		backendConfigs = data.restrictedUserIds and { restrictedUserIds = data.restrictedUserIds } or nil,
		iecConfigs = data.token and { token = data.token, universeId = data.universeId } or nil
	})

	local combineResultsIntoLegacy = LegacyValidationAdapter.combineResultsIntoLegacy
	local v2

	if data.bypassFlags ~= nil then
		v2 = data.bypassFlags.localizationCallback
	end

	return combineResultsIntoLegacy(flag, p, v, v2)
end

function LegacyValidationAdapter.studioRFUBundleValidation(p, p2, data, telemetryBundleId: string, flag: boolean, p3)
	local source = not (data.bypassFlags and data.bypassFlags.studioPluginName) and "Toolbox"
		or data.bypassFlags.studioPluginName
	local enforceShadowValidations

	if data.bypassFlags then
		enforceShadowValidations = data.bypassFlags.enforceShadowValidations or false
	else
		enforceShadowValidations = false
	end

	local precomputedEditables, preloadedEditableImages = LegacyValidationAdapter.getPrecomputedEditables(
		data.editableMeshes or {},
		data.editableImages or {}
	)

	local v = ValidationManager.ValidateFinalizedBundle(p, p2, {
		source = source,
		enforceR15FolderStructure = data.requireAllFolders or false,
		enforceShadowValidations = enforceShadowValidations,
		telemetryBundleId = telemetryBundleId,
		preloadedEditableMeshes = precomputedEditables,
		preloadedEditableImages = preloadedEditableImages,
		backendConfigs = data.restrictedUserIds and { restrictedUserIds = data.restrictedUserIds } or nil,
		iecConfigs = data.token and { token = data.token, universeId = data.universeId } or nil
	})

	assert(data.bypassFlags)
	assert(data.bypassFlags.localizationCallback)
	local combineResultsIntoLegacy = LegacyValidationAdapter.combineResultsIntoLegacy
	local v2

	if data.bypassFlags ~= nil then
		v2 = data.bypassFlags.localizationCallback
	end

	return combineResultsIntoLegacy(flag, p3, v, v2)
end

return LegacyValidationAdapter
