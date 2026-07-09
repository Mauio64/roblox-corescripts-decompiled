local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local VRService = game:GetService("VRService")
local useCallback = require(NotApprovedPageParent.React).useCallback
local AppLinking = require(NotApprovedPageParent.RoactServiceTags).AppLinking
local useRoactService = require(NotApprovedPageParent.RobloxAppHooks).useRoactService
local Responsive = require(NotApprovedPageParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(NotApprovedPageParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(NotApprovedPageParent.RobloxAppEnums).AppPage
local useWebView = require(NotApprovedPageParent.NotApprovedPage.Utils.useWebView)
local FFlagSignalsNavP3Dispatch = require(NotApprovedPageParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(NotApprovedPageParent.RobloxAppNavigation).NavigationCommands
local FFlagEnableNapNewWebView = require(NotApprovedPage.Flags.FFlagEnableNapNewWebView)

local function useOpenLink(s1: string, s2: string) -- line: 32
	-- upvalues: useDispatch (copy), useRoactService (copy), AppLinking (copy), usePreferredInput (copy), Responsive (copy), FFlagEnableNapNewWebView (copy), useWebView (copy), useCallback (copy), VRService (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy)
	local v19 = useDispatch()
	local v20 = useRoactService(AppLinking)
	local v21 = usePreferredInput() == Responsive.Input.Directional
	local v22 = if not FFlagEnableNapNewWebView then nil else useWebView(s1, s2)

	return (useCallback(function() -- line: 38
		-- upvalues: v21 (copy), VRService (copy), v20 (copy), s1 (copy), FFlagEnableNapNewWebView (copy), v22 (copy), AppPage (copy), s2 (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v19 (copy), NavigateDown (copy)
		if v21 or VRService.VREnabled then
			v20:openURL(s1)

			return
		end

		if FFlagEnableNapNewWebView and v22 then
			v22()

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = s1,
			extraProps = {
				title = s2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v14.down(v14.fromLegacyPage(t1))

			return
		end

		v19(NavigateDown(t1))
	end, {
		s1,
		s2,
		v19,
		v21,
		v20,
		v22
	}))
end

return useOpenLink
