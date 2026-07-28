local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationRulesUtil = require(ParentParent.util.ValidationRulesUtil)
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local valueToString = require(ParentParent.util.valueToString)
local t1 = {}
local v9 = game:DefineFastInt("LCPostDeformSizeMultiplierEyebrowEyelashHundredths", 100) / 100
local t2 = {
	[Enum.AssetType.EyebrowAccessory] = v9,
	[Enum.AssetType.EyelashAccessory] = v9
}
local v11 = game:DefineFastInt("LCPostDeformSizeMultiplierGeneralHundredths", 100) / 100

t1.fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExactLCDeformationSize)
t1.categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING }
t1.requiredData = { ValidationEnums.SharedDataMember.renderMeshesData }

function t1.run(p1, p2) -- line: 28
	-- upvalues: ValidationRulesUtil (copy), t2 (copy), v11 (copy), UGCValidationService (copy), Vector3Utils (copy), ErrorSourceStrings (copy), valueToString (copy)
	local Handle = p2.rootInstance:FindFirstChild("Handle")
	local Handle2 = p2.renderMeshesData.Handle
	local assetType = p2.uploadEnum.assetType

	if Handle == nil or Handle2 == nil then
		error("Schema should have ensured data exists for handle")
	end

	local v17, v18 = ValidationRulesUtil:getLCSizeLimit(assetType, Handle)

	if not v17 or v18 == nil then
		error("Could not find matching attachment on Handle for " .. assetType.Name)
	end

	local v19 = v18 * (t2[assetType] or v11)
	local LayeredClothingPostDeformationSize = UGCValidationService:GetLayeredClothingPostDeformationSize(p2.rootInstance, Handle2.editable, Handle2.scale)

	if not Vector3Utils.isFirstLessOrEqual(LayeredClothingPostDeformationSize, v19) then
		p1:fail(ErrorSourceStrings.Keys.LCDeformTooLarge, {
			maxSize = valueToString(v19)
		}, Handle)
	end
end

return t1
