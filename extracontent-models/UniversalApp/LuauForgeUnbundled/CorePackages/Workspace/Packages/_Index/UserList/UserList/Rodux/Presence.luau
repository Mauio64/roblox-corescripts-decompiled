local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Rodux/RoduxPresence")
local convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialReducerAdaptors").convertActions
local presenceActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialReducerAdaptors").presenceActionAdaptor

return convertActions(RoduxPresence.installReducer(), presenceActionAdaptor(RoduxPresence), {
	byUserId = {},
	byGameId = {},
	byGameInstanceId = {},
	byPlaceId = {}
})
