local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/dwL")
local module3 = require("@luauforge/bundled/fsq")
local module4 = require("@luauforge/bundled/eee")

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
