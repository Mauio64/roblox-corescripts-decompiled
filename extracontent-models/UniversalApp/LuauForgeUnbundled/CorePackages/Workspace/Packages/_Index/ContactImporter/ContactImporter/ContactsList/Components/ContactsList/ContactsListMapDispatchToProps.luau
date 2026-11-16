local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local networkingFriends = dependencies.NetworkingFriends
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/LocalTypes")
local networkingContacts = dependencies.NetworkingContacts
local roduxContacts = dependencies.RoduxContacts
local promise = dependencies.Promise
local llama = dependencies.llama

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/DataHydration").Friends.FriendsStore.get()

return function(callback)
	return {
		requestFriendship = function(p2)
			if not fFlagMigrateFriendshipStatusesRemainingActions then
				return callback(networkingFriends.RequestFriendshipFromContactId.API(p2))
			end

			return v5.RequestFriendship(
				p2.contactId,
				nil,
				{ isContact = true },
				if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
			)
		end,
		findContacts = function()
			return callback(networkingContacts.FindContactFriends.API()):andThen(function(p2)
				return p2.responseBody.userContactIds
			end)
		end,
		getContactEntities = function(p2)
			if llama.isEmpty(p2) or not p2 then
				return promise.resolve()
			end

			return callback(networkingContacts.GetContactEntitiesByContactId.API(p2))
		end,
		uploadContacts = function(p2)
			return callback(networkingContacts.UploadContactsByUser.API(p2))
		end,
		deviceContactsReceived = function(p2)
			return callback(roduxContacts.Actions.DeviceContactsReceived(p2))
		end,
		requestSent = function(p2)
			return callback(roduxContacts.Actions.RequestSent({ id = p2 }))
		end
	}
end
