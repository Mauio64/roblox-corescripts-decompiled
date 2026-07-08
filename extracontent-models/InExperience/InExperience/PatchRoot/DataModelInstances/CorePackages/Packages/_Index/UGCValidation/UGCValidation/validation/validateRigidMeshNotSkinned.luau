local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)
local UGCValidationService = game:GetService("UGCValidationService")

local function validateRigidMeshNotSkinned(s1: string?, p1) -- line: 13
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	local v8, v9 = pcallDeferred(function() -- line: 17
		-- upvalues: UGCValidationService (copy), s1 (copy)
		return UGCValidationService:DoesMeshHaveSkinningData(s1)
	end, p1)

	if not v8 then
		Analytics.reportFailure(Analytics.ErrorType.validateRigidMeshSkinning_FailedToDownload, nil, p1)

		return false, { "Could not verify underlying mesh data. Please try again or make a bug report." }
	end

	if v9 then
		Analytics.reportFailure(Analytics.ErrorType.validateRigidMeshSkinning_BonesFoundInMesh, nil, p1)

		return false, { "This accessory mesh has underlying skinning data, which is not supported for rigid accessories. Ensure that you are not importing bones when loading the mesh into Studio." }
	end

	return true
end

return validateRigidMeshNotSkinned
