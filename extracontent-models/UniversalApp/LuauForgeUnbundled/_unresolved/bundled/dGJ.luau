local module = require("@luauforge/bundled/dGd")

local module2 = require("@luauforge/bundled/dGG")

local v5 = {
	DIALOG_TYPE_INVALID = 0,
	DIALOG_TYPE_APPROVAL_2SV_LOGIN = 1,
	DIALOG_TYPE_APPROVAL_2SV_GENERIC = 2
}

local v6 = module("ChallengeDialogType", v5)

module2(v6, v5)

return v6
