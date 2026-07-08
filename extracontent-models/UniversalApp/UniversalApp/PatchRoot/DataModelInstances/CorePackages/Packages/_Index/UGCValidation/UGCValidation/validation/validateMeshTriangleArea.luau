local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)
local UGCValidationService = game:GetService("UGCValidationService")

local function validateMeshTriangleArea(p1, p2) -- line: 12
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local timestamp = tick()
	local v9 = if not p2 then nil else p2.isServer
	local v10, v11 = pcallDeferred(function() -- line: 20
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:ValidateEditableMeshTriangleArea(p1.editableMesh)
	end, p2)

	if not v10 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangleArea_FailedToLoadMesh, nil, p2)

		if v9 then
			error(string.format("Failed to load model mesh %s. Make sure mesh exists and try again.", p1.fullName))
		end

		return false, { string.format("Failed to load model mesh %s. Make sure mesh exists and try again.", p1.fullName) }
	end

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangleArea_NoArea, nil, p2)

		return false, { string.format("Detected zero-area triangle in model mesh %s. You need to edit the mesh to remove zero-area triangles.", p1.fullName) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateMeshTriangleArea
