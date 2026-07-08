local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local useExternalEvent = require(Parent.RoactUtils).Hooks.useExternalEvent

local function useKeybind(t1: {[any]: any}, p1: ((...any) -> ...any), t2: {[any]: any}) -- line: 15
	-- upvalues: useExternalEvent (copy), UserInputService (copy), Cryo (copy)
	useExternalEvent(UserInputService.InputBegan, function(p2) -- line: 16
		-- upvalues: t1 (copy), p1 (copy)
		if p2.KeyCode == t1.keyCode and (t1.modifierKey == nil or p2:IsModifierKeyDown(t1.modifierKey)) then
			p1()
		end
	end, Cryo.List.join({ t1 }, { p1 }, t2))
end

return useKeybind
