local module = require("@luauforge/bundled/dAJ")
local module2 = require("@luauforge/bundled/dAL")
local module3 = require("@luauforge/bundled/dAN")
local module4 = require("@luauforge/bundled/dAP")
local module5 = require("@luauforge/bundled/dAR")
local module6 = require("@luauforge/bundled/dAT")
local module7 = require("@luauforge/bundled/dAU")

return function(options, p2)
	local v5 = p2.type == module6.name and {} or options or {}

	return {
		SignUpBirthday = module4(v5.SignUpBirthday, p2),
		SignUpUsername = module(v5.SignUpUsername, p2),
		SignUpPassword = module2(v5.SignUpPassword, p2),
		SignUpSelectedBundleId = module5(v5.SignUpSelectedBundleId, p2),
		SignUpBundles = module3(v5.SignUpBundles, p2),
		HumanoidDescriptionProperties = module7(v5.HumanoidDescriptionProperties, p2)
	}
end
