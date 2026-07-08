local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local NetworkingFriends = dependencies.NetworkingFriends

require(ParentParent.Common.LocalTypes)

local NetworkingContacts = dependencies.NetworkingContacts
local RoduxContacts = dependencies.RoduxContacts
local Promise = dependencies.Promise
local llama = dependencies.llama

return function(p1) -- line: 11
	-- upvalues: NetworkingFriends (copy), NetworkingContacts (copy), llama (copy), Promise (copy), RoduxContacts (copy)
	return {
		requestFriendship = function(p2) -- line: 13
			-- upvalues: p1 (copy), NetworkingFriends (copy)
			return p1(NetworkingFriends.RequestFriendshipFromContactId.API(p2))
		end,
		findContacts = function() -- line: 16
			-- upvalues: p1 (copy), NetworkingContacts (copy)
			return p1(NetworkingContacts.FindContactFriends.API()):andThen(function(p3) -- line: 17
				return p3.responseBody.userContactIds
			end)
		end,
		getContactEntities = function(p4) -- line: 21
			-- upvalues: llama (copy), Promise (copy), p1 (copy), NetworkingContacts (copy)
			if llama.isEmpty(p4) or not p4 then
				return Promise.resolve()
			end

			return p1(NetworkingContacts.GetContactEntitiesByContactId.API(p4))
		end,
		uploadContacts = function(p5) -- line: 28
			-- upvalues: p1 (copy), NetworkingContacts (copy)
			return p1(NetworkingContacts.UploadContactsByUser.API(p5))
		end,
		deviceContactsReceived = function(p6) -- line: 31
			-- upvalues: p1 (copy), RoduxContacts (copy)
			return p1(RoduxContacts.Actions.DeviceContactsReceived(p6))
		end,
		requestSent = function(p7) -- line: 34
			-- upvalues: p1 (copy), RoduxContacts (copy)
			return p1(RoduxContacts.Actions.RequestSent({
				id = p7
			}))
		end
	}
end
