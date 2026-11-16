local GamepadService = game:GetService("GamepadService")

local parent = script.Parent.Parent

local FocusOffChromeSignal = require(parent.FocusUtils.FocusOffChromeSignal)

local function focusOffChrome(callback)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	FocusOffChromeSignal:fire()

	if callback then
		callback()
	end
end

return focusOffChrome
