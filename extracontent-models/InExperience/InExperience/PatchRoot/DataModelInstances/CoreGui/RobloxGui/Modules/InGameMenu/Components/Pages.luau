local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Images = InGameMenuDependencies.UIBlox.App.ImageSet.Images

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local Constants = require(parent.Resources.Constants)

local pagesByIndex = {
	{
		key = Constants.InitalPageKey,
		navigationDepth = 1,
		component = script.InitalPage,
		parentPage = nil
	},
	{
		key = Constants.MainPagePageKey,
		navigationDepth = 1,
		component = script.Parent.MainPage,
		parentPage = nil
	},
	{
		key = "Players",
		title = "CoreScripts.InGameMenu.PageTitle.Players",
		icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/controls/players" or Images["icons/controls/players"],
		component = script.PlayersPage,
		navigationDepth = 2,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "InviteFriends",
		title = "CoreScripts.InGameMenu.PageTitle.InviteFriends",
		icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/actions/friends/friendInvite" or Images["icons/actions/friends/friendInvite"],
		component = script.Parent.InviteFriendsPage,
		navigationDepth = 2,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "GameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.GameSettings",
		icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/common/settings" or Images["icons/common/settings"],
		component = script.Parent.GameSettingsPage.BasicPage,
		navigationDepth = 2,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "Report",
		title = "CoreScripts.InGameMenu.PageTitle.Report",
		icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/actions/feedback" or Images["icons/actions/feedback"],
		component = script.Parent.ReportPage,
		navigationDepth = 2,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "Controls",
		title = "CoreScripts.InGameMenu.PageTitle.Controls",
		icon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/controls/controls" or Images["icons/controls/controls"],
		component = script.Parent.ControlsPage,
		isModal = true,
		navigationDepth = 2,
		parentPage = Constants.MainPagePageKey
	},
	{
		key = "AdvancedGameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.GameSettings",
		icon = Images["icons/menu/settings_large"],
		component = script.Parent.GameSettingsPage.AdvancedPage,
		isSecondaryPage = true,
		navigationDepth = 3,
		parentPage = "GameSettings"
	},
	{
		key = "VRGameSettings",
		title = "CoreScripts.InGameMenu.PageTitle.VRComfortSettings",
		icon = Images["icons/menu/settings_large"],
		component = script.Parent.GameSettingsPage.VRComfortSettingsPage,
		isSecondaryPage = true,
		navigationDepth = 3,
		parentPage = "GameSettings"
	},
	{
		key = Constants.LeaveToAppPromptPageKey,
		navigationDepth = 1,
		component = script.Dialog.LeaveToAppPrompt,
		parentPage = nil
	},
	{
		key = Constants.LeaveGamePromptPageKey,
		navigationDepth = 1,
		component = script.Dialog.LeaveGamePrompt,
		parentPage = nil
	}
}

local pagesByKey = {}

for i, v in ipairs(pagesByIndex) do
	v.index = i
	assert(pagesByKey[v.key] == nil, ("page key %s is duplicated"):format(v.key))
	pagesByKey[v.key] = v
end

return { pagesByIndex = pagesByIndex, pagesByKey = pagesByKey }
