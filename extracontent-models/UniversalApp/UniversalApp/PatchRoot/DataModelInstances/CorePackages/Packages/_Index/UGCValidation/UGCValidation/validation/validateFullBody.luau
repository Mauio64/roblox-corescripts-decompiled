local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local getFFlagUGCValidateLegFullBodySeparation = require(ParentParent.flags.getFFlagUGCValidateLegFullBodySeparation)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)

require(ParentParent.util.Types)

local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local validateWithSchema = require(ParentParent.util.validateWithSchema)
local validateAssetBounds = require(ParentParent.validation.validateAssetBounds)
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local ValidateBodyBlockingTests = require(ParentParent.util.ValidateBodyBlockingTests)
local ValidateAssetBodyPartCages = require(ParentParent.validation.ValidateAssetBodyPartCages)
local ValidateLegsSeparation = require(ParentParent.validation.ValidateLegsSeparation)
local createDynamicHeadMeshPartSchema = require(ParentParent.util.createDynamicHeadMeshPartSchema)
local createLimbsAndTorsoSchema = require(ParentParent.util.createLimbsAndTorsoSchema)
local resetPhysicsData = require(ParentParent.util.resetPhysicsData)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(ParentParent.flags.getFFlagDebugAllowHRDUploadOnBundleBackend)

local function getInstance(t1: {[any]: any}, s1: string) -- line: 33
	for _, v33 in t1 do
		if s1 == v33.Name then
			return v33
		end
	end

	return nil
end
local function validateAllAssetsWithSchema(p1, t2: {[any]: any}, p2) -- line: 44
	-- upvalues: validateSingleInstance (copy), validateWithSchema (copy), createDynamicHeadMeshPartSchema (copy), createLimbsAndTorsoSchema (copy)
	local g44 = nil
	local v43 = nil

	for _, v38 in p1 do
		if Enum.AssetType.DynamicHead == v38.assetTypeEnum then
			if not validateSingleInstance(v38.allSelectedInstances, p2) then
				return false
			end

			if validateWithSchema(createDynamicHeadMeshPartSchema(p2), v38.allSelectedInstances[1], p2).success then
				continue
			end

			return false
		end

		for _, v40 in t2 do
			for _, v42 in v38.allSelectedInstances do
				if v40 == v42.Name then
					v43 = v42
					g44 = true
				end

				if g44 then
					break
				end
			end

			if not g44 then
				v43 = nil
			end

			g44 = false

			if not v43 then
				return false
			end

			if not validateWithSchema(createLimbsAndTorsoSchema(v38.assetTypeEnum, v40, p2), v43, p2).success then
				return false
			end
		end
	end

	return true
end
local function validateCorrectAssetTypesExist(p3) -- line: 83
	-- upvalues: ConstantsInterface (copy)
	local t3 = {}
	local v47 = #ConstantsInterface.getBodyPartAssets()
	local n1 = 0

	for _, v50 in p3 do
		if not ConstantsInterface.isBodyPart(v50.assetTypeEnum) then
			return false
		end

		if t3[v50.assetTypeEnum] then
			return false
		end

		t3[v50.assetTypeEnum] = true
		n1 += 1
	end

	return n1 == v47
end
local function createAllBodyPartsTable(s2: string, p4) -- line: 101
	local t4 = {}
	local g59 = nil
	local v58 = nil

	for _, v55 in p4 do
		if Enum.AssetType.DynamicHead == v55.assetTypeEnum then
			t4[v55.allSelectedInstances[1].Name] = v55.allSelectedInstances[1]
		else
			for _, v57 in v55.allSelectedInstances do
				if s2 == v57.Name then
					v58 = v57
					g59 = true
				end

				if g59 then
					break
				end
			end

			if not g59 then
				v58 = nil
			end

			g59 = false

			for _, child in v58:GetChildren() do
				t4[child.Name] = child
			end
		end
	end

	return t4
end
local function validateMeshIds(p5, p6) -- line: 116
	-- upvalues: ParseContentIds (copy), Analytics (copy)
	local t5 = {
		MeshPart = { "MeshId" }
	}
	local t6 = {
		MeshPart = {
			MeshId = true
		}
	}

	for _, v67 in p5 do
		for _, v69 in v67.allSelectedInstances do
			if not ParseContentIds.parseWithErrorCheck({}, {}, v69, t5, t6, p6) then
				Analytics.reportFailure(Analytics.ErrorType.validateFullBody_MeshIdsMissing, nil, p6)

				return false, { "Unable to run full body validation due to previous errors detected while processing individual body parts" }
			end
		end
	end

	return true
