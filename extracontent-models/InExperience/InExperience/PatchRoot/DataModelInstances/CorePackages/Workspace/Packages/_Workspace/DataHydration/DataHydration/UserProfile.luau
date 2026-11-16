local UserProfileDataHydration = require(script.UserProfileDataHydration)

return {
	resolveField = UserProfileDataHydration.resolveField,
	updateFromHydration = UserProfileDataHydration.updateFromHydration,
	getAndFetchUserInfo = UserProfileDataHydration.getAndFetchUserInfo,
	getAndFetchUserNames = UserProfileDataHydration.getAndFetchUserNames,
	getAndFetchUserNamesByUserIds = UserProfileDataHydration.getAndFetchUserNamesByUserIds
}
