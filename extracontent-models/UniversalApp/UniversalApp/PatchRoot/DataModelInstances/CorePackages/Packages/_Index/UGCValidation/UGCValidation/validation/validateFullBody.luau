local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)
local ConstantsInterface = require(parent.ConstantsInterface)

require(parent.util.Types)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local validateWithSchema = require(parent.util.validateWithSchema)

local validateSingleInstance = require(parent.validation.validateSingleInstance)

local createDynamicHeadMeshPartSchema = require(parent.util.createDynamicHeadMeshPartSchema)
local createLimbsAndTorsoSchema = require(parent.util.createLimbsAndTorsoSchema)
local resetPhysicsData = require(parent.util.resetPhysicsData)
local ParseContentIds = require(parent.util.ParseContentIds)
local R15plusUtils = require(parent.util.R15plusUtils)
local getFFlagDebugAllowHRDUploadOnBundleBackend = require(parent.flags.getFFlagDebugAllowHRDUploadOnBundleBackend)

local function getInstance(allSelectedInstances, p: string) -- 2 equivalent calls inferred from this helper
	for _, item in allSelectedInstances do
		if item.Name == p then
			return item
		end
	end

	return nil
end

local function validateAllAssetsWithSchema(items, items2, p): boolean
	for _, item in items do
		if Enum.AssetType.DynamicHead == item.assetTypeEnum then
			if not (validateSingleInstance(item.allSelectedInstances, p) and validateWithSchema(
				createDynamicHeadMeshPartSchema(p),
				item.allSelectedInstances[1],
				p
			).success) then
				return false
			end
		else
			for _, item2 in items2 do
				local instance = getInstance(item.allSelectedInstances, item2) -- inferred equivalent call

				if not (instance and validateWithSchema(
					createLimbsAndTorsoSchema(item.assetTypeEnum, item2, p),
					instance,
					p
				).success) then
					return false
				end
			end
		end
	end

	return true
end

local function validateCorrectAssetTypesExist(items): boolean
	local v = #ConstantsInterface.getBodyPartAssets()
	local assetTypeEnumSet = {}
	local count = 0

	for _, item in items do
		if not ConstantsInterface.isBodyPart(item.assetTypeEnum) or assetTypeEnumSet[item.assetTypeEnum] then
			return false
		end

		assetTypeEnumSet[item.assetTypeEnum] = true
		count += 1
	end

	return count == v
end

local function createAllBodyPartsTable(p: string, fullBodyData)
	local allBodyPartsTable = {}

	for _, item in fullBodyData do
		if Enum.AssetType.DynamicHead == item.assetTypeEnum then
			allBodyPartsTable[item.allSelectedInstances[1].Name] = item.allSelectedInstances[1]
		else
			local instance = getInstance(item.allSelectedInstances, p) -- inferred equivalent call

			for _, child in instance:GetChildren() do
				allBodyPartsTable[child.Name] = child
			end
		end
	end

	return allBodyPartsTable
end

local function validateMeshIds(items, p)
	local v = {
		MeshPart = { "MeshId" }
	}

	local v2 = {
		MeshPart = { MeshId = true }
	}

	for _, item in items do
		for _, allSelectedInstance in item.allSelectedInstances do
			if not ParseContentIds.parseWithErrorCheck({}, {}, allSelectedInstance, v, v2, p) then
				Analytics.reportFailure(Analytics.ErrorType.validateFullBody_MeshIdsMissing, nil, p)

				return
					false,
					{ "Unable to run full body validation due to previous errors detected while processing individual body parts" }
			end
		end
	end

	return true
end

local function validateInstanceHierarchy(fullBodyData, r15Fixeds, data)
	local isServer

	if data then
		isServer = data.isServer
	end

	if validateCorrectAssetTypesExist(fullBodyData) then
		if not validateAllAssetsWithSchema(fullBodyData, r15Fixeds, data) then
			Analytics.reportFailure(Analytics.ErrorType.validateFullBody_InstancesMissing, nil, data)

			return
				false,
				{ "Unable to run full body validation due to previous errors detected while processing individual body parts." }
		end

		local v, v2 = validateMeshIds(fullBodyData, data)

		if v then
			return true
		end

		return false, v2
	end

	Analytics.reportFailure(Analytics.ErrorType.validateFullBody_IncorrectAssetTypeSet, nil, data)

	if isServer then
		error("Full body check did not receive the correct set of body part Asset Types (i.e. Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg). Make sure the body model is valid and try again.")
	end

	return
		false,
		{ "Full body check did not receive the correct set of body part Asset Types (i.e. Head, Torso, LeftArm, RightArm, LeftLeg, RightLeg). Make sure the body model is valid and try again." }
end

local function resetAllPhysicsData(data)
	for _, v in data.fullBodyData do
		local v2, v3 = resetPhysicsData(v.allSelectedInstances, data)

		if not v2 then
			return false, { v3 }
		end
	end

	return true
end

local function validateFullBody(data)
	assert(data.fullBodyData ~= nil, "fullBodyData required in validationContext for validateFullBody")
	local fullBodyData = data.fullBodyData
	local requireAllFolders = data.requireAllFolders

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(data.isBackendBundleUpload == true)
	end

	local r15Fixeds = { Constants.FOLDER_NAMES.R15ArtistIntent }

	if requireAllFolders then
		table.insert(r15Fixeds, Constants.FOLDER_NAMES.R15Fixed)
	end

	local v, v2 = validateInstanceHierarchy(fullBodyData, r15Fixeds, data)

	if v then
		local v3, v4 = resetAllPhysicsData(data)

		if v3 then
			local v5 = FailureReasonsAccumulator.new()

			for _, v6 in r15Fixeds do
				assert(createAllBodyPartsTable(v6, fullBodyData))
			end

			if getFFlagDebugAllowHRDUploadOnBundleBackend() then
				R15plusUtils.setIsBackendBundleUpload(false)
			end

			return v5:getFinalResults()
		end

		if getFFlagDebugAllowHRDUploadOnBundleBackend() then
			R15plusUtils.setIsBackendBundleUpload(false)
		end

		return false, v4
	end

	if getFFlagDebugAllowHRDUploadOnBundleBackend() then
		R15plusUtils.setIsBackendBundleUpload(false)
	end

	return false, v2
end

return validateFullBody
