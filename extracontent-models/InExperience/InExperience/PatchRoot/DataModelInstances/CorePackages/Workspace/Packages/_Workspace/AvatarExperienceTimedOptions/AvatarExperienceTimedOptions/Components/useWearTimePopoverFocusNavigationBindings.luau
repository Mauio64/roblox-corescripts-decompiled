local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local PopoverFocusRestorationContext = require(script.Parent.PopoverFocusRestorationContext)
local FFlagAXFixIaBTimedOptionsPopoverFocus = AvatarExperienceFlags.FFlagAXFixIaBTimedOptionsPopoverFocus
local FFlagAXTimedOptionsPopoverSkipFocusOnCursor = AvatarExperienceFlags.FFlagAXTimedOptionsPopoverSkipFocusOnCursor
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useWearTimePopoverFocusNavigationBindings(p1: ((...any) -> ...any), b1: boolean, t2: {[any]: any}?) -- line: 27
	-- upvalues: React (copy), FFlagAXFixIaBTimedOptionsPopoverFocus (copy), PopoverFocusRestorationContext (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAXTimedOptionsPopoverSkipFocusOnCursor (copy), useLastInputMode (copy), getFirstFocusableDescendant (copy), GuiService (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v21 = React.useRef(nil)
	local v22, v23 = React.useState(false)
	local v24 = if not FFlagAXFixIaBTimedOptionsPopoverFocus then nil else React.useContext(PopoverFocusRestorationContext)

	React.useEffect(function() -- line: 38
		-- upvalues: v23 (copy), b1 (copy)
		v23(b1)
	end, { b1 })
	useFocusNavigableSurfaceRegistryConnection(v21 and v21.current, FocusNavigableSurfaceIdentifierEnum.PopUp, v22)

	local v25 = if not FFlagAXFixIaBTimedOptionsPopoverFocus or not FFlagAXTimedOptionsPopoverSkipFocusOnCursor then nil else useLastInputMode()

	if FFlagAXFixIaBTimedOptionsPopoverFocus then
		local v26 = React.useRef(false)

		React.useEffect(function() -- line: 62
			-- upvalues: FFlagAXTimedOptionsPopoverSkipFocusOnCursor (copy), v25 (copy), v22 (copy), v26 (copy), v21 (copy), getFirstFocusableDescendant (copy), GuiService (copy), v24 (copy), t2 (copy)
			local v29 = not FFlagAXTimedOptionsPopoverSkipFocusOnCursor or v25 == "Focus"

			if v22 and not v26.current then
				if v29 then
					local current = v21.current

					if current and current:IsDescendantOf(game) then
						local v31 = getFirstFocusableDescendant(current)

						if v31 then
							GuiService.SelectedCoreObject = v31
						end
					end
				end
			elseif not v22 and v26.current and v24 and v29 then
				local v32 = t2 and t2.current

				if v32 and v32:IsDescendantOf(game) then
					GuiService.SelectedCoreObject = v32
				end
			end

			v26.current = v22
		end, {
			v22,
			v24,
			t2,
			v25
		})
	end

	local v27 = ReactFocusNavigation.useEventMap(t1, v21)
	local v28 = React.useMemo(function() -- line: 90
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p1 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 93
					-- upvalues: p1 (copy)
					p2.cancelled = true
					p1()
				end)
			}
		}
	end, { p1 })

	return ReactFocusNavigation.useEventHandlerMap(v28, v27)
end

return useWearTimePopoverFocusNavigationBindings
