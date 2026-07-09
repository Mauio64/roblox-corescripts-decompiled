local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local enumerate = require(ChallengeDialogParent.enumerate)
local addRawValueMethodToEnum = require(ChallengeDialog.Enum.addRawValueMethodToEnum)
local t1 = {
	DIALOG_STATE_INVALID = 0,
	DIALOG_STATE_PENDING = 1,
	DIALOG_STATE_ACTIVE = 2,
	DIALOG_STATE_APPROVED = 3,
	DIALOG_STATE_DENIED = 4
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
