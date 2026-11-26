local UserInputService = game:GetService("UserInputService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useExternalEvent

local function useKeybind(p2, callback, p3)
	useExternalEvent(UserInputService.InputBegan, function(object)
		if
			object.KeyCode == p2.keyCode
			and (p2.modifierKey == nil or object:IsModifierKeyDown(p2.modifierKey))
		then
			callback()
		end
	end, Cryo.List.join({ p2 }, { callback }, p3))
end

return useKeybind
