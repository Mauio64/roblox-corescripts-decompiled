local ParentParent = script.Parent.Parent
local UGCValidationService = game:GetService("UGCValidationService")
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util
local Constants = require(ParentParent.Constants)

require(util.Types)

local pcallDeferred = require(util.pcallDeferred)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)
local getFFlagUGCValidationEnableR15plusSkinning = require(ParentParent.flags.getFFlagUGCValidationEnableR15plusSkinning)
local t1 = {
	validateMeshPart = function(p1, p2) -- line: 22
		-- upvalues: getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning (copy), getFFlagUGCValidationEnableR15plusSkinning (copy), getEditableMeshFromContext (copy), Analytics (copy), pcallDeferred (copy), UGCValidationService (copy), Constants (copy)
		if getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() and getFFlagUGCValidationEnableR15plusSkinning() then
			error("ValidateMeshPartOnlySkinnedToR15 is deprecated. Use RigidSkinnedToSchema / LCSkinnedToSchema / BodySkinnedToSchema instead.")
		end

		local v13, v14 = getEditableMeshFromContext(p1, "MeshId", p2)

		if not v13 then
			Analytics.reportFailure(Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_FailedToFetchSkinning, nil, p2)

			return false, { `Could not get editable mesh data for { p1 }. Please retry later or make a bug report.` }
		end

		local v15, v16 = pcallDeferred(function() -- line: 46
			-- upvalues: UGCValidationService (copy), v14 (copy)
			return { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(v14) }
		end, p2)

		if not v15 then
			Analytics.reportFailure(Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_FailedToFetchSkinning, nil, p2)

			return false, { `Could not get skinning data for { p1 }. Please retry later or make a bug report.` }
		end

		for _, v18 in v16 do
			if Constants.R15_STANDARD_JOINT_NAMES[v18] == nil then
				Analytics.reportFailure(Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_BodyIsSkinnedToFakeJoints, nil, p2)

				return false, { `{ p1 } is skinned to a non-standard joint { v18 }. This part may only be skinned to standard R15 joints.` }
			end
		end

		return true
	end
}

function t1.validateBodyParts(p3, p4) -- line: 76
	-- upvalues: getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning (copy), getFFlagUGCValidationEnableR15plusSkinning (copy), Constants (copy), t1 (copy)
	if getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning() and getFFlagUGCValidationEnableR15plusSkinning() then
		error("ValidateMeshPartOnlySkinnedToR15 is deprecated. Use RigidSkinnedToSchema / LCSkinnedToSchema / BodySkinnedToSchema instead.")
	end

	for _, v22 in Constants.R15_BODY_PARTS do
		local v23 = p3:FindFirstChild(v22)

		if not v23 then
			continue
		end

		local v24, v25 = t1.validateMeshPart(v23, p4)

		if not v24 then
			return v24, v25
		end
	end

	return true
end

return t1
