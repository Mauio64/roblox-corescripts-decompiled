local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local RoduxPresence = require(UserList.Rodux.RoduxPresence)
local convertActions = require(UserListParent.SocialReducerAdaptors).convertActions
local presenceActionAdaptor = require(UserListParent.SocialReducerAdaptors).presenceActionAdaptor
local t1 = {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
}

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), t1)
