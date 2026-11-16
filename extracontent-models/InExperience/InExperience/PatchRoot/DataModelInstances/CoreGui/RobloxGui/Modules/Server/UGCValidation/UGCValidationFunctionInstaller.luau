local CorePackages = game:GetService("CorePackages")
local UGCValidationService = game:GetService("UGCValidationService")
local UGCValidation = require(CorePackages.Packages.UGCValidation)

local engineFeature = game:GetEngineFeature("UGCValidationWithContextEntrypointFeature")
local defineFastFlag = game:DefineFastFlag("UGCValidateMigrateSchemaProperties2", false)
local defineFastFlag2 = game:DefineFastFlag("UGCValidateForwardIECRestrictedUserIds", false)

local function UGCValidationFunction(data)
	local instances = data.instances
	local assetType = data.assetType
	local isServer = data.isServer
	local fullBodyData = data.fullBodyData
	local allowUnreviewedAssets = data.allowUnreviewedAssets
	local restrictedUserIds = data.restrictedUserIds
	local token = data.token
	local universeId = data.universeId
	local requireAllFolders = data.requireAllFolders

	local bypassFlags = { skipSnapshot = true, skipPhysicsDataReset = true, skipValidateHSR = true }
	local v, v2

	if engineFeature then
		local v3 = {
			instances = instances,
			assetTypeEnum = assetType,
			isServer = isServer,
			allowUnreviewedAssets = allowUnreviewedAssets,
			restrictedUserIds = restrictedUserIds,
			token = token,
			universeId = universeId,
			allowEditableInstances = true,
			shouldYield = true,
			validateMeshPartAccessories = true,
			requireAllFolders = requireAllFolders,
			bypassFlags = bypassFlags
		}

		local v4 = {
			fullBodyData = fullBodyData,
			isServer = isServer,
			allowEditableInstances = true,
			bypassFlags = bypassFlags,
			shouldYield = true,
			requireAllFolders = requireAllFolders,
			validateMeshPartAccessories = false
		}

		if fullBodyData then
			v, v2 = UGCValidation.validateFullBodyWithContext(v4)
		else
			v, v2 = UGCValidation.validateWithContext(v3)
		end
	elseif fullBodyData then
		v, v2 = UGCValidation.validateFullBody(fullBodyData, isServer, true, bypassFlags, true, requireAllFolders)
	else
		v, v2 = UGCValidation.validate(
			instances,
			assetType,
			isServer,
			allowUnreviewedAssets,
			restrictedUserIds,
			token,
			universeId,
			true,
			bypassFlags,
			true,
			true,
			requireAllFolders
		)
	end

	local v3 = {
		source = isServer and "InExpServer" or "InExpClient",
		enforceR15FolderStructure = requireAllFolders or false,
		skipAssetQualityChecks = UGCValidation.shouldSkipAssetQualityChecks and UGCValidation.shouldSkipAssetQualityChecks() or nil,
		iecConfigs = 0
	}
	local iecConfigs

	if defineFastFlag then
		iecConfigs = { token = token, universeId = universeId, restrictedUserIds = 0 }

		if not defineFastFlag2 then
			restrictedUserIds = nil
		end

		iecConfigs.restrictedUserIds = restrictedUserIds
	end

	v3.iecConfigs = iecConfigs
	local v4

	if fullBodyData then
		v4 = UGCValidation.ValidateFinalizedBundle(fullBodyData, Enum.BundleType.BodyParts, v3)
	else
		v4 = UGCValidation.ValidateAsset(instances, assetType, v3)
	end

	local combineResultsIntoLegacy, v5 = UGCValidation.combineResultsIntoLegacy(v, v2, v4)

	if combineResultsIntoLegacy then
		return true, { "Success" }
	end

	return false, v5
end

local function Install()
	UGCValidationService:RegisterUGCValidationFunction(UGCValidationFunction)
end

return Install
