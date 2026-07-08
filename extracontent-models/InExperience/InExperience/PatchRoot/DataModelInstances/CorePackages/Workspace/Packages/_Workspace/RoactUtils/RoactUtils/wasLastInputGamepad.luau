local UserInputService = game:GetService("UserInputService")
local isGamepadInput = require(script.Parent.isGamepadInput)

local function wasLastInputGamepad() -- line: 5
	-- upvalues: UserInputService (copy), isGamepadInput (copy)
	local LastInputType = UserInputService:GetLastInputType()

	return isGamepadInput(LastInputType)
end

return wasLastInputGamepad
