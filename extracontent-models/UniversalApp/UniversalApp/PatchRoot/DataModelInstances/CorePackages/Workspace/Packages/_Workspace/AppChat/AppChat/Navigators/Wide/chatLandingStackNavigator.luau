local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local SquadQuickStartExperimentation = require(AppChatParent.SocialExperiments).SquadQuickStartExperimentation
local EnumScreens = require(AppChat.EnumScreens)
local ChatLandingScreenWithSwitchNavigator = require(AppChat.Components.ChatLanding.ChatLandingScreenWithSwitchNavigator)
local CreateNewChatScreen = require(AppChat.Components.CreateNewChat.CreateNewChatScreen)
local EditChatMembersScreen = require(AppChat.Components.EditChatMembers.EditChatMembersScreen)
local QuickStartSquadInviteFriendsScreen = require(AppChat.Components.Squads.QuickStartSquadInviteFriendsScreen)
local createOverlayTopBarStackNavigatorWithFocus = require(AppChat.Navigators.createOverlayTopBarStackNavigatorWithFocus)
local getFFlagAppChatRemoveDynamicRequires = require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)
local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton

local function wrapScreenInOverlayNavigator(p1, p2) -- line: 22
	-- upvalues: createOverlayTopBarStackNavigatorWithFocus (copy)
	return createOverlayTopBarStackNavigatorWithFocus({{
		[p1] = p2
	}})
end

local t1 = {
	backButtonEnabled = true,
	tabBarVisible = true,
	overlayEnabled = true,
	overlayTransparency = 0.5,
	absorbInput = true
}
local t2 = {
	{
		[EnumScreens.ChatLanding] = {
			screen = ChatLandingScreenWithSwitchNavigator,
			navigationOptions = if not getFFlagAppChatRemoveDynamicRequires() then {
				backButtonEnabled = false,
				tabBarVisible = true
			} else function() -- line: 44
				return {
					backButtonEnabled = false,
					tabBarVisible = true
				}
			end
		}
	},
	{
		CreateNewChatScreenWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({{
				[EnumScreens.CreateNewChat] = CreateNewChatScreen
			}}),
			navigationOptions = t1
		}
	},
	{
		EditChatMembersScreenWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({{
				[EnumScreens.EditChatMembers] = EditChatMembersScreen
			}}),
			navigationOptions = t1
		}
	}
}

if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
	table.insert(t2, {
		CreatePartyQuickStartWrapper = {
			screen = createOverlayTopBarStackNavigatorWithFocus({{
				[EnumScreens.QuickStartSquadInviteFriends] = QuickStartSquadInviteFriendsScreen
			}}),
			navigationOptions = t1
		}
	})
end

return RoactNavigation.createRobloxStackNavigator(t2, {
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
