local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getMeshMinMax = require(ParentParent.util.getMeshMinMax)
local getMeshSize = require(ParentParent.util.getMeshSize)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local getMeshInfo = require(ParentParent.util.getMeshInfo)
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
	conditionalData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.outerCagesData
	},
	fflag = getFFlagUGCValidateMigrateBodyPartBounds,
	expectedFailures = {}
}

local function calculateMeshSizeForPart(p1, p2) -- line: 33
	-- upvalues: getEditableMeshFromContext (copy), getMeshSize (copy)
	local t2 = {
		fieldName = "MeshId",
		fullName = p1:GetFullName(),
		contentId = p1.MeshId,
		context = p1.Name
	}
	local v17, v18 = getEditableMeshFromContext(p1, "MeshId", p2)

	if not v17 then
		return false, nil
	end

	t2.editableMesh = v18

	return true, (getMeshSize(t2))
end
local function validateWrapTargetComparison(vector3: Vector3, p3, p4, p5) -- line: 52
	-- upvalues: getMeshInfo (copy), Constants (copy), ErrorSourceStrings (copy), getMeshMinMax (copy)
	local v23, _, v25 = getMeshInfo(p3, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p4)

	if not v23 then
		p5:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
			meshName = p3:GetFullName()
		}, p3)

		return
	end

	local WrapTarget = p3:FindFirstChildWhichIsA("WrapTarget")

	if not WrapTarget then
		return
	end

	local v27, _, v29 = getMeshInfo(WrapTarget, Constants.MESH_CONTENT_TYPE.OUTER_CAGE, p4)

	if not v27 then
		p5:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
			meshName = WrapTarget:GetFullName()
		}, p3)

		return
	end

	v25.scale = vector3
	v29.scale = vector3

	local RenderVsWrapMeshMaxDiff = Constants.RenderVsWrapMeshMaxDiff
	local v31, _, v33, v34 = getMeshMinMax(v25, p4)

	if not v31 then
		p5:fetchError("Failed to read mesh: " .. v25.fullName)

		return
	end

	local v35, _, v37, v38 = getMeshMinMax(v29, p4)

	if not v35 then
		p5:fetchError("Failed to read mesh: " .. v29.fullName)

		return
	end

	if RenderVsWrapMeshMaxDiff < (v33 - v37).Magnitude or RenderVsWrapMeshMaxDiff < (v34 - v38).Magnitude then
		local v39 = v25.fullName .. "." .. v25.fieldName
		local v40 = v29.fullName .. "." .. v29.fieldName

		p5:fail(ErrorSourceStrings.Keys.BodyMesh_SizeMismatch, {
			meshContext = v39,
			maxDiff = string.format("%.2f", RenderVsWrapMeshMaxDiff),
			otherMeshContext = v40
		}, p3)
	end
end

function t1.run(p6, p7) -- line: 112
	-- upvalues: ValidationEnums (copy), calculateMeshSizeForPart (copy), ErrorSourceStrings (copy), getExpectedPartSize (copy), validateWrapTargetComparison (copy), Constants (copy)
	local rootInstance = p7.rootInstance
	local assetType = p7.uploadEnum.assetType
	local v45 = p7.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
	local t3 = {}

	if p7.renderMeshesData then
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v49 in descendants do
			local v50 = p7.renderMeshesData[v49.Name]

			if v50 and v50.editable then
				t3[v49] = {
					MeshId = {
						instance = v50.editable,
						created = v50.createdInValidation
					}
				}
			end
		end
	end

	if p7.outerCagesData then
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v53 in descendants do
			if v53:IsA("BaseWrap") and v53.Parent then
				local v54 = p7.outerCagesData[v53.Parent.Name]

				if v54 and v54.editable then
					t3[v53] = {
						CageMeshId = {
							instance = v54.editable,
							created = v54.createdInValidation
						}
					}
				end
			end
		end
	end

	local t4 = {
		assetTypeEnum = assetType,
		isServer = v45,
		editableMeshes = t3,
		bypassFlags = {
			skipPhysicsDataReset = true
		}
	}

	local function validateSingleMeshPart(p8) -- line: 156
		-- upvalues: calculateMeshSizeForPart (copy), t4 (copy), p6 (copy), ErrorSourceStrings (copy), getExpectedPartSize (copy), validateWrapTargetComparison (copy)
		local v61, v62 = calculateMeshSizeForPart(p8, t4)

		if not v61 or not v62 then
			p6:fail(ErrorSourceStrings.Keys.BodyMesh_LoadFailed, {
				meshName = p8:GetFullName()
			}, p8)

			return
		end

		local v63 = getExpectedPartSize(p8, t4) / v62

		validateWrapTargetComparison(v63, p8, t4, p6)
	end

	local v57 = Constants.ASSET_TYPE_INFO[assetType]

	if assetType == Enum.AssetType.DynamicHead then
		validateSingleMeshPart(rootInstance)

		return
	end

	if not v57 then
		return
	end

	for k in pairs(v57.subParts) do
		local k2 = rootInstance:FindFirstChild(k)

		if k2 then
			validateSingleMeshPart(k2)
		end
	end
end

return t1
