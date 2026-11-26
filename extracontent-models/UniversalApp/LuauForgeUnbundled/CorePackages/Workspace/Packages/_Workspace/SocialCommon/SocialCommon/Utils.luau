return {
	getMutualFriendsText = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getMutualFriendsText"),
	getRecommendationContextualInfoDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getRecommendationContextualInfoDisplay"),
	getRecommendationContextualInfoType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getRecommendationContextualInfoType"),
	convertLuaAppUserToSocialUser = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/convertLuaAppUserToSocialUser"),
	convertUserPresenceTypeToString = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/convertUserPresenceTypeToString"),
	convertToFoundationPresenceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/convertToFoundationPresenceEnum"),
	InputUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/InputUtilities"),
	isPresenceInGame = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/isPresenceInGame"),
	simpleUrlDecode = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/simpleUrlDecode"),
	buildApiSiteUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/buildApiSiteUrl"),
	userIdExists = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/userIdExists"),
	hydrateEmptyIdsHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/hydrateEmptyIdsHelper"),
	ImpressionCacheImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/ImpressionCacheImpl"),
	getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getDeepValue")
}
