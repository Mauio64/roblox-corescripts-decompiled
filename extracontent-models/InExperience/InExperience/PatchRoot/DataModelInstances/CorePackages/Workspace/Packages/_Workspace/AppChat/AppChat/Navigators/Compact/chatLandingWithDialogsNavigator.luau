local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local SharedFlags = require(parent.SharedFlags)
local AppNavBar = require(parent.AppNavBar)

local AppCommonLib = require(parent.AppCommonLib)
local memoize = AppCommonLib.memoize

local ChatDetails = AppChat.Components.ChatDetails
local GenericDialogType = require(ChatDetails.Dialogs.GenericDialogType)
local EditChatGroupNameDialogScreen = require(ChatDetails.EditChatGroupNameDialog.EditChatGroupNameDialogScreen)
local LeaveGroupDialogScreen = require(ChatDetails.LeaveGroupDialog.LeaveGroupDialogScreen)
local ParticipantDialogScreenDeprecated = require(ChatDetails.ParticipantDialog.ParticipantDialogScreenDeprecated)
local RemoveUserDialogScreen = require(ChatDetails.RemoveUserDialog.RemoveUserDialogScreen)
local AbuseReportScreen = require(AppChat.Components.ChatAbuseReport.AbuseReportScreen)

local MessageContextMenuScreen = require(AppChat.Components.ChatConversation.MessageInteraction.MessageContextMenuScreen)
local SquadVoiceChangerOverlay = require(parent.Squads.SquadVoiceChangerOverlay)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local useGetAndSetRef = require(AppChat.Hooks.useGetAndSetRef)
local TrustedFriendsUpsellScreen = require(AppChat.Components.TrustedFriendsUpsell.TrustedFriendsUpsellScreen)
local GroupOSADialogScreen = require(AppChat.Components.OSA.GroupOSADialogScreen)

local ChatConversation = AppChat.Components.ChatConversation

local CreateUnfilteredChatPartialModalScreen = require(ChatConversation.PartialModal.CreateUnfilteredChatPartialModalScreen)
local LearnMorePartialModalScreen = require(ChatConversation.PartialModal.LearnMorePartialModalScreen)
local ConversationOverlayScreen = require(ChatConversation.PartialModal.ConversationOverlayScreen)
local makeDialogScreenTelemetryWrapper = require(AppChat.Navigators.makeDialogScreenTelemetryWrapper)

local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local getChatLandingStackNavigator = require(script.Parent.getChatLandingStackNavigator)

local SquadVoiceAbuseReportScreen = require(parent.Squads.SquadVoiceAbuseReportScreen)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local ChatConversationTopBar = require(AppChat.Components.TopBar.ChatConversationTopBar)
local ChatLandingTopBar = require(AppChat.Components.TopBar.ChatLandingTopBar)
local ChatTopBarBase = require(AppChat.Components.TopBar.ChatTopBarBase)
local SquadAddFriendsIconButton = require(AppChat.Components.Squads.SquadAddFriendsIconButton)
local Provider = require(AppChat.Contexts.ChatPagePadding.Provider)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local ChatDetailsTelemetryState = require(AppChat.Contexts.TelemetryState.ChatDetailsTelemetryState)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local SocialBlockingModal = require(parent.SocialBlockingModal)
local BlockingModal = SocialBlockingModal.BlockingModal

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function AppChatNavigatorTelemetryProviders(p)
	local get, set = useGetAndSetRef({})
	local v = React.useCallback(function()
		local v = get()
		return {
			chatLandingListCount = v.chatLandingListCount,
			pendingConversationCount = v.pendingConversationCount,
			unfilteredConversationCount = v.unfilteredConversationCount,
			searchSessionId = v.searchSessionId,
			activeFilters = v.activeFilters
		}
	end, { get })

	local get2, set2 = useGetAndSetRef({})
	local v2 = React.useCallback(function()
		local v2 = get2()
		return {
			conversationId = v2.conversationId,
			moderationType = v2.moderationType,
			userPendingStatus = v2.userPendingStatus
		}
	end, { get2 })

	local _children = p.children

	local get3, set3 = useGetAndSetRef({})
	local v3 = React.useCallback(function()
		local v3 = get3()
		return { participantsCount = v3.participantsCount, isGroupOwner = v3.isGroupOwner }
	end, { get3, get2 })
	local v4 = React.useMemo(function()
		return { get = get3, set = set3 }
	end, { get3, set3 })
	local v5 = React.useMemo(function()
		return { get = get, set = set }
	end, { get, set })
	local v6 = React.useMemo(function()
		return { get = get2, set = set2 }
	end, { get2, set2 })

	local element = React.createElement(
		ChatDetailsTelemetryState.Provider,
		{ value = v4 },
		React.createElement(ChatDetailsTelemetryLayer.Provider, { value = v3 }, p.children)
	)

	return React.createElement(ChatLandingTelemetryState.Provider, { value = v5 }, {
		React.createElement(ChatLandingTelemetryLayer.Provider, { value = v }, {
			React.createElement(ChatConversationTelemetryState.Provider, { value = v6 }, {
				React.createElement(ChatConversationTelemetryLayer.Provider, { value = v2 }, element)
			})
		})
	})
end

