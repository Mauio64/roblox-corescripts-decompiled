local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local floatEquals = require(parent.util.floatEquals)
local getMeshSize = require(parent.util.getMeshSize)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local MeshSizePropertyCorrect = {}

MeshSizePropertyCorrect.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}

MeshSizePropertyCorrect.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadEnum,
	ValidationEnums.SharedDataMember.consumerConfig
}

MeshSizePropertyCorrect.conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData }

MeshSizePropertyCorrect.expectedFailures = {}

local function vector3Equals(meshSize: Vector3, meshSize2: Vector3) -- 1 equivalent call inferred from this helper
	return floatEquals(meshSize.X, meshSize2.X, 0.00001)
		and floatEquals(meshSize.Y, meshSize2.Y, 0.00001)
		and floatEquals(meshSize.Z, meshSize2.Z, 0.00001)
end

local function validateSingleMeshPart(instance, p, object)
	local v = {
		fullName = instance:GetFullName(),
		fieldName = "MeshId",
		contentId = instance.MeshId,
		context = instance.Name
	}

	local editableMeshFromContext, editableMesh = getEditableMeshFromContext(instance, "MeshId", p)

	if not editableMeshFromContext then
		object:fail(ErrorSourceStrings.Keys.MeshSize_LoadFailed, { meshName = instance.Name }, instance)
		return
	end

	v.editableMesh = editableMesh

	local meshSize = getMeshSize(v)

	if not vector3Equals(instance.MeshSize, meshSize) then -- inferred equivalent call
		object:fail(ErrorSourceStrings.Keys.MeshSize_Mismatch, { meshName = instance.Name }, instance)
	end
end

function MeshSizePropertyCorrect.run(p, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType

	local isServer = data.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

	if data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
		return
	end

	local editableMeshes = {}

	if data.renderMeshesData then
		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, descendant in descendants do
			local v = data.renderMeshesData[descendant.Name]

			if v and v.editable then
				editableMeshes[descendant] = {
					MeshId = { instance = v.editable, created = false }
				}
			end
		end
	end

	local v = { assetTypeEnum = assetType, isServer = isServer, editableMeshes = editableMeshes }

	if Enum.AssetType.DynamicHead == assetType then
		validateSingleMeshPart(rootInstance, v, p)
		return
	end

	local v2 = Constants.ASSET_TYPE_INFO[assetType]

	if not v2 then
		return
	end

	for childName in pairs(v2.subParts) do
		local child = rootInstance:FindFirstChild(childName)

		if child then
			validateSingleMeshPart(child, v, p)
		end
	end
end

return MeshSizePropertyCorrect
