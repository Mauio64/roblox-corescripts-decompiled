local GamepadService = game:GetService("GamepadService")
local parent = script.Parent.Parent
local GuiObjectUtils = require(parent.GuiObjectUtils)

local useProperty = GuiObjectUtils.useProperty

local function useGamepadCursorEnabled()
	return (useProperty(GamepadService, "GamepadCursorEnabled"))
end

return useGamepadCursorEnabled
