local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dMc")

local module = require("@luauforge/deferred/gPy")
local module2 = require("@luauforge/deferred/gPB")

local tutils = require(CorePackages.Packages.tutils)

return (React.memo(function(p2)
	local v5 = module(p2)
	return React.createElement(module2, v5)
end, tutils.deepEqual))
