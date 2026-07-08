local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local VRService = game:GetService("VRService")
local AppLinking = require(Parent.RoactServiceTags).AppLinking
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local NavigationRodux = require(Parent.NavigationRodux)
local React = require(Parent.React)
local Responsive = require(Parent.Responsive)
local RoactUtils = require(Parent.RoactUtils)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local usePreferredInput = Responsive.usePreferredInput
local useRoactService = RobloxAppHooks.useRoactService
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v17 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

local function useOpenLink() -- line: 30
	-- upvalues: useDispatch (copy), useRoactService (copy), AppLinking (copy), usePreferredInput (copy), Responsive (copy), React (copy), VRService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v17 (copy), NavigateDown (copy), default (copy)
	local v19 = useDispatch()
	local v20 = useRoactService(AppLinking)
	local v21 = usePreferredInput() == Responsive.Input.Directional

	return React.useCallback(function(s1: string, s2: string?) -- line: 35
		-- upvalues: v20 (copy), v21 (copy), VRService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v17 (copy), v19 (copy), NavigateDown (copy), default (copy)
		if s2 then
			if v20 then
				if v21 or VRService.VREnabled then
					v20:openURL(s2)

					return
				end

				local t1 = {
					name = AppPage.GenericWebPage,
					detail = s2,
					extraProps = {
						title = s1
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v17.down(v17.fromLegacyPage(t1))

					return
				end

				v19(NavigateDown(t1))

				return
			end

			default:openURL(s2)
		end
	end, {
		v20,
		v19,
		v21
	})
end

return useOpenLink
