require("@luauforge/deferred/ekr")

return {
	SchoolEntryTooltipVariant = {
		FeatureAvailable = "FeatureAvailable",
		SchoolIsLive = "SchoolIsLive"
	},
	SchoolWaitlistVariant = { School = "School", Alumni = "Alumni" },
	FriendshipOriginSourceType = { SchoolMemberList = "SchoolMemberList" },
	SchoolStatus = { Active = "Active", Inactive = "Inactive", Locked = "Locked" },
	VerifyErrorKind = {
		AlreadyLinked = "AlreadyLinked",
		NotSchoolEmail = "NotSchoolEmail",
		SchoolNotAvailable = "SchoolNotAvailable",
		OtpMismatch = "OtpMismatch",
		OtpExpired = "OtpExpired",
		OtpInvalidFormat = "OtpInvalidFormat",
		OtpAlreadyUsed = "OtpAlreadyUsed",
		OtpTooManyAttempts = "OtpTooManyAttempts",
		Network = "Network",
		Unknown = "Unknown"
	},
	InviteSendStatus = { Sending = "Sending", Sent = "Sent" },
	InviteRowStatus = { Invite = "Invite", Sending = "Sending", Invited = "Invited" }
}
