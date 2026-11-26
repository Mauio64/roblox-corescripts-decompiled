local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/dzO")
local module3 = require("@luauforge/bundled/fzK")
local module4 = require("@luauforge/bundled/ehB")

return function(onClose)
	module2.isTypeOrNil(onClose, "function", "onClose")

	return module4({
		name = module.SettingsSubPage,
		detail = module3.static.settings.security(),
		extraProps = {
			titleKey = "Feature.AccountSettings.Heading.Tab.Security",
			onClose = onClose
		}
	})
end
