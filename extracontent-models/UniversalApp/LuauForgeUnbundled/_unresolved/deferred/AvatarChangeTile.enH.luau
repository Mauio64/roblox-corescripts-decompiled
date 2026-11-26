local module = require("@luauforge/deferred/enn")
local activityTile = require("@luauforge/deferred/ent").ActivityTile

local module2 = require("@luauforge/deferred/enI")

local function AvatarChangeTile(p2)
	local v5 = module2(p2)
	return module.createElement(activityTile, v5)
end

return AvatarChangeTile
