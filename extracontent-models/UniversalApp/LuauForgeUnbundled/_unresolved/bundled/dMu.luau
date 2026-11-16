local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dHL")

local module2 = require("@luauforge/bundled/dMv")
local module3 = require("@luauforge/bundled/dNe")
local module4 = require("@luauforge/bundled/dNk")
local module5 = require("@luauforge/bundled/dNz")
local itemDetailsPeekView = module.Reducers.ItemDetailsPeekView
local avatarExperienceLoaded = module.Reducers.AvatarExperienceLoaded
local module6 = require("@luauforge/bundled/dNB")
local module7 = require("@luauforge/bundled/dND")
local module8 = require("@luauforge/bundled/dNE")
require("@luauforge/bundled/dMc")

return Rodux.combineReducers({
	AssetInfos = module2,
	BundleInfos = module3,
	Collectibles = module4,
	ItemDetailsExpanded = module5,
	ItemDetailsPeekView = itemDetailsPeekView,
	AvatarExperienceLoaded = avatarExperienceLoaded,
	PlayEmoteInBackground = module6,
	FullView = module7,
	Widgets = module8
})
