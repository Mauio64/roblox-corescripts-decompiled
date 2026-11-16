local UserInputService = game:GetService("UserInputService")

local isGamepadInput = require(script.Parent.isGamepadInput)

local function wasLastInputGamepad()
	return isGamepadInput((UserInputService:GetLastInputType()))
end

return wasLastInputGamepad
