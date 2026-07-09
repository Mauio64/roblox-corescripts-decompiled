local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local enumerate = require(ChallengeDialogParent.enumerate)
local addRawValueMethodToEnum = require(ChallengeDialog.Enum.addRawValueMethodToEnum)
local t1 = {
	DIALOG_TYPE_INVALID = 0,
	DIALOG_TYPE_APPROVAL_2SV_LOGIN = 1,
	DIALOG_TYPE_APPROVAL_2SV_GENERIC = 2
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
