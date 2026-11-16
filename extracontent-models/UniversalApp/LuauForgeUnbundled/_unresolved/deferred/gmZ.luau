local fFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXOutfitPageRevamp

local module = require("@luauforge/deferred/gfb")

local module2 = require("@luauforge/deferred/gmV")

local module3 = require("@luauforge/deferred/gna")
local module4 = require("@luauforge/deferred/gni")

if fFlagAXOutfitPageRevamp then
	return module2(module(module4))
end

return module2(module3)
