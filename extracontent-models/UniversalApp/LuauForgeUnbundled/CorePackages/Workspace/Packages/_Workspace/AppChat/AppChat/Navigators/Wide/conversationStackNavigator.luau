local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local autoFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/autoFocusNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ChatConversationScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationScreen")
local ChatDetailsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsScreen")
local SquadInviteFriendsScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadInviteFriendsScreen")
local SquadLobbyScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadLobbyScreen")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")

local function instantTransitionConfig()
	return {
		transitionSpec = { frequency = 1000000, dampingRatio = 1 }
	}
end

return function(options, p2)
	local v7 = {
		{
			[EnumScreens.ChatConversation] = {
				screen = ChatConversationScreen,
				navigationOptions = Cryo.Dictionary.join(
					{
						backButtonEnabled = false,
						isRoot = true,
						lockIconEnabled = true,
						tabBarVisible = true
					},
					options or {}
				)
			}
		},
		{
			[EnumScreens.ChatDetails] = {
				screen = autoFocusNavigation(ChatDetailsScreen),
				navigationOptions = options or {}
			}
		}
	}

	if getFFlagIsSquadEnabled() then
		local v8 = {
			[EnumScreens.SquadLobby] = {
				screen = autoFocusNavigation(SquadLobbyScreen.WideSquadLobbyScreen),
				navigationOptions = options or {}
			}
		}
		table.insert(v7, v8)

		local v9 = {
			[EnumScreens.SquadInviteFriends] = {
				screen = autoFocusNavigation(SquadInviteFriendsScreen),
				navigationOptions = options or {}
			}
		}
		table.insert(v7, v9)
	end

	local v8 = { tabBarVisible = true }

	if FFlagAppChatDisableAbsorbInputSelectable then
		v8.absorbInputSelectable = false
	end

	return RoactNavigation.createRobloxStackNavigator(v7, {
		defaultNavigationOptions = v8,
		transitionConfig = if p2 then instantTransitionConfig else nil
	})
end
