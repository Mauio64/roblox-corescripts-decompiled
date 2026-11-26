local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/ehB")

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose))

	return module3({
		name = module2.GenericWebPage,
		detail = string.format("%susers/friends#!/friend-requests", module.BASE_URL),
		extraProps = {
			titleKey = "CommonUI.Features.Label.Friends",
			onClose = onClose,
			searchParams = { searchType = "Players" }
		}
	})
end
