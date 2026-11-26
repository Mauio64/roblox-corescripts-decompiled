local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local FFlagAXFixPPEV2ConsoleSidebarNav = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Flags/FFlagAXFixPPEV2ConsoleSidebarNav")

local function FocusNavigatorWrapper(p2)
	local createElement = React.createElement

	local v7 = if FFlagAXFixPPEV2ConsoleSidebarNav then focusNavigableSurfaceIdentifierEnum.SubRouterView else focusNavigableSurfaceIdentifierEnum.PopUp
	return createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = v7,
		isIsolated = not FFlagAXFixPPEV2ConsoleSidebarNav,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					p2.onClose()
					object:cancel()
				end)
			}
		}
	}, p2.children)
end

return FocusNavigatorWrapper
