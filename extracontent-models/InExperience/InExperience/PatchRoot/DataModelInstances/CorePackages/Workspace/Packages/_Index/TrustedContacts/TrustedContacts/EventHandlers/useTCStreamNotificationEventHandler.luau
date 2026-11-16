local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local NavigationRodux = require(parent.NavigationRodux)
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

	local v2 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	return (React.useCallback(function(p)
		local callback = p and p.callback
		local sender_userid = p and p.clientEventsPayload and p.clientEventsPayload.sender_userid

		if not sender_userid then
			v(SetCurrentToastMessage({ toastMessage = v2.somethingIsWrongToast, isLocalized = true }))

			return
		end

		local v3 = {
			name = AppPage.TrustedContactsModal,
			props = {
				userId = sender_userid,
				source = Sources.StreamNotification,
				onRequestAccepted = callback
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3), true)
		else
			v(NavigateDown(v3, true))
		end
	end, { v, v2 }))
end
