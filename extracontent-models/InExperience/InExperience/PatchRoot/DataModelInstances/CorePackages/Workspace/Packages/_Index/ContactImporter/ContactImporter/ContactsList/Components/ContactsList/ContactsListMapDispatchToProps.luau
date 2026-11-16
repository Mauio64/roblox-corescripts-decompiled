local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local dependencies = require(parent.dependencies)
local networkingFriends = dependencies.NetworkingFriends
require(parent.Common.LocalTypes)
local networkingContacts = dependencies.NetworkingContacts
local roduxContacts = dependencies.RoduxContacts
local promise = dependencies.Promise
local llama = dependencies.llama

local SharedFlags = require(parent2.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions
local friendsStoreChallengeNetwork = require(parent.Networking.friendsStoreChallengeNetwork)

local SharedFlags2 = require(parent2.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags2.FFlagEnableFriendsStoreChallengeInterceptor
local DataHydration = require(parent2.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

return function(callback)
	return {
		requestFriendship = function(p)
			if not FFlagMigrateFriendshipStatusesRemainingActions then
				return callback(networkingFriends.RequestFriendshipFromContactId.API(p))
			end

			local requestFriendship = v.RequestFriendship
			local contactId = p.contactId
			local v2

			if FFlagEnableFriendsStoreChallengeInterceptor then
				v2 = friendsStoreChallengeNetwork
			end

			return requestFriendship(contactId, nil, { isContact = true }, v2)
		end,
		findContacts = function()
			return callback(networkingContacts.FindContactFriends.API()):andThen(function(p)
				return p.responseBody.userContactIds
			end)
		end,
		getContactEntities = function(p)
			if llama.isEmpty(p) or not p then
				return promise.resolve()
			end

			return callback(networkingContacts.GetContactEntitiesByContactId.API(p))
		end,
		uploadContacts = function(p)
			return callback(networkingContacts.UploadContactsByUser.API(p))
		end,
		deviceContactsReceived = function(p)
			return callback(roduxContacts.Actions.DeviceContactsReceived(p))
		end,
		requestSent = function(id)
			return callback(roduxContacts.Actions.RequestSent({ id = id }))
		end
	}
end
