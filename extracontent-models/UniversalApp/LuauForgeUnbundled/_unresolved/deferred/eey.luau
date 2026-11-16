local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/dCp")
local module3 = require("@luauforge/bundled/eee")

return function(onClose)
	assert(t.callback(onClose) or t.none(onClose))

	return module3({
		name = module2.GenericWebPage,
		detail = string.format("%susers/friends#!/friend-requests", Url.BASE_URL),
		extraProps = {
			titleKey = "CommonUI.Features.Label.Friends",
			onClose = onClose,
			searchParams = { searchType = "Players" }
		}
	})
end
