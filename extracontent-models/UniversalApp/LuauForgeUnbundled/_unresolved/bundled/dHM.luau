local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dHN")
local module2 = require("@luauforge/bundled/dMj")
local module3 = require("@luauforge/bundled/dMu")

local module4 = require("@luauforge/bundled/dHL")
local analyticsMetadata = module4.Reducers.AnalyticsMetadata
local module5 = require("@luauforge/bundled/dNM")
local module6 = require("@luauforge/bundled/dPz")
local module7 = require("@luauforge/bundled/dSZ")
local module8 = require("@luauforge/bundled/dTp")
local module9 = require("@luauforge/bundled/dTr")
local module10 = require("@luauforge/bundled/dTx")
local cameraButton = module4.Reducers.CameraButton

return Rodux.combineReducers({
	AnalyticsMetadata = analyticsMetadata,
	AvatarEditor = module5,
	Catalog = module6,
	ProfilePictureEditor = module7,
	Common = module3,
	AvatarScene = module,
	ExternalNavigationRequest = module2,
	AvatarAutocompleteSuggestions = module8,
	AccessoryAdjustment = module9,
	LayeredClothingSort = module10,
	CameraButton = cameraButton
})
