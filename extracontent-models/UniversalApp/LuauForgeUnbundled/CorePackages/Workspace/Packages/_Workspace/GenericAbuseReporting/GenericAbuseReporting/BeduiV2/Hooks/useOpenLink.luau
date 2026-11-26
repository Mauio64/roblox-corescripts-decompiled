local VRService = game:GetService("VRService")

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").AppLinking
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/LinkingProtocol").LinkingProtocol.default
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/NavigationRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Responsive")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks")

local appPage = RobloxAppEnums.AppPage
local navigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local usePreferredInput = Responsive.usePreferredInput
local useRoactService = RobloxAppHooks.useRoactService

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppNavigation").NavigationCommands else nil

local function useOpenLink()
	local v5 = useDispatch()
	local v6 = useRoactService(appLinking)
	local v7 = usePreferredInput() == Responsive.Input.Directional

	return React.useCallback(function(p2, p3)
		if p3 then
			if v6 then
				if v7 or VRService.VREnabled then
					v6:openURL(p3)
					return
				end

				local v8 = {
					name = appPage.GenericWebPage,
					detail = p3,
					extraProps = { title = p2 }
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v8))
				else
					v5(navigateDown(v8))
				end
			else
				default:openURL(p3)
			end
		end
	end, { v6, v5, v7 })
end

return useOpenLink
