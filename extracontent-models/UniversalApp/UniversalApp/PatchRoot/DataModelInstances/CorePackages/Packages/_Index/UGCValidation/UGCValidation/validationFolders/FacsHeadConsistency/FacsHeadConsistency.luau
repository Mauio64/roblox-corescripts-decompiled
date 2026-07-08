local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local UGCValidationService = game:GetService("UGCValidationService")
local v5 = game:DefineFastInt("UGCValidationMinimumHeadSizePercentAcrossFacs", 95)
local v6 = game:DefineFastInt("UGCValidationMaximumHeadSizePercentAcrossFacs", 120)

return {
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidateMinMaxMeshSizeAcrossAllFacs),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {
		"Asset_EF_HeadWithExpandingFacs",
		"Asset_EF_HeadWithShrinkingFacs"
	},
	run = function(p1, p2) -- line: 16
		-- upvalues: UGCValidationService (copy), v5 (copy), ErrorSourceStrings (copy), v6 (copy)
		local Head = p2.renderMeshesData.Head
		local v10, v11 = unpack(UGCValidationService:GetMinAndMaxMeshSizeAcrossAllFacs(Head.editable))
		local v12 = 100 * v10 / Head.originalSize
		local v13 = math.floor((math.min(v12.X, v12.Y, v12.Z)))

		if v13 < v5 then
			p1:fail(ErrorSourceStrings.Keys.FacsShrinksHead, {
				modPercent = v13
			})
		end

		local v14 = 100 * v11 / Head.originalSize
		local v15 = math.ceil((math.max(v14.X, v14.Y, v14.Z)))

		if v15 > v6 then
			p1:fail(ErrorSourceStrings.Keys.FacsExpandsHead, {
				modPercent = v15
			})
		end
	end
}
