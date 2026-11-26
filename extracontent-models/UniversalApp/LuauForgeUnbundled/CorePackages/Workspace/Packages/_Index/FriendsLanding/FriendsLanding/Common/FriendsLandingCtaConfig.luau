local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialCommon")
local ctaSurfaces = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserList").Enums.CtaSurfaces
return {
	supportedActions = { "Chat", "JoinExperience" },
	chatEntryPoint = SocialCommon.Enums.ChatEntryPointNames.FriendsLandingPage,
	analytics = { surface = ctaSurfaces.FriendsLandingPage }
}
