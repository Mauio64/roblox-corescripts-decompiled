local GamepadService = game:GetService("GamepadService")

local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/GuiObjectUtils").useProperty

local function useGamepadCursorEnabled()
	return useProperty(GamepadService, "GamepadCursorEnabled")
end

return useGamepadCursorEnabled
