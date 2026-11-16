local parent = script.Parent

local IconWithTooltip = require(script.IconWithTooltip)
local InfoPeekView = require(script.InfoPeekView)
local CheckboxFeedbackFormModal = require(script.CheckboxFeedbackFormModal)
local CloseOnlyInteractiveAlert = require(script.CloseOnlyInteractiveAlert)
local ConfirmationDialog = require(script.ConfirmationDialog)
local FullscreenFrame = require(script.FullscreenFrame)
local FullscreenPageWithSafeArea = require(script.FullscreenPageWithSafeArea)
local ImagePile = require(script.ImagePile)
local InfoCarousel = require(script.InfoCarousel)
local InfoCarouselCell = require(script.InfoCarouselCell)
local InsetBackground = require(script.InsetBackground)
local Banner = require(script.Banner)
local BannerBadge = require(script.Banner.BannerBadge)
local ScrollingAppCarousel = require(script.ScrollingAppCarousel.ScrollingAppCarousel)
local InfoTable = require(script.InfoTable)
local InfoTableCell = require(script.InfoTableCell)
local ExpandableText = require(script.ExpandableText)
local AnimateScrollViewToSelectionHelper = require(script.AnimateScrollViewToSelectionHelper)
local Composer = require(script.Composer)

local SharedFlags = require(parent.SharedFlags)
local FFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local FFlagLuaAppTextFeedbackFormModal = SharedFlags.FFlagLuaAppTextFeedbackFormModal

require(script.MediaGallery.MediaGalleryTypes)

local AppBlox = {}
AppBlox.CloseOnlyInteractiveAlert = CloseOnlyInteractiveAlert
AppBlox.Composer = Composer
AppBlox.ConfirmationDialog = ConfirmationDialog
AppBlox.LoadingBar = require(script.LoadingBar)
AppBlox.InlinePrompt = require(script.InlinePrompt)
AppBlox.FullscreenFrame = FullscreenFrame
AppBlox.FullscreenPageWithSafeArea = FullscreenPageWithSafeArea
AppBlox.IconWithTooltip = IconWithTooltip
AppBlox.ImagePile = ImagePile
AppBlox.InfoPeekView = InfoPeekView
AppBlox.InfoCarousel = InfoCarousel
AppBlox.InfoCarouselCell = InfoCarouselCell
AppBlox.InsetBackground = InsetBackground
AppBlox.Banner = Banner
AppBlox.BannerBadge = BannerBadge

if not FFlagUseAnimateScrollViewToSelectionHelper then
	AnimateScrollViewToSelectionHelper = nil
end

AppBlox.AnimateScrollViewToSelectionHelper = AnimateScrollViewToSelectionHelper

AppBlox.ContentPosition = require(script.DetailsPage.ContentPosition)
AppBlox.DetailsPageLayout = require(script.DetailsPageLayout)
AppBlox.DetailsPageSelector = require(script.DetailsPage.DetailsPageSelector)
AppBlox.DetailsPageTemplate = require(script.DetailsPage.DetailsPageTemplate)
AppBlox.InfoTable = InfoTable
AppBlox.InfoTableCell = InfoTableCell
AppBlox.ScrollingAppCarousel = ScrollingAppCarousel

AppBlox.CrossFadeAnimatedView = require(script.MediaGallery.CrossFadeAnimatedView)
AppBlox.MediaGalleryCarousel = require(script.MediaGallery.MediaGalleryCarousel)
AppBlox.MediaGalleryExpandableView = require(script.MediaGallery.MediaGalleryExpandableView)
AppBlox.MediaGalleryFullScreen = require(script.MediaGallery.MediaGalleryFullScreen)
AppBlox.MediaGalleryPreview = require(script.MediaGallery.MediaGalleryPreview)
AppBlox.calcMediaGallerySizesFromWidth = require(script.MediaGallery.calcMediaGallerySizesFromWidth)
AppBlox.useAnimateScrollViewToSelection = require(script.useAnimateScrollViewToSelection)
AppBlox.ExpandableText = ExpandableText
AppBlox.CheckboxFeedbackFormModal = CheckboxFeedbackFormModal
local textFeedbackFormModal

if FFlagLuaAppTextFeedbackFormModal then
	textFeedbackFormModal = require(script.TextFeedbackFormModal)
end

AppBlox.TextFeedbackFormModal = textFeedbackFormModal

AppBlox.ProvideFeedbackToast = require(script.ProvideFeedbackToast)
AppBlox.SnackbarWrapper = require(script.SnackbarWrapper)
AppBlox.EmptyTile = require(script.EmptyTile)
AppBlox.useCloseWithBackButton = require(script.DetailsPage.Hooks.useCloseWithBackButton)
AppBlox.OverflowMenu = require(script.OverflowMenu.OverflowMenu)
AppBlox.getOverflowMenuSignalStore = require(script.OverflowMenu.getOverflowMenuSignalStore)
AppBlox.useOverflowMenuOpen = require(script.OverflowMenu.useOverflowMenuOpen)
AppBlox["jest.config"] = script["jest.config"]
return AppBlox
