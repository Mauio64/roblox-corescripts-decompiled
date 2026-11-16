local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")

return function(p2, onClose)
	assert(t.string(p2))
	assert(t.callback(onClose) or t.none(onClose))

	return module2({
		name = module.SdkShare,
		extraProps = { context = "AddFriendsTile", userId = p2, onClose = onClose }
	})
end
