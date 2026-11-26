local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dRe")
local module2 = require("@luauforge/bundled/dRh")
local module3 = require("@luauforge/bundled/dRj")
local module4 = require("@luauforge/bundled/dRl")
local module5 = require("@luauforge/bundled/dRn")
local module6 = require("@luauforge/bundled/dRM")
local module7 = require("@luauforge/bundled/dSc")
require("@luauforge/bundled/dPs")

return Rodux.combineReducers({
	AvatarType = module,
	AvatarScales = module2,
	BodyColor3s = module4,
	BodyPartRangeIds = module3,
	EquippedAssets = module6,
	OwnedItemIdsBySubtype = module5,
	OutfitOrAsset = module7
})
