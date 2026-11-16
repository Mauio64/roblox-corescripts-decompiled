local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/RoduxPresence")
local convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialReducerAdaptors").convertActions
local presenceActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialReducerAdaptors").presenceActionAdaptor

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
})
