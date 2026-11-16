local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactUtils").Hooks.RoactRodux.useDispatch
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/ToastRodux").Actions.SetCurrentToastMessage
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics").Analytics.Enums.Sources

local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppNavigation").NavigationCommands else nil

return function()
	local v5 = useDispatch()

	local v6 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	return (React.useCallback(function(p2)
		local callback = p2 and p2.callback
		local sender_userid = p2 and p2.clientEventsPayload and p2.clientEventsPayload.sender_userid

		if not sender_userid then
			v5(setCurrentToastMessage({
				toastMessage = v6.somethingIsWrongToast,
				isLocalized = true
			}))

			return
		end

		local v7 = {
			name = appPage.TrustedContactsModal,
			props = {
				userId = sender_userid,
				source = sources.StreamNotification,
				onRequestAccepted = callback
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7), true)
		else
			v5(navigateDown(v7, true))
		end
	end, { v5, v6 }))
end
