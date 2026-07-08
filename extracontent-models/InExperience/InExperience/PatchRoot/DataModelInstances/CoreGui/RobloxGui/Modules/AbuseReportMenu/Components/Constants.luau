local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

require(AbuseReportMenu.Components.Types)

local t1 = {
	AbuseReportMenuRootName = "AbuseReportMenuNewRoot",
	AbuseReportMenuPlaceholderFrame = "AbuseReportMenuPlaceholderFrame",
	ModalBaseSelectorDialogRootName = "ModalBaseSelectorDialog",
	ReportModes = {
		Classic = "Classic",
		SelectInScene = "SelectInScene"
	},
	ReportTypes = {
		Person = "Person",
		Experience = "Experience"
	},
	PlayerAbuseTypes = {
		Swearing = "Swearing",
		Username = "Inappropriate Username",
		Bullying = "Bullying",
		Scamming = "Scamming",
		Dating = "Dating",
		Cheating = "Cheating/Exploiting",
		Personal = "Personal Question",
		Links = "Offsite Links"
	},
	PlayerVoiceAbuseTypes = {
		Swearing = "Swearing",
		Username = "Inappropriate Username",
		Bullying = "Bullying",
		Scamming = "Scamming",
		Dating = "Dating",
		Cheating = "Cheating/Exploiting",
		Personal = "Personal Question"
	},
	InappropriateContentAbuseReason = "Inappropriate Content",
	AbuseMethods = {
		TextChat = "Text Chat",
		VoiceChat = "Voice Chat",
		Other = "Other",
		Avatar = "Avatar"
	}
}

