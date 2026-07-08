local CorePackages = game:GetService("CorePackages")
local UGCValidationService = game:GetService("UGCValidationService")
local UGCValidation = require(CorePackages.Packages.UGCValidation)
local EngineFeature = game:GetEngineFeature("UGCValidationWithContextEntrypointFeature")
local v5 = game:DefineFastFlag("UGCValidateMigrateSchemaProperties2", false)
local v6 = game:DefineFastFlag("UGCValidateForwardIECRestrictedUserIds", false)

local function UGCValidationFunction(p1) -- line: 10
	-- upvalues: EngineFeature (copy), UGCValidation (copy), v5 (copy), v6 (copy)
	local instances = p1.instances
	local assetType = p1.assetType
	local isServer = p1.isServer
	local fullBodyData = p1.fullBodyData
	local allowUnreviewedAssets = p1.allowUnreviewedAssets
	local restrictedUserIds = p1.restrictedUserIds
	local token = p1.token
	local universeId = p1.universeId
	local requireAllFolders = p1.requireAllFolders
	local t1 = {
		skipSnapshot = true,
		skipPhysicsDataReset = true,
		skipValidateHSR = true
	}
	local v22, v23

	if EngineFeature then
		local t2 = {
			allowEditableInstances = true,
			shouldYield = true,
			validateMeshPartAccessories = true,
			instances = instances,
			assetTypeEnum = assetType,
			isServer = isServer,
			allowUnreviewedAssets = allowUnreviewedAssets,
			restrictedUserIds = restrictedUserIds,
			token = token,
			universeId = universeId,
			requireAllFolders = requireAllFolders,
			bypassFlags = t1
		}
		local t3 = {
			allowEditableInstances = true,
			shouldYield = true,
			validateMeshPartAccessories = false,
			fullBodyData = fullBodyData,
			isServer = isServer,
			bypassFlags = t1,
			requireAllFolders = requireAllFolders
		}

		if fullBodyData then
			v22, v23 = UGCValidation.validateFullBodyWithContext(t3)
		else
			v22, v23 = UGCValidation.validateWithContext(t2)
		end
	elseif fullBodyData then
		v22, v23 = UGCValidation.validateFullBody(fullBodyData, isServer, true, t1, true, requireAllFolders)
	else
		v22, v23 = UGCValidation.validate(instances, assetType, isServer, allowUnreviewedAssets, restrictedUserIds, token, universeId, true, t1, true, true, requireAllFolders)
	end

	if UGCValidation.isFolderStructureEnabled and UGCValidation.isFolderStructureEnabled() then
		local t4 = {
			source = not isServer and "InExpClient" or "InExpServer",
			enforceR15FolderStructure = requireAllFolders or false,
			iecConfigs = if not v5 then nil else {
				token = token,
				universeId = universeId,
				restrictedUserIds = if not v6 then nil else restrictedUserIds
			}
		}
		local v25 = if not fullBodyData then UGCValidation.ValidateAsset(instances, assetType, t4) else UGCValidation.ValidateFinalizedBundle(fullBodyData, Enum.BundleType.BodyParts, t4)

		if UGCValidation.isEntrypointMergingEnabled and UGCValidation.isEntrypointMergingEnabled() then
			v22, v23 = UGCValidation.combineResultsIntoLegacy(v22, v23, v25)
		end
	end

	if not v22 then
		return false, v23
	end

	return true, { "Success" }
end
local function Install() -- line: 126
	-- upvalues: UGCValidationService (copy), UGCValidationFunction (copy)
	UGCValidationService:RegisterUGCValidationFunction(UGCValidationFunction)
end

return Install
