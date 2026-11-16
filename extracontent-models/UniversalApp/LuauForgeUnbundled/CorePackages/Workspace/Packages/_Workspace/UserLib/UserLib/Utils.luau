local module = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/ThumbnailRequest")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/AvatarThumbnailRequests")

return {
	getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/getStandardSizeAvatarHeadShotRbxthumb"),
	getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/getRbxthumbWithTypeSizeAndOptions"),
	getFriendsActiveGamesPlaceIdsFromUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/getFriendsActiveGamesPlaceIdsFromUsersPresence"),
	receiveUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/receiveUsersPresence"),
	Constants = module,
	ThumbnailRequest = module2,
	AvatarThumbnailRequests = module3,
	isPlayerVerified = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/isPlayerVerified")
}
