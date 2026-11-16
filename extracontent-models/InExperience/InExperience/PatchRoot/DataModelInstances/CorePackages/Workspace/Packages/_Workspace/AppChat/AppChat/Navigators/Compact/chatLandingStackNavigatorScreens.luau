local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SocialExperiments = require(parent.SocialExperiments)

local SquadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation

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
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local getFFlagAppChatRemoveDynamicRequires = require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePartyQuickStartButton = SharedFlags2.FFlagEnablePartyQuickStartButton
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)

local function getChatDetailsNavigationOptions(p)
	return ChatDetailsNavigationOptions.getNavigationOptions(p, { tabBarVisible = false })
end

local ChatLandingStackNavigatorScreens = {
	{
		[EnumScreens.ChatLanding] = {
			screen = ChatLandingScreen,
			navigationOptions = getFFlagAppChatRemoveDynamicRequires() and function()
				return { isRoot = true, backButtonEnabled = false, tabBarVisible = true }
			end or { isRoot = true, backButtonEnabled = false, tabBarVisible = true }
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
			navigationOptions = not getFFlagAppChatEnableRootedNavigation() and {
				backButtonEnabled = true,
				tabBarVisible = false
			} or getChatDetailsNavigationOptions
		}
	},
	{
		[EnumScreens.CreateNewChat] = {
			screen = CreateNewChatScreen,
			navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
		}
	},
	{
		[EnumScreens.EditChatMembers] = {
			screen = EditChatMembersScreen,
			navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
		}
	}
}

if not GetFFlagIsSquadEnabled() then
	return ChatLandingStackNavigatorScreens
end

local v = {
	[EnumScreens.SquadLobby] = {
		screen = SquadLobbyScreen.CompactSquadLobbyScreen,
		navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
	}
}
table.insert(ChatLandingStackNavigatorScreens, v)

if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
	local v2 = {
		[EnumScreens.QuickStartSquadInviteFriends] = {
			screen = QuickStartSquadInviteFriendsScreen,
			navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
		}
	}
	table.insert(ChatLandingStackNavigatorScreens, v2)
end

local v2 = {
	[EnumScreens.SquadInviteFriends] = {
		screen = SquadInviteFriendsScreen,
		navigationOptions = {
			backButtonEnabled = true,
			tabBarVisible = false,
			headerText = FFlagEnablePartyQuickStartButton and {
				raw = "Feature.Squads.Action.Add",
				shouldLocalize = true
			} or nil
		}
	}
}
table.insert(ChatLandingStackNavigatorScreens, v2)

return ChatLandingStackNavigatorScreens
