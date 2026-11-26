local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/NavigationRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/RoactUtils")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/RobloxAppEnums").AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/RobloxAppNavigation").NavigationCommands else nil

return function()
	local v5 = useDispatch()

	return React.useCallback(function(p2)
		local v6 = {
			name = appPage.SocialToast,
			extraProps = { toastContent = p2 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v5(navigateDown(v6, nil))
		end
	end, {})
end
