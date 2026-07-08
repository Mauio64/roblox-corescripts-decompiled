local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Images = require(CorePackages.Packages.InGameMenuDependencies).UIBlox.App.ImageSet.Images
local Constants = require(ParentParent.Resources.Constants)
local t1 = {
	{
		navigationDepth = 1,
		parentPage = nil,
		key = Constants.InitalPageKey,
		component = script.InitalPage
	},
	{
		navigationDepth = 1,
		parentPage = nil,
		key = Constants.MainPagePageKey,
		component = script.Parent.MainPage
	},
	{
		key = "Players",
		title = "CoreScripts.InGameMenu.PageTitle.Players",
		navigationDepth = 2,
		icon = Images["icons/controls/players"],
		component = script.PlayersPage,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "InviteFriends",
		title = "CoreScripts.InGameMenu.PageTitle.InviteFriends",
		navigationDepth = 2,
		icon = Images["icons/actions/friends/friendInvite"],
		component = script.Parent.InviteFriendsPage,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "GameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.GameSettings",
		navigationDepth = 2,
		icon = Images["icons/common/settings"],
		component = script.Parent.GameSettingsPage.BasicPage,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "Report",
		title = "CoreScripts.InGameMenu.PageTitle.Report",
		navigationDepth = 2,
		icon = Images["icons/actions/feedback"],
		component = script.Parent.ReportPage,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "Controls",
		title = "CoreScripts.InGameMenu.PageTitle.Controls",
		isModal = true,
		navigationDepth = 2,
		icon = Images["icons/controls/controls"],
		component = script.Parent.ControlsPage,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "AdvancedGameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.GameSettings",
		isSecondaryPage = true,
		navigationDepth = 3,
		parentPage = "GameSettings",
		icon = Images["icons/menu/settings_large"],
		component = script.Parent.GameSettingsPage.AdvancedPage
	},
	{
		key = "VRGameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.VRComfortSettings",
		isSecondaryPage = true,
		navigationDepth = 3,
		parentPage = "GameSettings",
		icon = Images["icons/menu/settings_large"],
		component = script.Parent.GameSettingsPage.VRComfortSettingsPage
	},
	{
		navigationDepth = 1,
		parentPage = nil,
		key = Constants.LeaveToAppPromptPageKey,
		component = script.Dialog.LeaveToAppPrompt
	},
	{
		navigationDepth = 1,
		parentPage = nil,
		key = Constants.LeaveGamePromptPageKey,
		component = script.Dialog.LeaveGamePrompt
	}
}
local t2 = {}

for i, v in ipairs(t1) do
	v.index = i
	assert(t2[v.key] == nil, ("page key %s is duplicated"):format(v.key))
	t2[v.key] = v
end

return {
	pagesByIndex = t1,
	pagesByKey = t2
}
