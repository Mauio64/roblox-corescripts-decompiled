local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.Types.networkRequestsTypes)
game:DefineFastString("ContactImporterFindFriendsUrl", "contacts")

local FastString = game:GetFastString("ContactImporterFindFriendsUrl")

return function(p1) -- line: 8
	-- upvalues: API_URL (copy), FastString (copy)
	return p1.roduxNetworking.GET({
		Name = "FindContactFriends"
	}, function(p2) -- line: 11
		-- upvalues: API_URL (copy), FastString (copy)
		return p2(API_URL):path("contacts-api"):path("v1"):path(FastString)
	end)
end
