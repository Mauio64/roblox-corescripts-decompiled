local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigationUtils2 = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils2.FocusNavigableSurfaceIdentifierEnum

local function Overlay(p)
	local state, setState = React.useState(nil)

	useFocusNavigableSurfaceRegistryConnection(state, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)
	local clone = table.clone(p)
	clone.ref = setState
	clone.SelectionGroup = true
	clone.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	clone.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
	return React.createElement("Frame", clone)
end

return Overlay
