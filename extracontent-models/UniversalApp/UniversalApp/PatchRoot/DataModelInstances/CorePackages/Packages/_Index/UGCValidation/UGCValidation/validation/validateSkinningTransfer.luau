local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local ConstantsInterface = require(parent.ConstantsInterface)
local Constants = require(parent.Constants)

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local getFFlagUGCValidationEyebrowEyelashSupport = require(parent.flags.getFFlagUGCValidationEyebrowEyelashSupport)

local function validateSkinningTransfer(instance, p)
	local assetTypeEnum = p.assetTypeEnum

	local v, v2 = pcallDeferred(function()
		local editableMeshFromContext, v = getEditableMeshFromContext(instance, "MeshId", p)

		if not editableMeshFromContext then
			error("Failed to retrieve MeshContent")
		end

		return UGCValidationService:GetEditableMeshSkinningTransferJointsInfo(v)
	end, p)

	if not v then
		Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_FailedToExecute, nil, p)

		return
			false,
			{ string.format(
					"Failed to execute skinning transfer check for '%s'. Make sure the mesh exists and try again.",
					instance:GetFullName()
				) }
	end

	local v3 = next(v2) ~= nil

	if v3 then
		local v4 = {}

		for k in v2 do
			table.insert(v4, k)
		end

		local joined = table.concat(v4, ", ")

		if ConstantsInterface.isBodyPart(assetTypeEnum) then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_BodyPartsWithSpecialJoints, nil, p)

			return
				false,
				{ string.format(
						"Invalid joints [%s] found in body mesh '%s'. Please remove the joints and try again.",
						joined,
						instance:GetFullName()
					) }
		end

		local wrapLayer = instance:FindFirstChildOfClass("WrapLayer")
		assert(wrapLayer, "MeshPart isn't a body part, so it must be an accessory with a WrapLayer")

		if wrapLayer.AutoSkin ~= Enum.WrapLayerAutoSkin.EnabledOverride then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_SkinningTransferOverride, nil, p)

			return
				false,
				{ string.format(
						"Skinning Transfer joints [%s] found in '%s'. WrapLayer.AutoSkin must be set to EnabledOverride when joints are present.",
						joined,
						instance:GetFullName()
					) }
		end
	end

	if
		getFFlagUGCValidationEyebrowEyelashSupport()
		and not v3
		and Constants.SkinningTransferRequiredTypes[assetTypeEnum]
	then
		Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_RequiredAssetTypes, nil, p)

		return
			false,
			{ string.format(
					"No Skinning Transfer joints found in '%s'. Accessories of type %s are required to use Skinning Transfer with RBX_Leader and RBX_Follower joints.",
					instance:GetFullName(),
					assetTypeEnum.Name
				) }
	end

	for k, v4 in v2 do
		if not v4 then
			Analytics.reportFailure(Analytics.ErrorType.validateSkinningTransfer_Weights, nil, p)

			return
				false,
				{ string.format(
						"Vert(s) in mesh '%s' are only partially weighted to joint %s. Vert(s) must be fully weighted to this joint.",
						instance:GetFullName(),
						k
					) }
		end
	end

	return true
end

return validateSkinningTransfer
