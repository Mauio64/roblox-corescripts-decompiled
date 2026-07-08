local GamepadService = game:GetService("GamepadService")
local ParentParent = script.Parent.Parent
local FocusOnChromeSignal = require(ParentParent.FocusUtils.FocusOnChromeSignal)

local function focusOnChrome(p1: ((...any) -> ...any)?, s1: string?) -- line: 8
	-- upvalues: GamepadService (copy), FocusOnChromeSignal (copy)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	if p1 then
		p1()
	end

	FocusOnChromeSignal:fire(s1)
end

return focusOnChrome
