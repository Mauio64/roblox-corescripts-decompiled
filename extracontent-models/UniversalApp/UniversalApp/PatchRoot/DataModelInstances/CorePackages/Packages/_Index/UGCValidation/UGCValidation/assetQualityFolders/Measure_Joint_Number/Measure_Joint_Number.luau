local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQRiggingQuality),
	run = function(object, p)
		local measure_Joint_Number = p.aqsSummaryData.Measure_Joint_Number

		if measure_Joint_Number == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Joint_Number"
			})

			return
		end

		local full_body_mesh = measure_Joint_Number.full_body_mesh

		if full_body_mesh == nil or full_body_mesh.score == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Joint_Number"
			})
		elseif tonumber(full_body_mesh.score) ~= 100 then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_JointNumber, {
				joint_number = full_body_mesh.joint_number or "unknown",
				left_hand_joint_number = full_body_mesh.left_hand_joint_number or "unknown",
				right_hand_joint_number = full_body_mesh.right_hand_joint_number or "unknown"
			})
		end
	end
}
