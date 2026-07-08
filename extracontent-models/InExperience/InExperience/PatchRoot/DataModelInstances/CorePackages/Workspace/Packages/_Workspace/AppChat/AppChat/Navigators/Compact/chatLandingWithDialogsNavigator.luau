local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local SharedFlags = require(AppChatParent.SharedFlags)
local AppNavBar = require(AppChatParent.AppNavBar)
local memoize = require(AppChatParent.AppCommonLib).memoize
local ChatDetails = AppChat.Components.ChatDetails
local GenericDialogType = require(ChatDetails.Dialogs.GenericDialogType)
local EditChatGroupNameDialogScreen = require(ChatDetails.EditChatGroupNameDialog.EditChatGroupNameDialogScreen)
local LeaveGroupDialogScreen = require(ChatDetails.LeaveGroupDialog.LeaveGroupDialogScreen)
local ParticipantDialogScreenDeprecated = require(ChatDetails.ParticipantDialog.ParticipantDialogScreenDeprecated)
local RemoveUserDialogScreen = require(ChatDetails.RemoveUserDialog.RemoveUserDialogScreen)
local AbuseReportScreen = require(AppChat.Components.ChatAbuseReport.AbuseReportScreen)
local FFlagAppChatEnableTrustedFriendEntryPoint = require(AppChat.Flags.FFlagAppChatEnableTrustedFriendEntryPoint)
local TrustedContactsModalScreen = require(AppChat.Components.TrustedContactsModal.TrustedContactsModalScreen)
local MessageContextMenuScreen = require(AppChat.Components.ChatConversation.MessageInteraction.MessageContextMenuScreen)
local SquadVoiceChangerOverlay = require(AppChatParent.Squads.SquadVoiceChangerOverlay)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local useGetAndSetRef = require(AppChat.Hooks.useGetAndSetRef)
local TrustedConnectionsUpsellScreen = require(AppChat.Components.TrustedConnectionsUpsell.TrustedConnectionsUpsellScreen)
local GroupOSADialogScreen = require(AppChat.Components.OSA.GroupOSADialogScreen)
local ChatConversation = AppChat.Components.ChatConversation
local CreateUnfilteredChatPartialModalScreen = require(ChatConversation.PartialModal.CreateUnfilteredChatPartialModalScreen)
local LearnMorePartialModalScreen = require(ChatConversation.PartialModal.LearnMorePartialModalScreen)
local ConversationOverlayScreen = require(ChatConversation.PartialModal.ConversationOverlayScreen)
local makeDialogScreenTelemetryWrapper = require(AppChat.Navigators.makeDialogScreenTelemetryWrapper)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local getChatLandingStackNavigator = require(script.Parent.getChatLandingStackNavigator)
local SquadVoiceAbuseReportScreen = require(AppChatParent.Squads.SquadVoiceAbuseReportScreen)
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
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
local BlockingModal = require(AppChatParent.SocialBlockingModal).BlockingModal
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaScrollAwayFixSocial = SharedFlags.FFlagAppIaScrollAwayFixSocial
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function AppChatNavigatorTelemetryProviders(t1: {[any]: any}) -- line: 71
	-- upvalues: useGetAndSetRef (copy), React (copy), ChatDetailsTelemetryState (copy), ChatDetailsTelemetryLayer (copy), ChatLandingTelemetryState (copy), ChatLandingTelemetryLayer (copy), ChatConversationTelemetryState (copy), ChatConversationTelemetryLayer (copy)
	local v61, v62 = useGetAndSetRef({})
	local v63 = React.useCallback(function() -- line: 74
		-- upvalues: v61 (copy)
		local v89 = v61()

		return {
			chatLandingListCount = v89.chatLandingListCount,
			pendingConversationCount = v89.pendingConversationCount,
			unfilteredConversationCount = v89.unfilteredConversationCount
		}
	end, { v61 })
	local v64, v65 = useGetAndSetRef({})
	local v66 = React.useCallback(function() -- line: 84
		-- upvalues: v64 (copy)
		local v90 = v64()

		return {
			conversationId = v90.conversationId,
			moderationType = v90.moderationType,
			userPendingStatus = v90.userPendingStatus
		}
	end, { v64 })
	local _ = t1.children
	local v68, v69 = useGetAndSetRef({})
	local v70 = React.useCallback(function() -- line: 96
		-- upvalues: v68 (copy)
		local v91 = v68()

		return {
			participantsCount = v91.participantsCount,
			isGroupOwner = v91.isGroupOwner
		}
	end, {
		v68,
		v64
	})
	local v71 = React.createElement(ChatDetailsTelemetryState.Provider, {
		value = {
			get = v68,
			set = v69
		}
	}, React.createElement(ChatDetailsTelemetryLayer.Provider, {
		value = v70
	}, t1.children))

	return React.createElement(ChatLandingTelemetryState.Provider, {
		value = {
			get = v61,
			set = v62
		}
	}, { React.createElement(ChatLandingTelemetryLayer.Provider, {
		value = v63
	}, { React.createElement(ChatConversationTelemetryState.Provider, {
		value = {
			get = v64,
			set = v65
		}
	}, { React.createElement(ChatConversationTelemetryLayer.Provider, {
		value = v66
	}, v71) }) }) })
