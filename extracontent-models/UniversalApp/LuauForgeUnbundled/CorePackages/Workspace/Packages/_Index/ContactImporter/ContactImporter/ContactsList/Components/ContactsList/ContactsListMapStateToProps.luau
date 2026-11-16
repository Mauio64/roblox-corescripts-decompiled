local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants").RODUX_KEY
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local networkingFriends = dependencies.NetworkingFriends
local networkingContacts = dependencies.NetworkingContacts
local selectors = dependencies.RoduxContacts.Selectors
local memoize = dependencies.memoize
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local getDeviceContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/getDeviceContacts")
local decorateMatchedContact = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/decorateMatchedContact")

return function(p2)
	local localUserId = p2.LocalUserId

	local deepValue = getDeepValue(p2, RODUX_KEY .. ".Contacts")
	local v5 = memoize(getDeviceContacts)(deepValue)
	local v6 = decorateMatchedContact(selectors.sortContacts(p2), deepValue)

	local v7 = networkingFriends.RequestFriendshipFromContactId.getStatus(p2, localUserId) == networkStatus.Fetching
		or networkingContacts.FindContactFriends.getStatus(p2, localUserId) == networkStatus.Fetching
		or networkingContacts.GetContactEntitiesByContactId.getStatus(p2, localUserId) == networkStatus.Fetching
		or networkingContacts.UploadContactsByUser.getStatus(p2, localUserId) == networkStatus.Fetching

	return {
		localUserId = p2.LocalUserId,
		matchedContacts = v6,
		deviceContacts = v5,
		screenSize = p2.ScreenSize,
		isFetching = v7
	}
end
