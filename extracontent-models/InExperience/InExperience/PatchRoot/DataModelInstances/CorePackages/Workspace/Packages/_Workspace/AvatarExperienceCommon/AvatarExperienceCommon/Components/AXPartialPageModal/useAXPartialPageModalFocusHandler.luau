local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useOverlay = Foundation.Hooks.useOverlay
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local RoactUtils = require(parent.RoactUtils)
local wasLastInputGamepad = RoactUtils.wasLastInputGamepad

return function(p)
	local v = useOverlay()

	useFocusNavigableSurfaceRegistryConnection(p.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)

	local v2 = useFocusGuiObject()
	local v3 = wasLastInputGamepad()

	React.useEffect(function()
		if p.current and v == nil and v3 then
			task.delay(0.1, function()
				v2(p.current)
			end)
		end
	end, { v2, v, v3 })

	return v
end
