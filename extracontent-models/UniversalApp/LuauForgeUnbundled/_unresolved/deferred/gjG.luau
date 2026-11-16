local module = require("@luauforge/deferred/gjH")
local module2 = require("@luauforge/deferred/gjF")

return (module.buildFormValidator({
	module.Validators.isNotNull,
	module.Validators.String.buildIsShorterThanOrEqualTo(module2.MAX_NAME_LENGTH),
	module.Validators.String.isNotWhitespace
}))
