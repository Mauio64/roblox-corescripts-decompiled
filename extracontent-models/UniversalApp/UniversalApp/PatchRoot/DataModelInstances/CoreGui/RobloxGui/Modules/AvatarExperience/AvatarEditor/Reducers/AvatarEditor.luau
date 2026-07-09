local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Character = require(scriptParent.Character)
local Categories = require(scriptParent.Categories)
local EquippedEmotes = require(scriptParent.EquippedEmotes)
local OutfitInfos = require(scriptParent.OutfitInfos)
local AvatarSettings = require(scriptParent.AvatarSettings)
local DefaultBodyColorRanges = require(scriptParent.DefaultBodyColorRanges)
local PageFinished = require(scriptParent.PageFinished)
local RecommendedItems = require(scriptParent.RecommendedItems)
local UprankedItems = require(scriptParent.UprankedItems)
local PageLoaded = require(scriptParent.PageLoaded)
local NewItemNotifications = require(scriptParent.NewItemNotifications)
local BodyColorPickerSettings = require(scriptParent.BodyColorPickerSettings)
local HasAvatarData = require(scriptParent.HasAvatarData)
local PreventSaveAvatar = require(scriptParent.PreventSaveAvatar)
local UserInventoryRecommendations = require(scriptParent.UserInventoryRecommendations)
local UserInventoryRecommendationsFetchStatus = require(scriptParent.UserInventoryRecommendationsFetchStatus)
local GrantedItems = require(scriptParent.GrantedItems)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(Modules.AvatarExperience.Common.Types)

local GetFFlagAXEnableAvatarDataRefresh = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableAvatarDataRefresh)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothIsStandalone = AvatarExperienceFlags.FFlagAXPhotoboothIsStandalone
local FFlagAXPhotoboothBugBashFixes = AvatarExperienceFlags.FFlagAXPhotoboothBugBashFixes
local FFlagAXUprankBundles = require(Modules.AvatarExperience.Flags.FFlagAXUprankBundles)

return Rodux.combineReducers({
	Character = Character,
	Categories = Categories,
	EquippedEmotes = EquippedEmotes,
	OutfitInfos = OutfitInfos,
	AvatarSettings = AvatarSettings,
	DefaultBodyColorRanges = DefaultBodyColorRanges,
	PageFinished = PageFinished,
	RecommendedItems = RecommendedItems,
	UprankedItems = if not FFlagAXUprankBundles() then nil else UprankedItems,
	PageLoaded = PageLoaded,
	NewItemNotifications = NewItemNotifications,
	BodyColorPickerSettings = BodyColorPickerSettings,
	HasAvatarData = HasAvatarData,
	UserInventoryRecommendations = UserInventoryRecommendations,
	UserInventoryRecommendationsFetchStatus = UserInventoryRecommendationsFetchStatus,
	GrantedItems = if not GetFFlagAXEnableNewInventoryItemsList() and (not FFlagAXPhotoboothIsStandalone or not FFlagAXPhotoboothBugBashFixes) then nil else GrantedItems,
	PreventSaveAvatar = if not GetFFlagAXEnableAvatarDataRefresh() then nil else PreventSaveAvatar
})
