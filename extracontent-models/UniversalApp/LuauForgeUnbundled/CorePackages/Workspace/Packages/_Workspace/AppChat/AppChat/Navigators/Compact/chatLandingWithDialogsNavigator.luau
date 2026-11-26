local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar")

local memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").memoize

local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")
local EditChatGroupNameDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/EditChatGroupNameDialog/EditChatGroupNameDialogScreen")
local LeaveGroupDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupDialog/LeaveGroupDialogScreen")
local ParticipantDialogScreenDeprecated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialogScreenDeprecated")
local RemoveUserDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/RemoveUserDialogScreen")
local AbuseReportScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatAbuseReport/AbuseReportScreen")

local MessageContextMenuScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/MessageContextMenuScreen")
local SquadVoiceChangerOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadVoiceChangerOverlay")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local ChatLandingTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatLandingTelemetryState")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ChatConversationTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatConversationTelemetryState")
local useGetAndSetRef = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetAndSetRef")
local TrustedFriendsUpsellScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TrustedFriendsUpsell/TrustedFriendsUpsellScreen")
local GroupOSADialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/GroupOSADialogScreen")

local CreateUnfilteredChatPartialModalScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/CreateUnfilteredChatPartialModalScreen")
local LearnMorePartialModalScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/LearnMorePartialModalScreen")
local ConversationOverlayScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/ConversationOverlayScreen")
local makeDialogScreenTelemetryWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/makeDialogScreenTelemetryWrapper")

local configureTopBarWithNavigationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/configureTopBarWithNavigationOptions")
local getChatLandingStackNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Compact/getChatLandingStackNavigator")

local SquadVoiceAbuseReportScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadVoiceAbuseReportScreen")
local SystemMenuTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/SystemMenuTopBar")
local ChatConversationTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatConversationTopBar")
local ChatLandingTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatLandingTopBar")
local ChatTopBarBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatTopBarBase")
local SquadAddFriendsIconButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadAddFriendsIconButton")
local Provider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/Provider")
local ChatDialogTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDialogTelemetryLayer")
local ChatDetailsTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatDetailsTelemetryState")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local blockingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialBlockingModal").BlockingModal

local getFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local fFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function AppChatNavigatorTelemetryProviders(p2)
	local v5, v6 = useGetAndSetRef({})
	local v7 = React.useCallback(function()
		local v8 = v5()
		return {
			chatLandingListCount = v8.chatLandingListCount,
			pendingConversationCount = v8.pendingConversationCount,
			unfilteredConversationCount = v8.unfilteredConversationCount,
			searchSessionId = v8.searchSessionId,
			activeFilters = v8.activeFilters
		}
	end, { v5 })

	local v8, v9 = useGetAndSetRef({})
	local v10 = React.useCallback(function()
		local v11 = v8()
		return {
			conversationId = v11.conversationId,
			moderationType = v11.moderationType,
			userPendingStatus = v11.userPendingStatus
		}
	end, { v8 })

	local children = p2.children

	local v11, v12 = useGetAndSetRef({})
	local v13 = React.useCallback(function()
		local v14 = v11()
		return {
			participantsCount = v14.participantsCount,
			isGroupOwner = v14.isGroupOwner
		}
	end, { v11, v8 })
	local v14 = React.useMemo(function()
		return { get = v11, set = v12 }
	end, { v11, v12 })
	local v15 = React.useMemo(function()
		return { get = v5, set = v6 }
	end, { v5, v6 })
	local v16 = React.useMemo(function()
		return { get = v8, set = v9 }
	end, { v8, v9 })

	local element = React.createElement(
		ChatDetailsTelemetryState.Provider,
		{ value = v14 },
		React.createElement(ChatDialogTelemetryLayer.Provider, { value = v13 }, p2.children)
	)

	return React.createElement(ChatLandingTelemetryState.Provider, { value = v15 }, {
		React.createElement(ChatConversationTelemetryLayer.Provider, { value = v7 }, {
			React.createElement(ChatConversationTelemetryState.Provider, { value = v16 }, {
				React.createElement(ChatDetailsTelemetryLayer.Provider, { value = v10 }, element)
			})
		})
	})
end

local extended = Roact.Component:extend("ChatLandingStackNavigatorConnector")
extended.router = getChatLandingStackNavigator(UserGameSettings.ReducedMotion).router

function extended:init()
	self.state = { shouldReduceMotion = UserGameSettings.ReducedMotion }

	self.getNavigator = memoize(function(p2)
		local v5 = getChatLandingStackNavigator(p2)

		extended.router = v5.router
		return v5
	end)

	function self.updateSettings()
		self:setState({ shouldReduceMotion = UserGameSettings.ReducedMotion })
	end
	self.reducedMotionConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(self.updateSettings)
end

function extended.willUnmount(p2)
	if p2.reducedMotionConnection then
		p2.reducedMotionConnection:Disconnect()
	end
end

local function getActiveRouteName(p2)
	local state = p2 and p2.state

	if not (state and state.routes and state.index) then
		return nil
	end

	local route = state.routes[state.index]

	if not route then
		return nil
	end

	if route.routes and route.index then
		local route2 = route.routes[route.index]
		return route2 and route2.routeName or route.routeName
	end

	return route.routeName
end

