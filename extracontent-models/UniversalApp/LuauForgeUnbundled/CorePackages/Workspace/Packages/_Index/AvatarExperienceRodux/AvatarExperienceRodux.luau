require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/RoduxTypes")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/AssetMetadata")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/AssetInfo")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/OutfitTryOn")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/BodyColors")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/HydratedWidgetData")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/AXCommonState")

local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Constants")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Utils/ReducerUtils")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddAnalyticsMetadata")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddSelectedBundleInfo")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AvatarExperienceLoaded")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ClearTryOns")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/DefaultTryOnBodyColorsToggled")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/NavigatedToNonTryOnPage")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/NavigatedToTryOnPage")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/PlayingSwimAnimation")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ReceivedBundleInfoForTryOn")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveFromTryOn")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLook")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLookFromTryOn")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveLookItemsFromTryOn")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveUnselectedItemsFromTryOn")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetAccessoryAdjustments")
local module18 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetAnimationPreview")
local module19 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetAvatarSceneRoute")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetBackgroundPreview")
local module21 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetSpawnEffectPreview")
local module22 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetEquippedInTryOnManager")
local module23 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetFullView")
local module24 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetItemDetailsPeekViewState")
local module25 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetItemTryOnPeekViewState")
local module26 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetLastToggledLookType")
local module27 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetOrderForTryOns")
local module28 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetOutfitTryOns")
local module29 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetSelectedTimedOption")
local module30 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetTryOnManagerPeekViewState")
local module31 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCurrentCharacter")
local module32 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetLookDetailsPeekViewSelectedTab")
local module33 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/AddSaveDelay")
local module34 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/RemoveSaveDelay")
local module35 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCameraButtonStatus")
local module36 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetCameraButtonErrorOccurred")
local module37 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ApplyProfileConfiguration")
local module38 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/ToggleTryOn")
local module39 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnColorUpdated")
local module40 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnLooksOutfit")
local module41 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/TryOnClassicHeadShape")
local module42 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Actions/SetSpecialFeaturesFilter")

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local module43 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/CurrentCharacter")
local module44 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/AnalyticsMetadata")
local module45 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/AvatarExperienceLoaded")
local module46 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/AvatarRoute")
local module47 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/ItemDetailsPeekView")
local module48 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/PlayingSwimAnimation")
local module49 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/ShouldDelaySaveManager")
local module50 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/CameraButton")
local module51 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/ProfileConfiguration")
local module52 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Reducers/OutfitTryOn")

if not fFlagAXCatalogSpecialFeaturesFilter then
	module42 = nil
end

return {
	Actions = {
		AddAnalyticsMetadata = module3,
		AddSelectedBundleInfo = module4,
		AvatarExperienceLoaded = module5,
		ClearTryOns = module6,
		DefaultTryOnBodyColorsToggled = module7,
		NavigatedToNonTryOnPage = module8,
		NavigatedToTryOnPage = module9,
		PlayingSwimAnimation = module10,
		ReceivedBundleInfoForTryOn = module11,
		RemoveFromTryOn = module12,
		RemoveLook = module13,
		RemoveLookFromTryOn = module14,
		RemoveLookItemsFromTryOn = module15,
		RemoveUnselectedItemsFromTryOn = module16,
		SetAccessoryAdjustments = module17,
		SetAnimationPreview = module18,
		SetAvatarSceneRoute = module19,
		SetBackgroundPreview = module20,
		SetSpawnEffectPreview = module21,
		SetEquippedInTryOnManager = module22,
		SetFullView = module23,
		SetItemDetailsPeekViewState = module24,
		SetItemTryOnPeekViewState = module25,
		SetLastToggledLookType = module26,
		SetOrderForTryOns = module27,
		SetOutfitTryOns = module28,
		SetSelectedTimedOption = module29,
		SetTryOnManagerPeekViewState = module30,
		SetCurrentCharacter = module31,
		SetLookDetailsPeekViewSelectedTab = module32,
		AddSaveDelay = module33,
		RemoveSaveDelay = module34,
		SetCameraButtonStatus = module35,
		SetCameraButtonErrorOccurred = module36,
		ApplyProfileConfiguration = module37,
		ToggleTryOn = module38,
		TryOnColorUpdated = module39,
		TryOnClassicHeadShape = module41,
		TryOnLooksOutfit = module40,
		SetSpecialFeaturesFilter = module42
	},
	Reducers = {
		CurrentCharacter = module43,
		AnalyticsMetadata = module44,
		AvatarExperienceLoaded = module45,
		AvatarRoute = module46,
		ItemDetailsPeekView = module47,
		PlayingSwimAnimation = module48,
		ShouldDelaySaveManager = module49,
		CameraButton = module50,
		ProfileConfiguration = module51,
		OutfitTryOn = module52
	},
	Constants = module,
	Utils = { ReducerUtils = module2 }
}
