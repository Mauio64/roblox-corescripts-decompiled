local module = require("@luauforge/bundled/dEQ")
local module2 = require("@luauforge/bundled/dEV")

return function()
	return module.combineReducers({ ExperienceCommunityLinks = module2 })
end
