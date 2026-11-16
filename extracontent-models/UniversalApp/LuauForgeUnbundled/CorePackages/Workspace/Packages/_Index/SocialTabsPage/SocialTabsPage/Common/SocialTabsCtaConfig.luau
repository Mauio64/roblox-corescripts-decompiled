local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/NetworkingFriends")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SocialCommon")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RobloxAppEnums")
local UserList = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList")

local appPage = RobloxAppEnums.AppPage
local ctaSurfaces = UserList.Enums.CtaSurfaces
local clientCtaActions = UserList.Enums.ClientCtaActions
local friendshipOriginSourceType = NetworkingFriends.Enums.FriendshipOriginSourceType
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local FFlagSocialTabsSelfRowViewCta = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Flags/FFlagSocialTabsSelfRowViewCta")
local FFlagSocialTabsViewOnlyRowCta = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Flags/FFlagSocialTabsViewOnlyRowCta")

local v5 = {
	friendshipOriginSourceType = friendshipOriginSourceType.SocialTabsPage.rawValue(),
	chatEntryPoint = chatEntryPointNames.SocialTabsPage,
	primaryCtaMinWidth = 64,
	primaryCtaMaxWidth = 90,
	clientActions = FFlagSocialTabsViewOnlyRowCta and { clientCtaActions.ViewProfile } or nil,
	showSelfProfileCta = FFlagSocialTabsSelfRowViewCta and true or nil
}

local function forTab(p2)
	local clone = table.clone(v5)
	clone.analytics = { surface = ctaSurfaces.SocialTabsPage, subpage = p2 }

	return clone
end

local v6 = { friendshipOriginSourceType = v5.friendshipOriginSourceType }

local socialTabsFriends = appPage.SocialTabsFriends
local clone = table.clone(v5)
clone.analytics = { surface = ctaSurfaces.SocialTabsPage, subpage = socialTabsFriends }

local socialTabsMutuals = appPage.SocialTabsMutuals
local clone2 = table.clone(v5)
clone2.analytics = { surface = ctaSurfaces.SocialTabsPage, subpage = socialTabsMutuals }

return { Friends = clone, Mutuals = clone2, RowSelection = v6 }
