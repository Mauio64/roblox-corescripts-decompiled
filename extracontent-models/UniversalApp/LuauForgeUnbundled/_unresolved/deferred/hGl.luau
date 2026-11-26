local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/fzK")
local module3 = require("@luauforge/bundled/ehB")

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose))
	return module3({
		name = module.GenericWebPage,
		detail = module2.static.friends(),
		extraProps = {
			titleKey = "CommonUI.Features.Label.Friends",
			onClose = onClose,
			searchParams = { searchType = "Players" }
		}
	})
end
