local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local useOpenQuickMenuCallback = require(script.Parent.useOpenQuickMenuCallback)
local useQuickMenuAvailable = require(script.Parent.useQuickMenuAvailable)
local t1 = {
	[Enum.KeyCode.ButtonStart] = FocusNavigationEventNameEnum.OpenQuickMenu
}

local function useAvatarExperienceFocusNavigationBindings(t2: {[any]: any}, p1) -- line: 18
	-- upvalues: useQuickMenuAvailable (copy), useOpenQuickMenuCallback (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy)
	local v12 = useQuickMenuAvailable()
	local v13 = useOpenQuickMenuCallback(t2.overlayClosedCallback)
	local v14 = React.useMemo(function() -- line: 21
		-- upvalues: FocusNavigationEventNameEnum (copy), v12 (copy), InputHandlers (copy), v13 (copy)
		return {
			[FocusNavigationEventNameEnum.OpenQuickMenu] = {
				handler = if not v12 then nil else InputHandlers.onRelease(v13)
			}
		}
	end, { t2 })
	local v15 = ReactFocusNavigation.useEventMap(t1, p1)

	return ReactFocusNavigation.useEventHandlerMap(v14, v15)
end

return useAvatarExperienceFocusNavigationBindings
