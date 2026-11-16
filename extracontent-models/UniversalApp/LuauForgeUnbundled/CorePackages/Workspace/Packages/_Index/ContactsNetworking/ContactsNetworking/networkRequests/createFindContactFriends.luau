local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ContactsNetworking/ContactsNetworking/Types/networkRequestsTypes")

game:DefineFastString("ContactImporterFindFriendsUrl", "contacts")
local fastString = game:GetFastString("ContactImporterFindFriendsUrl")

return function(p2)
	return p2.roduxNetworking.GET("FindContactFriends", function(callback)
		return callback(API_URL):path("contacts-api"):path("v1"):path(fastString)
	end)
end