local extended = Roact.Component:extend("ChatLandingStackNavigatorConnector")
extended.router = getChatLandingStackNavigator(UserGameSettings.ReducedMotion).router

function extended:init()
	self.state = { shouldReduceMotion = UserGameSettings.ReducedMotion }

	self.getNavigator = memoize(function(p)
		local chatLandingStackNavigator = getChatLandingStackNavigator(p)

		extended.router = chatLandingStackNavigator.router
		return chatLandingStackNavigator
	end)

	function self.updateSettings()
		self:setState({ shouldReduceMotion = UserGameSettings.ReducedMotion })
	end
	self.reducedMotionConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(self.updateSettings)
end

function extended.willUnmount(p)
	if p.reducedMotionConnection then
		p.reducedMotionConnection:Disconnect()
	end
end

local function getActiveRouteName(navigation) -- 1 equivalent call inferred from this helper
	local state = navigation and navigation.state

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
	local v

	if FFlagAppIaScrollAway then
		v = props.props.navigation.getScreenProps("isInExperience", false)
	end

	local v2 = FFlagAppIaScrollAway and not v and AppNavBar.getScrollAwayEnabled()

	if FFlagAppIaScrollAwayFixSocial then
		local activeChildNavigationOptions = RoactNavigation.getActiveChildNavigationOptions(props.props.navigation)

		v2 = v2 and activeChildNavigationOptions.tabBarVisible
	end

	local v3 = nil

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
	end

	local activeRouteName = getActiveRouteName(props.props.navigation) -- inferred equivalent call

	if activeRouteName == EnumScreens.CreateNewChat or activeRouteName == EnumScreens.EditChatMembers then
		v3 = Roact.createElement(SystemMenuTopBar, {
			screenName = activeRouteName,
			navigation = props.props.navigation
		})
	elseif activeRouteName == EnumScreens.ChatConversation then
		v3 = Roact.createElement(ChatConversationTopBar, {
			screenName = EnumScreens.ChatConversation,
			navigation = props.props.navigation
		})
	elseif activeRouteName == EnumScreens.ChatLanding then
		v3 = Roact.createElement(ChatLandingTopBar, {
			screenName = EnumScreens.ChatLanding,
			navigation = props.props.navigation
		})
	elseif activeRouteName == EnumScreens.ChatDetails then
		v3 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.ChatDetails,
			navigation = props.props.navigation
		})
	elseif activeRouteName == EnumScreens.SquadLobby then
		v3 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadLobby,
			navigation = props.props.navigation,
			renderRight = function()
				return React.createElement(SquadAddFriendsIconButton, {
					navigation = props.props.navigation
				})
			end
		})
	elseif activeRouteName == EnumScreens.SquadInviteFriends then
		v3 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadInviteFriends,
			navigation = props.props.navigation
		})
	elseif activeRouteName == EnumScreens.QuickStartSquadInviteFriends then
		v3 = Roact.createElement(ChatTopBarBase, {
			screenName = EnumScreens.QuickStartSquadInviteFriends,
			navigation = props.props.navigation
		})
	end

	local topBar = v3 or configureTopBarWithNavigationOptions(props.props.navigation)

	local createElement = Roact.createElement
	local layout

	if not (FFlagAppIaScrollAway and v2) then
		layout = Roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder })
	end

	local createElement2 = Roact.createElement
	local v4 = {
		value = {
			left = props.props.navigation.getScreenProps("appChatOuterPadding", 12),
			right = props.props.navigation.getScreenProps("appChatOuterPadding", 12)
		}
	}

	local createElement3 = Roact.createElement
	local size

	if FFlagAppIaScrollAway and v2 then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, 0, 1, -props.props.navigation.getScreenProps("topBarHeight", 0))
	end

	local element = createElement(AppChatNavigatorTelemetryProviders, {}, {
		layout = layout,
		topBar = topBar,
		content = createElement2(Provider, v4, {
			navigatorFrame = createElement3("Frame", {
				Size = size,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				navigator = Roact.createElement(props.getNavigator(props.state.shouldReduceMotion), props.props)
			})
		})
	})

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagAppChatConsoleFocusFixes or nil
	}, { ChatLandingStackNavigator = element })
end

local v = {
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

local v2 = {
	[EnumScreens.AppChatReportAbuse] = {
		screen = AbuseReportScreen,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v2)

local v3 = {
	[EnumScreens.BlockingModal] = {
		screen = BlockingModal,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v3)

local v4 = {
	[EnumScreens.MessageContextMenu] = {
		screen = MessageContextMenuScreen,
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v4)

if GetFFlagIsSquadEnabled() and GetFFlagEnableCrossExpVoice() then
	local v5 = {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = SquadVoiceAbuseReportScreen,
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
	table.insert(v, v5)
end

local v5 = {
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
table.insert(v, v5)

local v6 = {
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
table.insert(v, v6)

local v7 = {
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
table.insert(v, v7)

if FFlagEnablePartyVoiceChangersInLua then
	local v8 = {
		[EnumScreens.SquadVoiceChangers] = {
			screen = SquadVoiceChangerOverlay,
			navigationOptions = { overlayEnabled = true, overlayTransparency = 0.5 }
		}
	}
	table.insert(v, v8)
end

return RoactNavigation.createRobloxStackNavigator(v, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and {
		absorbInputSelectable = false
	} or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
