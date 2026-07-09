local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local TrustedContacts = require(Parent.TrustedContacts)
local AppTabBarRodux = require(Parent.AppTabBarRodux)
local RoactUtils = require(Parent.RoactUtils)
local SetTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local TrustedFriendsModalEntry = TrustedContacts.TrustedFriendsModalEntry

local function TrustedContactsModalScreen(t1: {[any]: any}) -- line: 37
	-- upvalues: useDispatch (copy), React (copy), SetTabBarVisibleFromChat (copy), TrustedFriendsModalEntry (copy), Cryo (copy)
	local navigation = t1.navigation
	local v13 = navigation.getParam("props")
	local v14 = useDispatch()
	local v15 = React.useCallback(function() -- line: 42
		-- upvalues: navigation (copy)
		navigation.pop()
	end, { navigation })

	React.useEffect(function() -- line: 46
		-- upvalues: v14 (copy), SetTabBarVisibleFromChat (copy)
		v14(SetTabBarVisibleFromChat(false))

		return function() -- line: 48
			-- upvalues: v14 (copy), SetTabBarVisibleFromChat (copy)
			v14(SetTabBarVisibleFromChat(true))
		end
	end, { v14 })

	return React.createElement(TrustedFriendsModalEntry, Cryo.Dictionary.join(v13, {
		onClosed = v15
	}))
end

return TrustedContactsModalScreen
