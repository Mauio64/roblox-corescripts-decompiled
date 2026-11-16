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
		local measure_Texture_Resolution = p.aqsSummaryData.Measure_Texture_Resolution

		if measure_Texture_Resolution == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Texture_Resolution"
			})

			return
		end

		for k, v in measure_Texture_Resolution do
			if k == "measurement_score" then
				continue
			end

			if v == nil or v.score == nil then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Texture_Resolution"
				})
				break
			elseif tonumber(v.score) ~= 100 then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_TextureResolution, {
					textureName = k,
					texture_width = v.texture_width or "unknown",
					texture_height = v.texture_height or "unknown"
				})
			end
		end
	end
}
