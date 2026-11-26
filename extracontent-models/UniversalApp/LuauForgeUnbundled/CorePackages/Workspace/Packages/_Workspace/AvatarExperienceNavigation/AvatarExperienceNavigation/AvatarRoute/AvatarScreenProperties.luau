local AvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarScreen")
local UnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/UnifiedLoggingSurface")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/Dash")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceFlags")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local fFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local fFlagAXPhotoboothMomentsLogging = AvatarExperienceFlags.FFlagAXPhotoboothMomentsLogging

local defineFastFlag = game:DefineFastFlag("AXKeepTryOnsInAvatarEditor", false)
local fFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local fFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/SharedFlags").FFlagAXEnableProfileTab
local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/SharedFlags").FFlagEditProfileImageV2Enabled

local v5 = {
	isTransparent = false,
	coversSceneWhenExpanded = false,
	isTryOnOutfitResetPage = false,
	isRefinementPage = false,
	refinementButtonVisible = false,
	VRPanelRoundedCorners = false,
	VRPanelPlacement = "Center"
}

local v6 = {
	[AvatarScreen.AccessoryAdjustment] = {
		isRefinementPage = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.AvatarExperienceLandingPage] = { isTryOnOutfitResetPage = true },
	[AvatarScreen.AvatarExperienceRoot] = {},
	[AvatarScreen.AvatarBackground] = { isTransparent = false },
	[AvatarScreen.BackgroundGeneration] = {
		analyticsData = fFlagAXBackgroundGenerationAnalytics and {
			unifiedLoggingSurface = UnifiedLoggingSurface.BACKGROUND_GENERATION
		} or nil
	},
	[AvatarScreen.Catalog] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CATALOG }
	},
	[AvatarScreen.CatalogContextMenu] = { VRPanelPlacement = "Right" },
	[AvatarScreen.CatalogSearch] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_RESULTS }
	},
	[AvatarScreen.CatalogSearchLanding] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_LANDING_PAGE }
	},
	[AvatarScreen.ItemDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.OutfitDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.ItemOwnershipPage] = {
		isTransparent = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.CreateOrUpdateOutfitMenu] = { VRPanelPlacement = "Left" },
	[AvatarScreen.LayeredClothingSort] = {
		isRefinementPage = true,
		VRPanelPlacement = "Center",
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.LCSortContextMenu] = { VRPanelPlacement = "Right" },
	[AvatarScreen.AvatarEditor] = {
		isTryOnOutfitResetPage = not defineFastFlag,
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.AvatarRefinement] = {
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.ManageOutfitPage] = {
		isTransparent = false,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.ProfilePictureEditorEmotes] = { isTryOnOutfitResetPage = true },
	[AvatarScreen.ResellersPage] = {
		isTransparent = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.SellItemPage] = {
		isTransparent = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.SellItemPeekView] = {
		isTransparent = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.SortAndFilters] = { isTransparent = true, VRPanelPlacement = "Left" },
	[AvatarScreen.TryOnItem] = {
		isTransparent = false,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.UpdateOutfitPage] = {
		isTransparent = true,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true
	},
	[AvatarScreen.AdjustAccessoryView] = {
		isTransparent = false,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.HeadRefinement] = {
		isRefinementPage = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.LookDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS }
	},
	[AvatarScreen.ContextMenu] = { VRPanelPlacement = "Right" },
	[AvatarScreen.MySharedAvatars] = {
		isTryOnOutfitResetPage = true,
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.FavoritesSaved] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true
	},
	[AvatarScreen.CommunityAvatarEntryMenu] = { VRPanelPlacement = "Left" },
	[AvatarScreen.SearchLandingFocusedWidgetPage] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_LANDING_PAGE }
	},
	[AvatarScreen.BodyShape] = {
		isRefinementPage = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.AvatarSwitcher] = {
		isTransparent = false,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.EditEmotes] = {
		isTransparent = false,
		isTryOnOutfitResetPage = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
}

if fFlagAXOutfitPageRevamp then
	v6[AvatarScreen.AddOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.DuplicateOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}

	v6[AvatarScreen.DuplicateOutfitNameDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}

	v6[AvatarScreen.RenameOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Right"
	}

	v6[AvatarScreen.DeleteOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Right"
	}

	v6[AvatarScreen.BulkDeleteOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}

	v6[AvatarScreen.ManageOutfitsPage] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if fFlagAXAvatarFoldersEnabled then
	v6[AvatarScreen.CreateFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.RenameFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.DuplicateFolderNameDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.FolderNameNotAllowedDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.FolderLimitReachedDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.FolderErrorDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.DeleteFolderPrompt] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.SelectFolderMenu] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.RemoveFromFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v6[AvatarScreen.FolderItemsErrorDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if fFlagAXFixAvatarScreenVR then
	if fFlagAXCatalogMakeupSupport then
		v6[AvatarScreen.MakeupMax6LayersPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end

	if fFlagAXMakeupReleaseFTUX then
		v6[AvatarScreen.MakeupReleaseFtuxPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end
end

if fFlagAXEditorSubcategoryFilters then
	v6[AvatarScreen.SubcategoryFiltersDropdown] = {
		isTransparent = true,
		VRPanelPlacement = "Left"
	}
end

v6[AvatarScreen.Checkout] = {
	isTransparent = true,
	coversSceneWhenExpanded = true,
	VRPanelPlacement = "Right",
	VRPanelRoundedCorners = true,
	analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CATALOG }
}

if fFlagAXEnableProfileTab then
	v6[AvatarScreen.Profile] = {
		refinementButtonVisible = true,
		isTryOnOutfitResetPage = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true
	}
end

if fFlagAXEnableExpiredUserLookCheckout then
	v6[AvatarScreen.ExpiredUserLookActionBar] = {
		isTransparent = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true
	}

	v6[AvatarScreen.ExpiredUserLookCheckout] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if fFlagAXGifting then
	v6[AvatarScreen.SendGiftRecipientPicker] = {
		isTransparent = true,
		VRPanelPlacement = "Left"
	}

	v6[AvatarScreen.SendGiftReview] = { isTransparent = true, VRPanelPlacement = "Left" }
end

if fFlagEditProfileImageV2Enabled then
	v6[AvatarScreen.EditProfileImage] = { isTryOnOutfitResetPage = true }

	v6[AvatarScreen.AppCatalogContextMenuHost] = { isTransparent = true }
end

if fFlagAXPhotoboothMomentsPage then
	v6[AvatarScreen.PhotoboothMomentsPage] = {
		isTryOnOutfitResetPage = true,
		analyticsData = fFlagAXPhotoboothMomentsLogging and {
			unifiedLoggingSurface = UnifiedLoggingSurface.PHOTOBOOTH_MOMENTS
		} or nil
	}
end

local result = {}

for k, v7 in AvatarScreen do
	result[v7] = Cryo.Dictionary.join(v5, v6[v7] or {})
end

return result