function extended.render(props)
	local v5 = if fFlagAppIaScrollAway then props.props.navigation.getScreenProps("isInExperience", false) else nil

	local v6 = fFlagAppIaScrollAway and not v5 and AppNavBar.getScrollAwayEnabled()

	if fFlagAppIaScrollAwayFixSocial then
		local activeChildNavigationOptions = RoactNavigation.getActiveChildNavigationOptions(props.props.navigation)

		v6 = v6 and activeChildNavigationOptions.tabBarVisible
	end

	local v7 = nil

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
	end

	local navigation = props.props.navigation
	local state = navigation and navigation.state
	local routeName

	if state and state.routes and state.index then
		local route = state.routes[state.index]

		if route then
			if route.routes and route.index then
				local route2 = route.routes[route.index]
				routeName = route2 and route2.routeName or route.routeName
			else
				routeName = route.routeName
			end
		end
	end

	if routeName == EnumScreens.CreateNewChat or routeName == EnumScreens.EditChatMembers then
		v7 = Roact.createElement(SystemMenuTopBar, {
			screenName = routeName,
			navigation = props.props.navigation
		})
	elseif routeName == EnumScreens.ChatConversation then
		v7 = Roact.createElement(ChatConversationTopBar, {
			screenName = EnumScreens.ChatConversation,
			navigation = props.props.navigation
		})
	elseif routeName == EnumScreens.ChatLanding then
		v7 = Roact.createElement(ChatLandingTopBar, {
			screenName = EnumScreens.ChatLanding,
			navigation = props.props.navigation
		})
	elseif routeName == EnumScreens.ChatDetails then
		v7 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.ChatDetails,
			navigation = props.props.navigation
		})
	elseif routeName == EnumScreens.SquadLobby then
		v7 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadLobby,
			navigation = props.props.navigation,
			renderRight = function()
				return React.createElement(SquadAddFriendsIconButton, {
					navigation = props.props.navigation
				})
			end
		})
	elseif routeName == EnumScreens.SquadInviteFriends then
		v7 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadInviteFriends,
			navigation = props.props.navigation
		})
	elseif routeName == EnumScreens.QuickStartSquadInviteFriends then
		v7 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.QuickStartSquadInviteFriends,
			navigation = props.props.navigation
		})
	end

	local v8 = v7 or configureTopBarWithNavigationOptions(props.props.navigation)

	local createElement = Roact.createElement

	local v12 = if not (fFlagAppIaScrollAway and v6) then Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil

	local createElement2 = Roact.createElement
	local v14 = {
		value = {
			left = props.props.navigation.getScreenProps("appChatOuterPadding", 12),
			right = props.props.navigation.getScreenProps("appChatOuterPadding", 12)
		}
	}

	local createElement3 = Roact.createElement

	local v18 = if fFlagAppIaScrollAway and v6 then UDim2.fromScale(1, 1) else UDim2.new(
		1,
		0,
		1,
		-props.props.navigation.getScreenProps("topBarHeight", 0)
	)
	local element = createElement(AppChatNavigatorTelemetryProviders, {}, {
		layout = v12,
		topBar = v8,
		content = createElement2(Provider, v14, {
			navigatorFrame = createElement3(
				"Frame",
				{ Size = v18, BackgroundTransparency = 1, BorderSizePixel = 0 },
				{
					navigator = Roact.createElement(
						props.getNavigator(props.state.shouldReduceMotion),
						props.props
					)
				}
			)
		})
	})

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagAppChatConsoleFocusFixes or nil
	}, { ChatLandingStackNavigator = element })
end

local v11 = {
	{ [EnumScreens.ChatLandingStack] = extended },
	{
		[GenericDialogType.EditChatGroupNameDialog] = {
			screen = EditChatGroupNameDialogScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.LeaveGroupDialog] = {
			screen = makeDialogScreenTelemetryWrapper(LeaveGroupDialogScreen),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.ParticipantDialog] = {
			screen = makeDialogScreenTelemetryWrapper(ParticipantDialogScreenDeprecated),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.RemoveUserDialog] = {
			screen = RemoveUserDialogScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.CreateUnfilteredChatPartialModal] = {
			screen = CreateUnfilteredChatPartialModalScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.LearnMorePartialModal] = {
			screen = LearnMorePartialModalScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
}

local v12 = {
	[EnumScreens.AppChatReportAbuse] = {
		screen = AbuseReportScreen,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v12)

local v13 = {
	[EnumScreens.BlockingModal] = {
		screen = blockingModal,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v13)

local v14 = {
	[EnumScreens.MessageContextMenu] = {
		screen = MessageContextMenuScreen,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v14)

if getFFlagIsSquadEnabled() and getFFlagEnableCrossExpVoice() then
	local v15 = {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = SquadVoiceAbuseReportScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
	table.insert(v11, v15)
end

local v15 = {
	[EnumScreens.ConversationOverlay] = {
		screen = ConversationOverlayScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
}
table.insert(v11, v15)

local v16 = {
	[EnumScreens.TrustedConnectionsUpsell] = {
		screen = TrustedFriendsUpsellScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
}
table.insert(v11, v16)

local v17 = {
	[EnumScreens.GroupOSADialog] = {
		screen = GroupOSADialogScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
}
table.insert(v11, v17)

if fFlagEnablePartyVoiceChangersInLua then
	local v18 = {
		[EnumScreens.SquadVoiceChangers] = {
			screen = SquadVoiceChangerOverlay,
			navigationOptions = { overlayEnabled = true, overlayTransparency = 0.5 }
		}
	}
	table.insert(v11, v18)
end

return RoactNavigation.createRobloxStackNavigator(v11, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and { absorbInputSelectable = false } or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
