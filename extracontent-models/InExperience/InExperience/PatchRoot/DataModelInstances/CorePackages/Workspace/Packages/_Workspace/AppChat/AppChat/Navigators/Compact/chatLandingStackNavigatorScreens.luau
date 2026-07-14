local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SquadQuickStartExperimentation = require(AppChatParent.SocialExperiments).SquadQuickStartExperimentation
local EnumScreens = require(AppChat.EnumScreens)
local ChatLandingScreen = require(AppChat.Components.ChatLanding.ChatLandingScreen)
local ChatConversationScreen = require(AppChat.Components.ChatConversation.ChatConversationScreen)
local ChatDetailsScreen = require(AppChat.Components.ChatDetails.ChatDetailsScreen)
local ChatDetailsNavigationOptions = require(AppChat.Components.ChatDetails.ChatDetailsNavigationOptions)
local CreateNewChatScreen = require(AppChat.Components.CreateNewChat.CreateNewChatScreen)
local EditChatMembersScreen = require(AppChat.Components.EditChatMembers.EditChatMembersScreen)
local SquadInviteFriendsScreen = require(AppChat.Components.Squads.SquadInviteFriendsScreen)
local SquadLobbyScreen = require(AppChat.Components.Squads.SquadLobbyScreen)
local QuickStartSquadInviteFriendsScreen = require(AppChat.Components.Squads.QuickStartSquadInviteFriendsScreen)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local getFFlagAppChatRemoveDynamicRequires = require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)
local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)

local function getChatDetailsNavigationOptions(p1) -- line: 23
	-- upvalues: ChatDetailsNavigationOptions (copy)
	return ChatDetailsNavigationOptions.getNavigationOptions(p1, {
		tabBarVisible = false
	})
end

local t1 = {
	{
		[EnumScreens.ChatLanding] = {
			screen = ChatLandingScreen,
			navigationOptions = if not getFFlagAppChatRemoveDynamicRequires() then {
				isRoot = true,
				backButtonEnabled = false,
				tabBarVisible = true
			} else function() -- line: 34
				return {
					isRoot = true,
					backButtonEnabled = false,
					tabBarVisible = true
				}
			end
		}
	},
	{
		[EnumScreens.ChatConversation] = {
			screen = ChatConversationScreen,
			navigationOptions = {
				backButtonEnabled = true,
				tabBarVisible = false,
				lockIconEnabled = true,
				absorbInput = false
			}
		}
	},
	{
		[EnumScreens.ChatDetails] = {
			screen = ChatDetailsScreen,
			navigationOptions = if not getFFlagAppChatEnableRootedNavigation() then {
				backButtonEnabled = true,
				tabBarVisible = false
			} else getChatDetailsNavigationOptions
		}
	},
	{
		[EnumScreens.CreateNewChat] = {
			screen = CreateNewChatScreen,
			navigationOptions = {
				backButtonEnabled = true,
				tabBarVisible = false
			}
		}
	},
	{
		[EnumScreens.EditChatMembers] = {
			screen = EditChatMembersScreen,
			navigationOptions = {
				backButtonEnabled = true,
				tabBarVisible = false
			}
		}
	}
}

if GetFFlagIsSquadEnabled() then
	table.insert(t1, {
		[EnumScreens.SquadLobby] = {
			screen = SquadLobbyScreen.CompactSquadLobbyScreen,
			navigationOptions = {
				backButtonEnabled = true,
				tabBarVisible = false
			}
		}
	})

	if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
		table.insert(t1, {
			[EnumScreens.QuickStartSquadInviteFriends] = {
				screen = QuickStartSquadInviteFriendsScreen,
				navigationOptions = {
					backButtonEnabled = true,
					tabBarVisible = false
				}
			}
		})
	end

	table.insert(t1, {
		[EnumScreens.SquadInviteFriends] = {
			screen = SquadInviteFriendsScreen,
			navigationOptions = {
				backButtonEnabled = true,
				tabBarVisible = false,
				headerText = if not FFlagEnablePartyQuickStartButton then nil else {
					raw = "Feature.Squads.Action.Add",
					shouldLocalize = true
				}
			}
		}
	})
end

return t1
