local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive")
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactFocusNavigation").useFocusGuiObject
local inputModeStore = Responsive.GetInputModeStore(false)

local fFlagLuaSupportMicroGamepadPreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SharedFlags").FFlagLuaSupportMicroGamepadPreferredInput

local function useFocusOnMountEffect(p2, p3)
	local v5 = useFocusGuiObject()
	local v6 = Responsive.useIsSpatial()

	React.useEffect(function()
		local thread = task.delay(not p3 and 0 or p3, function()
			local v8 = inputModeStore.getLastInputType(false) == Responsive.Input.Directional
			local v9 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
				or fFlagLuaSupportMicroGamepadPreferredInput
				and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad

			if p2.current and (v9 or v8) and v5 and not v6 then
				local selectedCoreObject = GuiService.SelectedCoreObject

				if
					selectedCoreObject ~= p2.current
					and not (selectedCoreObject and selectedCoreObject:IsDescendantOf(p2.current))
					and p2.current:IsDescendantOf(game)
				then
					v5(p2.current)
				end
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, {})
end
return useFocusOnMountEffect