end

local v57 = Roact.Component:extend("ChatLandingStackNavigatorConnector")

v57.router = getChatLandingStackNavigator(UserGameSettings.ReducedMotion).router

function v57.init(p1) -- line: 143
	-- upvalues: UserGameSettings (copy), memoize (copy), getChatLandingStackNavigator (copy), v57 (copy)
	p1.state = {
		shouldReduceMotion = UserGameSettings.ReducedMotion
	}
	p1.getNavigator = memoize(function(p2) -- line: 148
		-- upvalues: getChatLandingStackNavigator (copy), v57 (copy)
		local v93 = getChatLandingStackNavigator(p2)

		v57.router = v93.router

		return v93
	end)

	function p1.updateSettings() -- line: 155
		-- upvalues: p1 (copy), UserGameSettings (copy)
		p1:setState({
			shouldReduceMotion = UserGameSettings.ReducedMotion
		})
	end

	p1.reducedMotionConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(p1.updateSettings)
end
function v57.willUnmount(p3) -- line: 164
	if p3.reducedMotionConnection then
		p3.reducedMotionConnection:Disconnect()
	end
end

local function getActiveRouteName(p4) -- line: 170
	local v75 = p4 and p4.state

	if not v75 or (not v75.routes or not v75.index) then
		return nil
	end

	local v76 = v75.routes[v75.index]

	if not v76 then
		return nil
	end

	if v76.routes and v76.index then
		local v77 = v76.routes[v76.index]

		return v77 and v77.routeName or v76.routeName
	end

	return v76.routeName
end

function v57.render(p5) -- line: 187
	-- upvalues: FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagAppIaScrollAwayFixSocial (copy), RoactNavigation (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), EnumScreens (copy), Roact (copy), SystemMenuTopBar (copy), ChatConversationTopBar (copy), ChatLandingTopBar (copy), ChatTopBarBase (copy), React (copy), SquadAddFriendsIconButton (copy), configureTopBarWithNavigationOptions (copy), AppChatNavigatorTelemetryProviders (copy), Provider (copy)
	local v79 = if not FFlagAppIaScrollAway then nil else p5.props.navigation.getScreenProps("isInExperience", false)
	local v80 = FFlagAppIaScrollAway and (not v79 and AppNavBar.getScrollAwayEnabled())

	if FFlagAppIaScrollAwayFixSocial then
		local v81 = RoactNavigation.getActiveChildNavigationOptions(p5.props.navigation)

		v80 = v80 and v81.tabBarVisible
	end

	local v82 = nil

	if FFlagAppChatTopBarConfigDriven() then
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
		end

		local navigation = p5.props.navigation
		local v84 = navigation and navigation.state
		local v85

		if not v84 or not v84.routes or not v84.index then
			v85 = nil
		else
			local v86 = v84.routes[v84.index]

			if not v86 then
				v85 = nil
			elseif v86.routes and v86.index then
				local v87 = v86.routes[v86.index]

				v85 = v87 and v87.routeName or v86.routeName
			else
				v85 = v86.routeName
			end
		end

		if v85 == EnumScreens.CreateNewChat or v85 == EnumScreens.EditChatMembers then
			v82 = Roact.createElement(SystemMenuTopBar, {
				screenName = v85,
				navigation = p5.props.navigation
			})
		elseif v85 == EnumScreens.ChatConversation then
			v82 = Roact.createElement(ChatConversationTopBar, {
				screenName = EnumScreens.ChatConversation,
				navigation = p5.props.navigation
			})
		elseif v85 == EnumScreens.ChatLanding then
			v82 = Roact.createElement(ChatLandingTopBar, {
				screenName = EnumScreens.ChatLanding,
				navigation = p5.props.navigation
			})
		elseif v85 == EnumScreens.ChatDetails then
			v82 = Roact.createElement(ChatTopBarBase, {
				screenName = EnumScreens.ChatDetails,
				navigation = p5.props.navigation
			})
		elseif v85 == EnumScreens.SquadLobby then
			v82 = Roact.createElement(ChatTopBarBase, {
				screenName = EnumScreens.SquadLobby,
				navigation = p5.props.navigation,
				renderRight = function() -- line: 227
					-- upvalues: React (copy), SquadAddFriendsIconButton (copy), p5 (copy)
					return React.createElement(SquadAddFriendsIconButton, {
						navigation = p5.props.navigation
					})
				end
			})
		elseif v85 == EnumScreens.SquadInviteFriends then
			v82 = Roact.createElement(ChatTopBarBase, {
				screenName = EnumScreens.SquadInviteFriends,
				navigation = p5.props.navigation
			})
		elseif v85 == EnumScreens.QuickStartSquadInviteFriends then
			v82 = Roact.createElement(ChatTopBarBase, {
				screenName = EnumScreens.QuickStartSquadInviteFriends,
				navigation = p5.props.navigation
			})
		end
	end

	if not v82 then
		v82 = configureTopBarWithNavigationOptions(p5.props.navigation)
	end

	local v88 = Roact.createElement(AppChatNavigatorTelemetryProviders, {}, {
		layout = if not FFlagAppIaScrollAway or not v80 then Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}) else nil,
		topBar = v82,
		content = Roact.createElement(Provider, {
			value = {
				left = p5.props.navigation.getScreenProps("appChatOuterPadding", 12),
				right = p5.props.navigation.getScreenProps("appChatOuterPadding", 12)
			}
		}, {
			navigatorFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = if not FFlagAppIaScrollAway or not v80 then UDim2.new(1, 0, 1, -p5.props.navigation.getScreenProps("topBarHeight", 0)) else UDim2.fromScale(1, 1)
			}, {
				navigator = Roact.createElement(p5.getNavigator(p5.state.shouldReduceMotion), p5.props)
			})
		})
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ChatLandingStackNavigator = v88
	})
