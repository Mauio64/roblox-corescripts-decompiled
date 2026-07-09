local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local enumerate = require(Parent.enumerate)
local t1 = {
	ChallengeDialogApproval = "CHALLENGE_DIALOG_APPROVAL",
	ChallengeDialogDenied = "CHALLENGE_DIALOG_DENIED",
	ChallengeDialogExpired = "CHALLENGE_DIALOG_EXPIRED",
	ChallengeDialogAlreadyCompleted = "CHALLENGE_DIALOG_ALREADY_COMPLETED"
}

return (enumerate(script.Name, t1))
