local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Constants = require(ContactImporter.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local networkingFriends = dependencies.NetworkingFriends
local networkingContacts = dependencies.NetworkingContacts
local selectors = dependencies.RoduxContacts.Selectors
local memoize = dependencies.memoize
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

local getDeviceContacts = require(script.Parent.getDeviceContacts)
local decorateMatchedContact = require(script.Parent.decorateMatchedContact)

return function(p)
	local localUserId = p.LocalUserId

	local deepValue = getDeepValue(p, RODUX_KEY .. ".Contacts")
	local deviceContacts = memoize(getDeviceContacts)(deepValue)
	local matchedContacts = decorateMatchedContact(selectors.sortContacts(p), deepValue)

	local isFetching = networkingFriends.RequestFriendshipFromContactId.getStatus(p, localUserId) == networkStatus.Fetching
		or networkingContacts.FindContactFriends.getStatus(p, localUserId) == networkStatus.Fetching
		or networkingContacts.GetContactEntitiesByContactId.getStatus(p, localUserId) == networkStatus.Fetching
		or networkingContacts.UploadContactsByUser.getStatus(p, localUserId) == networkStatus.Fetching

	return {
		localUserId = p.LocalUserId,
		matchedContacts = matchedContacts,
		deviceContacts = deviceContacts,
		screenSize = p.ScreenSize,
		isFetching = isFetching
	}
end
