local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dPs")

local module = require("@luauforge/deferred/hbB")
local module2 = require("@luauforge/deferred/hbE")

local tutils = require(CorePackages.Packages.tutils)

return (React.memo(function(p2)
	local v5 = module(p2)
	return React.createElement(module2, v5)
end, tutils.deepEqual))
