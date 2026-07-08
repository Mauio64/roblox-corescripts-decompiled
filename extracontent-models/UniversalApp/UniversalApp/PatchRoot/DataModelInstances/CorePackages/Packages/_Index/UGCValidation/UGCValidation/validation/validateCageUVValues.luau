local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local Analytics = require(ParentParent.Analytics)
local UGCValidationService = game:GetService("UGCValidationService")

local function validateCageUVValues(p1, p2, p3) -- line: 19
	-- upvalues: WrapTargetCageUVReferenceValues (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local timestamp = tick()
	local isServer = p3.isServer
	local v12 = assert(WrapTargetCageUVReferenceValues[p2.Parent.Name], "WrapTarget is not parented to a MeshPart")
	local v13, v14 = pcallDeferred(function() -- line: 32
		-- upvalues: UGCValidationService (copy), v12 (copy), p1 (copy)
		return UGCValidationService:ValidateEditableMeshUVValuesInReference(v12, p1.editableMesh)
	end, p3)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateCageUVValues_FailedToLoadMesh, nil, p3)

		local v15 = string.format("Failed to load UVs for '%s'. Make sure the UV map exists and try again.", p2:GetFullName())

		if isServer then
			error(v15)
		end

		return false, { v15 }
	end

	if not v14 then
		Analytics.reportFailure(Analytics.ErrorType.validateCageUVValues_UnexpectedUVValue, nil, p3)

		return false, { string.format("Found invalid UV value outside [0, 1] range for '%s'. You need to edit the UV map to fix this issue.", p2:GetFullName()) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p3)

	return true
end

return validateCageUVValues
