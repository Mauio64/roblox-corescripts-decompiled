local module = require("@luauforge/bundled/dGd")

local module2 = require("@luauforge/bundled/dGG")

local v5 = { Approve = 1, Deny = 2 }

local v6 = module("ChallengeDialogAction", v5)

module2(v6, v5)

return v6
