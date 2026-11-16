local formatted = `{require("@luauforge/deferred/ehn").UrlBase.APIS}/school-verification-api/v1/school-verification`

return {
	email = `{formatted}/email`,
	next = `{formatted}/next`,
	emailOtp = `{formatted}/email/otp`,
	otpResend = `{formatted}/otp/resend`,
	school = `{formatted}/school?includeRewardInfo=true`,
	roles = `{formatted}/roles`,
	members = `{formatted}/members`,
	leave = `{formatted}/leave`,
	shareLink = `{formatted}/share-link`,
	recordAttempt = `{formatted}/record-attempt`,
	inviteCandidates = `{formatted}/invite-candidates`,
	invite = `{formatted}/invite`
}
