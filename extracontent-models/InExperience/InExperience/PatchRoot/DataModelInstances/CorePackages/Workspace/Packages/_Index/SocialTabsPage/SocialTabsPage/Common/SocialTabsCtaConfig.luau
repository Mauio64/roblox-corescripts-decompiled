local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local FriendsNetworking = require(parent.FriendsNetworking)
local SocialCommon = require(parent.SocialCommon)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UserList = require(parent.UserList)

local AppPage = RobloxAppEnums.AppPage
local CtaSurfaces = UserList.Enums.CtaSurfaces
local ClientCtaActions = UserList.Enums.ClientCtaActions
local FriendshipOriginSourceType = FriendsNetworking.Enums.FriendshipOriginSourceType
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local FFlagSocialTabsSelfRowViewCta = require(SocialTabsPage.Flags.FFlagSocialTabsSelfRowViewCta)
local FFlagSocialTabsViewOnlyRowCta = require(SocialTabsPage.Flags.FFlagSocialTabsViewOnlyRowCta)

local v = {
	friendshipOriginSourceType = FriendshipOriginSourceType.SocialTabsPage.rawValue(),
	chatEntryPoint = ChatEntryPointNames.SocialTabsPage,
	primaryCtaMinWidth = 64,
	primaryCtaMaxWidth = 90,
	clientActions = FFlagSocialTabsViewOnlyRowCta and { ClientCtaActions.ViewProfile } or nil,
	showSelfProfileCta = FFlagSocialTabsSelfRowViewCta and true or nil
}

local function forTab(subpage: string) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(v)
	clone.analytics = { surface = CtaSurfaces.SocialTabsPage, subpage = subpage }

	return clone
end

local rowSelection = { friendshipOriginSourceType = v.friendshipOriginSourceType }

return {
	Friends = forTab(AppPage.SocialTabsFriends), -- inferred equivalent call
	Mutuals = forTab(AppPage.SocialTabsMutuals), -- inferred equivalent call
	RowSelection = rowSelection
}
