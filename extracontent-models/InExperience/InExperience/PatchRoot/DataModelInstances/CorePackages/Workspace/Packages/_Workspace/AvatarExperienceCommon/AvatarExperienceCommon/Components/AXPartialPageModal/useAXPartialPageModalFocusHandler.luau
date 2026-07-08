local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local useOverlay = require(Parent.Foundation).Hooks.useOverlay
local useFocusGuiObject = require(Parent.ReactFocusNavigation).useFocusGuiObject
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local wasLastInputGamepad = require(Parent.RoactUtils).wasLastInputGamepad

return function(p1) -- line: 14
	-- upvalues: useOverlay (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusGuiObject (copy), wasLastInputGamepad (copy), React (copy)
	local v10 = useOverlay()

	useFocusNavigableSurfaceRegistryConnection(p1.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)

	local v11 = useFocusGuiObject()
	local v12 = wasLastInputGamepad()

	React.useEffect(function() -- line: 22
		-- upvalues: p1 (copy), v10 (copy), v12 (copy), v11 (copy)
		if p1.current and (v10 == nil and v12) then
			task.delay(0.1, function() -- line: 24
				-- upvalues: v11 (copy), p1 (copy)
				v11(p1.current)
			end)
		end
	end, {
		v11,
		v10,
		v12
	})

	return v10
end
