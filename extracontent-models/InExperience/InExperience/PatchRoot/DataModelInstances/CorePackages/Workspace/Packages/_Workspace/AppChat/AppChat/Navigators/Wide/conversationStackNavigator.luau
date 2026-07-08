local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactNavigation = require(AppChatParent.RoactNavigation)
local Cryo = require(AppChatParent.Cryo)
local autoFocusNavigation = require(script.Parent.Parent.autoFocusNavigation)
local React = require(AppChatParent.React)
local SquadAddFriendsIconButton = require(AppChat.Components.Squads.SquadAddFriendsIconButton)
local EnumScreens = require(AppChat.EnumScreens)
local ChatConversationScreen = require(AppChat.Components.ChatConversation.ChatConversationScreen)
local ChatDetailsScreen = require(AppChat.Components.ChatDetails.ChatDetailsScreen)
local SquadInviteFriendsScreen = require(AppChat.Components.Squads.SquadInviteFriendsScreen)
local SquadLobbyScreen = require(AppChat.Components.Squads.SquadLobbyScreen)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagEnablePartyQuickStartButton = require(AppChatParent.SharedFlags).FFlagEnablePartyQuickStartButton
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local TopBarProvider = require(AppChat.TopBarProvider)
local createSystemMenuButton = require(AppChat.Components.SelectChatMembers.createSystemMenuButton)
local withLocalization = require(AppChatParent.Localization).withLocalization
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local NavProps = require(AppChat.Constants).NavProps

local function instantTransitionConfig() -- line: 31
	return {
		transitionSpec = {
			frequency = 1000000,
			dampingRatio = 1
		}
	}
end

return function(p1, b1: boolean?) -- line: 40
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), Cryo (copy), GetFFlagIsSquadEnabled (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), React (copy), SquadAddFriendsIconButton (copy), NavProps (copy), FFlagEnablePartyQuickStartButton (copy), TopBarProvider (copy), EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy), ChatConversationScreen (copy), autoFocusNavigation (copy), ChatDetailsScreen (copy), SquadLobbyScreen (copy), SquadInviteFriendsScreen (copy), FFlagAppChatDisableAbsorbInputSelectable (copy), RoactNavigation (copy), instantTransitionConfig (copy)
	local function getChatDetailsNavigationOptions(_) -- line: 41
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p1 (copy), Cryo (copy), GetFFlagIsSquadEnabled (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy)
		if FFlagAppChatTopBarConfigDriven() then
			return p1 or {}
		end

		return Cryo.Dictionary.join({
			backButtonEnabled = true,
			headerText = {
				shouldLocalize = true,
				raw = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatDetails" or "Feature.Chat.Label.Details"
			},
			backButtonTestId = if not FFlagDebugAppChatEnableDomLocators then nil else DomLocators.chatDetailsTopBarActionButton("back")
		}, p1 or {})
	end
	local function getSquadLobbyNavigationOptions(p3) -- line: 59
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p1 (copy), Cryo (copy), React (copy), SquadAddFriendsIconButton (copy)
		if FFlagAppChatTopBarConfigDriven() then
			return p1 or {}
		end

		local navigation = p3.navigation

		return Cryo.Dictionary.join({
			backButtonEnabled = true,
			renderRight = function() -- line: 66
				-- upvalues: React (copy), SquadAddFriendsIconButton (copy), navigation (copy)
				return React.createElement(SquadAddFriendsIconButton, {
					navigation = navigation
				})
			end
		}, p1 or {})
	end
	local function getSquadInviteFriendsNavigationOptions(p4) -- line: 74
		-- upvalues: FFlagAppChatTopBarConfigDriven (copy), p1 (copy), NavProps (copy), FFlagEnablePartyQuickStartButton (copy), React (copy), TopBarProvider (copy), EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy), Cryo (copy)
		if FFlagAppChatTopBarConfigDriven() then
			return p1 or {}
		end

		local v35 = p4.navigation and (p4.navigation.getScreenProps and p4.navigation.getScreenProps(NavProps.WIDE_MODE, false))
		local t1 = {
			backButtonEnabled = true,
			headerText = if not FFlagEnablePartyQuickStartButton then nil else {
				raw = "Feature.Squads.Action.Add",
				shouldLocalize = true
			}
		}

		if v35 then
			function t1.renderRight() -- line: 94
				-- upvalues: React (copy), TopBarProvider (copy), EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy)
				return React.createElement(TopBarProvider, {
					screenName = EnumScreens.SquadInviteFriends,
					render = function(p5) -- line: 97
						-- upvalues: EnumScreens (copy), withLocalization (copy), createSystemMenuButton (copy)
						local v38 = p5.getScreenTopBar(EnumScreens.SquadInviteFriends)

						return withLocalization({
							systemButtonText = "Feature.Squads.Action.Add"
						})(function(p6) -- line: 102
							-- upvalues: createSystemMenuButton (copy), v38 (copy)
							return createSystemMenuButton({
								localizedStrings = p6,
								isDisabled = not v38.systemButtonEnabled,
								onActivated = v38.systemButtonActivated
							})
						end)
					end
				})
			end
		end

		return Cryo.Dictionary.join(t1, p1 or {})
	end

	local t2 = {
		{
			[EnumScreens.ChatConversation] = {
				screen = ChatConversationScreen,
				navigationOptions = Cryo.Dictionary.join({
					backButtonEnabled = false,
					isRoot = true,
					lockIconEnabled = true,
					tabBarVisible = true
				}, p1 or {})
			}
		},
		{
			[EnumScreens.ChatDetails] = {
				screen = autoFocusNavigation(ChatDetailsScreen),
				navigationOptions = getChatDetailsNavigationOptions
			}
		}
	}

	if GetFFlagIsSquadEnabled() then
		table.insert(t2, {
			[EnumScreens.SquadLobby] = {
				screen = autoFocusNavigation(SquadLobbyScreen.WideSquadLobbyScreen),
				navigationOptions = getSquadLobbyNavigationOptions
			}
		})
		table.insert(t2, {
			[EnumScreens.SquadInviteFriends] = {
				screen = autoFocusNavigation(SquadInviteFriendsScreen),
				navigationOptions = getSquadInviteFriendsNavigationOptions
			}
		})
	end

	local t3 = {
		tabBarVisible = true
	}

	if FFlagAppChatDisableAbsorbInputSelectable then
		t3.absorbInputSelectable = false
	end

	return RoactNavigation.createRobloxStackNavigator(t2, {
		defaultNavigationOptions = t3,
		transitionConfig = if not b1 then nil else instantTransitionConfig
	})
end
