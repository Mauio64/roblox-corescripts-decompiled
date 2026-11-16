local IconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/IconWithTooltip")
local InfoPeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoPeekView")
local CheckboxFeedbackFormModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/CheckboxFeedbackFormModal")
local CloseOnlyInteractiveAlert = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/CloseOnlyInteractiveAlert")
local ConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ConfirmationDialog")
local FullscreenFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/FullscreenFrame")
local FullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/FullscreenPageWithSafeArea")
local ImagePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ImagePile")
local InfoCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoCarousel")
local InfoCarouselCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoCarouselCell")
local InsetBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InsetBackground")
local Banner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Banner")
local BannerBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Banner/BannerBadge")
local ScrollingAppCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ScrollingAppCarousel/ScrollingAppCarousel")
local InfoTable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoTable")
local InfoTableCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoTableCell")
local ExpandableText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ExpandableText")
local AnimateScrollViewToSelectionHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/AnimateScrollViewToSelectionHelper")
local Composer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local fFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local fFlagLuaAppTextFeedbackFormModal = SharedFlags.FFlagLuaAppTextFeedbackFormModal

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryTypes")

local v5 = {}
v5.CloseOnlyInteractiveAlert = CloseOnlyInteractiveAlert
v5.Composer = Composer
v5.ConfirmationDialog = ConfirmationDialog
v5.LoadingBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/LoadingBar")
v5.InlinePrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InlinePrompt")
v5.FullscreenFrame = FullscreenFrame
v5.FullscreenPageWithSafeArea = FullscreenPageWithSafeArea
v5.IconWithTooltip = IconWithTooltip
v5.ImagePile = ImagePile
v5.InfoPeekView = InfoPeekView
v5.InfoCarousel = InfoCarousel
v5.InfoCarouselCell = InfoCarouselCell
v5.InsetBackground = InsetBackground
v5.Banner = Banner
v5.BannerBadge = BannerBadge

if not fFlagUseAnimateScrollViewToSelectionHelper then
	AnimateScrollViewToSelectionHelper = nil
end

v5.AnimateScrollViewToSelectionHelper = AnimateScrollViewToSelectionHelper

v5.ContentPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/ContentPosition")
v5.DetailsPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout")
v5.DetailsPageSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageSelector")
v5.DetailsPageTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageTemplate")
v5.InfoTable = InfoTable
v5.InfoTableCell = InfoTableCell
v5.ScrollingAppCarousel = ScrollingAppCarousel

v5.CrossFadeAnimatedView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/CrossFadeAnimatedView")
v5.MediaGalleryCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryCarousel")
v5.MediaGalleryExpandableView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryExpandableView")
v5.MediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryFullScreen")
v5.MediaGalleryPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/MediaGalleryPreview")
v5.calcMediaGallerySizesFromWidth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/calcMediaGallerySizesFromWidth")
v5.useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/useAnimateScrollViewToSelection")
v5.ExpandableText = ExpandableText
v5.CheckboxFeedbackFormModal = CheckboxFeedbackFormModal

local v6 = if fFlagLuaAppTextFeedbackFormModal then require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/TextFeedbackFormModal") else nil
v5.TextFeedbackFormModal = v6

v5.ProvideFeedbackToast = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/ProvideFeedbackToast")
v5.SnackbarWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/SnackbarWrapper")
v5.EmptyTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/EmptyTile")
v5.useCloseWithBackButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Hooks/useCloseWithBackButton")
v5.OverflowMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/OverflowMenu")
v5.getOverflowMenuSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/getOverflowMenuSignalStore")
v5.useOverflowMenuOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/OverflowMenu/useOverflowMenuOpen")
return v5
