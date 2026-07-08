local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local floatEquals = require(ParentParent.util.floatEquals)
local getMeshSize = require(ParentParent.util.getMeshSize)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = getFFlagUGCValidateMigrateBodyPartBounds,
	expectedFailures = {}
}

local function vector3Equals(vector3: Vector3, vector3_2: Vector3) -- line: 30
	-- upvalues: floatEquals (copy)
	return floatEquals(vector3.X, vector3_2.X, 1E-05) and (floatEquals(vector3.Y, vector3_2.Y, 1E-05) and floatEquals(vector3.Z, vector3_2.Z, 1E-05))
end
local function validateSingleMeshPart(p1, p2, p3) -- line: 35
	-- upvalues: getEditableMeshFromContext (copy), ErrorSourceStrings (copy), getMeshSize (copy), floatEquals (copy)
	local t2 = {
		fieldName = "MeshId",
		fullName = p1:GetFullName(),
		contentId = p1.MeshId,
		context = p1.Name
	}
	local v18, v19 = getEditableMeshFromContext(p1, "MeshId", p2)

	if not v18 then
		p3:fail(ErrorSourceStrings.Keys.MeshSize_LoadFailed, {
			meshName = p1.Name
		}, p1)

		return
	end

	t2.editableMesh = v19

	local v20 = getMeshSize(t2)
	local MeshSize = p1.MeshSize

	if not floatEquals(MeshSize.X, v20.X, 1E-05) or (not floatEquals(MeshSize.Y, v20.Y, 1E-05) or not floatEquals(MeshSize.Z, v20.Z, 1E-05)) then
		p3:fail(ErrorSourceStrings.Keys.MeshSize_Mismatch, {
			meshName = p1.Name
		}, p1)
	end
end

function t1.run(p4, p5) -- line: 58
	-- upvalues: ValidationEnums (copy), validateSingleMeshPart (copy), Constants (copy)
	local rootInstance = p5.rootInstance
	local assetType = p5.uploadEnum.assetType
	local consumerEnv = p5.consumerConfig.consumerEnv
	local v27 = consumerEnv == ValidationEnums.ConsumerEnv.Backend

	if consumerEnv == ValidationEnums.ConsumerEnv.IEC then
		return
	end

	local t3 = {}

	if p5.renderMeshesData then
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v31 in descendants do
			local v32 = p5.renderMeshesData[v31.Name]

			if v32 and v32.editable then
				t3[v31] = {
					MeshId = {
						created = false,
						instance = v32.editable
					}
				}
			end
		end
	end

	local t4 = {
		assetTypeEnum = assetType,
		isServer = v27,
		editableMeshes = t3
	}

	if assetType == Enum.AssetType.DynamicHead then
		validateSingleMeshPart(rootInstance, t4, p4)

		return
	end

	local v34 = Constants.ASSET_TYPE_INFO[assetType]

	if not v34 then
		return
	end

	for k in pairs(v34.subParts) do
		local k2 = rootInstance:FindFirstChild(k)

		if k2 then
			validateSingleMeshPart(k2, t4, p4)
		end
	end
end

return t1
