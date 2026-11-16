local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFIntUGCValidateMaxHSRDataLen = require(parent.flags.getFIntUGCValidateMaxHSRDataLen)
local getFFlagUGCValidateWrapDataCaps = require(parent.flags.getFFlagUGCValidateWrapDataCaps)
local getFIntUGCValidateMaxHSRMeshIdDataLen = require(parent.flags.getFIntUGCValidateMaxHSRMeshIdDataLen)
local getFFlagUGCValidateDisallowAeroMeshData = require(parent.flags.getFFlagUGCValidateDisallowAeroMeshData)
local getFFlagUGCValidateTemporaryIdsBackendOnly = require(parent.flags.getFFlagUGCValidateTemporaryIdsBackendOnly)

local describeProblematicProperties = require(script.Parent.describeProblematicProperties)

local v = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH
}

local getFFlagUGCValidateMakeupCategoryParity = require(parent.flags.getFFlagUGCValidateMakeupCategoryParity)
local categories

if getFFlagUGCValidateMakeupCategoryParity() then
	categories = Constants.AllAssetUploadCategories
else
	categories = Constants.AllAssetUploadCategoriesIncludingMakeup
end

local PropertiesSensible = {
	["categories"] = categories,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.hsrAssets,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.uploadCategory
	},
	expectedFailures = {}
}

local function walkInstanceTree(object, folder, p)
	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	for _, descendant in descendants do
		local v2 = p[descendant.ClassName]
		local v3, v4 = UGCValidationService:ValidatePropertiesSensible(descendant, v2)

		if not v3 then
			object:fail(ErrorSourceStrings.Keys.PropertiesNotSensible, {
				ClassName = descendant.ClassName,
				InstancePath = descendant:GetFullName(),
				ProblematicProperties = describeProblematicProperties(v4, v2)
			})
		end
	end
end

function PropertiesSensible.run(p, data)
	if not getEngineFeatureEngineUGCValidatePropertiesSensible() then
		return
	end

	local v2 = {
		HiddenSurfaceRemovalAsset = {
			HSRData = getFIntUGCValidateMaxHSRDataLen()
		}
	}

	if getFFlagUGCValidateDisallowAeroMeshData() then
		v2.MeshPart = { AeroMeshData = 0 }
	end

	if getFFlagUGCValidateWrapDataCaps() then
		local consumerEnv = data.consumerConfig.consumerEnv
		local v3 = consumerEnv == ValidationEnums.ConsumerEnv.Backend
		local v4

		if getFFlagUGCValidateTemporaryIdsBackendOnly() then
			v4 = consumerEnv == ValidationEnums.ConsumerEnv.Backend
		else
			v4 = consumerEnv ~= ValidationEnums.ConsumerEnv.IEC
		end

		local v5 = v4 and table.find(v, data.uploadCategory) ~= nil

		local wrapTarget = {
			HSRMeshIdData = getFIntUGCValidateMaxHSRMeshIdDataLen()
		}
		local wrapLayer = {
			HSRMeshIdData = getFIntUGCValidateMaxHSRMeshIdDataLen()
		}

		if v3 then
			wrapTarget.HSRData = 0
			wrapLayer.HSRData = 0
		end

		if v5 then
			wrapTarget.TemporaryCageMeshId = 0
			wrapLayer.TemporaryCageMeshId = 0
			wrapLayer.TemporaryReferenceId = 0
		end

		v2.WrapTarget = wrapTarget
		v2.WrapLayer = wrapLayer
	end

	walkInstanceTree(p, data.rootInstance, v2)

	for _, hsrAsset in data.hsrAssets do
		for _, v3 in hsrAsset do
			walkInstanceTree(p, v3, v2)
		end
	end
end

return PropertiesSensible
