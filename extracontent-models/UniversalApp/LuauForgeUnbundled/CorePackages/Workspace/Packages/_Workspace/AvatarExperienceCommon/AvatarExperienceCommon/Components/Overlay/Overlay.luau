local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local useFocusNavigableSurfaceRegistryConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/FocusNavigationUtils").useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/FocusNavigationUtils").FocusNavigableSurfaceIdentifierEnum

local function Overlay(p2)
	local state, setState = React.useState(nil)

	useFocusNavigableSurfaceRegistryConnection(state, focusNavigableSurfaceIdentifierEnum.CentralOverlay)
	local clone = table.clone(p2)
	clone.ref = setState
	clone.SelectionGroup = true
	clone.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
	return React.createElement("Frame", clone)
end

return Overlay
