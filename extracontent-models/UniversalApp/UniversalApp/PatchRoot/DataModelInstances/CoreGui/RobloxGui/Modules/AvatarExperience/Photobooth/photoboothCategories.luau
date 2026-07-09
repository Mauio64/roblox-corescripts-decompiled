local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local CatalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local FFlagAXCatalogCategoriesSDUI = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogCategoriesSDUI
local PhotoboothCategories = require(CorePackages.Workspace.Packages.AvatarExperiencePhotobooth).Enums.PhotoboothCategories

return {
	[PhotoboothCategories.All] = {
		Title = "Feature.Avatar.Heading.All",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.All,
		NavigationKey = PhotoboothCategories.All,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = {
			Constants.AssetTypeIdStrings.EmoteAnimation,
			Constants.AssetTypeIdStrings.IdleAnimation,
			Constants.AssetTypeIdStrings.WalkAnimation,
			Constants.AssetTypeIdStrings.RunAnimation,
			Constants.AssetTypeIdStrings.JumpAnimation,
			Constants.AssetTypeIdStrings.FallAnimation,
			Constants.AssetTypeIdStrings.ClimbAnimation,
			Constants.AssetTypeIdStrings.SwimAnimation
		},
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Emotes] = {
		Title = "Feature.Avatar.Heading.Emotes",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Emotes,
		NavigationKey = PhotoboothCategories.Emotes,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.EmoteAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Idle] = {
		Title = "Feature.Avatar.Label.Idle",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Idle,
		NavigationKey = PhotoboothCategories.Idle,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.IdleAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Walk] = {
		Title = "Feature.Avatar.Label.Walk",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Walk,
		NavigationKey = PhotoboothCategories.Walk,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.WalkAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Run] = {
		Title = "Feature.Avatar.Label.Run",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Run,
		NavigationKey = PhotoboothCategories.Run,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.RunAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Jump] = {
		Title = "Feature.Avatar.Label.Jump",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Jump,
		NavigationKey = PhotoboothCategories.Jump,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.JumpAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Fall] = {
		Title = "Feature.Avatar.Label.Fall",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Fall,
		NavigationKey = PhotoboothCategories.Fall,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.FallAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Climb] = {
		Title = "Feature.Avatar.Label.Climb",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Climb,
		NavigationKey = PhotoboothCategories.Climb,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.ClimbAnimation },
		SearchUuid = SearchUuid()
	},
	[PhotoboothCategories.Swim] = {
		Title = "Feature.Avatar.Label.Swim",
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Subcategories = nil,
		Name = PhotoboothCategories.Swim,
		NavigationKey = PhotoboothCategories.Swim,
		CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
		RecommendationsType = Constants2.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			SubcategoryKey = nil,
			CategoryKey = CatalogCategories.AllAnimations
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			SubcategoryId = nil,
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue()
		},
		AssetTypeIdStrings = { Constants.AssetTypeIdStrings.SwimAnimation },
		SearchUuid = SearchUuid()
	}
}
