local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local UGCValidationService = game:GetService("UGCValidationService")
local defineFastInt = game:DefineFastInt("UGCValidationMinimumHeadSizePercentAcrossFacs", 95)
local defineFastInt2 = game:DefineFastInt("UGCValidationMaximumHeadSizePercentAcrossFacs", 120)

return {
	["fflag"] = require(parent.flags.getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = { "Asset_EF_HeadWithExpandingFacs", "Asset_EF_HeadWithShrinkingFacs" },
	run = function(object, p)
		local head = p.renderMeshesData.Head

		local v, v2 = unpack(UGCValidationService:GetMinAndMaxMeshSizeAcrossAllFacs(head.editable))

		local v3 = 100 * v / head.originalSize
		local modPercent = math.floor((math.min(v3.X, v3.Y, v3.Z)))

		if modPercent < defineFastInt then
			object:fail(ErrorSourceStrings.Keys.FacsShrinksHead, { modPercent = modPercent })
		end

		local v4 = 100 * v2 / head.originalSize
		local modPercent2 = math.ceil((math.max(v4.X, v4.Y, v4.Z)))

		if defineFastInt2 < modPercent2 then
			object:fail(ErrorSourceStrings.Keys.FacsExpandsHead, { modPercent = modPercent2 })
		end
	end
}
