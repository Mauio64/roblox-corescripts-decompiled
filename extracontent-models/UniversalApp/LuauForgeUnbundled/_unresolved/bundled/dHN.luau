local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dHO")
local module2 = require("@luauforge/bundled/dHL")

local module3 = require("@luauforge/bundled/dLH")
local module4 = require("@luauforge/bundled/dLX")
local avatarRoute = module2.Reducers.AvatarRoute
local outfitTryOn = module2.Reducers.OutfitTryOn
local module5 = require("@luauforge/bundled/dMa")
local module6 = require("@luauforge/bundled/dMh")
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
