local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dKW")
local module2 = require("@luauforge/bundled/dPz")
local module3 = require("@luauforge/bundled/dPK")

local module4 = require("@luauforge/bundled/dKU")
local analyticsMetadata = module4.Reducers.AnalyticsMetadata
local module5 = require("@luauforge/bundled/dRc")
local module6 = require("@luauforge/bundled/dSP")
local module7 = require("@luauforge/bundled/dWu")
local module8 = require("@luauforge/bundled/dWK")
local module9 = require("@luauforge/bundled/dWM")
local module10 = require("@luauforge/bundled/dWS")
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
