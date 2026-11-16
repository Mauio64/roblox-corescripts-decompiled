local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")

local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics").Analytics.Enums.DiagEventTypes

return {
	[EventNames.ChatLandingGroupsBtnClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingGroupsBtnClicked", "ChatLandingGroupsBtnClicked")
	},
	[EventNames.ChatLandingPvUpsellRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellRenderedCounter", "ChatLandingPvUpsellRendered")
	},
	[EventNames.ChatLandingPvUpsellDismissed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellDismissedCounter", "ChatLandingPvUpsellDismissed")
	},
	[EventNames.ChatLandingPvUpsellContinueClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingPvUpsellContinueClickedCounter",
			"ChatLandingPvUpsellContinueClicked"
		)
	},
	[EventNames.ChatLandingPvUpsellSucceeded] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellSucceededCounter", "ChatLandingPvUpsellSucceeded")
	},
	[EventNames.ChatLandingPvUpsellFailed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatLandingPvUpsellFailedCounter", "ChatLandingPvUpsellFailed")
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxRenderedCounter",
			"ChatLandingUnfilteredThreadsFtuxRendered"
		)
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxDismissed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxDismissedCounter",
			"ChatLandingUnfilteredThreadsFtuxDismissed"
		)
	},
	[EventNames.ChatLandingUnfilteredThreadsFtuxLearnMoreClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatLandingUnfilteredThreadsFtuxLearnMoreClickedCounter",
			"ChatLandingUnfilteredThreadsFtuxLearnMoreClicked"
		)
	},
	[EventNames.ConversationPvUpsellRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellRenderedCounter", "ConversationPvUpsellRendered")
	},
	[EventNames.ConversationPvUpsellLeftGroup] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationPvUpsellLeftGroupCounter",
			"ConversationPvUpsellLeftGroup"
		)
	},
	[EventNames.ConversationPvUpsellContinueClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationPvUpsellContinueClickedCounter",
			"ConversationPvUpsellContinueClicked"
		)
	},
	[EventNames.ConversationPvUpsellSucceeded] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationPvUpsellSucceededCounter",
			"ConversationPvUpsellSucceeded"
		)
	},
	[EventNames.ConversationPvUpsellFailed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ConversationPvUpsellFailedCounter", "ConversationPvUpsellFailed")
	},
	[EventNames.ConversationIneligibleModalRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationIneligibleModalRenderedCounter",
			"ConversationIneligibleModalRendered"
		)
	},
	[EventNames.ConversationIneligibleModalLeftGroup] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationIneligibleModalLeftGroupCounter",
			"ConversationIneligibleModalLeftGroup"
		)
	},
	[EventNames.ConversationIneligibleModalLearnMoreClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationIneligibleModalLearnMoreClickedCounter",
			"ConversationIneligibleModalLearnMoreClicked"
		)
	},
	[EventNames.ConversationUpgradeDialogRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationUpgradeDialogRenderedCounter",
			"ConversationUpgradeDialogRendered"
		)
	},
	[EventNames.ConversationUpgradeDialogActionClicked] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationUpgradeDialogActionClickedCounter",
			"ConversationUpgradeDialogActionClicked"
		)
	},
	[EventNames.ConversationUpgradeDialogDismissed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationUpgradeDialogDismissedCounter",
			"ConversationUpgradeDialogDismissed"
		)
	},
	[EventNames.ConversationLearnMoreDialogRendered] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationLearnMoreDialogRenderedCounter",
			"ConversationLearnMoreDialogRendered"
		)
	},
	[EventNames.ConversationLearnMoreDialogDismissed] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ConversationLearnMoreDialogDismissedCounter",
			"ConversationLearnMoreDialogDismissed"
		)
	},
	[EventNames.NewConversationCreated] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("NewConversationCreatedCounter", "NewConversationCreated")
	},
	[EventNames.ChatMessageMenuOpened] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString("ChatMessageMenuOpenedCounter", "ChatMessageMenuOpened")
	},
	[EventNames.ChatMessageMenuReplyBtnActivated] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatMessageMenuReplyBtnActivatedCounter",
			"ChatMessageMenuReplyBtnActivated"
		)
	},
	[EventNames.ChatMessageMenuCopyBtnActivated] = {
		type = diagEventTypes.Counter,
		name = game:DefineFastString(
			"ChatMessageMenuCopyBtnActivatedCounter",
			"ChatMessageMenuCopyBtnActivated"
		)
	}
}
