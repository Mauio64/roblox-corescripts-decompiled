local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQTextureQuality),
	run = function(object, p)
		local measure_Texture_Complexity = p.aqsSummaryData.Measure_Texture_Complexity

		if measure_Texture_Complexity == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Texture_Complexity"
			})

			return
		end

		for k, v in measure_Texture_Complexity do
			if k == "measurement_score" then
				continue
			end

			if v == nil or v.score == nil then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Texture_Complexity"
				})
				break
			elseif tonumber(v.score) ~= 100 then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_TextureComplexity, { textureName = k })
			end
		end
	end
}
