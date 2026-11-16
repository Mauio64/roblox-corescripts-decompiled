local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local FFlagAXFixPPEV2ConsoleSidebarNav = require(AvatarExperienceProfilePictureEditor.Flags.FFlagAXFixPPEV2ConsoleSidebarNav)

local function FocusNavigatorWrapper(p)
	local createElement = React.createElement
	local surfaceIdentifier

	if FFlagAXFixPPEV2ConsoleSidebarNav then
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.SubRouterView
	else
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	end

	return createElement(FocusNavigableSurfaceWrapper, {
		surfaceIdentifier = surfaceIdentifier,
		isIsolated = not FFlagAXFixPPEV2ConsoleSidebarNav,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					p.onClose()
					object:cancel()
				end)
			}
		}
	}, p.children)
end

return FocusNavigatorWrapper
