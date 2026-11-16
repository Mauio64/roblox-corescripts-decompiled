local module = require("@luauforge/deferred/ejR")
local activityTile = require("@luauforge/deferred/ejX").ActivityTile

local module2 = require("@luauforge/deferred/ekK")

local function BadgeAwardedTile(p2)
	local v5 = module2(p2)
	return module.createElement(activityTile, v5)
end

return BadgeAwardedTile
