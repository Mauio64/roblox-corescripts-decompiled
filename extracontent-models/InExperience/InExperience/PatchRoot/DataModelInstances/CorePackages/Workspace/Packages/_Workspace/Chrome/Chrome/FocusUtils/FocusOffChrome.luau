local GamepadService = game:GetService("GamepadService")
local ParentParent = script.Parent.Parent
local FocusOffChromeSignal = require(ParentParent.FocusUtils.FocusOffChromeSignal)

local function focusOffChrome(p1: ((...any) -> ...any)?) -- line: 8
	-- upvalues: GamepadService (copy), FocusOffChromeSignal (copy)
	if GamepadService.GamepadCursorEnabled then
		return
	end

	FocusOffChromeSignal:fire()

	if p1 then
		p1()
	end
end

return focusOffChrome
