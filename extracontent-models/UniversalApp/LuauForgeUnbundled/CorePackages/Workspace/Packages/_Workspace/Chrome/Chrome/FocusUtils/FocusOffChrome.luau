local GamepadService = game:GetService("GamepadService")

local FocusOnChromeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/FocusUtils/FocusOnChromeSignal")

local function focusOffChrome(callback)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	FocusOnChromeSignal:fire()

	if callback then
		callback()
	end
end

return focusOffChrome
