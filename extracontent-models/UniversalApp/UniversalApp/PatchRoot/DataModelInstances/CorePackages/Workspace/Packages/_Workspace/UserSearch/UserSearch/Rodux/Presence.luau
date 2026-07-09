local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local RoduxPresence = require(UserSearch.Rodux.RoduxPresence)
local convertActions = require(UserSearchParent.SocialReducerAdaptors).convertActions
local presenceActionAdaptor = require(UserSearchParent.SocialReducerAdaptors).presenceActionAdaptor
local t1 = {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
}

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), t1)
