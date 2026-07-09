local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local enumerate = require(ChallengeDialogParent.enumerate)
local addRawValueMethodToEnum = require(ChallengeDialog.Enum.addRawValueMethodToEnum)
local t1 = {
	Approve = 1,
	Deny = 2
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
