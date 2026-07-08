local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local useFocusGuiObject = require(Parent.ReactFocusNavigation).useFocusGuiObject
local v7 = Responsive.GetInputModeStore(false)

local function useFocusOnMountEffect(p1, n1: number?) -- line: 20
	-- upvalues: useFocusGuiObject (copy), Responsive (copy), React (copy), v7 (copy), UserInputService (copy), GuiService (copy)
	local v11 = useFocusGuiObject()
	local v12 = Responsive.useIsSpatial()

	React.useEffect(function() -- line: 24
		-- upvalues: n1 (copy), v7 (copy), Responsive (copy), UserInputService (copy), p1 (copy), v11 (copy), v12 (copy), GuiService (copy)
		local v13 = not n1 and 0 or n1
		local thread = task.delay(v13, function() -- line: 26
			-- upvalues: v7 (copy), Responsive (copy), UserInputService (copy), p1 (copy), v11 (copy), v12 (copy), GuiService (copy)
			local v15 = v7.getLastInputType(false) == Responsive.Input.Directional
			local v16 = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or v15

			if p1.current and (v16 and v11 and not v12) then
				local SelectedCoreObject = GuiService.SelectedCoreObject

				if SelectedCoreObject ~= p1.current and (not SelectedCoreObject or not SelectedCoreObject:IsDescendantOf(p1.current)) and p1.current:IsDescendantOf(game) then
					v11(p1.current)
				end
			end
		end)

		return function() -- line: 42
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {})
end

return useFocusOnMountEffect
