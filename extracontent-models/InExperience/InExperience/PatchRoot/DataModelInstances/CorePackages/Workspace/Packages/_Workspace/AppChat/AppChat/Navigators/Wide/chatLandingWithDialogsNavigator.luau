local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local SharedFlags = require(AppChatParent.SharedFlags)
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
local FocusNavigableSurfaceIdentifierEnum = require(AppChatParent.FocusNavigationUtils).FocusNavigableSurfaceIdentifierEnum
local ChatConversation = AppChat.Components.ChatConversation
local CreateUnfilteredChatPartialModalScreen = require(ChatConversation.PartialModal.CreateUnfilteredChatPartialModalScreen)
local LearnMorePartialModalScreen = require(ChatConversation.PartialModal.LearnMorePartialModalScreen)
local SquadVoiceAbuseReportScreen = require(AppChatParent.Squads.SquadVoiceAbuseReportScreen)
local ConversationOverlayScreen = require(ChatConversation.PartialModal.ConversationOverlayScreen)
local TrustedConnectionsUpsellScreen = require(AppChat.Components.TrustedConnectionsUpsell.TrustedConnectionsUpsellScreen)
local GroupOSADialogScreen = require(AppChat.Components.OSA.GroupOSADialogScreen)
local makeDialogScreenTelemetryWrapper = require(AppChat.Navigators.makeDialogScreenTelemetryWrapper)
local isolatedAutoFocusNavigation = require(AppChat.Navigators.isolatedAutoFocusNavigation)
local BlockingModal = require(AppChatParent.SocialBlockingModal).BlockingModal
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local chatLandingStackNavigator = require(script.Parent.chatLandingStackNavigator)
local v34 = Roact.Component:extend("ChatLandingStackNavigatorConnector")

v34.router = chatLandingStackNavigator.router

function v34.render(p1) -- line: 47
	-- upvalues: Roact (copy), chatLandingStackNavigator (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ChatLandingStackNavigator = Roact.createElement(chatLandingStackNavigator, p1.props)
	})
end

local t1 = {
	{
		[EnumScreens.ChatLandingStack] = v34
	},
	{
		[GenericDialogType.EditChatGroupNameDialog] = {
			screen = isolatedAutoFocusNavigation(EditChatGroupNameDialogScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.LeaveGroupDialog] = {
			screen = isolatedAutoFocusNavigation(makeDialogScreenTelemetryWrapper(LeaveGroupDialogScreen), FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.ParticipantDialog] = {
			screen = isolatedAutoFocusNavigation(makeDialogScreenTelemetryWrapper(ParticipantDialogScreenDeprecated), FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[GenericDialogType.RemoveUserDialog] = {
			screen = isolatedAutoFocusNavigation(RemoveUserDialogScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[EnumScreens.CreateUnfilteredChatPartialModal] = {
			screen = isolatedAutoFocusNavigation(CreateUnfilteredChatPartialModalScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	},
	{
		[EnumScreens.LearnMorePartialModal] = {
			screen = isolatedAutoFocusNavigation(LearnMorePartialModalScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	}
}

table.insert(t1, {
	[EnumScreens.AppChatReportAbuse] = {
		screen = isolatedAutoFocusNavigation(AbuseReportScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if FFlagAppChatEnableTrustedFriendEntryPoint then
	table.insert(t1, {
		[EnumScreens.AppChatTrustedContactsModal] = {
			screen = isolatedAutoFocusNavigation(TrustedContactsModalScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t1, {
	[EnumScreens.BlockingModal] = {
		screen = isolatedAutoFocusNavigation(BlockingModal, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})
table.insert(t1, {
	[EnumScreens.MessageContextMenu] = {
		screen = isolatedAutoFocusNavigation(MessageContextMenuScreen, FocusNavigableSurfaceIdentifierEnum.ContextualMenu),
		navigationOptions = {
			backButtonEnabled = true,
			overlayEnabled = true
		}
	}
})

if GetFFlagIsSquadEnabled() and GetFFlagEnableCrossExpVoice() then
	table.insert(t1, {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceAbuseReportScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				backButtonEnabled = true,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t1, {
	[EnumScreens.ConversationOverlay] = {
		screen = isolatedAutoFocusNavigation(ConversationOverlayScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = {
			overlayEnabled = true,
			transparent = true,
			overlayTransparency = 0.5
		}
	}
})

if FFlagAppChatEnableDoubleOptIn then
	table.insert(t1, {
		[EnumScreens.TrustedConnectionsUpsell] = {
			screen = TrustedConnectionsUpsellScreen,
			navigationOptions = {
				transparent = true,
				overlayTransparency = 0.5,
				overlayEnabled = true
			}
		}
	})
end

table.insert(t1, {
	[EnumScreens.GroupOSADialog] = {
		screen = GroupOSADialogScreen,
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
			overlayEnabled = true
		}
	}
})

if FFlagEnablePartyVoiceChangersInLua then
	table.insert(t1, {
		[EnumScreens.SquadVoiceChangers] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceChangerOverlay, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 0.5
			}
		}
	})
end

return RoactNavigation.createRobloxStackNavigator(t1, {
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
