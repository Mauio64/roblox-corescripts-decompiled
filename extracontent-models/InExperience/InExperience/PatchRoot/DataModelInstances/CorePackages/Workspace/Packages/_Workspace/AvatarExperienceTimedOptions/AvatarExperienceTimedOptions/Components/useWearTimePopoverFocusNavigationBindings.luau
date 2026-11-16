local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local PopoverFocusRestorationContext = require(script.Parent.PopoverFocusRestorationContext)

local FFlagAXTimedOptionsPopoverSkipFocusOnCursor = AvatarExperienceFlags.FFlagAXTimedOptionsPopoverSkipFocusOnCursor

local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useWearTimePopoverFocusNavigationBindings(callback, flag: boolean, p)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local v = React.useContext(PopoverFocusRestorationContext)

	React.useEffect(function()
		setState(flag)
	end, { flag })

	useFocusNavigableSurfaceRegistryConnection(ref and ref.current, FocusNavigableSurfaceIdentifierEnum.PopUp, state)
	local v2

	if FFlagAXTimedOptionsPopoverSkipFocusOnCursor then
		v2 = useLastInputMode()
	else
		v2 = nil
	end

	local ref2 = React.useRef(false)
	React.useEffect(function()
		local v3 = not FFlagAXTimedOptionsPopoverSkipFocusOnCursor or v2 == "Focus"

		if state and not ref2.current then
			if v3 then
				local current = ref.current
				local selectedCoreObject = current
					and current:IsDescendantOf(game)
					and getFirstFocusableDescendant(current)

				if selectedCoreObject then
					GuiService.SelectedCoreObject = selectedCoreObject
				end
			end
		elseif not state and ref2.current and v and v3 then
			local current = p and p.current

			if current and current:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = current
			end
		end

		ref2.current = state
	end, { state, v, p, v2 })

	local v3 = ReactFocusNavigation.useEventMap(navigateBacksByButtonB, ref)
	local v4 = React.useMemo(function()
		local v4 = {}
		v4[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2)
				p2.cancelled = true
				callback()
			end)
		}

		return v4
	end, { callback })

	return ReactFocusNavigation.useEventHandlerMap(v4, v3)
end

return useWearTimePopoverFocusNavigationBindings
