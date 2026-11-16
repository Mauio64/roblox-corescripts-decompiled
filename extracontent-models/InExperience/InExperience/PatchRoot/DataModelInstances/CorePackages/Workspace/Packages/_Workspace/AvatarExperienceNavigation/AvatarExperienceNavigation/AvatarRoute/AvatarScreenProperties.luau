local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local parent = AvatarExperienceNavigation.Parent

local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
local UnifiedLoggingSurface = require(AvatarExperienceNavigation.Enums.UnifiedLoggingSurface)
local Cryo = require(parent.Cryo)
require(parent.Dash)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local FFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled
local FFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics
local FFlagAXPhotoboothMomentsPage = AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage
local FFlagAXPhotoboothMomentsLogging = AvatarExperienceFlags.FFlagAXPhotoboothMomentsLogging

local defineFastFlag = game:DefineFastFlag("AXKeepTryOnsInAvatarEditor", false)
local FFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local FFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting
local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEditProfileImageV2Enabled = SharedFlags2.FFlagEditProfileImageV2Enabled

local v = {
	isTransparent = false,
	coversSceneWhenExpanded = false,
	isTryOnOutfitResetPage = false,
	isRefinementPage = false,
	refinementButtonVisible = false,
	VRPanelRoundedCorners = false,
	VRPanelPlacement = "Center"
}

local v2 = {
	[AvatarScreen.AccessoryAdjustment] = {
		isRefinementPage = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	},
	[AvatarScreen.AvatarExperienceLandingPage] = { isTryOnOutfitResetPage = true },
	[AvatarScreen.AvatarExperienceRoot] = {},
	[AvatarScreen.AvatarBackground] = { isTransparent = false },
	[AvatarScreen.BackgroundGeneration] = {
		analyticsData = FFlagAXBackgroundGenerationAnalytics and {
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

if FFlagAXOutfitPageRevamp then
	v2[AvatarScreen.AddOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.DuplicateOutfitDialog] = { isTransparent = false, VRPanelPlacement = "Left" }

	v2[AvatarScreen.DuplicateOutfitNameDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}

	v2[AvatarScreen.RenameOutfitDialog] = { isTransparent = false, VRPanelPlacement = "Right" }

	v2[AvatarScreen.DeleteOutfitDialog] = { isTransparent = false, VRPanelPlacement = "Right" }

	v2[AvatarScreen.BulkDeleteOutfitDialog] = { isTransparent = false, VRPanelPlacement = "Left" }

	v2[AvatarScreen.ManageOutfitsPage] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if FFlagAXAvatarFoldersEnabled then
	v2[AvatarScreen.CreateFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.RenameFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.DuplicateFolderNameDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.FolderNameNotAllowedDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.FolderLimitReachedDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.FolderErrorDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.DeleteFolderPrompt] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.SelectFolderMenu] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.RemoveFromFolderDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}

	v2[AvatarScreen.FolderItemsErrorDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if FFlagAXFixAvatarScreenVR then
	if FFlagAXCatalogMakeupSupport then
		v2[AvatarScreen.MakeupMax6LayersPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end

	if FFlagAXMakeupReleaseFTUX then
		v2[AvatarScreen.MakeupReleaseFtuxPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end
end

if FFlagAXEditorSubcategoryFilters then
	v2[AvatarScreen.SubcategoryFiltersDropdown] = {
		isTransparent = true,
		VRPanelPlacement = "Left"
	}
end

v2[AvatarScreen.Checkout] = {
	isTransparent = true,
	coversSceneWhenExpanded = true,
	VRPanelPlacement = "Right",
	VRPanelRoundedCorners = true,
	analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CATALOG }
}

if FFlagAXEnableProfileTab then
	v2[AvatarScreen.Profile] = {
		refinementButtonVisible = true,
		isTryOnOutfitResetPage = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true
	}
end

if FFlagAXEnableExpiredUserLookCheckout then
	v2[AvatarScreen.ExpiredUserLookActionBar] = {
		isTransparent = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true
	}

	v2[AvatarScreen.ExpiredUserLookCheckout] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = { unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE }
	}
end

if FFlagAXGifting then
	v2[AvatarScreen.SendGiftRecipientPicker] = { isTransparent = true, VRPanelPlacement = "Left" }

	v2[AvatarScreen.SendGiftReview] = { isTransparent = true, VRPanelPlacement = "Left" }
end

if FFlagEditProfileImageV2Enabled then
	v2[AvatarScreen.EditProfileImage] = { isTryOnOutfitResetPage = true }

	v2[AvatarScreen.AppCatalogContextMenuHost] = { isTransparent = true }
end

if FFlagAXPhotoboothMomentsPage then
	v2[AvatarScreen.PhotoboothMomentsPage] = {
		isTryOnOutfitResetPage = true,
		analyticsData = FFlagAXPhotoboothMomentsLogging and {
			unifiedLoggingSurface = UnifiedLoggingSurface.PHOTOBOOTH_MOMENTS
		} or nil
	}
end

local AvatarScreenProperties = {}

for _, v3 in AvatarScreen do
	AvatarScreenProperties[v3] = Cryo.Dictionary.join(v, v2[v3] or {})
end

return AvatarScreenProperties
