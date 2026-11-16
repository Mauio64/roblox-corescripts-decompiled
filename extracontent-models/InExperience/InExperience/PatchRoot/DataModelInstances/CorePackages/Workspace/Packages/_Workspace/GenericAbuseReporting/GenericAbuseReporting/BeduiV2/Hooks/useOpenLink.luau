local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local VRService = game:GetService("VRService")

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local NavigationRodux = require(parent.NavigationRodux)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local usePreferredInput = Responsive.usePreferredInput
local useRoactService = RobloxAppHooks.useRoactService

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function useOpenLink()
	local v = useDispatch()
	local v2 = useRoactService(AppLinking)
	local v3 = usePreferredInput() == Responsive.Input.Directional

	return React.useCallback(function(title: string, detail: string?)
		if detail then
			if v2 then
				if v3 or VRService.VREnabled then
					v2:openURL(detail)
					return
				end

				local v4 = {
					name = AppPage.GenericWebPage,
					detail = detail,
					extraProps = { title = title }
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v4))
				else
					v(NavigateDown(v4))
				end
			else
				default:openURL(detail)
			end
		end
	end, { v2, v, v3 })
end

return useOpenLink
