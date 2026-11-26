local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactNavigation")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage

local v5 = {
	[appPage.TrustedFriendsUserModal] = {
		getScreen = function()
			return require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal").Screen
		end,
		navigationOptions = {
			renderUnderlyingPage = true,
			disableBackButton = true,
			overlayEnabled = true
		}
	}
}

local v6 = {
	[appPage.TrustedFriendsVPCPrologue] = {
		getScreen = function()
			return require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedFriendsVPCPrologue").Screen
		end,
		navigationOptions = {
			renderUnderlyingPage = true,
			disableBackButton = true,
			overlayEnabled = true
		}
	}
}
return (RoactNavigation.createRobloxStackNavigator({ v5, v6 }, {
	initialRouteName = appPage.TrustedFriendsUserModal,
	keepVisitedScreensMounted = false,
	backBehavior = RoactNavigation.BackBehavior.History
}))
