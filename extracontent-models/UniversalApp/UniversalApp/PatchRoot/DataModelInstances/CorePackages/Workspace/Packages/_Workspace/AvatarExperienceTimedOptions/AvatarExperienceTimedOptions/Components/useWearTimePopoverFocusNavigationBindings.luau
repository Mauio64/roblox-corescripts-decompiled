local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local PopoverFocusRestorationContext = require(script.Parent.PopoverFocusRestorationContext)
local FFlagAXFixIaBTimedOptionsPopoverFocus = AvatarExperienceFlags.FFlagAXFixIaBTimedOptionsPopoverFocus
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useWearTimePopoverFocusNavigationBindings(p1: ((...any) -> ...any), b1: boolean, t2: {[any]: any}?) -- line: 25
	-- upvalues: React (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), PopoverFocusRestorationContext (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), getFirstFocusableDescendant (copy), GuiService (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v19 = React.useRef(nil)
	local v20, v21 = React.useState(false)
	local v22 = if not FFlagAXFixIaBTimedOptionsPopoverFocus then nil else React.useContext(PopoverFocusRestorationContext)

	React.useEffect(function() -- line: 36
		-- upvalues: v21 (copy), b1 (copy)
		v21(b1)
	end, { b1 })
	useFocusNavigableSurfaceRegistryConnection(v19 and v19.current, FocusNavigableSurfaceIdentifierEnum.PopUp, v20)

	if FFlagAXFixIaBTimedOptionsPopoverFocus then
		local v23 = React.useRef(false)

		React.useEffect(function() -- line: 53
			-- upvalues: v20 (copy), v23 (copy), v19 (copy), getFirstFocusableDescendant (copy), GuiService (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), v22 (copy), t2 (copy)
			if v20 and not v23.current then
				local current = v19.current

				if current and current:IsDescendantOf(game) then
					local v27 = getFirstFocusableDescendant(current)

					if v27 then
						GuiService.SelectedCoreObject = v27
					end
				end
			elseif not v20 and v23.current and FFlagAXFixIaBTimedOptionsPopoverFocus and v22 then
				local v28 = t2 and t2.current

				if v28 and v28:IsDescendantOf(game) then
					GuiService.SelectedCoreObject = v28
				end
			end

			v23.current = v20
		end, {
			v20,
			v22,
			t2
		})
	end

	local v24 = ReactFocusNavigation.useEventMap(t1, v19)
	local v25 = React.useMemo(function() -- line: 77
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p1 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 80
					-- upvalues: p1 (copy)
					p2.cancelled = true
					p1()
				end)
			}
		}
	end, { p1 })

	return ReactFocusNavigation.useEventHandlerMap(v25, v24)
end

return useWearTimePopoverFocusNavigationBindings
