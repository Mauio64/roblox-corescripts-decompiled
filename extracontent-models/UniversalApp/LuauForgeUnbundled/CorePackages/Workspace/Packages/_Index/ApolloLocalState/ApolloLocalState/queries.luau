return {
	profilesInsightsByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/fragments/userPresenceAllFields"),
	userProfilesCombinedNameByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/allFriendsByUserId"),
	userProfilesCombinedNameAndAliasByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/onlineFriendsByUserId"),
	userProfilesCombinedNameAndUsernameByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/profilesInsightsByUserIds"),
	userProfilesCombinedNameUsernameAndIsVerifiedByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/userProfilesBasicNamesByUserIds"),
	userProfilesBasicNamesByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/userProfilesCombinedAndPlatformByUserIds"),
	userProfilesAllNamesByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/userProfilesAllNamesByUserIds"),
	userProfilesDisplayNameAndUsernameByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/userProfilesCombinedNameAndAliasByUserIds"),
	userProfilesDisplayUserPlatformNamesByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/queries/userProfilesCombinedNameAndUsernameByUserIds"),
	userProfilesInExperienceNamesByUserIds = require("@luauforge/bundled/aTi"),
	userProfilesCombinedAndPlatformByUserIds = require("@luauforge/bundled/aTk"),
	userProfilesPlatformNamesByUserIds = require("@luauforge/bundled/aTm"),
	userProfilesPlatformProfileIdsByUserIds = require("@luauforge/bundled/aTo"),
	allFriendsByUserId = require("@luauforge/bundled/aTq"),
	onlineFriendsByUserId = require("@luauforge/bundled/aTs"),
	userProfilesFriendsLandingQueryByUserIds = require("@luauforge/bundled/aTu")
}
