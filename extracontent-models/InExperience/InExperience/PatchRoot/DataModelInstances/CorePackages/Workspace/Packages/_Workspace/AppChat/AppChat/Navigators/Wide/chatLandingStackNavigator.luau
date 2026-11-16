local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)
local SocialExperiments = require(parent.SocialExperiments)

local SquadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation

local EnumScreens = require(AppChat.EnumScreens)

local ChatLandingScreenWithSwitchNavigator = require(AppChat.Components.ChatLanding.ChatLandingScreenWithSwitchNavigator)
local CreateNewChatScreen = require(AppChat.Components.CreateNewChat.CreateNewChatScreen)
local EditChatMembersScreen = require(AppChat.Components.EditChatMembers.EditChatMembersScreen)
local QuickStartSquadInviteFriendsScreen = require(AppChat.Components.Squads.QuickStartSquadInviteFriendsScreen)

local createOverlayTopBarStackNavigatorWithFocus = require(AppChat.Navigators.createOverlayTopBarStackNavigatorWithFocus)
local getFFlagAppChatRemoveDynamicRequires = require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local function wrapScreenInOverlayNavigator(p, p2)
	return createOverlayTopBarStackNavigatorWithFocus({
		{ [p] = p2 }
	})
end

local navigationOptions = {
	backButtonEnabled = true,
	tabBarVisible = true,
	overlayEnabled = true,
	overlayTransparency = 0.5,
	absorbInput = true
}
local v = {
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
			navigationOptions = navigationOptions
		}
	},
	{
		EditChatMembersScreenWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({
				{ [EnumScreens.EditChatMembers] = EditChatMembersScreen }
			}),
			navigationOptions = navigationOptions
		}
	}
}

if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
	local createPartyQuickStartWrapper = {
		screen = createOverlayTopBarStackNavigatorWithFocus({
			{ [EnumScreens.QuickStartSquadInviteFriends] = QuickStartSquadInviteFriendsScreen }
		}),
		navigationOptions = navigationOptions
	}
	table.insert(v, { CreatePartyQuickStartWrapper = createPartyQuickStartWrapper })
end

return RoactNavigation.createRobloxStackNavigator(v, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and {
		absorbInputSelectable = false
	} or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
