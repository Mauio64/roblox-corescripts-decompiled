local module = require("@luauforge/deferred/gOn")
local module2 = require("@luauforge/deferred/gOl")

return (module.buildFormValidator({
	module.Validators.isNotNull,
	module.Validators.String.buildIsShorterThanOrEqualTo(module2.MAX_NAME_LENGTH),
	module.Validators.String.isNotWhitespace
}))
