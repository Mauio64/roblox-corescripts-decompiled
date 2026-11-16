local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dNO")
local module2 = require("@luauforge/bundled/dNR")
local module3 = require("@luauforge/bundled/dNT")
local module4 = require("@luauforge/bundled/dNV")
local module5 = require("@luauforge/bundled/dNX")
local module6 = require("@luauforge/bundled/dOw")
local module7 = require("@luauforge/bundled/dOM")
require("@luauforge/bundled/dMc")

return Rodux.combineReducers({
	AvatarType = module,
	AvatarScales = module2,
	BodyColor3s = module4,
	BodyPartRangeIds = module3,
	EquippedAssets = module6,
	OwnedItemIdsBySubtype = module5,
	OutfitOrAsset = module7
})
