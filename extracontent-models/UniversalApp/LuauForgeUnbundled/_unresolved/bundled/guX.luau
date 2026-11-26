local module = require("@luauforge/bundled/guY")
return require("@luauforge/bundled/guZ").makeActionCreator("SetModerationStatus", function(p2)
	module.isType(p2, "boolean", "SetModerationStatus action expects `moderationStatus` to be a boolean")

	return { userModerated = p2 }
end)
