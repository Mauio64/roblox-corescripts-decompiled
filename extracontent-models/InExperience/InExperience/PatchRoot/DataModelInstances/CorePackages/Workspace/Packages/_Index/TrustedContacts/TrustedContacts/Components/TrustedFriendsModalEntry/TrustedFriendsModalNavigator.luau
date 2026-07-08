local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local RoactNavigation = require(TrustedContactsParent.RoactNavigation)
local AppPage = require(TrustedContactsParent.RobloxAppEnums).AppPage
local t1 = {
	{
		[AppPage.TrustedFriendsUserModal] = {
			getScreen = function() -- line: 15
				-- upvalues: TrustedContacts (copy)
				return require(TrustedContacts.Components.TrustedContactsModal).Screen
			end,
			navigationOptions = {
				renderUnderlyingPage = true,
				disableBackButton = true,
				overlayEnabled = true
			}
		}
	},
	{
		[AppPage.TrustedFriendsVPCPrologue] = {
			getScreen = function() -- line: 27
				-- upvalues: TrustedContacts (copy)
				return require(TrustedContacts.Components.TrustedFriendsVPCPrologue).Screen
			end,
			navigationOptions = {
				renderUnderlyingPage = true,
				disableBackButton = true,
				overlayEnabled = true
			}
		}
	}
}

return (RoactNavigation.createRobloxStackNavigator(t1, {
	keepVisitedScreensMounted = false,
	initialRouteName = AppPage.TrustedFriendsUserModal,
	backBehavior = RoactNavigation.BackBehavior.History
}))
