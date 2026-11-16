local parent = script:FindFirstAncestor("FriendsLanding").Parent

local SocialCommon = require(parent.SocialCommon)
local UserList = require(parent.UserList)

local CtaSurfaces = UserList.Enums.CtaSurfaces
return {
	supportedActions = { "Chat", "JoinExperience" },
	chatEntryPoint = SocialCommon.Enums.ChatEntryPointNames.FriendsLandingPage,
	analytics = { surface = CtaSurfaces.FriendsLandingPage }
}
