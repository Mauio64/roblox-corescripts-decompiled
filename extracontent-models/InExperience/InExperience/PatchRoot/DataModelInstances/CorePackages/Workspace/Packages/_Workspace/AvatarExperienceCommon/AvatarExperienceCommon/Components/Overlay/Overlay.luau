local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local useFocusNavigableSurfaceRegistryConnection = require(Parent.FocusNavigationUtils).useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = require(Parent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum

local function Overlay(p1) -- line: 8
	-- upvalues: React (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v7, v8 = React.useState(nil)

	useFocusNavigableSurfaceRegistryConnection(v7, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)

	local v9 = table.clone(p1)

	v9.ref = v8
	v9.SelectionGroup = true
	v9.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	v9.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	v9.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	v9.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop

	return React.createElement("Frame", v9)
end

return Overlay
