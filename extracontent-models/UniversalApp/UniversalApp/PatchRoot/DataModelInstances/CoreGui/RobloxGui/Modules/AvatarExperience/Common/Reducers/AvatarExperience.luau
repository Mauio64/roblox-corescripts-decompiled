local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarScene = require(Modules.AvatarExperience.Common.Reducers.AvatarScene)
local ExternalNavigationRequest = require(Modules.AvatarExperience.Common.Reducers.ExternalNavigationRequest)
local Common = require(Modules.AvatarExperience.Common.Reducers.Common)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local AnalyticsMetadata = AvatarExperienceRodux.Reducers.AnalyticsMetadata
local AvatarEditor = require(Modules.AvatarExperience.AvatarEditor.Reducers.AvatarEditor)
local Catalog = require(Modules.AvatarExperience.Catalog.Reducers.Catalog)
local ProfilePictureEditor = require(Modules.AvatarExperience.ProfilePictureEditor.Reducers.ProfilePictureEditor)
local AvatarAutocompleteSuggestions = require(Modules.AvatarExperience.Catalog.Reducers.AvatarAutocompleteSuggestions)
local AccessoryAdjustment = require(Modules.AvatarExperience.AccessoryAdjustment.Reducers.AccessoryAdjustment)
local LayeredClothingSort = require(Modules.AvatarExperience.LayeredClothingSort.Reducers.LayeredClothingSort)
local CameraButton = AvatarExperienceRodux.Reducers.CameraButton

return Rodux.combineReducers({
	AnalyticsMetadata = AnalyticsMetadata,
	AvatarEditor = AvatarEditor,
	Catalog = Catalog,
	ProfilePictureEditor = ProfilePictureEditor,
	Common = Common,
	AvatarScene = AvatarScene,
	ExternalNavigationRequest = ExternalNavigationRequest,
	AvatarAutocompleteSuggestions = AvatarAutocompleteSuggestions,
	AccessoryAdjustment = AccessoryAdjustment,
	LayeredClothingSort = LayeredClothingSort,
	CameraButton = CameraButton
})
