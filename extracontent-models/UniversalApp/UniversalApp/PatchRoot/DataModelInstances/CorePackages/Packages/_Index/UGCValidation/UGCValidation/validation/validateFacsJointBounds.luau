local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getFIntFacsJointMaximumDistRatioDirect = require(ParentParent.flags.getFIntFacsJointMaximumDistRatioDirect)
local getFIntFacsJointMaximumDistRatioAccumulated = require(ParentParent.flags.getFIntFacsJointMaximumDistRatioAccumulated)

require(ParentParent.util.Types)

local function validateFacsJointBounds(p1, p2) -- line: 10
	-- upvalues: pcallDeferred (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), Analytics (copy), getFIntFacsJointMaximumDistRatioDirect (copy), getFIntFacsJointMaximumDistRatioAccumulated (copy)
	local v11, v12 = pcallDeferred(function() -- line: 14
		-- upvalues: getEditableMeshFromContext (copy), p1 (copy), p2 (copy), UGCValidationService (copy)
		local v17, v18 = getEditableMeshFromContext(p1, "MeshId", p2)

		if not v17 then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:GetMaximalJointDistancesWithinFacs(v18)
	end, p2)

	if not v11 then
		Analytics.reportFailure(Analytics.ErrorType.validateFACSJointTransformsWithinBounds_Error, nil, p2)

		return false, { "Failed to validate facial animation joint bounds, please try again later" }
	end

	local v13, v14, v15, v16 = unpack(v12)

	if v13 > getFIntFacsJointMaximumDistRatioDirect() / 100 then
		return false, { `Head facial animation { v14 } results in joints being moved substantially outside of the head. Please edit your facial animations and try again.` }
	end

	if v15 > getFIntFacsJointMaximumDistRatioAccumulated() / 100 then
		return false, { `Head facial animations can be combined to extend the joint { v16 } far outside the head. Please edit your facial animations and try again.` }
	end

	return true
end

return validateFacsJointBounds
