local parent = script.Parent
local networkRequests = parent.networkRequests
local createUploadContactsByUser = require(networkRequests.createUploadContactsByUser)
local createFindContactFriends = require(networkRequests.createFindContactFriends)
local createGetContactEntitiesByContactId = require(networkRequests.createGetContactEntitiesByContactId)
require(parent.Types.networkRequestsTypes)

return function(p)
	return {
		UploadContactsByUser = createUploadContactsByUser(p),
		FindContactFriends = createFindContactFriends(p),
		GetContactEntitiesByContactId = createGetContactEntitiesByContactId(p)
	}
end