end

local t2 = {
	{
		[EnumScreens.ChatLandingStack] = v57
	},
	{
		[GenericDialogType.EditChatGroupNameDialog] = {
			screen = EditChatGroupNameDialogScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.LeaveGroupDialog] = {
			screen = makeDialogScreenTelemetryWrapper(LeaveGroupDialogScreen),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.ParticipantDialog] = {
			screen = makeDialogScreenTelemetryWrapper(ParticipantDialogScreenDeprecated),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.RemoveUserDialog] = {
			screen = RemoveUserDialogScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[EnumScreens.CreateUnfilteredChatPartialModal] = {
			screen = CreateUnfilteredChatPartialModalScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[EnumScreens.LearnMorePartialModal] = {
			screen = LearnMorePartialModalScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	}
}

table.insert(t2, {
	[EnumScreens.AppChatReportAbuse] = {
		screen = AbuseReportScreen,
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if FFlagAppChatEnableTrustedFriendEntryPoint then
	table.insert(t2, {
		[EnumScreens.AppChatTrustedContactsModal] = {
			screen = TrustedContactsModalScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t2, {
	[EnumScreens.BlockingModal] = {
		screen = BlockingModal,
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})
table.insert(t2, {
	[EnumScreens.MessageContextMenu] = {
		screen = MessageContextMenuScreen,
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if GetFFlagIsSquadEnabled() and GetFFlagEnableCrossExpVoice() then
	table.insert(t2, {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = SquadVoiceAbuseReportScreen,
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t2, {
	[EnumScreens.ConversationOverlay] = {
		screen = ConversationOverlayScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if FFlagAppChatEnableDoubleOptIn then
	table.insert(t2, {
		[EnumScreens.TrustedConnectionsUpsell] = {
			screen = TrustedConnectionsUpsellScreen,
			navigationOptions = {
				transparent = true,
				overlayTransparency = 0.5,
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t2, {
	[EnumScreens.GroupOSADialog] = {
		screen = GroupOSADialogScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if FFlagEnablePartyVoiceChangersInLua then
	table.insert(t2, {
		[EnumScreens.SquadVoiceChangers] = {
			screen = SquadVoiceChangerOverlay,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 0.5
			}
		}
	})
end

return RoactNavigation.createRobloxStackNavigator(t2, {
	defaultNavigationOptions = if not FFlagAppChatDisableAbsorbInputSelectable then nil else {
		absorbInputSelectable = false
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
