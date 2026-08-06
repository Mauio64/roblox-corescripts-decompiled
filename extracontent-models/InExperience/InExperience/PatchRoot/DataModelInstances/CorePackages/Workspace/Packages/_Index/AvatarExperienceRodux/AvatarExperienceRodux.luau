require(script.Types.RoduxTypes)
require(script.Types.AssetMetadata)
require(script.Types.AssetInfo)
require(script.Types.OutfitTryOn)
require(script.Types.BodyColors)
require(script.Types.HydratedWidgetData)

local Constants = require(script.Constants)
local ReducerUtils = require(script.Utils.ReducerUtils)
local AddAnalyticsMetadata = require(script.Actions.AddAnalyticsMetadata)
local AddSelectedBundleInfo = require(script.Actions.AddSelectedBundleInfo)
local AvatarExperienceLoaded = require(script.Actions.AvatarExperienceLoaded)
local ClearTryOns = require(script.Actions.ClearTryOns)
local DefaultTryOnBodyColorsToggled = require(script.Actions.DefaultTryOnBodyColorsToggled)
local NavigatedToNonTryOnPage = require(script.Actions.NavigatedToNonTryOnPage)
local NavigatedToTryOnPage = require(script.Actions.NavigatedToTryOnPage)
local PlayingSwimAnimation = require(script.Actions.PlayingSwimAnimation)
local ReceivedBundleInfoForTryOn = require(script.Actions.ReceivedBundleInfoForTryOn)
local RemoveFromTryOn = require(script.Actions.RemoveFromTryOn)
local RemoveLook = require(script.Actions.RemoveLook)
local RemoveLookFromTryOn = require(script.Actions.RemoveLookFromTryOn)
local RemoveLookItemsFromTryOn = require(script.Actions.RemoveLookItemsFromTryOn)
local RemoveUnselectedItemsFromTryOn = require(script.Actions.RemoveUnselectedItemsFromTryOn)
local SetAccessoryAdjustments = require(script.Actions.SetAccessoryAdjustments)
local SetAvatarSceneRoute = require(script.Actions.SetAvatarSceneRoute)
local SetEquippedInTryOnManager = require(script.Actions.SetEquippedInTryOnManager)
local SetItemDetailsPeekViewState = require(script.Actions.SetItemDetailsPeekViewState)
local SetItemTryOnPeekViewState = require(script.Actions.SetItemTryOnPeekViewState)
local SetLastToggledLookType = require(script.Actions.SetLastToggledLookType)
local SetOrderForTryOns = require(script.Actions.SetOrderForTryOns)
local SetOutfitTryOns = require(script.Actions.SetOutfitTryOns)
local SetSelectedTimedOption = require(script.Actions.SetSelectedTimedOption)
local SetTryOnManagerPeekViewState = require(script.Actions.SetTryOnManagerPeekViewState)
local SetCurrentCharacter = require(script.Actions.SetCurrentCharacter)
local SetLookDetailsPeekViewSelectedTab = require(script.Actions.SetLookDetailsPeekViewSelectedTab)
local AddSaveDelay = require(script.Actions.AddSaveDelay)
local RemoveSaveDelay = require(script.Actions.RemoveSaveDelay)
local SetCameraButtonStatus = require(script.Actions.SetCameraButtonStatus)
local SetCameraButtonErrorOccurred = require(script.Actions.SetCameraButtonErrorOccurred)
local ApplyProfileConfiguration = require(script.Actions.ApplyProfileConfiguration)
local ToggleTryOn = require(script.Actions.ToggleTryOn)
local TryOnColorUpdated = require(script.Actions.TryOnColorUpdated)
local TryOnLooksOutfit = require(script.Actions.TryOnLooksOutfit)
local TryOnClassicHeadShape = require(script.Actions.TryOnClassicHeadShape)
local CurrentCharacter = require(script.Reducers.CurrentCharacter)
local AnalyticsMetadata = require(script.Reducers.AnalyticsMetadata)
local AvatarExperienceLoaded2 = require(script.Reducers.AvatarExperienceLoaded)
local AvatarRoute = require(script.Reducers.AvatarRoute)
local ItemDetailsPeekView = require(script.Reducers.ItemDetailsPeekView)
local PlayingSwimAnimation2 = require(script.Reducers.PlayingSwimAnimation)
local ShouldDelaySaveManager = require(script.Reducers.ShouldDelaySaveManager)
local CameraButton = require(script.Reducers.CameraButton)
local ProfileConfiguration = require(script.Reducers.ProfileConfiguration)

return {
	Actions = {
		AddAnalyticsMetadata = AddAnalyticsMetadata,
		AddSelectedBundleInfo = AddSelectedBundleInfo,
		AvatarExperienceLoaded = AvatarExperienceLoaded,
		ClearTryOns = ClearTryOns,
		DefaultTryOnBodyColorsToggled = DefaultTryOnBodyColorsToggled,
		NavigatedToNonTryOnPage = NavigatedToNonTryOnPage,
		NavigatedToTryOnPage = NavigatedToTryOnPage,
		PlayingSwimAnimation = PlayingSwimAnimation,
		ReceivedBundleInfoForTryOn = ReceivedBundleInfoForTryOn,
		RemoveFromTryOn = RemoveFromTryOn,
		RemoveLook = RemoveLook,
		RemoveLookFromTryOn = RemoveLookFromTryOn,
		RemoveLookItemsFromTryOn = RemoveLookItemsFromTryOn,
		RemoveUnselectedItemsFromTryOn = RemoveUnselectedItemsFromTryOn,
		SetAccessoryAdjustments = SetAccessoryAdjustments,
		SetAvatarSceneRoute = SetAvatarSceneRoute,
		SetEquippedInTryOnManager = SetEquippedInTryOnManager,
		SetItemDetailsPeekViewState = SetItemDetailsPeekViewState,
		SetItemTryOnPeekViewState = SetItemTryOnPeekViewState,
		SetLastToggledLookType = SetLastToggledLookType,
		SetOrderForTryOns = SetOrderForTryOns,
		SetOutfitTryOns = SetOutfitTryOns,
		SetSelectedTimedOption = SetSelectedTimedOption,
		SetTryOnManagerPeekViewState = SetTryOnManagerPeekViewState,
		SetCurrentCharacter = SetCurrentCharacter,
		SetLookDetailsPeekViewSelectedTab = SetLookDetailsPeekViewSelectedTab,
		AddSaveDelay = AddSaveDelay,
		RemoveSaveDelay = RemoveSaveDelay,
		SetCameraButtonStatus = SetCameraButtonStatus,
		SetCameraButtonErrorOccurred = SetCameraButtonErrorOccurred,
		ApplyProfileConfiguration = ApplyProfileConfiguration,
		ToggleTryOn = ToggleTryOn,
		TryOnColorUpdated = TryOnColorUpdated,
		TryOnClassicHeadShape = TryOnClassicHeadShape,
		TryOnLooksOutfit = TryOnLooksOutfit
	},
	Reducers = {
		CurrentCharacter = CurrentCharacter,
		AnalyticsMetadata = AnalyticsMetadata,
		AvatarExperienceLoaded = AvatarExperienceLoaded2,
		AvatarRoute = AvatarRoute,
		ItemDetailsPeekView = ItemDetailsPeekView,
		PlayingSwimAnimation = PlayingSwimAnimation2,
		ShouldDelaySaveManager = ShouldDelaySaveManager,
		CameraButton = CameraButton,
		ProfileConfiguration = ProfileConfiguration
	},
	Constants = Constants,
	Utils = {
		ReducerUtils = ReducerUtils
	},
	["jest.config"] = script["jest.config"]
}