t1.AbuseMethodToVectorMapping = {
	[t1.AbuseMethods.TextChat] = "chat",
	[t1.AbuseMethods.VoiceChat] = "voice",
	[t1.AbuseMethods.Other] = "other",
	[t1.AbuseMethods.Avatar] = "avatar"
}
t1.AnalyticsAbuseMethods = {
	Chat = "Chat",
	Voice = "Voice",
	Other = "Other",
	Game = "Game"
}
t1.AbuseMethodToAnalyticsMapping = {
	[t1.AbuseMethods.TextChat] = t1.AnalyticsAbuseMethods.Chat,
	[t1.AbuseMethods.VoiceChat] = t1.AnalyticsAbuseMethods.Voice,
	[t1.AbuseMethods.Other] = t1.AnalyticsAbuseMethods.Other,
	[t1.AbuseMethods.Avatar] = t1.AnalyticsAbuseMethods.Other
}
t1.AbuseMethodSublabel = {
	TextChat = "This person typed a mean word in text chat",
	VoiceChat = "This person was screaming on top of their lungs",
	Other = "This person is following me, wearing a bad shirt, etc.",
	Avatar = "This person's avatar is wearing offensive clothing"
}
t1.PlayerMenuActions = {
	UpdateAbuseReason = "UpdateAbuseReason",
	UpdateComment = "UpdateComment",
	UpdateMethodOfAbuse = "UpdateMethodOfAbuse",
	UpdateAbuser = "UpdateAbuser",
	UpdatedSelectedChatAndOrderedMessages = "UpdatedSelectedChatAndOrderedMessages",
	UpdatePlayerNameMap = "UpdatePlayerNameMap",
	SetVoiceEnabled = "SetVoiceEnabled",
	ClearState = "ClearState",
	SetShowModalSelector = "SetShowModalSelector",
	SetMenuOpenTimestamp = "SetMenuOpenTimestamp",
	SetPreselectedPlayer = "SetPreselectedPlayer"
}
t1.ReportAnythingActions = {
	ClearAll = "ClearAll",
	ClearAnnotationFlowProperties = "ClearAnnotationFlowProperties",
	SetScreenshotId = "SetScreenshotId",
	SetScreenshotContentId = "SetScreenshotContentId",
	SetAnnotationPoints = "SetAnnotationPoints",
	SetIdentificationResults = "SetIdentificationResults",
	CompleteAttachment = "CompleteAttachment",
	SetAnnotationAreaDimensions = "SetAnnotationAreaDimensions",
	SetAnnotationCircleRadius = "SetAnnotationCircleRadius",
	SetAnnotationOptionSeen = "SetAnnotationOptionSeen"
}
t1.AnalyticsActions = {
	Reset = "Reset",
	SetMenuOpenedTimestamp = "SetMenuOpenedTimestamp",
	IncrementExperiencePersonChanged = "IncrementExperiencePersonChanged",
	IncrementTypeofabuseChanged = "IncrementTypeofabuseChanged",
	IncrementPersonChanged = "IncrementPersonChanged",
	IncrementReasonChanged = "IncrementReasonChanged",
	IncrementCaptureScene = "IncrementCaptureScene",
	IncrementChatLineChanged = "IncrementChatLineChanged",
	SetMemoryRequirementMet = "SetMemoryRequirementMet",
	SetViewportInformation = "SetViewportInformation",
	SetSubmissionCompleted = "SetSubmissionCompleted",
	SetTypeOfAbuseSelection = "SetTypeOfAbuseSelection",
	SetPreselectedAbuseSelection = "SetPreselectedAbuseSelection",
	SetReasonSelection = "SetReasonSelection",
	SetCommentAdded = "SetCommentAdded",
	SwitchToExperienceInitialSelections = "SwitchToExperienceInitialSelections",
	SwitchToPersonInitialSelections = "SwitchToPersonInitialSelections"
}
t1.ReportSuccessToast = {
	ReportAnythingGeneric = "We’ve received your report and will take action soon if needed. Your feedback helps keep our community safe.",
	ChatGeneric = "Thanks for your report! Our moderators will review the chat logs and evaluate what happened.",
	Cheating = "Thanks for your report! We've recorded your report for evaluation.",
	BadUserName = "Thanks for your report! Our moderators will evaluate the username.",
	Place = "Thanks for your report! Our moderators will review the place and make a determination."
}
t1.localizationKeys = {
	ReportType = "Feature.ReportAbuse.Label.ReportType",
	Person = "Feature.ReportAbuse.Label.Person",
	Experience = "Feature.ReportAbuse.Label.Experience",
	SelectInScene = "Feature.ReportAbuse.Action.SelectInScene",
	BuildAReport = "Feature.ReportAbuse.Action.BuildAReport",
	[t1.AbuseMethods.TextChat] = "Feature.ReportAbuse.Label.TextChat",
	[t1.AbuseMethods.VoiceChat] = "Feature.SettingsHub.MethodOfAbuse.VoiceChat.Title",
	[t1.AbuseMethods.Other] = "Feature.SettingsHub.MethodOfAbuse.Other.Title",
	[t1.AbuseMethods.Avatar] = "Feature.ReportAbuse.Label.Avatar",
	[t1.InappropriateContentAbuseReason] = "Feature.ReportAbuse.Label.Content",
	[t1.PlayerAbuseTypes.Swearing] = "Feature.ReportAbuse.Problem.Swearing",
	[t1.PlayerAbuseTypes.Username] = "Feature.ReportAbuse.ProblemSurface.Username",
	[t1.PlayerAbuseTypes.Bullying] = "Feature.ReportAbuse.Problem.Bullying",
	[t1.PlayerAbuseTypes.Scamming] = "Feature.ReportAbuse.Problem.Scamming",
	[t1.PlayerAbuseTypes.Dating] = "Feature.ReportAbuse.Problem.Dating",
	[t1.PlayerAbuseTypes.Cheating] = "Feature.ReportAbuse.Problem.Cheating",
	[t1.PlayerAbuseTypes.Personal] = "Feature.ReportAbuse.Problem.Personal",
	[t1.PlayerAbuseTypes.Links] = "Feature.ReportAbuse.Problem.Links",
	[t1.PlayerVoiceAbuseTypes.Swearing] = "Feature.ReportAbuse.Problem.Swearing",
	[t1.PlayerVoiceAbuseTypes.Username] = "Feature.ReportAbuse.ProblemSurface.Username",
	[t1.PlayerVoiceAbuseTypes.Bullying] = "Feature.ReportAbuse.Problem.Bullying",
	[t1.PlayerVoiceAbuseTypes.Scamming] = "Feature.ReportAbuse.Problem.Scamming",
	[t1.PlayerVoiceAbuseTypes.Dating] = "Feature.ReportAbuse.Problem.Dating",
	[t1.PlayerVoiceAbuseTypes.Cheating] = "Feature.ReportAbuse.Problem.Cheating",
	[t1.PlayerVoiceAbuseTypes.Personal] = "Feature.ReportAbuse.Problem.Personal",
	ReasonForAbuse = "Feature.SettingsHub.Label.ReasonForAbuse",
	AttachScreenshot = "Feature.SettingsHub.Label.AttachScreenshot",
	SceneCaptured = "Feature.SettingsHub.Label.SceneCaptured",
	CaptureScene = "Feature.SettingsHub.Action.CaptureScene",
	MethodOfAbuse = "Feature.SettingsHub.Label.MethodOfAbuse",
	WhichChat = "Feature.SettingsHub.Label.WhichChatOptional",
	WhichPerson = "Feature.SettingsHub.Label.WhichPlayer",
	ChooseOne = "Feature.SettingsHub.Label.ChooseOne",
	ReportCommentPlaceholder = "Feature.SettingsHub.Label.ReportComment",
	SubmitButton = "Feature.ReportAbuse.Action.Submit",
	FooterInformation1 = "Feature.ReportAbuse.Message.OSACopy1",
	FooterInformation2 = "Feature.ReportAbuse.Message.ReportInformationCopy"
}
t1.InitialIdentificationResults = {
	identifiedAvatars = {},
	identifiedAds = {},
	avatarIDStats = {
		totalPlayers = 0,
		checkedPlayers = 0,
		duration = 0
	},
	adIDStats = {
		totalPlayers = 0,
		checkedPlayers = 0,
		duration = 0
	}
}
t1.ReportAnythingInitialState = {
	screenshotId = "",
	screenshotContentId = "",
	attachCompleted = false,
	identificationResults = t1.InitialIdentificationResults,
	annotationPoints = {}
}
t1.AnalyticsInitialState = {
	menuEverShown = false,
	menuOpenedUnixTimestampMilliseconds = 0,
	experiencePersonChangeCount = 0,
	typeofabuseChangeCount = 0,
	personChangeCount = 0,
	reasonChangeCount = 0,
	captureSceneCount = 0,
	chatLineChangeCount = 0,
	viewportSizeX = -1,
	viewportSizeY = -1,
	isPortraitMode = false,
	isSubmissionCompleted = false,
	typeofabuseSelection = nil,
	reasonSelection = nil,
	commentAdded = false,
	experiencePersonSelection = nil,
	memoryRequirementMet = -1
}
t1.AnalyticsPersonInitialSelections = {
	typeofabuseSelection = nil,
	reasonSelection = nil,
	commentAdded = false,
	experiencePersonSelection = string.lower(t1.ReportTypes.Person)
}
t1.AnalyticsExpeirenceInitialSelections = {
	commentAdded = false,
	typeofabuseSelection = t1.AnalyticsAbuseMethods.Game,
	reasonSelection = t1.InappropriateContentAbuseReason,
	experiencePersonSelection = string.lower(t1.ReportTypes.Experience)
}
t1.AbuseVector = {
	Voice = "voice"
}
t1.MenuItemHeight = 42
t1.MenuItemHeightTight = 36
t1.FreeCommentsMenuItemHeight = 60
t1.FieldLabelSize = 18
t1.LeftContainerWidth = 240
t1.RightContainerWidth = 300
t1.MenuItemDynamicWidthOffset = 100
t1.FieldLabelSizeSmall = 16
t1.LeftContainerWidthSmall = 100
t1.RightContainerWidthSmall = 180
t1.SmallLayoutThreshold = 540
t1.ReportMenuFontStyle = "Header1"
t1.ReportMenuButtonSize = 36
t1.ReportMenuButtonSizeConsole = 48
t1.InitPersonUIState = {
	comment = "",
	menuContainerWidth = 0,
	allegedAbuserId = nil,
	allegedAbuser = nil,
	abuseReason = nil,
	methodOfAbuse = nil,
	isVoiceEnabled = nil,
	menuOpenedUnixTimestampMilliseconds = nil,
	modalSelectorCellData = nil,
	isModalSelectorShown = nil,
	preselectedPlayer = nil,
	selectedMessage = nil,
	reportType = t1.ReportTypes.Person,
	playerObjects = {},
	orderedMessages = {}
}
t1.InitExperienceUIState = {
	comment = "",
	menuContainerWidth = 0,
	reportType = t1.ReportTypes.Experience,
	abuseReason = t1.InappropriateContentAbuseReason
}
t1.ChatLineReportingVariant = {
	IGM_CLRv1 = "IGM_CLRv1"
}

return t1
