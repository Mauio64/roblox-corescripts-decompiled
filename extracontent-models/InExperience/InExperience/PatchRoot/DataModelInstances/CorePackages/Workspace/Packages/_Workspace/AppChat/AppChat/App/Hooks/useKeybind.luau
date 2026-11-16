local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)

local useExternalEvent = RoactUtils.Hooks.useExternalEvent

local function useKeybind(p, callback, p2)
	useExternalEvent(UserInputService.InputBegan, function(object)
		if object.KeyCode == p.keyCode and (p.modifierKey == nil or object:IsModifierKeyDown(p.modifierKey)) then
			callback()
		end
	end, Cryo.List.join({ p }, { callback }, p2))
end

return useKeybind
