local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local module = require("@luauforge/bundled/dzP")

return makeActionCreator("AddFriendStatus", function(p2, p3)
	module.isType(p2, "string", "Actions.AddFriendStatus.id")
	module.isType(p3, "EnumItem", "Actions.AddFriendStatus.status")

	return { id = p2, status = p3 }
end)
