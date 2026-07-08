local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)

local function validateCageUVTriangleArea(p1, p2) -- line: 12
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local timestamp = tick()
	local isServer = p2.isServer
	local v10, v11 = pcallDeferred(function() -- line: 20
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:ValidateEditableMeshCageUVTriangleArea(p1.editableMesh)
	end, p2)

	if not v10 then
		if isServer then
			error(string.format("Failed to load UVs for '%s'. Make sure the model has a valid UV map and try again.", p1.fullName))
		end

		Analytics.reportFailure(Analytics.ErrorType.validateCageUVTriangleArea_FailedToLoadMesh, nil, p2)

		return false, { string.format("Failed to load UVs for '%s'. Make sure the model has a valid UV map and try again.", p1.fullName) }
	end

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateCageUVTriangleArea_ZeroAreaTriangle, nil, p2)

		return false, { string.format("Detected zero-area triangle in UV map of '%s'. You need to edit the UV map to fix this issue.", p1.fullName) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateCageUVTriangleArea
