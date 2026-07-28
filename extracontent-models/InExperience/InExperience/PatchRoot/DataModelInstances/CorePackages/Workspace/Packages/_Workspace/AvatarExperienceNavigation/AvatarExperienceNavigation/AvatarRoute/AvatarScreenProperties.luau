local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarExperienceNavigationParent = AvatarExperienceNavigation.Parent
local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
local UnifiedLoggingSurface = require(AvatarExperienceNavigation.Enums.UnifiedLoggingSurface)
local Cryo = require(AvatarExperienceNavigationParent.Cryo)

require(AvatarExperienceNavigationParent.Dash)

local AvatarExperienceFlags = require(AvatarExperienceNavigationParent.AvatarExperienceFlags)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout
local FFlagAXFixGamepadNavigationOnOutfitManagement = AvatarExperienceFlags.FFlagAXFixGamepadNavigationOnOutfitManagement
local FFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local v12 = game:DefineFastFlag("AXEnableMultiTryOnUI", false)
local v13 = game:DefineFastFlag("AXKeepTryOnsInAvatarEditor", false)
local FFlagAXFixAvatarScreenVR = AvatarExperienceFlags.FFlagAXFixAvatarScreenVR
local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXFixTryOnItemVR = AvatarExperienceFlags.FFlagAXFixTryOnItemVR
local FFlagAXEnableProfileTab = require(AvatarExperienceNavigationParent.SharedFlags).FFlagAXEnableProfileTab
local t1 = {
	isTransparent = false,
	coversSceneWhenExpanded = false,
	isTryOnOutfitResetPage = false,
	isRefinementPage = false,
	refinementButtonVisible = false,
	VRPanelRoundedCorners = false,
	VRPanelPlacement = "Center",
	isMultiTryOn = not not FFlagAXMISEnableMultiShopping and nil
}
local t2 = {
	[AvatarScreen.AccessoryAdjustment] = {
		isRefinementPage = true,
		isMultiTryOn = if not FFlagAXMISEnableMultiShopping then v12 else nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.AvatarExperienceLandingPage] = {
		isTryOnOutfitResetPage = true
	},
	[AvatarScreen.AvatarExperienceRoot] = {},
	[AvatarScreen.AvatarBackground] = {
		isTransparent = false
	},
	[AvatarScreen.Catalog] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		isMultiTryOn = if not FFlagAXMISEnableMultiShopping then v12 else nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CATALOG
		}
	},
	[AvatarScreen.CatalogContextMenu] = {
		VRPanelPlacement = "Right"
	},
	[AvatarScreen.CatalogSearch] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		isMultiTryOn = if not FFlagAXMISEnableMultiShopping then v12 else nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_RESULTS
		}
	},
	[AvatarScreen.CatalogSearchLanding] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		isMultiTryOn = if not FFlagAXMISEnableMultiShopping then v12 else nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_LANDING_PAGE
		}
	},
	[AvatarScreen.ItemDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.OutfitDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.ItemOwnershipPage] = {
		isTransparent = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.CreateOrUpdateOutfitMenu] = {
		VRPanelPlacement = "Left"
	},
	[AvatarScreen.LayeredClothingSort] = {
		isRefinementPage = true,
		VRPanelPlacement = "Center",
		isMultiTryOn = if not FFlagAXMISEnableMultiShopping then v12 else nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.LCSortContextMenu] = {
		VRPanelPlacement = "Right"
	},
	[AvatarScreen.AvatarEditor] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		isTryOnOutfitResetPage = not v13,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.AvatarRefinement] = {
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.ManageOutfitPage] = {
		isTransparent = not FFlagAXFixGamepadNavigationOnOutfitManagement,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.ProfilePictureEditorEmotes] = {
		isTryOnOutfitResetPage = true
	},
	[AvatarScreen.ResellersPage] = {
		isTransparent = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.SellItemPage] = {
		isTransparent = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.SellItemPeekView] = {
		isTransparent = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.SortAndFilters] = {
		isTransparent = true,
		VRPanelPlacement = "Left"
	},
	[AvatarScreen.TryOnItem] = {
		isTransparent = false,
		VRPanelPlacement = if not FFlagAXFixTryOnItemVR then nil else "Right",
		VRPanelRoundedCorners = not not FFlagAXFixTryOnItemVR or nil,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.UpdateOutfitPage] = {
		isTransparent = true,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true
	},
	[AvatarScreen.AdjustAccessoryView] = {
		isTransparent = false,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.HeadRefinement] = {
		isRefinementPage = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.LookDetails] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.ITEM_DETAILS
		}
	},
	[AvatarScreen.ContextMenu] = {
		VRPanelPlacement = "Right"
	},
	[AvatarScreen.MySharedAvatars] = {
		isTryOnOutfitResetPage = true,
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.FavoritesSaved] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true
	},
	[AvatarScreen.CommunityAvatarEntryMenu] = {
		VRPanelPlacement = "Left"
	},
	[AvatarScreen.SearchLandingFocusedWidgetPage] = {
		refinementButtonVisible = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.SEARCH_LANDING_PAGE
		}
	},
	[AvatarScreen.BodyShape] = {
		isRefinementPage = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.AvatarSwitcher] = {
		isTransparent = false,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	},
	[AvatarScreen.EditEmotes] = {
		isTransparent = false,
		isTryOnOutfitResetPage = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	}
}

if FFlagAXOutfitPageRevamp then
	t2[AvatarScreen.AddOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	}
	t2[AvatarScreen.DuplicateOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}
	t2[AvatarScreen.DuplicateOutfitNameDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Left"
	}
	t2[AvatarScreen.RenameOutfitDialog] = {
		isTransparent = false,
		VRPanelPlacement = "Right"
	}
	t2[AvatarScreen.ManageOutfitsPage] = {
		isTransparent = false,
		VRPanelPlacement = "Left",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	}
end

if FFlagAXFixAvatarScreenVR then
	if FFlagAXCatalogMakeupSupport then
		t2[AvatarScreen.MakeupMax6LayersPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end

	if FFlagAXMakeupReleaseFTUX then
		t2[AvatarScreen.MakeupReleaseFtuxPrompt] = {
			isTransparent = false,
			VRPanelPlacement = "Left",
			VRPanelRoundedCorners = true
		}
	end
end

if FFlagAXEditorSubcategoryFilters then
	t2[AvatarScreen.SubcategoryFiltersDropdown] = {
		isTransparent = true,
		VRPanelPlacement = "Left"
	}
end

if FFlagAXMISEnableMultiShopping then
	t2[AvatarScreen.Checkout] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CATALOG
		}
	}
end

if FFlagAXEnableProfileTab then
	t2[AvatarScreen.Profile] = {
		refinementButtonVisible = true,
		isTryOnOutfitResetPage = true,
		VRPanelPlacement = "None",
		VRPanelRoundedCorners = true
	}
end

if FFlagAXEnableExpiredUserLookCheckout then
	t2[AvatarScreen.ExpiredUserLookActionBar] = {
		isTransparent = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true
	}
	t2[AvatarScreen.ExpiredUserLookCheckout] = {
		isTransparent = true,
		coversSceneWhenExpanded = true,
		VRPanelPlacement = "Right",
		VRPanelRoundedCorners = true,
		analyticsData = {
			unifiedLoggingSurface = UnifiedLoggingSurface.CUSTOMIZE
		}
	}
end

local t3 = {}

for _, v23 in AvatarScreen do
	t3[v23] = Cryo.Dictionary.join(t1, t2[v23] or {})
end

return t3
