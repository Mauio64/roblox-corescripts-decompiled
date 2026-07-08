local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local ConstantsInterface = require(ParentParent.ConstantsInterface)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getFFlagUGCValidationEyebrowEyelashSupport = require(ParentParent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

local function validateSkinningTransfer(p1, p2) -- line: 17
	-- upvalues: pcallDeferred (copy), getEditableMeshFromContext (copy), UGCValidationService (copy), Analytics (copy), ConstantsInterface (copy), getFFlagUGCValidationEyebrowEyelashSupport (copy), Constants (copy)
	local assetTypeEnum = p2.assetTypeEnum
	local v13, v14 = pcallDeferred(function() -- line: 23
		-- upvalues: getEditableMeshFromContext (copy), p1 (copy), p2 (copy), UGCValidationService (copy)
		local v22, v23 = getEditableMeshFromContext(p1, "MeshId", p2)

		if not v22 then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:GetEditableMeshSkinningTransferJointsInfo(v23)
	end, p2)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_FailedToExecute, nil, p2)

		return false, { string.format("Failed to execute skinning transfer check for '%s'. Make sure the mesh exists and try again.", p1:GetFullName()) }
	end

	local v15 = next(v14) ~= nil

	if v15 then
		local t1 = {}

		for v17 in v14 do
			table.insert(t1, v17)
		end

		local v18 = table.concat(t1, ", ")

		if ConstantsInterface.isBodyPart(assetTypeEnum) then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_BodyPartsWithSpecialJoints, nil, p2)

			return false, { string.format("Invalid joints [%s] found in body mesh '%s'. Please remove the joints and try again.", v18, p1:GetFullName()) }
		end

		local WrapLayer = p1:FindFirstChildOfClass("WrapLayer")

		assert(WrapLayer, "MeshPart isn't a body part, so it must be an accessory with a WrapLayer")

		if WrapLayer.AutoSkin ~= Enum.WrapLayerAutoSkin.EnabledOverride then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_SkinningTransferOverride, nil, p2)

			return false, { string.format("Skinning Transfer joints [%s] found in '%s'. WrapLayer.AutoSkin must be set to EnabledOverride when joints are present.", v18, p1:GetFullName()) }
		end
	end

	if getFFlagUGCValidationEyebrowEyelashSupport() and not v15 and Constants.SkinningTransferRequiredTypes[assetTypeEnum] then
		Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_RequiredAssetTypes, nil, p2)

		return false, { string.format("No Skinning Transfer joints found in '%s'. Accessories of type %s are required to use Skinning Transfer with RBX_Leader and RBX_Follower joints.", p1:GetFullName(), assetTypeEnum.Name) }
	end

	for v20, v21 in v14 do
		if not v21 then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_Weights, nil, p2)

			return false, { string.format("Vert(s) in mesh '%s' are only partially weighted to joint %s. Vert(s) must be fully weighted to this joint.", p1:GetFullName(), v20) }
		end
	end

	return true
end

return validateSkinningTransfer
