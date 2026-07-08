local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage
local Sources = require(Parent.SocialLuaAnalytics).Analytics.Enums.Sources
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function() -- line: 22
	-- upvalues: useDispatch (copy), useLocalization (copy), React (copy), AppPage (copy), Sources (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), SetCurrentToastMessage (copy)
	local v11 = useDispatch()
	local v12 = useLocalization({
		somethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	return (React.useCallback(function(t1: {[any]: any}?) -- line: 30
		-- upvalues: AppPage (copy), Sources (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), v11 (copy), NavigateDown (copy), SetCurrentToastMessage (copy), v12 (copy)
		local v14 = t1 and t1.callback
		local v15 = t1 and (t1.clientEventsPayload and t1.clientEventsPayload.sender_userid)

		if v15 then
			local t2 = {
				name = AppPage.TrustedContactsModal,
				props = {
					userId = v15,
					source = Sources.StreamNotification,
					onRequestAccepted = v14
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t2), true)

				return
			end

			v11(NavigateDown(t2, true))

			return
		end

		v11(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v12.somethingIsWrongToast
		}))
	end, {
		v11,
		v12
	}))
end
