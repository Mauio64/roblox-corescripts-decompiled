local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQTextureQuality),
	run = function(p1, p2) -- line: 16
		-- upvalues: ErrorSourceStrings (copy)
		local Measure_Texture_Resolution = p2.aqsSummaryData.Measure_Texture_Resolution

		if Measure_Texture_Resolution == nil then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Texture_Resolution"
			})

			return
		end

		for v7, v8 in Measure_Texture_Resolution do
			if v7 == "measurement_score" then
				continue
			end

			if v8 == nil or v8.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Texture_Resolution"
				})

				return
			end

			if tonumber(v8.score) ~= 100 then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_TextureResolution, {
					textureName = v7,
					texture_width = v8.texture_width or "unknown",
					texture_height = v8.texture_height or "unknown",
					score = tostring((math.floor(tonumber(v8.score) or 0)))
				})
			end
		end
	end
}
