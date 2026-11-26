local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dKU")

local module2 = require("@luauforge/bundled/dPL")
local module3 = require("@luauforge/bundled/dQu")
local module4 = require("@luauforge/bundled/dQA")
local module5 = require("@luauforge/bundled/dQP")
local itemDetailsPeekView = module.Reducers.ItemDetailsPeekView
local avatarExperienceLoaded = module.Reducers.AvatarExperienceLoaded
local module6 = require("@luauforge/bundled/dQR")
local module7 = require("@luauforge/bundled/dQT")
local module8 = require("@luauforge/bundled/dQU")
require("@luauforge/bundled/dPs")

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
