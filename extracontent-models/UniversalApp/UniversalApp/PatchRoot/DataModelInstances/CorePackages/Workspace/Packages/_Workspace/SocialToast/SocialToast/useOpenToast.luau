local Parent = script:FindFirstAncestor("SocialToast").Parent
local NavigationRodux = require(Parent.NavigationRodux)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function() -- line: 15
	-- upvalues: useDispatch (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy)
	local v10 = useDispatch()

	return React.useCallback(function(t1: {[any]: any}) -- line: 18
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), v10 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.SocialToast,
			extraProps = {
				toastContent = t1
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v9.down(v9.fromLegacyPage(t2))

			return
		end

		v10(NavigateDown(t2, nil))
	end, {})
end
