local squadQuickStartExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").SquadQuickStartExperimentation

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ChatLandingScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingScreen")
local ChatConversationScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationScreen")
local ChatDetailsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsScreen")
local ChatDetailsNavigationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsNavigationOptions")
local CreateNewChatScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/CreateNewChat/CreateNewChatScreen")
local EditChatMembersScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EditChatMembers/EditChatMembersScreen")
local SquadInviteFriendsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadInviteFriendsScreen")
local SquadLobbyScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadLobbyScreen")
local QuickStartSquadInviteFriendsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/QuickStartSquadInviteFriendsScreen")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagAppChatRemoveDynamicRequires = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatRemoveDynamicRequires")
local fFlagEnablePartyQuickStartButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnablePartyQuickStartButton

local function getChatDetailsNavigationOptions(p2)
	return ChatDetailsNavigationOptions.getNavigationOptions(p2, { tabBarVisible = false })
end

local v10 = {
	{
		[EnumScreens.ChatLanding] = {
			screen = ChatLandingScreen,
			navigationOptions = getFFlagAppChatRemoveDynamicRequires() and function()
				return {
					isRoot = true,
					backButtonEnabled = false,
					tabBarVisible = true
				}
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
			navigationOptions = getChatDetailsNavigationOptions
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

if not getFFlagIsSquadEnabled() then
	return v10
end

local v11 = {
	[EnumScreens.SquadLobby] = {
		screen = SquadLobbyScreen.CompactSquadLobbyScreen,
		navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
	}
}
table.insert(v10, v11)

if
	squadQuickStartExperimentation.getPartyQuickStartChangesEnabled()
	and fFlagEnablePartyQuickStartButton
then
	local v12 = {
		[EnumScreens.QuickStartSquadInviteFriends] = {
			screen = QuickStartSquadInviteFriendsScreen,
			navigationOptions = { backButtonEnabled = true, tabBarVisible = false }
		}
	}
	table.insert(v10, v12)
end

local v12 = {
	[EnumScreens.SquadInviteFriends] = {
		screen = SquadInviteFriendsScreen,
		navigationOptions = {
			backButtonEnabled = true,
			tabBarVisible = false,
			headerText = fFlagEnablePartyQuickStartButton and {
				raw = "Feature.Squads.Action.Add",
				shouldLocalize = true
			} or nil
		}
	}
}
table.insert(v10, v12)

return v10
