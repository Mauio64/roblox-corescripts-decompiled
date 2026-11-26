local v5 = { PushUpsellHome = "homePushUpsell", PushUpsellChat = "chatPushUpsell" }

return {
	ModalKey = v5,
	LocalStorageKeys = {
		PromptShownCount = "PushUpsellPromptShownCount",
		ChatPromptShownCount = "PushUpsellChatPromptShownCount",
		SysPromptShownTimestamp = "PushUpsellSysPromptShownTimestamp",
		EduPromptResponseTimestamp = "PushUpsellEduPromptResponseTimestamp",
		EduPromptResponse = "PushUpsellEduPromptResponse"
	},
	TranslationKeys = {
		[v5.PushUpsellHome] = {
			CancelAction = "Feature.Notifications.Action.PushUpsellNotNow",
			ConfirmAction = "Feature.Notifications.Action.PushUpsellAllow",
			Heading = "Feature.Notifications.Heading.PushUpsellGeneric",
			Body = "Feature.Notifications.Label.PushUpsellGeneric",
			SomethingWentWrong = "Feature.Call.Error.Description.Generic"
		},
		[v5.PushUpsellChat] = {
			CancelAction = "Feature.Notifications.Action.PushUpsellNotNow",
			ConfirmAction = "Feature.Notifications.Action.PushUpsellAllow",
			Heading = "Feature.Notifications.Heading.PushUpsellChat",
			Body = "Feature.Notifications.Label.PushUpsellChat",
			SomethingWentWrong = "Feature.Call.Error.Description.Generic"
		}
	}
}
