local scriptParent = script.Parent
local networkRequests = scriptParent.networkRequests
local createUploadContactsByUser = require(networkRequests.createUploadContactsByUser)
local createFindContactFriends = require(networkRequests.createFindContactFriends)
local createGetContactEntitiesByContactId = require(networkRequests.createGetContactEntitiesByContactId)

require(scriptParent.Types.networkRequestsTypes)

return function(p1) -- line: 8
	-- upvalues: createUploadContactsByUser (copy), createFindContactFriends (copy), createGetContactEntitiesByContactId (copy)
	return {
		UploadContactsByUser = createUploadContactsByUser(p1),
		FindContactFriends = createFindContactFriends(p1),
		GetContactEntitiesByContactId = createGetContactEntitiesByContactId(p1)
	}
end
