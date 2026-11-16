local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation").Hooks.useOverlay
local useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/ReactFocusNavigation").useFocusGuiObject

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactUtils").wasLastInputGamepad

return function(p2)
	local v5 = useOverlay()

	useFocusNavigableSurfaceRegistryConnection(
		p2.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay
	)

	local v6 = useFocusGuiObject()
	local v7 = wasLastInputGamepad()

	React.useEffect(function()
		if p2.current and v5 == nil and v7 then
			task.delay(0.1, function()
				v6(p2.current)
			end)
		end
	end, { v6, v5, v7 })

	return v5
end
