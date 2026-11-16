local HapticService = game:GetService("HapticService")
require(script.Parent.Parent.EventType)

local HapticFeedbackEvent = { Name = "HapticFeedbackEvent" }

function HapticFeedbackEvent.StartEvent()
	local gamepad1 = Enum.UserInputType.Gamepad1
	local gamepad2 = Enum.UserInputType.Gamepad2

	HapticService:SetMotor(gamepad1, Enum.VibrationMotor.Large, 10)
	HapticService:SetMotor(gamepad2, Enum.VibrationMotor.Large, 10)
	task.wait(1)
	HapticService:SetMotor(gamepad1, Enum.VibrationMotor.Large, 0)
	HapticService:SetMotor(gamepad2, Enum.VibrationMotor.Large, 0)
end

return HapticFeedbackEvent
