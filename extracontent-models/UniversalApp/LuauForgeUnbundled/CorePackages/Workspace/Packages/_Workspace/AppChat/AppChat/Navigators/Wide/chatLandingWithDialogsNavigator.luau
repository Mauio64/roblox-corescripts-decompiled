local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")
local EditChatGroupNameDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/EditChatGroupNameDialog/EditChatGroupNameDialogScreen")
local LeaveGroupDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupDialog/LeaveGroupDialogScreen")
local ParticipantDialogScreenDeprecated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialogScreenDeprecated")
local RemoveUserDialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/RemoveUserDialogScreen")
local AbuseReportScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatAbuseReport/AbuseReportScreen")
local FFlagAppChatDisableAbsorbInputSelectable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDisableAbsorbInputSelectable")

local MessageContextMenuScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/MessageContextMenuScreen")
local SquadVoiceChangerOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadVoiceChangerOverlay")
local focusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils").FocusNavigableSurfaceIdentifierEnum

local CreateUnfilteredChatPartialModalScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/CreateUnfilteredChatPartialModalScreen")
local LearnMorePartialModalScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/LearnMorePartialModalScreen")
local SquadVoiceAbuseReportScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/SquadVoiceAbuseReportScreen")
local ConversationOverlayScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PartialModal/ConversationOverlayScreen")
local TrustedFriendsUpsellScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TrustedFriendsUpsell/TrustedFriendsUpsellScreen")
local GroupOSADialogScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/GroupOSADialogScreen")
local makeDialogScreenTelemetryWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/makeDialogScreenTelemetryWrapper")
local isolatedAutoFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/isolatedAutoFocusNavigation")

local blockingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialBlockingModal").BlockingModal

local getFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local fFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local chatLandingStackNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/chatLandingStackNavigator")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

local extended = Roact.Component:extend("ChatLandingStackNavigatorConnector")
extended.router = chatLandingStackNavigator.router

function extended.render(p2)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = not FFlagAppChatConsoleFocusFixes or nil
	}, {
		ChatLandingStackNavigator = Roact.createElement(chatLandingStackNavigator, p2.props)
	})
end

local v11 = {
	{ [EnumScreens.ChatLandingStack] = extended },
	{
		[GenericDialogType.EditChatGroupNameDialog] = {
			screen = isolatedAutoFocusNavigation(EditChatGroupNameDialogScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.LeaveGroupDialog] = {
			screen = isolatedAutoFocusNavigation(makeDialogScreenTelemetryWrapper(LeaveGroupDialogScreen), focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.ParticipantDialog] = {
			screen = isolatedAutoFocusNavigation(makeDialogScreenTelemetryWrapper(ParticipantDialogScreenDeprecated), focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[GenericDialogType.RemoveUserDialog] = {
			screen = isolatedAutoFocusNavigation(RemoveUserDialogScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.CreateUnfilteredChatPartialModal] = {
			screen = isolatedAutoFocusNavigation(CreateUnfilteredChatPartialModalScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	},
	{
		[EnumScreens.LearnMorePartialModal] = {
			screen = isolatedAutoFocusNavigation(LearnMorePartialModalScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
}

local v12 = {
	[EnumScreens.AppChatReportAbuse] = {
		screen = isolatedAutoFocusNavigation(AbuseReportScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v12)

local v13 = {
	[EnumScreens.BlockingModal] = {
		screen = isolatedAutoFocusNavigation(blockingModal, focusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v13)

local v14 = {
	[EnumScreens.MessageContextMenu] = {
		screen = isolatedAutoFocusNavigation(MessageContextMenuScreen, focusNavigableSurfaceIdentifierEnum.ContextualMenu),
		navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
	}
}
table.insert(v11, v14)

if getFFlagIsSquadEnabled() and getFFlagEnableCrossExpVoice() then
	local v15 = {
		[EnumScreens.SquadVoiceReportAbuse] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceAbuseReportScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { backButtonEnabled = true, overlayEnabled = true }
		}
	}
	table.insert(v11, v15)
end

local v15 = {
	[EnumScreens.ConversationOverlay] = {
		screen = isolatedAutoFocusNavigation(ConversationOverlayScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = {
			overlayEnabled = true,
			transparent = true,
			overlayTransparency = 0.5
		}
	}
}
table.insert(v11, v15)

local v16 = {
	[EnumScreens.TrustedConnectionsUpsell] = {
		screen = isolatedAutoFocusNavigation(TrustedFriendsUpsellScreen, focusNavigableSurfaceIdentifierEnum.PopUp),
		navigationOptions = {
			transparent = true,
			overlayTransparency = 0.5,
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
			overlayEnabled = true
		}
	}
}
table.insert(v11, v17)

if fFlagEnablePartyVoiceChangersInLua then
	local v18 = {
		[EnumScreens.SquadVoiceChangers] = {
			screen = isolatedAutoFocusNavigation(SquadVoiceChangerOverlay, focusNavigableSurfaceIdentifierEnum.PopUp),
			navigationOptions = { overlayEnabled = true, overlayTransparency = 0.5 }
		}
	}
	table.insert(v11, v18)
end

return RoactNavigation.createRobloxStackNavigator(v11, {
	defaultNavigationOptions = FFlagAppChatDisableAbsorbInputSelectable and { absorbInputSelectable = false } or nil,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
