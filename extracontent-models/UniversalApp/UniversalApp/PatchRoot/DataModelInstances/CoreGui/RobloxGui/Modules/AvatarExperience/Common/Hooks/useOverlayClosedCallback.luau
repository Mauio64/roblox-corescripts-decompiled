local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useLastInputMethod = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useLastInputMethod
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

local function useOverlayClosedCallback(p1) -- line: 11
	-- upvalues: useAvatarRoute (copy), useLastInputMethod (copy), React (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy)
	local name = useAvatarRoute().opaque.name
	local v11 = useLastInputMethod() == "Gamepad"

	return (React.useCallback(function() -- line: 15
		-- upvalues: v11 (copy), logOnOverlayClosed (copy), name (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p1 (copy)
		local v12 = v11

		logOnOverlayClosed(name, v12)

		if not FFlagAXMigrateAXToGlobalAutofocus and (v12 and p1) then
			p1.captureFocus()
		end
	end, {
		v11,
		name,
		if not FFlagAXMigrateAXToGlobalAutofocus then p1 else nil
	}))
end

return useOverlayClosedCallback
