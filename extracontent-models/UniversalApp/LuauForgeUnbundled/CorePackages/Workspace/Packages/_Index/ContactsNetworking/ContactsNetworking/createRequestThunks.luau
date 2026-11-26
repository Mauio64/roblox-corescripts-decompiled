local createUploadContactsByUser = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/networkRequests/createUploadContactsByUser")
local createFindContactFriends = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/networkRequests/createFindContactFriends")
local createGetContactEntitiesByContactId = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/networkRequests/createGetContactEntitiesByContactId")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/Types/networkRequestsTypes")

return function(p2)
	return {
		UploadContactsByUser = createUploadContactsByUser(p2),
		FindContactFriends = createFindContactFriends(p2),
		GetContactEntitiesByContactId = createGetContactEntitiesByContactId(p2)
	}
end
