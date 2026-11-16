local parent = script.Parent.Parent

local UGCValidationService = game:GetService("UGCValidationService")
local Analytics = require(parent.Analytics)

local util = parent.util
local Constants = require(parent.Constants)
require(util.Types)
local pcallDeferred = require(util.pcallDeferred)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning = require(parent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning)
local getFFlagUGCValidationEnableR15plusSkinning = require(parent.flags.getFFlagUGCValidationEnableR15plusSkinning)

local ValidateMeshPartOnlySkinnedToR15 = {
	["validateMeshPart"] = nil,
	validateMeshPart = function(p, p2)
		if
			getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning()
			and getFFlagUGCValidationEnableR15plusSkinning()
		then
			error("ValidateMeshPartOnlySkinnedToR15 is deprecated. Use RigidSkinnedToSchema / LCSkinnedToSchema / BodySkinnedToSchema instead.")
		end

		local editableMeshFromContext, v = getEditableMeshFromContext(p, "MeshId", p2)

		if not editableMeshFromContext then
			Analytics.reportFailure(
				Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_FailedToFetchSkinning,
				nil,
				p2
			)

			return false, { `Could not get editable mesh data for {p}. Please retry later or make a bug report.` }
		end

		local v2, v3 = pcallDeferred(function()
			return { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(v) }
		end, p2)

		if not v2 then
			Analytics.reportFailure(
				Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_FailedToFetchSkinning,
				nil,
				p2
			)

			return false, { `Could not get skinning data for {p}. Please retry later or make a bug report.` }
		end

		for _, v4 in v3 do
			if Constants.R15_STANDARD_JOINT_NAMES[v4] == nil then
				Analytics.reportFailure(
					Analytics.ErrorType.validateBodyPartVertsSkinnedToR15_BodyIsSkinnedToFakeJoints,
					nil,
					p2
				)

				return
					false,
					{ `{p} is skinned to a non-standard joint {v4}. This part may only be skinned to standard R15 joints.` }
			end
		end

		return true
	end
}

function ValidateMeshPartOnlySkinnedToR15.validateBodyParts(instance, p)
	if
		getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning()
		and getFFlagUGCValidationEnableR15plusSkinning()
	then
		error("ValidateMeshPartOnlySkinnedToR15 is deprecated. Use RigidSkinnedToSchema / LCSkinnedToSchema / BodySkinnedToSchema instead.")
	end

	for _, childName in Constants.R15_BODY_PARTS do
		local child = instance:FindFirstChild(childName)

		if not child then
			continue
		end

		local v, v2 = ValidateMeshPartOnlySkinnedToR15.validateMeshPart(child, p)

		if not v then
			return v, v2
		end
	end

	return true
end

return ValidateMeshPartOnlySkinnedToR15
