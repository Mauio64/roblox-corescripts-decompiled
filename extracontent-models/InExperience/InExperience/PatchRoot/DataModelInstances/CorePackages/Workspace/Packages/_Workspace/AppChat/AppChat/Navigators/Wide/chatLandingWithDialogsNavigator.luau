local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local RoactNavigation = require(parent.RoactNavigation)
local EnumScreens = require(AppChat.EnumScreens)
local SharedFlags = require(parent.SharedFlags)

local ChatDetails = AppChat.Components.ChatDetails
local GenericDialogType = require(ChatDetails.Dialogs.GenericDialogType)
local EditChatGroupNameDialogScreen = require(ChatDetails.EditChatGroupNameDialog.EditChatGroupNameDialogScreen)
local LeaveGroupDialogScreen = require(ChatDetails.LeaveGroupDialog.LeaveGroupDialogScreen)
local ParticipantDialogScreenDeprecated = require(ChatDetails.ParticipantDialog.ParticipantDialogScreenDeprecated)
local RemoveUserDialogScreen = require(ChatDetails.RemoveUserDialog.RemoveUserDialogScreen)
local AbuseReportScreen = require(AppChat.Components.ChatAbuseReport.AbuseReportScreen)
local FFlagAppChatDisableAbsorbInputSelectable = require(AppChat.Flags.FFlagAppChatDisableAbsorbInputSelectable)

local MessageContextMenuScreen = require(AppChat.Components.ChatConversation.MessageInteraction.MessageContextMenuScreen)
local SquadVoiceChangerOverlay = require(parent.Squads.SquadVoiceChangerOverlay)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local ChatConversation = AppChat.Components.ChatConversation

local CreateUnfilteredChatPartialModalScreen = require(ChatConversation.PartialModal.CreateUnfilteredChatPartialModalScreen)
local LearnMorePartialModalScreen = require(ChatConversation.PartialModal.LearnMorePartialModalScreen)
local SquadVoiceAbuseReportScreen = require(parent.Squads.SquadVoiceAbuseReportScreen)
local ConversationOverlayScreen = require(ChatConversation.PartialModal.ConversationOverlayScreen)
local TrustedFriendsUpsellScreen = require(AppChat.Components.TrustedFriendsUpsell.TrustedFriendsUpsellScreen)
local GroupOSADialogScreen = require(AppChat.Components.OSA.GroupOSADialogScreen)
local makeDialogScreenTelemetryWrapper = require(AppChat.Navigators.makeDialogScreenTelemetryWrapper)
local isolatedAutoFocusNavigation = require(AppChat.Navigators.isolatedAutoFocusNavigation)

local SocialBlockingModal = require(parent.SocialBlockingModal)
local BlockingModal = SocialBlockingModal.BlockingModal

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local chatLandingStackNavigator = require(script.Parent.chatLandingStackNavigator)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)

local extended = Roact.Component:extend("ChatLandingStackNavigatorConnector")
extended.router = chatLandingStackNavigator.router

function extended.render(p)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagAppChatConsoleFocusFixes or nil
	}, {
		ChatLandingStackNavigator = Roact.createElement(chatLandingStackNavigator, p.props)
	})
end

local v = {
	{ [EnumScreens.ChatLandingStack] = extended },
	{
		[GenericDialogType.EditChatGroupNameDialog] = {
			screen = isolatedAutoFocusNavigation(
				EditChatGroupNameDialogScreen,
				FocusNavigableSurfaceIdentifierEnum.PopUp
			),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.LeaveGroupDialog] = {
			screen = isolatedAutoFocusNavigation(
				makeDialogScreenTelemetryWrapper(LeaveGroupDialogScreen),
				FocusNavigableSurfaceIdentifierEnum.PopUp
			),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.ParticipantDialog] = {
			screen = isolatedAutoFocusNavigation(
				makeDialogScreenTelemetryWrapper(ParticipantDialogScreenDeprecated),
				FocusNavigableSurfaceIdentifierEnum.PopUp
			),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.RemoveUserDialog] = {
			screen = isolatedAutoFocusNavigation(RemoveUserDialogScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.CreateUnfilteredChatPartialModal] = {
			screen = isolatedAutoFocusNavigation(
				CreateUnfilteredChatPartialModalScreen,
				FocusNavigableSurfaceIdentifierEnum.PopUp
			),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.LearnMorePartialModal] = {
			screen = isolatedAutoFocusNavigation(LearnMorePartialModalScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
}

local v2 = {
	[EnumScreens.AppChatReportAbuse] = {
		screen = isolatedAutoFocusNavigation(AbuseReportScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v2)

local v3 = {
	[EnumScreens.BlockingModal] = {
		screen = isolatedAutoFocusNavigation(BlockingModal, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v3)

local v4 = {
	[EnumScreens.MessageContextMenu] = {
		screen = isolatedAutoFocusNavigation(
			MessageContextMenuScreen,
			FocusNavigableSurfaceIdentifierEnum.ContextualMenu
		),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v, v4)

if GetFFlagIsSquadEnabled() and GetFFlagEnableCrossExpVoice() then
	local v5 = {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceAbuseReportScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
	table.insert(v, v5)
end

local v5 = {
	[EnumScreens.ConversationOverlay] = {
		screen = isolatedAutoFocusNavigation(ConversationOverlayScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { overlayEnabled = true, transparent = true, overlayTransparency = 0.5 }
	}
}
table.insert(v, v5)

local v6 = {
	[EnumScreens.TrustedConnectionsUpsell] = {
		screen = isolatedAutoFocusNavigation(TrustedFriendsUpsellScreen, FocusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { transparent = true, overlayTransparency = 0.5, overlayEnabled = true }
	}
}
table.insert(v, v6)

local v7 = {
	[EnumScreens.GroupOSADialog] = {
		screen = GroupOSADialogScreen,
		navigationOptions = { transparent = true, overlayTransparency = 0.5, overlayEnabled = true }
	}
}
table.insert(v, v7)

if FFlagEnablePartyVoiceChangersInLua then
	local v8 = {
		[EnumScreens.SquadVoiceChangers] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceChangerOverlay, FocusNavigableSurfaceIdentifierEnum.PopUp),
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
