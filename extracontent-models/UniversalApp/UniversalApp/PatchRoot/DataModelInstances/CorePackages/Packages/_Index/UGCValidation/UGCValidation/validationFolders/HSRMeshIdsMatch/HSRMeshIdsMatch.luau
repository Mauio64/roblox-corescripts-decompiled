local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local getFFlagUGCValidateVersionedContentIds = require(parent.flags.getFFlagUGCValidateVersionedContentIds)

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local ParseContentIds = require(parent.util.ParseContentIds)
local pcallDeferred = require(parent.util.pcallDeferred)

local HSRMeshIdsMatch = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.hsrAssets
	},
	expectedFailures = {}
}

local function validateHSRStructure(hsrAsset, wrapLayer, object)
	if #hsrAsset ~= 1 then
		object:fail(ErrorSourceStrings.Keys.HSRAssetInvalidRoot, {
			InstancePath = wrapLayer:GetFullName()
		})

		return nil
	end

	local hiddenSurfaceRemovalAsset = hsrAsset[1]

	if not hiddenSurfaceRemovalAsset:IsA("HiddenSurfaceRemovalAsset") then
		object:fail(ErrorSourceStrings.Keys.HSRAssetInvalidRoot, {
			InstancePath = wrapLayer:GetFullName()
		})

		return nil
	end

	if #hiddenSurfaceRemovalAsset:GetDescendants() > 0 then
		object:fail(ErrorSourceStrings.Keys.HSRAssetHasChildren, {
			InstancePath = wrapLayer:GetFullName()
		})

		return nil
	end

	return hiddenSurfaceRemovalAsset
end

function HSRMeshIdsMatch.run(object, data)
	if data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
		return
	end

	local v = data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend

	local descendants = data.rootInstance:GetDescendants()
	table.insert(descendants, data.rootInstance)

	for _, wrapLayer in descendants do
		if not wrapLayer:IsA("WrapLayer") then
			continue
		end

		local hsrAssetId = wrapLayer.HSRAssetId

		if hsrAssetId and hsrAssetId ~= "" then
			local v2

			if getFFlagUGCValidateVersionedContentIds() then
				local v3, v4 = ParseContentIds.tryParseContentId(hsrAssetId)

				if v3 then
					v2 = ParseContentIds.getReferenceKey(v3, v4)
				end
			else
				v2 = ParseContentIds.tryGetAssetIdFromContentId(hsrAssetId)
			end

			if v2 then
				local hsrAsset = data.hsrAssets[v2]

				if hsrAsset then
					local v3 = validateHSRStructure(hsrAsset, wrapLayer, object)

					if v3 then
						local v4, v5 = pcallDeferred(function()
							return UGCValidationService:ValidateHSRMeshIds(wrapLayer, v3)
						end, {})

						if v4 then
							if not v5 then
								object:fail(ErrorSourceStrings.Keys.HSRMeshIdsMismatch, {
									InstancePath = wrapLayer:GetFullName()
								})
							end
						else
							object:fail(ErrorSourceStrings.Keys.HSRMeshIdValidationError, {
								InstancePath = wrapLayer:GetFullName()
							})
						end
					end
				end
			else
				object:fail(ErrorSourceStrings.Keys.HSRAssetIdInvalidUrl, {
					InstancePath = wrapLayer:GetFullName()
				})
			end
		elseif v then
			object:fail(ErrorSourceStrings.Keys.HSRAssetIdRequired, {
				InstancePath = wrapLayer:GetFullName()
			})
		end
	end
end

return HSRMeshIdsMatch
