local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local squadQuickStartExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").SquadQuickStartExperimentation

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local ChatLandingScreenWithSwitchNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingScreenWithSwitchNavigator")
local CreateNewChatScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/CreateNewChat/CreateNewChatScreen")
local EditChatMembersScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EditChatMembers/EditChatMembersScreen")
local QuickStartSquadInviteFriendsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/QuickStartSquadInviteFriendsScreen")

local createOverlayTopBarStackNavigatorWithFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/createOverlayTopBarStackNavigatorWithFocus")
local getFFlagAppChatRemoveDynamicRequires = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatRemoveDynamicRequires")
local fFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePartyQuickStartButton
local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")

local function wrapScreenInOverlayNavigator(p2, p3)
	return createOverlayTopBarStackNavigatorWithFocus({
		{ [p2] = p3 }
	})
end

local v5 = {
	backButtonEnabled = true,
	tabBarVisible = true,
	overlayEnabled = true,
	overlayTransparency = 0.5,
	absorbInput = true
}
local v11 = {
	{
		[EnumScreens.ChatLanding] = {
			screen = ChatLandingScreenWithSwitchNavigator,
			navigationOptions = getFFlagAppChatRemoveDynamicRequires() and function()
				return { backButtonEnabled = false, tabBarVisible = true }
			end or { backButtonEnabled = false, tabBarVisible = true }
		}
	},
	{
		CreateNewChatScreenWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({
				{ [EnumScreens.CreateNewChat] = CreateNewChatScreen }
			}),
			navigationOptions = v5
		}
	},
	{
		EditChatMembersScreenWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({
				{ [EnumScreens.EditChatMembers] = EditChatMembersScreen }
			}),
			navigationOptions = v5
		}
	}
}

if
	squadQuickStartExperimentation.getPartyQuickStartChangesEnabled()
	and fFlagEnablePartyQuickStartButton
then
	local v13 = {
		screen = createOverlayTopBarStackNavigatorWithFocus({
			{ [EnumScreens.QuickStartSquadInviteFriends] = QuickStartSquadInviteFriendsScreen }
		}),
		navigationOptions = v5
	}
	table.insert(v11, { CreatePartyQuickStartWrapper = v13 })
end

return RoactNavigation.createRobloxStackNavigator(v11, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and { absorbInputSelectable = false } or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
