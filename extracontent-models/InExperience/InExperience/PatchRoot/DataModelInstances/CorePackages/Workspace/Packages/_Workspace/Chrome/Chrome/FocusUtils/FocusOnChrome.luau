local GamepadService = game:GetService("GamepadService")

local parent = script.Parent.Parent

local FocusOnChromeSignal = require(parent.FocusUtils.FocusOnChromeSignal)

local function focusOnChrome(callback, p: string?)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if callback then
		callback()
	end

	FocusOnChromeSignal:fire(p)
end

return focusOnChrome
