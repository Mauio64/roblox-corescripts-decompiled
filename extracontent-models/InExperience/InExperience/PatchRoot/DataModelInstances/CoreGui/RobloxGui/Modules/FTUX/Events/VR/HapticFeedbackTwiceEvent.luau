local HapticService = game:GetService("HapticService")

require(script.Parent.Parent.EventType)

return {
	Name = "HapticFeedbackTwiceEvent",
	StartEvent = function() -- line: 10
		-- upvalues: HapticService (copy)
		local Gamepad1 = Enum.UserInputType.Gamepad1
		local Gamepad2 = Enum.UserInputType.Gamepad2

		for _ = 1, 2 do
			HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, 5)
			HapticService:SetMotor(Gamepad2, Enum.VibrationMotor.Large, 5)
			task.wait(0.5)
			HapticService:SetMotor(Gamepad1, Enum.VibrationMotor.Large, 0)
			HapticService:SetMotor(Gamepad2, Enum.VibrationMotor.Large, 0)
			task.wait(0.125)
		end
	end
}
