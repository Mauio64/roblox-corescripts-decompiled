local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local RoactNavigation = require(AccountRecoveryParent.RoactNavigation)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local useNavigation = require(AccountRecoveryParent.Navigation).useNavigation
local DarkTheme = UIBlox.App.Style.Themes.DarkTheme
local useStyle = UIBlox.Core.Style.useStyle
local memoize = require(AccountRecoveryParent.AppCommonLib).memoize
local useIOSStatusBarStyler = require(AccountRecoveryParent.RoactUtils).Hooks.useIOSStatusBarStyler

require(AccountRecovery.Store.State)

local AccountRecoveryContextProvider = require(AccountRecovery.Store.AccountRecoveryContextProvider)
local AccountRecoveryStackNavigator = require(AccountRecovery.Navigators.AccountRecoveryStackNavigator)
local v13 = memoize(function(p1) -- line: 23
	-- upvalues: RoactNavigation (copy)
	return RoactNavigation.createAppContainer(p1)
end)

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useNavigation (copy), useStyle (copy), v13 (copy), AccountRecoveryStackNavigator (copy), React (copy), RoactNavigation (copy), useIOSStatusBarStyler (copy), DarkTheme (copy), AccountRecoveryContextProvider (copy)
	local v16 = useNavigation()
	local v17 = useStyle()
	local v18 = v13(AccountRecoveryStackNavigator)
	local v19 = React.useRef(nil)
	local v20 = React.useCallback(function(p2) -- line: 34
		-- upvalues: v19 (copy)
		v19.current = p2

		return function() -- line: 36
			-- upvalues: v19 (copy)
			v19.current = nil
		end
	end, {})
	local v21 = React.useCallback(function() -- line: 41
		-- upvalues: v19 (copy), RoactNavigation (copy)
		local current = v19.current

		if current then
			current(RoactNavigation.StackActions.popToTop())
		end
	end, {})

	useIOSStatusBarStyler(v17.Theme == DarkTheme)

	return React.createElement(AccountRecoveryContextProvider, {
		parentNavigation = v16,
		monoDeps = t1.monoDeps,
		resetChildNavigationToFirstScreen = v21
	}, {
		NavigationAppContainer = React.createElement(v18, {
			externalDispatchConnector = v20
		})
	})
end