end
local function validateInstanceHierarchy(p7, t7: {[any]: any}, p8) -- line: 153
	-- upvalues: validateCorrectAssetTypesExist (copy), Analytics (copy), validateAllAssetsWithSchema (copy), validateMeshIds (copy)
	local v73 = if not p8 then nil else p8.isServer

	if not validateCorrectAssetTypesExist(p7) then
		Analytics.reportFailure(Analytics.ErrorType.validateFullBody_IncorrectAssetTypeSet, nil, p8)

		if v73 then
			error("Full body check did not receive the correct set of body part Asset Types (i.e. Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg). Make sure the body model is valid and try again.")
		end

		return false, { "Full body check did not receive the correct set of body part Asset Types (i.e. Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg). Make sure the body model is valid and try again." }
	end

	if not validateAllAssetsWithSchema(p7, t7, p8) then
		Analytics.reportFailure(Analytics.ErrorType.validateFullBody_InstancesMissing, nil, p8)

		return false, { "Unable to run full body validation due to previous errors detected while processing individual body parts." }
	end

	local v74, v75 = validateMeshIds(p7, p8)

	if not v74 then
		return false, v75
	end

	return true
end
local function resetAllPhysicsData(p9) -- line: 187
	-- upvalues: resetPhysicsData (copy)
	for _, v78 in p9.fullBodyData do
		local v79, v80 = resetPhysicsData(v78.allSelectedInstances, p9)

		if not v79 then
			return false, { v80 }
		end
	end

	return true
end
local function validateFullBody(p10) -- line: 200
	-- upvalues: getFFlagDebugAllowHRDUploadOnBundleBackend (copy), R15plusUtils (copy), Constants (copy), validateInstanceHierarchy (copy), resetAllPhysicsData (copy), FailureReasonsAccumulator (copy), createAllBodyPartsTable (copy), getFFlagUGCValidateMigratePoseBlocking (copy), ValidateBodyBlockingTests (copy), Analytics (copy), getFFlagUGCValidateMigrateCageGeometry (copy), ValidateAssetBodyPartCages (copy), getFFlagUGCValidateMigrateBodyPartBounds (copy), validateAssetBounds (copy), getFFlagUGCValidateLegFullBodySeparation (copy), ValidateLegsSeparation (copy)
	assert(p10.fullBodyData ~= nil, "fullBodyData required in validationContext for validateFullBody")

	local fullBodyData = p10.fullBodyData
	local requireAllFolders = p10.requireAllFolders

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(p10.isBackendBundleUpload == true)
	end

	local t8 = { Constants.FOLDER_NAMES.R15ArtistIntent }

	if requireAllFolders then
		table.insert(t8, Constants.FOLDER_NAMES.R15Fixed)
	end

	local v85, v86 = validateInstanceHierarchy(fullBodyData, t8, p10)

	if not v85 then
		if getFFlagDebugAllowHRDUploadOnBundleBackend() then
			R15plusUtils.setIsBackendBundleUpload(false)
		end

		return false, v86
	end

	local v87, v88 = resetAllPhysicsData(p10)

	if not v87 then
		if getFFlagDebugAllowHRDUploadOnBundleBackend() then
			R15plusUtils.setIsBackendBundleUpload(false)
		end

		return false, v88
	end

	local v89 = FailureReasonsAccumulator.new()

	for _, v91 in t8 do
		local v92 = createAllBodyPartsTable(v91, fullBodyData)

		assert(v92)

		if not getFFlagUGCValidateMigratePoseBlocking() and not ValidateBodyBlockingTests.validateAll(v92, p10) then
			Analytics.reportFailure(Analytics.ErrorType.validateFullBody_ZeroMeshSize, nil, p10)

			if getFFlagDebugAllowHRDUploadOnBundleBackend() then
				R15plusUtils.setIsBackendBundleUpload(false)
			end

			return false, { "Unable to run full body validation due to previous errors detected while processing individual body parts." }
		end

		if not getFFlagUGCValidateMigrateCageGeometry() then
			v89:updateReasons(ValidateAssetBodyPartCages.validateFullBody(v92, p10))
		end

		if not getFFlagUGCValidateMigrateBodyPartBounds() then
			v89:updateReasons(validateAssetBounds(v92, nil, p10))
		end

		if not getFFlagUGCValidateMigratePoseBlocking() and getFFlagUGCValidateLegFullBodySeparation() then
			v89:updateReasons(ValidateLegsSeparation.validateFullBody(v92, p10))
		end
	end

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(false)
	end

	return v89:getFinalResults()
end

return validateFullBody
