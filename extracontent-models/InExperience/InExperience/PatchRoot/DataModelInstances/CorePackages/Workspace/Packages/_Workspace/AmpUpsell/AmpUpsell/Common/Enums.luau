local t1 = {
	Phone = "Phone",
	GovernmentId = "GovernmentId",
	Email = "Email",
	AddedEmail = "AddedEmail",
	ParentConsent = "ParentConsent",
	ParentLink = "ParentLink",
	AgeEstimation = "AgeEstimation",
	Subscription = "Subscription",
	CardVerification = "CardVerification",
	Wait = "Wait",
	UserAgreement = "UserAgreement",
	UserSettings = "UserSettings",
	Invalid = "Invalid"
}
local t2 = {
	Granted = "Granted",
	Denied = "Denied",
	Actionable = "Actionable",
	Pending = "Pending",
	Error = "Error"
}
local t3 = {
	Success = "Success",
	Failure = "Failure",
	Cancelled = "Cancelled",
	Unknown = "Unknown",
	RetryRequested = "RetryRequested"
}
local t4 = {
	AllowFacialAgeEstimation = "allowFacialAgeEstimation"
}
local t5 = {
	ChargebackReenableAccount = "ChargebackReenableAccount",
	SavePaymentMethods = "SavePaymentMethods",
	UpdateUserSetting = "UpdateUserSetting",
	UpdateBirthdate = "UpdateBirthdate",
	LinkToChild = "LinkToChild",
	ManageFriend = "ManageFriend",
	ManageExperience = "ManageExperience",
	LiftPunishment = "LiftPunishment",
	AddTrustedConnection = "AddTrustedConnection",
	SendTransfer = "SendTransfer",
	ReceiveTransfer = "ReceiveTransfer",
	LiftRestriction = "LiftRestriction",
	Unknown = "Unknown"
}
local t6 = {
	ConnectedMobile = 1,
	Verified = 2,
	GotResults = 3,
	UpdatedRobloxProfile = 4
}
local t7 = {
	Error = 1,
	RequestSent = 2,
	AlreadyLinkedSendRequest = 3,
	NewParentCollectEmail = 4,
	NewParentSendRequest = 5,
	NewParentLoading = 6
}
local t8 = {
	InternalVPCError = "InternalVPCError",
	InvalidEmail = "InvalidEmail",
	Flooded = "Flooded",
	ReceiverFlooded = "ReceiverFlooded",
	SenderFlooded = "SenderFlooded",
	BadUserInput = "BadUserInput",
	UserStateRecoursePathMismatch = "UserStateRecoursePathMismatch",
	SenderFloodedRequestCreated = "SenderFloodedRequestCreated",
	GenericError = "GenericError",
	ConflictingPendingConsent = "ConflictingPendingConsent"
}
local t9 = {
	RetryVPC = "RetryVPC",
	RetryAMP = "RetryAMP",
	NoRetry = "NoRetry",
	Success = "Success"
}
local t10 = {
	InvalidEmailAddress = "InvalidEmailAddress",
	EmailNotUnique = "EmailNotUnique",
	LinkingIneligible = "LinkingIneligible",
	ParentAtLinkLimit = "ParentAtLinkLimit",
	SenderFlooded = "SenderFlooded",
	ReceiverFlooded = "ReceiverFlooded",
	InvalidParameter = "InvalidParameter",
	UpdateUserSettingRequestInvalid = "UpdateUserSettingRequestInvalid",
	AlreadyLinked = "AlreadyLinked",
	ChildAtLinkLimit = "ChildAtLinkLimit",
	NoLinkedParents = "NoLinkedParents",
	SenderFloodedRequestCreated = "SenderFloodedRequestCreated",
	Unknown = "Unknown",
	ServiceUnavailable = "ServiceUnavailable",
	IllegalState = "IllegalState",
	InvalidUserID = "InvalidUserID",
	ConsentAlreadyApplied = "ConsentAlreadyApplied",
	ConsentAlreadyRequestedConflictingData = "ConsentAlreadyRequestedConflictingData",
	ReceiverNotWhitelisted = "ReceiverNotWhitelisted",
	InvalidComplianceFeature = "InvalidComplianceFeature",
	ChildTooOld = "ChildTooOld",
	UserForgotten = "UserForgotten",
	UnsupportedNotificationType = "UnsupportedNotificationType",
	UnsupportedRequestType = "UnsupportedRequestType",
	ChildIneligibleForConsent = "ChildIneligibleForConsent"
}

return {
	ActionTypeEnum = t1,
	AccessResponseEnum = t2,
	ActionStatusEnum = t3,
	VPCRequestTypeEnum = t5,
	IDVStep = t6,
	VPCStepEnum = t7,
	VPCErrorCategoriesEnum = t8,
	VPCRetryBehaviorEnum = t9,
	UserSettingsSettingNameEnum = t4,
	VPCErrorCodesEnum = t10
}
