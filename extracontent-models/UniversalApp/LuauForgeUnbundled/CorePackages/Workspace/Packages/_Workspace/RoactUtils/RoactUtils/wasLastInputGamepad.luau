local UserInputService = game:GetService("UserInputService")

local isGamepadInput = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/isGamepadInput")

local function wasLastInputGamepad()
	return isGamepadInput((UserInputService:GetLastInputType()))
end

return wasLastInputGamepad
