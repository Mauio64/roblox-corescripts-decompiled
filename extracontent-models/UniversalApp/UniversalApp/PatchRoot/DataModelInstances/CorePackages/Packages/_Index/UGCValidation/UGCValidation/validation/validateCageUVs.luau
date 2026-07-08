local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local getFIntUniqueUVTolerance = require(ParentParent.flags.getFIntUniqueUVTolerance)
local UGCValidationService = game:GetService("UGCValidationService")

local function validateCageUVs(p1, p2, p3) -- line: 17
	-- upvalues: Constants (copy), pcallDeferred (copy), UGCValidationService (copy), getFIntUniqueUVTolerance (copy), Analytics (copy)
	local timestamp = tick()
	local isServer = p3.isServer
	local v13 = assert(Constants.WRAP_TARGET_CAGE_MESH_UV_COUNTS[p2.Parent.Name], "WrapTarget is not parented to a MeshPart")
	local u14 = nil
	local v15, v16 = pcallDeferred(function() -- line: 34
		-- upvalues: u14 (ref), UGCValidationService (copy), p1 (copy), v13 (copy), getFIntUniqueUVTolerance (copy)
		u14 = UGCValidationService:CalculateEditableMeshUniqueUVCount(p1.editableMesh)

		return math.abs(u14 - v13) <= getFIntUniqueUVTolerance()
	end, p3)

	if not v15 then
		local v17 = string.format("Failed to execute UV check for '%s'. Make sure the UV map exists and try again.", p2:GetFullName())

		if isServer then
			error(v17)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateCageUVs_TestExecutedSuccessfully, nil, p3)

		return false, { v17 }
	end

	if not v16 then
		Analytics.reportFailure(Analytics.ErrorType.validateCageUVs_TestPassed, nil, p3)

		return false, { string.format("%s.%s ( %s ) should have %d unique UVs, but has %d. Please make sure the mesh has the required number of unique UVs and try again.", p2:GetFullName(), p1.fieldName, not p1.contentId and "" or p1.contentId, v13, u14) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p3)

	return true
end

return validateCageUVs
