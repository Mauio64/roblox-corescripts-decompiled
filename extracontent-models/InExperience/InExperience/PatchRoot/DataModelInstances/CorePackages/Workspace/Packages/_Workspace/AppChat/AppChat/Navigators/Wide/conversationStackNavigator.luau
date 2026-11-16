local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactNavigation = require(parent.RoactNavigation)
local Cryo = require(parent.Cryo)

local autoFocusNavigation = require(script.Parent.Parent.autoFocusNavigation)

local EnumScreens = require(AppChat.EnumScreens)
local ChatConversationScreen = require(AppChat.Components.ChatConversation.ChatConversationScreen)
local ChatDetailsScreen = require(AppChat.Components.ChatDetails.ChatDetailsScreen)
local SquadInviteFriendsScreen = require(AppChat.Components.Squads.SquadInviteFriendsScreen)
local SquadLobbyScreen = require(AppChat.Components.Squads.SquadLobbyScreen)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local function instantTransitionConfig()
	return {
		transitionSpec = { frequency = 1000000, dampingRatio = 1 }
	}
end

return function(options, flag: boolean?)
	local v = {
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

	if GetFFlagIsSquadEnabled() then
		local v2 = {
			[EnumScreens.SquadLobby] = {
				screen = autoFocusNavigation(SquadLobbyScreen.WideSquadLobbyScreen),
				navigationOptions = options or {}
			}
		}
		table.insert(v, v2)

		local v3 = {
			[EnumScreens.SquadInviteFriends] = {
				screen = autoFocusNavigation(SquadInviteFriendsScreen),
				navigationOptions = options or {}
			}
		}
		table.insert(v, v3)
	end

	local defaultNavigationOptions = { tabBarVisible = true }

	if FFlagAppChatDisableAbsorbInputSelectable then
		defaultNavigationOptions.absorbInputSelectable = false
	end

	local createRobloxStackNavigator = RoactNavigation.createRobloxStackNavigator
	local transitionConfig

	if flag then
		transitionConfig = instantTransitionConfig
	end

	return createRobloxStackNavigator(v, {
		defaultNavigationOptions = defaultNavigationOptions,
		transitionConfig = transitionConfig
	})
end
