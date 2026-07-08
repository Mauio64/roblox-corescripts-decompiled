local HapticService = game:GetService("HapticService")

require(script.Parent.Parent.EventType)

return {
	Name = "HapticFeedbackEvent",
	StartEvent = function() -- line: 10
		-- upvalues: HapticService (copy)
		local Gamepad1 = Enum.UserInputType.Gamepad1
		local Gamepad2 = Enum.UserInputType.Gamepad2

		HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, 10)
		HapticService:SetMotor(Gamepad2, Enum.VibrationMotor.Large, 10)
		task.wait(1)
		HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, 0)
		HapticService:SetMotor(Gamepad2, Enum.VibrationMotor.Large, 0)
	end
}
