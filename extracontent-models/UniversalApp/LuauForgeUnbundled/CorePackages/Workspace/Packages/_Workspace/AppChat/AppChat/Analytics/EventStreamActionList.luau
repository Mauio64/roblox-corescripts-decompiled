local LocalizationService = game:GetService("LocalizationService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Dash")

local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics").Analytics.Enums
local eventTypes = enums.EventTypes
local contexts = enums.Contexts

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

return {
	[EventNames.ChatLandingGroupsBtnClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingGroupsBtnClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {}
	},
	[EventNames.ChatLandingPartyQuickStartButtonClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPartyQuickStartButtonClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			clickLocation = Dash.identity,
			partyAttemptId = Dash.identity,
			placeId = Dash.identity,
			universeId = Dash.identity
		}
	},
	[EventNames.ChatLandingPvUpsellRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPvUpsellRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellDismissed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPvUpsellDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellContinueClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPvUpsellContinueClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellSucceeded] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPvUpsellSucceeded,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellFailed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingPvUpsellFailed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingUnfilteredThreadsFtuxRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingUnfilteredThreadsFtuxDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ConversationScrollToLatestBtnClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationScrollToLatestBtnClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			messageListVersion = Dash.identity
		}
	},
	[EventNames.NewConversationCreated] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.NewConversationCreated,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			createConversationResult = Dash.identity,
			participantsCount = Dash.identity,
			createdReason = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuOpened] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatMessageMenuOpened,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuReplyBtnActivated] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatMessageMenuReplyBtnActivated,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuCopyBtnActivated] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ChatMessageMenuCopyBtnActivated,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			targetMessageSenderId = Dash.identity,
			targetMessageId = Dash.identity,
			targetMessageSentAt = Dash.identity,
			targetMessageLength = Dash.identity
		}
	},
	[EventNames.ConversationPvUpsellRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationPvUpsellRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellLeftGroup] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationPvUpsellLeftGroup,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellContinueClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationPvUpsellContinueClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellSucceeded] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationPvUpsellSucceeded,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellFailed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationPvUpsellFailed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationIneligibleModalRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationIneligibleModalLeftGroup,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationIneligibleModalLearnMoreClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationUpgradeDialogRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationUpgradeDialogActionClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationUpgradeDialogDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationLearnMoreDialogRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.ConversationLearnMoreDialogDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.preloadSocialTabDataEvent] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.preloadSocialTabDataEvent,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { unreadConversationCount = Dash.identity }
	},
	[EventNames.preloadSocialTabDataFailedEvent] = {
		context = contexts.PlatformChat,
		eventType = eventTypes.preloadSocialTabDataFailedEvent,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	}
}
