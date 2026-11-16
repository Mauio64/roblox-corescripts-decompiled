local parent = script:FindFirstAncestor("AppChat").Parent

local LocalizationService = game:GetService("LocalizationService")

local Dash = require(parent.Dash)

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local EventTypes = Enums.EventTypes
local Contexts = Enums.Contexts

local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.ChatLandingGroupsBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingGroupsBtnClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {}
	},
	[EventNames.ChatLandingPartyQuickStartButtonClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPartyQuickStartButtonClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
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
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellContinueClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellContinueClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellSucceeded] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellSucceeded,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingPvUpsellFailed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingPvUpsellFailed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	},
	[EventNames.ConversationScrollToLatestBtnClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationScrollToLatestBtnClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			messageListVersion = Dash.identity
		}
	},
	[EventNames.NewConversationCreated] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.NewConversationCreated,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = {
			conversationId = Dash.identity,
			createConversationResult = Dash.identity,
			participantsCount = Dash.identity,
			createdReason = Dash.identity
		}
	},
	[EventNames.ChatMessageMenuOpened] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuOpened,
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
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuReplyBtnActivated,
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
		context = Contexts.PlatformChat,
		eventType = EventTypes.ChatMessageMenuCopyBtnActivated,
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
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellLeftGroup] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellLeftGroup,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellContinueClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellContinueClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellSucceeded] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellSucceeded,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationPvUpsellFailed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationPvUpsellFailed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalLeftGroup,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationIneligibleModalLearnMoreClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogActionClicked,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationUpgradeDialogDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreDialogRendered,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.ConversationLearnMoreDialogDismissed,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { conversationId = Dash.identity }
	},
	[EventNames.preloadSocialTabDataEvent] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.preloadSocialTabDataEvent,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId },
		formatRulesForAdditionalInfo = { unreadConversationCount = Dash.identity }
	},
	[EventNames.preloadSocialTabDataFailedEvent] = {
		context = Contexts.PlatformChat,
		eventType = EventTypes.preloadSocialTabDataFailedEvent,
		additionalInfo = { locale = LocalizationService.RobloxLocaleId }
	}
}
