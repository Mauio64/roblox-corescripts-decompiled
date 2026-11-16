local GamepadService = game:GetService("GamepadService")

local FocusOffChromeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/FocusUtils/FocusOffChromeSignal")

local function focusOnChrome(callback, p2)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if callback then
		callback()
	end

	FocusOffChromeSignal:fire(p2)
end

return focusOnChrome
