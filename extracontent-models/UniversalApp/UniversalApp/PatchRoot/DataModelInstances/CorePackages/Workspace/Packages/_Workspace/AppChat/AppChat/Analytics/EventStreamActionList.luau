local Parent = script:FindFirstAncestor("AppChat").Parent
local LocalizationService = game:GetService("LocalizationService")
local Dash = require(Parent.Dash)
local Enums = require(Parent.SocialLuaAnalytics).Analytics.Enums
local EventTypes = Enums.EventTypes
local Contexts = Enums.Contexts
local EventNames = require(script.Parent.EventNames)
local SendButtonClickActionResult = require(script.Parent.Enums).SendButtonClickActionResult
local ConversationExitType = require(script.Parent.Enums).ConversationExitType
local EmptyStateType = require(script.Parent.Enums).EmptyStateType

return {
	[EventNames.AppChatVisible] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.AppChatVisible,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			isChatEnabled = Dash.identity,
			isChatLoading = Dash.identity,
			chatLandingListCount = Dash.identity
		}
	},
	[EventNames.AppChatClosed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.AppChatClosed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			isChatEnabled = Dash.identity,
			isChatLoading = Dash.identity,
			chatLandingListCount = Dash.identity
		}
	},
	[EventNames.ChatLandingScreenRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingScreenRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			isChatEnabled = Dash.identity
		}
	},
	[EventNames.ChatLandingSearchBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingSearchBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingComposeBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingComposeBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingNotifBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingNotifBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingSnoozeBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingSnoozeBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId,
			isChatNotificationsMuted = Dash.identity
		}
	},
	[EventNames.ChatLandingConversationClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingConversationClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			isFiltered = Dash.identity,
			conversationListCount = Dash.identity,
			selectedConversationId = Dash.identity,
			selectedIndex = Dash.identity,
			hasUnreadMessages = Dash.identity,
			selectedConversationModerationType = Dash.identity,
			selectedConversationUserPendingStatus = Dash.identity
		}
	},
	[EventNames.ChatLandingGroupsBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingGroupsBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {}
	},
	[EventNames.ChatLandingPartyQuickStartButtonClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPartyQuickStartButtonClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			clickLocation = Dash.identity,
			partyAttemptId = Dash.identity,
			placeId = Dash.identity,
			universeId = Dash.identity
		}
	},
	[EventNames.ChatLandingPvUpsellRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingPvUpsellDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellDismissed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingPvUpsellContinueClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellContinueClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingPvUpsellSucceeded] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellSucceeded,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingPvUpsellFailed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellFailed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxDismissed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	},
	[EventNames.ConversationScreenRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationScreenRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			loadedMessageCount = Dash.identity
		}
	},
	[EventNames.ConversationSendBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationSendBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			sendBtnClickResult = SendButtonClickActionResult
		}
	},
	[EventNames.ConversationScreenExit] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationScreenExit,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			conversationExitType = ConversationExitType
		}
	},
	[EventNames.ConversationInfoBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationInfoBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.NewConversationCreated] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.NewConversationCreated,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			createConversationResult = Dash.identity,
			participantsCount = Dash.identity,
			createdReason = Dash.identity
		}
	},
	[EventNames.ChatMessagePressed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessagePressed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageLongPressed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageLongPressed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageOpenMenuIconClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageOpenMenuIconClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageReplyIconClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageReplyIconClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuOpened] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuOpened,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuReplyBtnActivated] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuReplyBtnActivated,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuCopyBtnActivated] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuCopyBtnActivated,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatInputBarReplyComposeRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatInputBarReplyComposeRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatInputBarReplyComposeCancelBtnActivated] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatInputBarReplyComposeCancelBtnActivated,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatDetailsRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			participantsCount = Dash.identity,
			isGroupOwner = Dash.identity,
			isGroupConversation = Dash.identity
		}
	},
	[EventNames.ConversationMessageSent] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationMessageSent,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			messageSentResult = Dash.identity,
			messageId = Dash.identity,
			recipientIds = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatEmptyStateScreenRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatEmptyStateScreenRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			emptyStateType = EmptyStateType
		}
	},
	[EventNames.ChatAddFriendsBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatAddFriendsBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {}
	},
	[EventNames.ChatDetailsAddFriendsBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsAddFriendsBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			participantsCount = Dash.identity,
			isGroupOwner = Dash.identity,
			isGroupConversation = Dash.identity
		}
	},
	[EventNames.ChatDetailsLeaveGroupBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsLeaveGroupBtnClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			participantsCount = Dash.identity,
			isGroupOwner = Dash.identity
		}
	},
	[EventNames.ChatDetailsLeaveGroupDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsLeaveGroupDialogRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ChatDetailsLeaveGroupDialogStayClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsLeaveGroupDialogStayClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ChatDetailsLeaveGroupDialogLeaveClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsLeaveGroupDialogLeaveClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			selectedConversationHasGroupUp = Dash.identity
		}
	},
	[EventNames.ChatDetailsReportUserClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsReportUserClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ChatDetailsCreateUnfilteredChatCellRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsCreateUnfilteredChatCellRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ChatDetailsCreateUnfilteredChatCellClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatDetailsCreateUnfilteredChatCellClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			participantsCount = Dash.identity,
			isGroupOwner = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellLeftGroup] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellLeftGroup,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellContinueClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellContinueClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellSucceeded] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellSucceeded,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellFailed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellFailed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationIneligibleModalRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalLeftGroup,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalLearnMoreClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvBannerRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvBannerRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvBannerActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvBannerActionClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationUpgradeBannerRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeBannerRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationUpgradeBannerActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeBannerActionClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationLearnMoreBannerRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreBannerRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationLearnMoreBannerActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreBannerActionClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvDialogRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvDialogActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvDialogActionClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvDialogDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvDialogDismissed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvDialogSucceeded] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvDialogSucceeded,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationPvDialogFailed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvDialogFailed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogActionClicked,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogDismissed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreDialogRendered,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreDialogDismissed,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity
		}
	},
	[EventNames.preloadSocialTabDataEvent] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.preloadSocialTabDataEvent,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		},
		formatRulesForAdditionalInfo = {
			unreadConversationCount = Dash.identity
		}
	},
	[EventNames.preloadSocialTabDataFailedEvent] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.preloadSocialTabDataFailedEvent,
		additionalInfo = {
			locale = LocalizationService.RobloxLocaleId
		}
	}
}
