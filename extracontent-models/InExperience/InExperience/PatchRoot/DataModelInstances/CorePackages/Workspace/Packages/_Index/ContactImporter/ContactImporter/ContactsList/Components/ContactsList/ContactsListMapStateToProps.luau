local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local RODUX_KEY = require(ContactImporter.Common.Constants).RODUX_KEY
local NetworkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local NetworkingFriends = dependencies.NetworkingFriends
local NetworkingContacts = dependencies.NetworkingContacts
local Selectors = dependencies.RoduxContacts.Selectors
local memoize = dependencies.memoize
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local getDeviceContacts = require(script.Parent.getDeviceContacts)
local decorateMatchedContact = require(script.Parent.decorateMatchedContact)

return function(p1) -- line: 16
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy), memoize (copy), getDeviceContacts (copy), decorateMatchedContact (copy), Selectors (copy), NetworkingFriends (copy), NetworkStatus (copy), NetworkingContacts (copy)
	local LocalUserId = p1.LocalUserId
	local v14 = getDeepValue(p1, RODUX_KEY .. ".Contacts")
	local v15 = memoize(getDeviceContacts)(v14)
	local v16 = decorateMatchedContact(Selectors.sortContacts(p1), v14)
	local v17 = NetworkingFriends.RequestFriendshipFromContactId.getStatus(p1, LocalUserId) == NetworkStatus.Fetching or (NetworkingContacts.FindContactFriends.getStatus(p1, LocalUserId) == NetworkStatus.Fetching or (NetworkingContacts.GetContactEntitiesByContactId.getStatus(p1, LocalUserId) == NetworkStatus.Fetching or NetworkingContacts.UploadContactsByUser.getStatus(p1, LocalUserId) == NetworkStatus.Fetching))

	return {
		localUserId = p1.LocalUserId,
		matchedContacts = v16,
		deviceContacts = v15,
		screenSize = p1.ScreenSize,
		isFetching = v17
	}
end
