local UserProfileDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UserProfile/UserProfileDataHydration")

return {
	resolveField = UserProfileDataHydration.resolveField,
	updateFromHydration = UserProfileDataHydration.updateFromHydration,
	getAndFetchUserInfo = UserProfileDataHydration.getAndFetchUserInfo,
	getAndFetchUserNames = UserProfileDataHydration.getAndFetchUserNames,
	getAndFetchUserNamesByUserIds = UserProfileDataHydration.getAndFetchUserNamesByUserIds
}
