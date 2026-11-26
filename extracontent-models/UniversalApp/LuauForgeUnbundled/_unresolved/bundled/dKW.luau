local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dKX")
local module2 = require("@luauforge/bundled/dKU")

local module3 = require("@luauforge/bundled/dOX")
local module4 = require("@luauforge/bundled/dPn")
local avatarRoute = module2.Reducers.AvatarRoute
local outfitTryOn = module2.Reducers.OutfitTryOn
local module5 = require("@luauforge/bundled/dPq")
local module6 = require("@luauforge/bundled/dPx")
local headRefinementReducer = module.Reducers.HeadRefinementReducer
local profileConfiguration = module2.Reducers.ProfileConfiguration

return Rodux.combineReducers({
	Character = module3,
	TryOn = module4,
	AvatarRoute = avatarRoute,
	OutfitTryOn = outfitTryOn,
	Looks = module5,
	LastSavedTriedOnOutfit = module6,
	HeadRefinement = headRefinementReducer,
	ProfileConfiguration = profileConfiguration
})
