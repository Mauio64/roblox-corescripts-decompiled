local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

local function validateMeshTriangles(p1, n1: number?, p2) -- line: 12
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Constants (copy), Analytics (copy)
	local isServer = p2.isServer
	local v11, v12 = pcallDeferred(function() -- line: 19
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableMeshTriCount(p1.editableMesh)
	end, p2)

	if n1 == nil then
		n1 = Constants.MAX_HAT_TRIANGLES
	end

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangles_FailedToLoadMesh, nil, p2)

		if isServer ~= nil and isServer then
			error(string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p1.fullName))
		end

		return false, { string.format("Failed to load model mesh %s. Make sure the mesh exists and try again.", p1.fullName) }
	end

	if n1 < v12 then
		Analytics.reportFailure(Analytics.ErrorType.validateMeshTriangles_TooManyTriangles, nil, p2)

		return false, { string.format("Model mesh %s resolution of %d is higher than max support value of %d. You need to retopologize your model and try again.", p1.fullName, v12, n1) }
	end

	return true
end

return validateMeshTriangles
