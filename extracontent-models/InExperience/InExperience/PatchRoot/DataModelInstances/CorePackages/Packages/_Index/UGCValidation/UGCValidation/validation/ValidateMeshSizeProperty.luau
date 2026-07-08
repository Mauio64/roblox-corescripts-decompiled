local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util
local floatEquals = require(ParentParent.util.floatEquals)

require(util.Types)

local pcallDeferred = require(util.pcallDeferred)
local getMeshSize = require(util.getMeshSize)
local getEditableMeshFromContext = require(util.getEditableMeshFromContext)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local t1 = {}

local function reportFailure(s1: string, s2: string, p1, b1: boolean) -- line: 21
	-- upvalues: Analytics (copy)
	if b1 and (p1.isServer ~= nil and p1.isServer) then
		error(s1)
	end

	Analytics.reportFailure(s2, nil, p1)

	return false, { s1 }
end
local function vector3Equals(vector3: Vector3, vector3_2: Vector3) -- line: 40
	-- upvalues: floatEquals (copy)
	return floatEquals(vector3.X, vector3_2.X, 1E-05) and (floatEquals(vector3.Y, vector3_2.Y, 1E-05) and floatEquals(vector3.Z, vector3_2.Z, 1E-05))
end
local function calculateMeshSize(p2, p3) -- line: 45
	-- upvalues: getEditableMeshFromContext (copy), reportFailure (copy), Analytics (copy), pcallDeferred (copy), getMeshSize (copy)
	local t2 = {
		fieldName = "MeshId",
		fullName = p2:GetFullName(),
		contentId = p2.MeshId,
		context = p2.Name
	}
	local v24, v25 = getEditableMeshFromContext(p2, "MeshId", p3)

	if not v24 then
		return reportFailure(string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", p2.Name), Analytics.ErrorType.validateMeshSizeProperty_FailedToLoadMesh, p3, false)
	end

	t2.editableMesh = v25

	local v26, v27 = pcallDeferred(function() -- line: 68
		-- upvalues: getMeshSize (copy), t2 (copy)
		return getMeshSize(t2)
	end, p3)

	if not v26 then
		return reportFailure(string.format("Mesh for '%s' failed to load. Make sure the mesh exists and try again.", p2.Name), Analytics.ErrorType.validateMeshSizeProperty_FailedToLoadMesh, p3, true)
	end

	return true, nil, v27
end
local function validateInternal(p4, p5) -- line: 83
	-- upvalues: calculateMeshSize (copy), floatEquals (copy), reportFailure (copy), Analytics (copy)
	local timestamp = tick()
	local v31, v32, v33 = calculateMeshSize(p4, p5)

	if not v31 or not v33 then
		return v31, v32
	end

	local MeshSize = p4.MeshSize

	if not floatEquals(MeshSize.X, v33.X, 1E-05) or (not floatEquals(MeshSize.Y, v33.Y, 1E-05) or not floatEquals(MeshSize.Z, v33.Z, 1E-05)) then
		return reportFailure(string.format("Calculated mesh size for %s does not match MeshSize property value", p4.Name), Analytics.ErrorType.validateMeshSizeProperty_Mismatch, p5, false)
	end

	Analytics.recordScriptTime(script.Name, timestamp, p5)

	return true
end

function t1.validateSingleMeshPart(p6, p7) -- line: 107
	-- upvalues: validateInternal (copy)
	if p7.allowEditableInstances then
		return true
	end

	return validateInternal(p6, p7)
end
function t1.validateBodyAsset(p8, p9) -- line: 117
	-- upvalues: validateInternal (copy), Analytics (copy), FailureReasonsAccumulator (copy), Constants (copy)
	local timestamp = tick()

	if p9.allowEditableInstances then
		return true
	end

	local assetTypeEnum = p9.assetTypeEnum

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		local v41, v42 = validateInternal(p8, p9)

		Analytics.recordScriptTime(script.Name, timestamp, p9)

		return v41, v42
	end

	local v43 = FailureReasonsAccumulator.new()

	for v44 in Constants.ASSET_TYPE_INFO[assetTypeEnum].subParts do
		local v45 = p8:FindFirstChild(v44)

		assert(v45)
		v43:updateReasons(validateInternal(v45, p9))
	end

	Analytics.recordScriptTime(script.Name, timestamp, p9)

	return v43:getFinalResults()
end

return t1
