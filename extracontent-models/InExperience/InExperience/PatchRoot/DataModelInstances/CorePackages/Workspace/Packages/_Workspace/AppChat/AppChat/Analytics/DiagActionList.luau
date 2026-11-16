local AppChat = script:FindFirstAncestor("AppChat")
local EventNames = require(script.Parent.EventNames)

local parent = AppChat.Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local DiagEventTypes = SocialLuaAnalytics.Analytics.Enums.DiagEventTypes

return {
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
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxRenderedCounter",
			"ChatLandingUnfilteredThreadsFtuxRendered"
		)
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxDismissedCounter",
			"ChatLandingUnfilteredThreadsFtuxDismissed"
		)
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxLearnMoreClickedCounter",
			"ChatLandingUnfilteredThreadsFtuxLearnMoreClicked"
		)
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
		name = game:DefineFastString(
			"ConversationPvUpsellContinueClickedCounter",
			"ConversationPvUpsellContinueClicked"
		)
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
		name = game:DefineFastString(
			"ConversationIneligibleModalRenderedCounter",
			"ConversationIneligibleModalRendered"
		)
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationIneligibleModalLeftGroupCounter",
			"ConversationIneligibleModalLeftGroup"
		)
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationIneligibleModalLearnMoreClickedCounter",
			"ConversationIneligibleModalLearnMoreClicked"
		)
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeDialogRenderedCounter", "ConversationUpgradeDialogRendered")
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationUpgradeDialogActionClickedCounter",
			"ConversationUpgradeDialogActionClicked"
		)
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ConversationUpgradeDialogDismissedCounter", "ConversationUpgradeDialogDismissed")
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationLearnMoreDialogRenderedCounter",
			"ConversationLearnMoreDialogRendered"
		)
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationLearnMoreDialogDismissedCounter",
			"ConversationLearnMoreDialogDismissed"
		)
	},
	[EventNames.NewConversationCreated] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("NewConversationCreatedCounter", "NewConversationCreated")
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
	}
}
