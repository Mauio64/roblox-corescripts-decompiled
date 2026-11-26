local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local module = require("@luauforge/bundled/dzP")

return makeActionCreator("RemoveUsersSearchResults", function(p2)
	module.isType(p2, "string", "Actions.RemoveUsersSearchResults.keyword")
	return { searchUuid = p2, keyword = p2 }
end)
