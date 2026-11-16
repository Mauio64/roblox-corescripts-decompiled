local SerializationService = game:GetService("SerializationService")
local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateSerializedAssetSizeBounded = require(parent.flags.getFFlagUGCValidateSerializedAssetSizeBounded)

local getEngineFeatureEngineUGCValidateSerializeExcludeCollisionPhysics = require(parent.flags.getEngineFeatureEngineUGCValidateSerializeExcludeCollisionPhysics)

local getFIntUGCValidateMaxSerializedAssetSizeBytesDefault = require(parent.flags.getFIntUGCValidateMaxSerializedAssetSizeBytesDefault)

local getFIntUGCValidateMaxSerializedAssetSizeBytesTorsoAndLimbs = require(parent.flags.getFIntUGCValidateMaxSerializedAssetSizeBytesTorsoAndLimbs)

local getFIntUGCValidateMaxSerializedAssetSizeBytesDynamicHead = require(parent.flags.getFIntUGCValidateMaxSerializedAssetSizeBytesDynamicHead)

local getFIntUGCValidateMaxSerializedAssetSizeBytesLayeredClothing = require(parent.flags.getFIntUGCValidateMaxSerializedAssetSizeBytesLayeredClothing)

local getFIntUGCValidateMaxSerializedAssetSizeBytesRigidAccessory = require(parent.flags.getFIntUGCValidateMaxSerializedAssetSizeBytesRigidAccessory)

local v = {
	[ValidationEnums.UploadCategory.TORSO_AND_LIMBS] = getFIntUGCValidateMaxSerializedAssetSizeBytesTorsoAndLimbs,
	[ValidationEnums.UploadCategory.DYNAMIC_HEAD] = getFIntUGCValidateMaxSerializedAssetSizeBytesDynamicHead,
	[ValidationEnums.UploadCategory.LAYERED_CLOTHING] = getFIntUGCValidateMaxSerializedAssetSizeBytesLayeredClothing,
	[ValidationEnums.UploadCategory.EYEBROW_EYELASH] = getFIntUGCValidateMaxSerializedAssetSizeBytesLayeredClothing,
	[ValidationEnums.UploadCategory.RIGID_ACCESSORY] = getFIntUGCValidateMaxSerializedAssetSizeBytesRigidAccessory
}
return {
	["categories"] = Constants.AllAssetUploadCategories,
	requiredData = {
		ValidationEnums.SharedDataMember.entrypointInput,
		ValidationEnums.SharedDataMember.uploadCategory,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	fflag = getFFlagUGCValidateSerializedAssetSizeBounded,
	run = function(object, data)
		if data.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.Backend then
			return
		end

		local v2

		if getEngineFeatureEngineUGCValidateSerializeExcludeCollisionPhysics() then
			v2 = UGCValidationService:GetSerializedSizeExcludingCollisionAsync(data.entrypointInput)
		else
			v2 = buffer.len(SerializationService:SerializeInstancesAsync(data.entrypointInput))
		end

		local v3 = (v[data.uploadCategory] or getFIntUGCValidateMaxSerializedAssetSizeBytesDefault)()

		if v3 < v2 then
			object:fail(ErrorSourceStrings.Keys.SerializedAssetTooLarge, {
				sizeBytes = tostring(v2),
				maxSizeBytes = tostring(v3)
			})
		end
	end
}
