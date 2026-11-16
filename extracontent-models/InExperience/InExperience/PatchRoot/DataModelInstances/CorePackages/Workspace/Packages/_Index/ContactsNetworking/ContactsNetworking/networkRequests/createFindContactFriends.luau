local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)
require(parent.Types.networkRequestsTypes)

game:DefineFastString("ContactImporterFindFriendsUrl", "contacts")
local fastString = game:GetFastString("ContactImporterFindFriendsUrl")

return function(p)
	return p.roduxNetworking.GET("FindContactFriends", function(callback)
		return callback(API_URL):path("contacts-api"):path("v1"):path(fastString)
	end)
end
