local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationRulesUtil = require(ParentParent.util.ValidationRulesUtil)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local valueToString = require(ParentParent.util.valueToString)
local t1 = {}
local v10 = game:DefineFastInt("LCPostDeformSizeMultiplierEyebrowEyelashHundredths", 100) / 100
local t2 = {
	[Enum.AssetType.EyebrowAccessory] = v10,
	[Enum.AssetType.EyelashAccessory] = v10
}
local v12 = game:DefineFastInt("LCPostDeformSizeMultiplierGeneralHundredths", 100) / 100

t1.fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExactLCDeformationSize)
t1.categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING }
t1.requiredData = { ValidationEnums.SharedDataMember.renderMeshesData }

function t1.run(p1, p2) -- line: 30
	-- upvalues: ValidationRulesUtil (copy), t2 (copy), v12 (copy), UGCValidationService (copy), Vector3Utils (copy), ErrorSourceStrings (copy), valueToString (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
	local Handle = p2.rootInstance:FindFirstChild("Handle")
	local Handle2 = p2.renderMeshesData.Handle
	local assetType = p2.uploadEnum.assetType

	if Handle == nil or Handle2 == nil then
		error("Schema should have ensured data exists for handle")
	end

	local v18, v19 = ValidationRulesUtil:getLCSizeLimit(assetType, Handle)

	if not v18 or v19 == nil then
		error("Could not find matching attachment on Handle for " .. assetType.Name)
	end

	local v20 = v19 * (t2[assetType] or v12)
	local LayeredClothingPostDeformationSize = UGCValidationService:GetLayeredClothingPostDeformationSize(p2.rootInstance, Handle2.editable, Handle2.scale)

	if not Vector3Utils.isFirstLessOrEqual(LayeredClothingPostDeformationSize, v20) then
		p1:fail(ErrorSourceStrings.Keys.LCDeformTooLarge, {
			maxSize = valueToString(v20)
		}, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else Handle)
	end
end

return t1
