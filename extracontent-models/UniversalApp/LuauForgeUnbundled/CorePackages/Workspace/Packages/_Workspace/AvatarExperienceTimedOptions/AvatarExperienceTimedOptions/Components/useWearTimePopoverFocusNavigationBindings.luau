local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/InputHandlers")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceFlags")

local PopoverFocusRestorationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceTimedOptions/Components/PopoverFocusRestorationContext")

local fFlagAXTimedOptionsPopoverSkipFocusOnCursor = AvatarExperienceFlags.FFlagAXTimedOptionsPopoverSkipFocusOnCursor

local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
}

local function useWearTimePopoverFocusNavigationBindings(callback, p2, p3)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local v5 = React.useContext(PopoverFocusRestorationContext)

	React.useEffect(function()
		setState(p2)
	end, { p2 })

	useFocusNavigableSurfaceRegistryConnection(
		ref and ref.current,
		focusNavigableSurfaceIdentifierEnum.PopUp,
		state
	)

	local v6 = if fFlagAXTimedOptionsPopoverSkipFocusOnCursor then useLastInputMode() else nil
	local ref2 = React.useRef(false)
	React.useEffect(function()
		local v7 = not fFlagAXTimedOptionsPopoverSkipFocusOnCursor or v6 == "Focus"

		if state and not ref2.current then
			if v7 then
				local current = ref.current
				local v8 = current and current:IsDescendantOf(game) and getFirstFocusableDescendant(current)

				if v8 then
					GuiService.SelectedCoreObject = v8
				end
			end
		elseif not state and ref2.current and v5 and v7 then
			local current = p3 and p3.current

			if current and current:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = current
			end
		end

		ref2.current = state
	end, { state, v5, p3, v6 })

	local v7 = ReactFocusNavigation.useEventMap(navigateBacksByButtonB, ref)
	local v8 = React.useMemo(function()
		local v9 = {}
		v9[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p4)
				p4.cancelled = true
				callback()
			end)
		}

		return v9
	end, { callback })

	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

return useWearTimePopoverFocusNavigationBindings
