local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local validateMeshComparison = require(ParentParent.validation.validateMeshComparison)
local getMeshSize = require(ParentParent.util.getMeshSize)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local getMeshInfo = require(ParentParent.util.getMeshInfo)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)

local function validateWrapTargetComparison(vector3: Vector3, p1, p2) -- line: 21
	-- upvalues: getMeshInfo (copy), Constants (copy), validateMeshComparison (copy)
	local v18, v19, v20 = getMeshInfo(p1, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p2)

	if not v18 then
		return false, v19
	end

	local WrapTarget = p1:FindFirstChildWhichIsA("WrapTarget")

	assert(WrapTarget, "Missing WrapTarget child for " .. p1.Name)

	local v22, v23, v24 = getMeshInfo(WrapTarget, Constants.MESH_CONTENT_TYPE.OUTER_CAGE, p2)

	if not v22 then
		return false, v23
	end

	v20.scale = vector3
	v24.scale = vector3

	return validateMeshComparison(v20, v24, Constants.RenderVsWrapMeshMaxDiff, p2)
end
local function calculateMeshSize(p3, p4) -- line: 52
	-- upvalues: getEditableMeshFromContext (copy), pcallDeferred (copy), getMeshSize (copy), Analytics (copy)
	local t1 = {
		fieldName = "MeshId",
		fullName = p3:GetFullName(),
		contentId = p3.MeshId,
		context = p3.Name
	}
	local v28, v29 = getEditableMeshFromContext(p3, "MeshId", p4)

	if not v28 then
		return false, { string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", t1.fullName) }
	end

	t1.editableMesh = v29

	local v30, v31 = pcallDeferred(function() -- line: 76
		-- upvalues: getMeshSize (copy), t1 (copy)
		return getMeshSize(t1)
	end, p4)

	if not v30 then
		Analytics.reportFailure(Analytics.ErrorType.validateBodyPartMeshBounds_FailedToLoadMesh, nil, p4)

		if p4.isServer then
			error("Failed to read mesh")
		end

		return false, { "Failed to read mesh" }
	end

	return true, nil, v31
end
local function validateInternal(p5, p6) -- line: 94
	-- upvalues: calculateMeshSize (copy), getExpectedPartSize (copy), FailureReasonsAccumulator (copy), validateWrapTargetComparison (copy), Analytics (copy)
	local timestamp = tick()
	local v35, v36, v37 = calculateMeshSize(p5, p6)

	if not v35 or not v37 then
		return v35, v36
	end

	local v38 = getExpectedPartSize(p5, p6) / v37
	local v39 = FailureReasonsAccumulator.new()

	v39:updateReasons(validateWrapTargetComparison(v38, p5, p6))
	Analytics.recordScriptTime(script.Name, timestamp, p6)

	return v39:getFinalResults()
end
local function validateBodyPartMeshBounds(p7, p8) -- line: 115
	-- upvalues: Constants (copy), validateInternal (copy), FailureReasonsAccumulator (copy)
	local assetTypeEnum = p8.assetTypeEnum
	local v43 = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		return validateInternal(p7, p8)
	end

	local v44 = FailureReasonsAccumulator.new()

	for k in pairs(v43.subParts) do
		local k2 = p7:FindFirstChild(k)

		assert(k2)
		v44:updateReasons(validateInternal(k2, p8))
	end

	return v44:getFinalResults()
end

return validateBodyPartMeshBounds
