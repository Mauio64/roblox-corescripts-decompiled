local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local FFlagAXExportTimedOptionsConstant = require(Parent.AvatarExperienceFlags).FFlagAXExportTimedOptionsConstant
local t1 = {
	AXEquipAsset = "AXEquipAsset",
	AXUnequipAsset = "AXUnequipAsset",
	AXCreateCostume = "AXCreateCostume",
	AXCreateMakeupLook = "AXCreateMakeupLook",
	AXColorPickerChanged = "AXColorPickerChanged",
	AXCameraEnabled = "AXCameraEnabled",
	AXCameraDisabled = "AXCameraDisabled",
	AXUpdateProfilePicture = "AXUpdateProfilePicture",
	AXPurchaseAsset = "AXPurchaseAsset",
	AXPurchaseBundle = "AXPurchaseBundle",
	CatalogPurchaseShownEnableTwoStepAuth = "CatalogPurchaseShownEnableTwoStepAuth",
	CatalogPurchaseShownTwoStepAuth = "CatalogPurchaseShownTwoStepAuth",
	CatalogPurchaseFailedShowTwoStepAuth = "CatalogPurchaseFailedShowTwoStepAuth",
	CatalogPurchaseCompletedTwoStepAuth = "CatalogPurchaseCompletedTwoStepAuth",
	CatalogPurchaseInvalidatedTwoStepAuth = "CatalogPurchaseInvalidatedTwoStepAuth",
	CatalogPurchaseAbandonedTwoStepAuth = "CatalogPurchaseAbandonedTwoStepAuth",
	CatalogPurchaseLoadFailedTwoStepAuth = "CatalogPurchaseLoadFailedTwoStepAuth"
}
local t2 = {
	GetRecommendedAssets = "AvatarEditorServiceGetRecommendedAssetsError",
	GetOutfits = "AvatarEditorServiceGetOutfitsError",
	CreateOutfit = "AvatarEditorServiceCreateOutfitError",
	GetAvatarRules = "AvatarEditorServiceGetAvatarRulesError",
	GetInventory = "AvatarEditorServiceGetInventoryError",
	SearchCatalog = "AvatarEditorServiceSearchCatalogError",
	GetBatchItemDetails = "AvatarEditorServiceGetBatchItemDetailsError",
	GetRecommendedBundles = "AvatarEditorServiceGetRecommendedBundlesError",
	NoPromptSetFavorite = "AvatarEditorServiceNoPromptSetFavoriteError",
	NoPromptSaveAvatarThumbnailCustomization = "AvatarEditorServiceNoPromptSaveAvatarThumbnailCustomizationError",
	NoPromptCreateOutfit = "AvatarEditorServiceNoPromptCreateOutfitError",
	GetOutfitDetails = "AvatarEditorServiceGetOutfitDetailsError",
	FetchAssetOrBundleInfo = "AvatarEditorServiceFetchAssetOrBundleInfoError",
	FetchBundleInfo = "AvatarEditorServiceFetchBundleInfoError",
	GetAssetFavorite = "AvatarEditorServiceGetAssetFavoriteError",
	GetBundleFavorite = "AvatarEditorServiceGetBundleFavoriteError",
	SetBundleFavorite = "AvatarEditorServiceSetBundleFavoriteError",
	SetAssetFavorite = "AvatarEditorServiceSetAssetFavoriteError",
	ConformToAvatarRules = "AvatarEditorServiceConformToAvatarRulesError",
	NoPromptSaveAvatar = "AvatarEditorServiceNoPromptSaveAvatarError",
	PromptSaveAvatarCompleted = "AvatarEditorServicePromptSaveAvatarCompletedError",
	NoPromptApplyProfileConfiguration = "AvatarEditorServiceNoPromptApplyProfileConfigurationError",
	PromptApplyProfileConfigurationCompleted = "AvatarEditorServicePromptApplyProfileConfigurationCompletedError",
	GetProfileConfiguration = "AvatarEditorServiceGetProfileConfigurationError"
}
local t3 = {
	AvatarItems = "avatarItemImpressions",
	AvatarItemsCatalog = "avatarItemImpressionsCatalog"
}
local v7 = if not FFlagAXExportTimedOptionsConstant then nil else {
	[3] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_3,
	[7] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_7,
	[14] = UnifiedEventLogEnums.MarketplaceTimedOption.DAYS_14
}

return {
	AVATAR_EVENT_COUNTER_NAME = t1,
	AVATAR_EDITOR_SERVICE_ERRORS = t2,
	IMPRESSIONS_EVENTS = t3,
	TIMED_OPTION_BY_DAYS = if not FFlagAXExportTimedOptionsConstant then nil else v7
}
