local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local RoactNavigation = require(parent.RoactNavigation)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local v = {
	[AppPage.TrustedFriendsUserModal] = {
		getScreen = function()
			local TrustedContactsModal = require(TrustedContacts.Components.TrustedContactsModal)
			return TrustedContactsModal.Screen
		end,
		navigationOptions = {
			renderUnderlyingPage = true,
			disableBackButton = true,
			overlayEnabled = true
		}
	}
}

local v2 = {
	[AppPage.TrustedFriendsVPCPrologue] = {
		getScreen = function()
			local TrustedFriendsVPCPrologue = require(TrustedContacts.Components.TrustedFriendsVPCPrologue)
			return TrustedFriendsVPCPrologue.Screen
		end,
		navigationOptions = {
			renderUnderlyingPage = true,
			disableBackButton = true,
			overlayEnabled = true
		}
	}
}
return (RoactNavigation.createRobloxStackNavigator({ v, v2 }, {
	initialRouteName = AppPage.TrustedFriendsUserModal,
	keepVisitedScreensMounted = false,
	backBehavior = RoactNavigation.BackBehavior.History
}))
