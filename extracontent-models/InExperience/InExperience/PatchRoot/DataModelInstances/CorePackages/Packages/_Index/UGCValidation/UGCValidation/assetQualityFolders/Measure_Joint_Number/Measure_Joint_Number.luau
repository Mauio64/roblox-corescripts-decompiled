local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQRiggingQuality),
	run = function(p1, p2) -- line: 11
		-- upvalues: ErrorSourceStrings (copy)
		local Measure_Joint_Number = p2.aqsSummaryData.Measure_Joint_Number

		if Measure_Joint_Number == nil then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Joint_Number"
			})

			return
		end

		local full_body_mesh = Measure_Joint_Number.full_body_mesh

		if full_body_mesh == nil or full_body_mesh.score == nil then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Joint_Number"
			})

			return
		end

		if tonumber(full_body_mesh.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_JointNumber, {
				score = tostring((math.floor(tonumber(full_body_mesh.score) or 0))),
				joint_number = full_body_mesh.joint_number or "unknown",
				left_hand_joint_number = full_body_mesh.left_hand_joint_number or "unknown",
				right_hand_joint_number = full_body_mesh.right_hand_joint_number or "unknown"
			})
		end
	end
}
