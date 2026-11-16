local module = require("@luauforge/bundled/dBL")
local module2 = require("@luauforge/bundled/dBQ")

return function()
	return module.combineReducers({ ExperienceCommunityLinks = module2 })
end
