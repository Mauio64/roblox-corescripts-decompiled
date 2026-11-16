local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getMeshMinMax = require(parent.util.getMeshMinMax)
local getMeshSize = require(parent.util.getMeshSize)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)
local getMeshInfo = require(parent.util.getMeshInfo)

local BodyMeshSizesConsistent = {}

BodyMeshSizesConsistent.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}

BodyMeshSizesConsistent.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadEnum,
	ValidationEnums.SharedDataMember.consumerConfig
}

BodyMeshSizesConsistent.conditionalData = {
	ValidationEnums.SharedDataMember.renderMeshesData,
	ValidationEnums.SharedDataMember.outerCagesData
}

BodyMeshSizesConsistent.expectedFailures = {}

local function calculateMeshSizeForPart(instance, p)
	local v = {
		fullName = instance:GetFullName(),
		fieldName = "MeshId",
		contentId = instance.MeshId,
		context = instance.Name
	}

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(instance, "MeshId", p)

	if not editableMeshFromContext then
		return false, nil
	end

	v.editableMesh = editableMesh

	return true, (getMeshSize(v))
end

local function validateWrapTargetComparison(scale: Vector3, instance, p, object)
	local meshInfo, _, v = getMeshInfo(instance, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p)

	if not meshInfo then
		object:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
			meshName = instance:GetFullName()
		}, instance)
		return
	end

	local wrapTarget = instance:FindFirstChildWhichIsA("WrapTarget")

	if not wrapTarget then
		return
	end

	local meshInfo2, _, v2 = getMeshInfo(wrapTarget, Constants.MESH_CONTENT_TYPE.OUTER_CAGE, p)

	if not meshInfo2 then
		object:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
			meshName = wrapTarget:GetFullName()
		}, instance)
		return
	end

	v.scale = scale
	v2.scale = scale

	local renderVsWrapMeshMaxDiff = Constants.RenderVsWrapMeshMaxDiff

	local meshMinMax, _, v3, v4 = getMeshMinMax(v, p)

	if not meshMinMax then
		object:fetchError("Failed to read mesh: " .. v.fullName)
		return
	end

	local meshMinMax2, _, v5, v6 = getMeshMinMax(v2, p)

	if not meshMinMax2 then
		object:fetchError("Failed to read mesh: " .. v2.fullName)
	elseif renderVsWrapMeshMaxDiff < (v3 - v5).Magnitude or renderVsWrapMeshMaxDiff < (v4 - v6).Magnitude then
		local meshContext = v.fullName .. "." .. v.fieldName
		local otherMeshContext = v2.fullName .. "." .. v2.fieldName
		object:fail(
			ErrorSourceStrings.Keys.BodyMesh_SizeMismatch,
			{
				meshContext = meshContext,
				maxDiff = string.format("%.2f", renderVsWrapMeshMaxDiff),
				otherMeshContext = otherMeshContext
			},
			instance
		)
	end
end

function BodyMeshSizesConsistent.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType
	local isServer = data.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

	local editableMeshes = {}

	if data.renderMeshesData then
		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, descendant in descendants do
			local v = data.renderMeshesData[descendant.Name]

			if v and v.editable then
				editableMeshes[descendant] = {
					MeshId = { instance = v.editable, created = v.createdInValidation }
				}
			end
		end
	end

	if data.outerCagesData then
		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, baseWrap in descendants do
			if not (baseWrap:IsA("BaseWrap") and baseWrap.Parent) then
				continue
			end

			local v = data.outerCagesData[baseWrap.Parent.Name]

			if v and v.editable then
				editableMeshes[baseWrap] = {
					CageMeshId = { instance = v.editable, created = v.createdInValidation }
				}
			end
		end
	end

	local v = {
		assetTypeEnum = assetType,
		isServer = isServer,
		editableMeshes = editableMeshes,
		bypassFlags = { skipPhysicsDataReset = true }
	}

	local function validateSingleMeshPart(instance)
		local v2, v3 = calculateMeshSizeForPart(instance, v)

		if v2 and v3 then
			validateWrapTargetComparison(getExpectedPartSize(instance, v) / v3, instance, v, object)
		else
			object:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
				meshName = instance:GetFullName()
			}, instance)
		end
	end

	local v2 = Constants.ASSET_TYPE_INFO[assetType]

	if Enum.AssetType.DynamicHead == assetType then
		validateSingleMeshPart(rootInstance)
		return
	end

	if not v2 then
		return
	end

	for childName in pairs(v2.subParts) do
		local child = rootInstance:FindFirstChild(childName)

		if child then
			validateSingleMeshPart(child)
		end
	end
end

return BodyMeshSizesConsistent
