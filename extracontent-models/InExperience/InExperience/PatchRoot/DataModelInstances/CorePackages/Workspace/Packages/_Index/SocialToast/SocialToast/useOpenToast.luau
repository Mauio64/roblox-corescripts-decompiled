local parent = script:FindFirstAncestor("SocialToast").Parent
local NavigationRodux = require(parent.NavigationRodux)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

return function()
	local v = useDispatch()

	return React.useCallback(function(toastContent)
		local v2 = {
			name = AppPage.SocialToast,
			extraProps = { toastContent = toastContent }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			v(NavigateDown(v2, nil))
		end
	end, {})
end
