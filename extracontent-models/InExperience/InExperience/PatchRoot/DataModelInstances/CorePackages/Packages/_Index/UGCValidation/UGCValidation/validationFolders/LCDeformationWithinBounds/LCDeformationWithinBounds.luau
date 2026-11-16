local UGCValidationService = game:GetService("UGCValidationService")
local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationRulesUtil = require(parent.util.ValidationRulesUtil)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local Vector3Utils = require(parent.util.Vector3Utils)
local valueToString = require(parent.util.valueToString)

local getEngineFeatureLayeredClothingDecomposition = require(parent.flags.getEngineFeatureLayeredClothingDecomposition)

local v = game:DefineFastInt("LCPostDeformSizeMultiplierEyebrowEyelashHundredths", 100) / 100

local v2 = { [Enum.AssetType.EyebrowAccessory] = v, [Enum.AssetType.EyelashAccessory] = v }

local v3 = game:DefineFastInt("LCPostDeformSizeMultiplierGeneralHundredths", 100) / 100
return {
	["fflag"] = require(parent.flags.getEngineFeatureEngineUGCValidationExactLCDeformationSize),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(object, data)
		local handle = data.rootInstance:FindFirstChild("Handle")
		local handle2 = data.renderMeshesData.Handle
		local assetType = data.uploadEnum.assetType

		if handle == nil or handle2 == nil then
			error("Schema should have ensured data exists for handle")
		end

		local lcSizeLimit, v4 = ValidationRulesUtil:getLCSizeLimit(assetType, handle)

		if not lcSizeLimit or v4 == nil then
			error("Could not find matching attachment on Handle for " .. assetType.Name)
		end

		local v5 = v4 * (v2[assetType] or v3)
		local v6

		if getEngineFeatureLayeredClothingDecomposition() then
			v6 = UGCValidationService:GetLayeredClothingPostDeformationSizeAsync(
				data.rootInstance,
				handle2.editable,
				handle2.scale
			)
		else
			v6 = UGCValidationService:GetLayeredClothingPostDeformationSize(
				data.rootInstance,
				handle2.editable,
				handle2.scale
			)
		end

		if not Vector3Utils.isFirstLessOrEqual(v6, v5) then
			object:fail(ErrorSourceStrings.Keys.LCDeformTooLarge, { maxSize = valueToString(v5) }, handle)
		end
	end
}
