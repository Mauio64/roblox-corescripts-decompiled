local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local inputModeStore = Responsive.GetInputModeStore(false)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function useFocusOnMountEffect(p, p2: number?)
	local v = useFocusGuiObject()
	local v2 = Responsive.useIsSpatial()

	React.useEffect(function()
		local thread = task.delay(not p2 and 0 or p2, function()
			local v3 = inputModeStore.getLastInputType(false) == Responsive.Input.Directional
			local v4 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
				or FFlagLuaSupportMicroGamepadPreferredInput
				and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

			if p.current and (v4 or v3) and v and not v2 then
				local selectedCoreObject = GuiService.SelectedCoreObject

				if
					selectedCoreObject ~= p.current
					and not (selectedCoreObject and selectedCoreObject:IsDescendantOf(p.current))
					and p.current:IsDescendantOf(game)
				then
					v(p.current)
				end
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, {})
end
return useFocusOnMountEffect
