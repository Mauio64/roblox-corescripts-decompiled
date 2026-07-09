local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local AssetInfos = require(Modules.AvatarExperience.Common.Reducers.AssetInfos)
local BundleInfos = require(Modules.AvatarExperience.Common.Reducers.BundleInfos)
local Collectibles = require(Modules.AvatarExperience.Common.Reducers.Collectibles)
local ItemDetailsExpanded = require(Modules.AvatarExperience.Common.Reducers.ItemDetailsExpanded)
local ItemDetailsPeekView = AvatarExperienceRodux.Reducers.ItemDetailsPeekView
local AvatarExperienceLoaded = AvatarExperienceRodux.Reducers.AvatarExperienceLoaded
local PlayEmoteInBackground = require(Modules.AvatarExperience.Common.Reducers.PlayEmoteInBackground)
local FullView = require(Modules.AvatarExperience.Common.Reducers.FullView)
local Widgets = require(Modules.AvatarExperience.Common.Reducers.Widgets)

require(Modules.AvatarExperience.Common.Types)

return Rodux.combineReducers({
	AssetInfos = AssetInfos,
	BundleInfos = BundleInfos,
	Collectibles = Collectibles,
	ItemDetailsExpanded = ItemDetailsExpanded,
	ItemDetailsPeekView = ItemDetailsPeekView,
	AvatarExperienceLoaded = AvatarExperienceLoaded,
	PlayEmoteInBackground = PlayEmoteInBackground,
	FullView = FullView,
	Widgets = Widgets
})
