local AppChat = script:FindFirstAncestor("AppChat")
local EventNames = require(script.Parent.EventNames)
local AppChatParent = AppChat.Parent
local DiagEventTypes = require(AppChatParent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes

return {
	[EventNames.ChatLandingScreenRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingScreenRenderedCounter", "ChatLandingScreenRendered")
	},
	[EventNames.AppChatVisible] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("AppChatVisibleCounter", "AppChatVisible")
	},
	[EventNames.AppChatClosed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("AppChatClosedCounter", "AppChatClosed")
	},
	[EventNames.ChatLandingSearchBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingSearchBtnClickedCounter", "ChatLandingSearchBtnClicked")
	},
	[EventNames.ChatLandingComposeBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingComposeBtnClickedCounter", "ChatLandingComposeBtnClicked")
	},
	[EventNames.ChatLandingNotifBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingNotifBtnClickedCounter", "ChatLandingNotifBtnClicked")
	},
	[EventNames.ChatLandingConversationClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingConversationClickedCounter", "ChatLandingConversationClicked")
	},
	[EventNames.ChatLandingGroupsBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingGroupsBtnClicked", "ChatLandingGroupsBtnClicked")
	},
	[EventNames.ChatLandingPvUpsellRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellRenderedCounter", "ChatLandingPvUpsellRendered")
	},
	[EventNames.ChatLandingPvUpsellDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellDismissedCounter", "ChatLandingPvUpsellDismissed")
	},
	[EventNames.ChatLandingPvUpsellContinueClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellContinueClickedCounter", "ChatLandingPvUpsellContinueClicked")
	},
	[EventNames.ChatLandingPvUpsellSucceeded] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellSucceededCounter", "ChatLandingPvUpsellSucceeded")
	},
	[EventNames.ChatLandingPvUpsellFailed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellFailedCounter", "ChatLandingPvUpsellFailed")
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingUnfilteredThreadsFtuxRenderedCounter", "ChatLandingUnfilteredThreadsFtuxRendered")
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingUnfilteredThreadsFtuxDismissedCounter", "ChatLandingUnfilteredThreadsFtuxDismissed")
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingUnfilteredThreadsFtuxLearnMoreClickedCounter", "ChatLandingUnfilteredThreadsFtuxLearnMoreClicked")
	},
	[EventNames.ConversationScreenRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationScreenRenderedCounter", "ConversationScreenRendered")
	},
	[EventNames.ConversationSendBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationSendBtnClickedCounter", "ConversationSendBtnClicked")
	},
	[EventNames.ConversationScreenExit] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationScreenExitCounter", "ConversationScreenExit")
	},
	[EventNames.ConversationInfoBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationInfoBtnClickedCounter", "ConversationInfoBtnClicked")
	},
	[EventNames.ConversationMessageSent] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationMessageSentCounter", "ConversationMessageSent")
	},
	[EventNames.ConversationPvUpsellRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellRenderedCounter", "ConversationPvUpsellRendered")
	},
	[EventNames.ConversationPvUpsellLeftGroup] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellLeftGroupCounter", "ConversationPvUpsellLeftGroup")
	},
	[EventNames.ConversationPvUpsellContinueClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellContinueClickedCounter", "ConversationPvUpsellContinueClicked")
	},
	[EventNames.ConversationPvUpsellSucceeded] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellSucceededCounter", "ConversationPvUpsellSucceeded")
	},
	[EventNames.ConversationPvUpsellFailed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellFailedCounter", "ConversationPvUpsellFailed")
	},
	[EventNames.ConversationIneligibleModalRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationIneligibleModalRenderedCounter", "ConversationIneligibleModalRendered")
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationIneligibleModalLeftGroupCounter", "ConversationIneligibleModalLeftGroup")
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationIneligibleModalLearnMoreClickedCounter", "ConversationIneligibleModalLearnMoreClicked")
	},
	[EventNames.ConversationPvBannerRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvBannerRenderedCounter", "ConversationPvBannerRendered")
	},
	[EventNames.ConversationPvBannerActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvBannerActionClickedCounter", "ConversationPvBannerActionClicked")
	},
	[EventNames.ConversationUpgradeBannerRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeBannerRenderedCounter", "ConversationUpgradeBannerRendered")
	},
	[EventNames.ConversationUpgradeBannerActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeBannerActionClickedCounter", "ConversationUpgradeBannerActionClicked")
	},
	[EventNames.ConversationLearnMoreBannerRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationLearnMoreBannerRenderedCounter", "ConversationLearnMoreBannerRendered")
	},
	[EventNames.ConversationLearnMoreBannerActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationLearnMoreBannerActionClickedCounter", "ConversationLearnMoreBannerActionClicked")
	},
	[EventNames.ConversationPvDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvDialogRenderedCounter", "ConversationPvDialogRendered")
	},
	[EventNames.ConversationPvDialogActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvDialogActionClickedCounter", "ConversationPvDialogActionClicked")
	},
	[EventNames.ConversationPvDialogDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvDialogDismissedCounter", "ConversationPvDialogDismissed")
	},
	[EventNames.ConversationPvDialogSucceeded] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvDialogSucceededCounter", "ConversationPvDialogSucceeded")
	},
	[EventNames.ConversationPvDialogFailed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvDialogFailedCounter", "ConversationPvDialogFailed")
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeDialogRenderedCounter", "ConversationUpgradeDialogRendered")
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeDialogActionClickedCounter", "ConversationUpgradeDialogActionClicked")
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeDialogDismissedCounter", "ConversationUpgradeDialogDismissed")
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationLearnMoreDialogRenderedCounter", "ConversationLearnMoreDialogRendered")
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationLearnMoreDialogDismissedCounter", "ConversationLearnMoreDialogDismissed")
	},
	[EventNames.NewConversationCreated] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("NewConversationCreatedCounter", "NewConversationCreated")
	},
	[EventNames.ChatMessagePressed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessagePressedCounter", "ChatMessagePressed")
	},
	[EventNames.ChatMessageLongPressed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageLongPressedCounter", "ChatMessageLongPressed")
	},
	[EventNames.ChatMessageOpenMenuIconClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageOpenMenuIconClickedCounter", "ChatMessageOpenMenuIconClicked")
	},
	[EventNames.ChatMessageReplyIconClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageReplyIconClickedCounter", "ChatMessageReplyIconClicked")
	},
	[EventNames.ChatMessageMenuOpened] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageMenuOpenedCounter", "ChatMessageMenuOpened")
	},
	[EventNames.ChatMessageMenuReplyBtnActivated] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageMenuReplyBtnActivatedCounter", "ChatMessageMenuReplyBtnActivated")
	},
	[EventNames.ChatMessageMenuCopyBtnActivated] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageMenuCopyBtnActivatedCounter", "ChatMessageMenuCopyBtnActivated")
	},
	[EventNames.ChatInputBarReplyComposeRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatInputBarReplyComposeRenderedCounter", "ChatInputBarReplyComposeRendered")
	},
	[EventNames.ChatInputBarReplyComposeCancelBtnActivated] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatInputBarReplyComposeCancelBtnActivatedCounter", "ChatInputBarReplyComposeCancelBtnActivated")
	},
	[EventNames.ChatDetailsRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsRenderedCounter", "ChatDetailsRendered")
	},
	[EventNames.ChatEmptyStateScreenRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatEmptyStateScreenRenderedCounter", "ChatEmptyStateScreenRendered")
	},
	[EventNames.ChatAddFriendsBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatAddFriendsBtnClickedCounter", "ChatAddFriendsBtnClicked")
	},
	[EventNames.ChatDetailsAddFriendsBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsAddFriendsBtnClickedCounter", "ChatDetailsAddFriendsBtnClicked")
	},
	[EventNames.ChatDetailsLeaveGroupBtnClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsLeaveGroupBtnClickedCounter", "ChatDetailsLeaveGroupBtnClicked")
	},
	[EventNames.ChatDetailsLeaveGroupDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsLeaveGroupDialogRenderedCounter", "ChatDetailsLeaveGroupDialogRendered")
	},
	[EventNames.ChatDetailsLeaveGroupDialogStayClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsLeaveGroupDialogStayClickedCounter", "ChatDetailsLeaveGroupDialogStayClicked")
	},
	[EventNames.ChatDetailsLeaveGroupDialogLeaveClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsLeaveGroupDialogLeaveClickedCounter", "ChatDetailsLeaveGroupDialogLeaveClicked")
	},
	[EventNames.ChatDetailsReportUserClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsReportUserClickedCounter", "ChatDetailsReportUserClicked")
	},
	[EventNames.ChatDetailsCreateUnfilteredChatCellRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsCreateUnfilteredChatCellRenderedCounter", "ChatDetailsCreateUnfilteredChatCellRendered")
	},
	[EventNames.ChatDetailsCreateUnfilteredChatCellClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ChatDetailsCreateUnfilteredChatCellClickedCounter", "ChatDetailsCreateUnfilteredChatCellClicked")
	}
}
