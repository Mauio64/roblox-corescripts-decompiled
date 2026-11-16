local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local RoduxPresence = require(UserSearch.Rodux.RoduxPresence)
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
