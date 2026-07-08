local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local RoduxPresence = dependencies.RoduxPresence
local convertActions = dependencies.convertActions
local presenceActionAdaptor = dependencies.presenceActionAdaptor
local t1 = {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
}

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), t1)
