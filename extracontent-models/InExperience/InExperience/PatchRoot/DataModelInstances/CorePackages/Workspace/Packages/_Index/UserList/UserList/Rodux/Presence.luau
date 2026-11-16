local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local RoduxPresence = require(UserList.Rodux.RoduxPresence)
local SocialReducerAdaptors = require(parent.SocialReducerAdaptors)
local convertActions = SocialReducerAdaptors.convertActions
local SocialReducerAdaptors2 = require(parent.SocialReducerAdaptors)
local presenceActionAdaptor = SocialReducerAdaptors2.presenceActionAdaptor

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
})
