local module = require("@luauforge/bundled/dJi")

local module2 = require("@luauforge/bundled/dJL")

local v5 = {
	DIALOG_STATE_INVALID = 0,
	DIALOG_STATE_PENDING = 1,
	DIALOG_STATE_ACTIVE = 2,
	DIALOG_STATE_APPROVED = 3,
	DIALOG_STATE_DENIED = 4
}

local v6 = module("ChallengeDialogState", v5)

module2(v6, v5)

return v6
