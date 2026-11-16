local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FocusNavigatorWrapper = require(script.Parent.FocusNavigatorWrapper)
local CombinedCarouselsContent = require(script.Parent.CombinedCarouselsContent)
local ExpandedEmotesGridContent = require(script.Parent.ExpandedEmotesGridContent)
local AssetGridScrollSection = require(script.Parent.AssetGridScrollSection)
local EditProfileImageFooter = require(script.Parent.EditProfileImageFooter)
local EditProfileImageActionsContext = require(AvatarExperienceProfilePictureEditor.Context.EditProfileImageActionsContext)
local useGuiInset = require(AvatarExperienceProfilePictureEditor.Hooks.useGuiInset)
local useGuiInset2 = useGuiInset.useGuiInset

local useEditProfileImageLayout = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageLayout)
local useEditProfileImageLayout2 = useEditProfileImageLayout.useEditProfileImageLayout
local useEditProfileImageViewModel = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageViewModel)
local FramesPlusUpsellBar = require(script.Parent.FramesPlusUpsellBar)
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local RobloxPlusUpsellBanner = RobloxSubscriptionPurchaseApp.Components.RobloxPlusUpsellBanner
local FFlagProfileFramesUpsellFreeTrial = require(AvatarExperienceProfilePictureEditor.Flags.FFlagProfileFramesUpsellFreeTrial)
local RotatableAvatarPreview = require(script.Parent.RotatableAvatarPreview)
local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)
local Constants = require(AvatarExperienceProfilePictureEditor.Constants)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagSplitPaneProfileEditFillPane = SharedFlags.FFlagSplitPaneProfileEditFillPane
local FFlagEditProfileImageR15UpgradePrompt = SharedFlags.FFlagEditProfileImageR15UpgradePrompt
local EditProfileImageAnalytics = require(AvatarExperienceProfilePictureEditor.Analytics.EditProfileImageAnalytics)

local function renderFramesPlusUpsellBanner(props)
	return React.createElement(FramesPlusUpsellBar, {
		layoutOrder = props.LayoutOrder,
		actionText = props.actionText,
		onSubscribeActivated = props.onActivated
	})
end

local function createSplitLayout(props, previewHeight: number)
	local element = React.createElement(View, { tag = "col grow size-full-0", LayoutOrder = 2 }, {
		[props.activeView] = props.options
	})

	local splitLayout = {
		Preview = React.createElement(View, {
			tag = "align-x-center position-top-right anchor-top-right",
			Size = UDim2.new(1 - Constants.SplitControlsPaneWidthScale, 0, 0, previewHeight),
			ZIndex = 0
		}, { AvatarPreview = props.avatarPreview }),
		LeftPane = React.createElement(
			View,
			{
				tag = "col size-full-full bg-surface-0",
				Size = UDim2.fromScale(Constants.SplitControlsPaneWidthScale, 1),
				LayoutOrder = 1,
				ZIndex = 1
			},
			{ Header = props.header, Options = element, Footer = props.footer }
		),
		CloseButton = 0
	}
	local closeButton

	if not props.header then
		closeButton = props.closeButton
	end

	splitLayout.CloseButton = closeButton
	return splitLayout
end

local function createStackedLayout(props, previewWidth: number, visiblePreviewHeight: number)
	local createElement = React.createElement

	local v = {
		TitleHeader = props.header,
		Preview = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			ProfilePhotoRow = React.createElement(
				View,
				{ tag = "align-x-center size-full-0 auto-y", LayoutOrder = 1 },
				{
					PreviewClipHost = React.createElement(
						"Frame",
						{
							Size = UDim2.fromOffset(previewWidth, visiblePreviewHeight),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ClipsDescendants = true
						},
						{ AvatarPreview = props.avatarPreview }
					)
				}
			)
		}),
		ScrollBody = 0,
		Footer = 0
	}
	local scrollBody

	if props.activeView == "emotes" then
		scrollBody = React.createElement(
			View,
			{ testId = "virtualized-emotes-body", tag = "col grow size-full-0", LayoutOrder = 3 },
			{ Emotes = props.options }
		)
	else
		scrollBody = React.createElement(ScrollView, {
			testId = "portrait-scroll-body",
			tag = "grow size-full-0",
			LayoutOrder = 3,
			selection = { Selectable = false },
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				scrollBarVisibility = Visibility.Auto
			}
		}, {
			Content = React.createElement(View, { tag = "col size-full-0 auto-y" }, {
				[props.activeView] = props.options
			})
		})
	end

	v.ScrollBody = scrollBody

	v.Footer = props.footer
	return {
		StackedContent = createElement(View, { tag = "col size-full-full" }, v),
		CloseButton = props.closeButton
	}
end

local function EditProfileImageBody(props)
	local v = useTokens()
	local guiInset = useGuiInset2()
	local v2 = { editProfilePicture = TextKeys.EditProfilePicture }

	if FFlagProfileFramesUpsellFreeTrial then
		v2.profileFramesUnlockBanner = TextKeys.ProfileFramesUnlockBanner
		v2.subscribe = TextKeys.Subscribe
		v2.tryItForFree = TextKeys.TryItForFree
	end

	local v3 = useLocalization(v2)
	local showCloseButton = props.showCloseButton ~= false
	local containerSize

	if FFlagSplitPaneProfileEditFillPane then
		containerSize = props.containerSize
	end

	local v4 = useEditProfileImageLayout2({ guiInset = guiInset, containerSize = containerSize })

	local cutoutFieldOfViewDeg = v4.cutoutFieldOfViewDeg

	local v5 = useEditProfileImageViewModel({
		mode = props.mode,
		initialFrameAssetId = props.initialFrameAssetId,
		initialFrameSelectionRequestId = props.initialFrameSelectionRequestId,
		onClose = props.onClose,
		onSaveSuccess = props.onSaveSuccess,
		cutoutFieldOfViewDeg = cutoutFieldOfViewDeg
	})

	local navigation = v5.navigation
	local emotes = v5.emotes
	local frames = v5.frames
	local preview = v5.preview
	local footer = v5.footer

	local activeView = navigation.activeView
	local onSelectEmote = emotes.onSelect

	if FFlagEditProfileImageR15UpgradePrompt then
		local accountRigType = props.accountRigType
		onSelectEmote = React.useCallback(function(p: string)
			local onPromptR15Upgrade = props.onPromptR15Upgrade

			if accountRigType == Enum.HumanoidRigType.R6 and p ~= emotes.selectedEmoteId and onPromptR15Upgrade then
				onPromptR15Upgrade(function()
					emotes.onSelect(p)
				end)
			else
				emotes.onSelect(p)
			end
		end, { accountRigType, emotes.selectedEmoteId, emotes.onSelect, props.onPromptR15Upgrade })
	end

	React.useEffect(function()
		EditProfileImageAnalytics.logPageView({ mode = props.mode })
	end, { props.mode })

	local onActivated = React.useCallback(function()
		EditProfileImageAnalytics.logClose({ mode = props.mode, activeView = activeView })

		navigation.onLeaveScreen()
	end, { props.mode, activeView, navigation.onLeaveScreen })

	local v6 = props.mode == Enums.EditProfileImageMode.FramesOnly
	local v7

	if frames.shouldShowUpsell then
		if FFlagProfileFramesUpsellFreeTrial then
			v7 = React.createElement(RobloxPlusUpsellBanner, {
				message = v3.profileFramesUnlockBanner,
				subscribeText = v3.subscribe,
				freeTrialText = v3.tryItForFree,
				onActivated = function()
					frames.onOpenSubscriptionUpsell("banner")
				end,
				showPlusIcon = true,
				testId = "FramesPlusUpsellBar",
				renderBanner = renderFramesPlusUpsellBanner
			})
		else
			v7 = React.createElement(FramesPlusUpsellBar, {
				onSubscribeActivated = function()
					frames.onOpenSubscriptionUpsell("banner")
				end
			})
		end
	end

	local cutoutTopOffset = v4.cutoutTopOffset
	local cutoutSize = v4.cutoutSize
	local previewHeight = v4.previewHeight
	local visiblePreviewHeight = v4.visiblePreviewHeight
	local previewWidth = v4.previewWidth
	local useInternalScroll = v4.mode == "split"
	local containerWidth

	if useInternalScroll then
		containerWidth = math.floor(v4.safeWidth * Constants.SplitControlsPaneWidthScale + 0.5)
	else
		containerWidth = v4.safeWidth
	end

	local closeButtonTopOffset = v4.closeButtonTopOffset
	local onTitleBack

	if v6 then
		if useInternalScroll then
			onTitleBack = onActivated
		end
	else
		onTitleBack = navigation.onTitleBack
	end

	local options

	if activeView == "frames" then
		if frames.show then
			options = React.createElement(AssetGridScrollSection, {
				title = frames.localizedTitle,
				titleLeadingIconName = IconName.RobloxPlus,
				onTitleBack = onTitleBack,
				layoutOrder = 3,
				useInternalScroll = useInternalScroll,
				gridProps = {
					items = frames.items,
					isLoading = frames.isLoading,
					hasError = frames.hasError,
					onRetry = frames.onRetry,
					bannerComponent = v7,
					selectedId = frames.selectedFrameId,
					onSelect = frames.onSelect,
					tileSize = 96,
					containerWidth = containerWidth
				}
			})
		else
			options = React.createElement(View, { tag = "size-full-0", LayoutOrder = 3 })
		end
	elseif activeView == "emotes" then
		options = React.createElement(ExpandedEmotesGridContent, {
			layoutOrder = 3,
			tileSize = 96,
			containerWidth = containerWidth,
			onTitleBack = onTitleBack,
			useInternalScroll = useInternalScroll,
			ownedEmoteItems = emotes.ownedItems,
			recommendedEmoteItems = emotes.recommendedItems,
			emotesLoading = emotes.isLoading,
			emotesError = emotes.hasError,
			hasMoreEmotes = emotes.hasMore,
			isLoadingMoreEmotes = emotes.isLoadingMore,
			hasLoadMoreEmotesError = emotes.hasLoadMoreError,
			onMoreEmotes = emotes.onMore,
			onRetryEmotes = emotes.onRetry,
			selectedEmoteId = emotes.selectedEmoteId,
			onSelectEmote = onSelectEmote
		})
	else
		options = React.createElement(CombinedCarouselsContent, {
			layoutOrder = 3,
			tileSize = 96,
			showFrames = frames.show,
			useInternalScroll = useInternalScroll,
			emoteItems = emotes.items,
			emotesLoading = emotes.isLoading,
			emotesError = emotes.hasError,
			onRetryEmotes = emotes.onRetry,
			selectedEmoteId = emotes.selectedEmoteId,
			onSelectEmote = onSelectEmote,
			onExpandEmotes = navigation.onExpandEmotes,
			frameItems = frames.items,
			framesLoading = frames.isLoading,
			framesError = frames.hasError,
			onRetryFrames = frames.onRetry,
			selectedFrameId = frames.selectedFrameId,
			onSelectFrame = frames.onSelect,
			onExpandFrames = navigation.onExpandFrames,
			framesBannerComponent = v7
		})
	end

	local element = React.createElement(EditProfileImageFooter, {
		footerCta = footer.cta,
		isSaving = footer.isSaving,
		localizedSubscribeLabel = footer.subscribeLabel,
		localizedSaveLabel = footer.saveLabel,
		selectedEmoteId = emotes.selectedEmoteId,
		layoutOrder = 4,
		onSave = footer.onSave,
		onOpenProfileFramesSubscriptionUpsell = frames.onOpenSubscriptionUpsell,
		renderRecommendedEmotePurchaseFooter = props.renderRecommendedEmotePurchaseFooter
	})

	local createElement = React.createElement
	local v8 = {
		userId = preview.localUserId or "",
		width = previewWidth,
		height = previewHeight,
		fillContainer = false,
		cutoutSize = cutoutSize,
		cutoutTopOffset = cutoutTopOffset,
		isCameraControlBarDisabled = not useInternalScroll,
		fieldOfViewDeg = Constants.CameraFieldOfViewDeg,
		fieldOfViewForDistanceScaleDeg = cutoutFieldOfViewDeg,
		distanceScale = preview.distanceScale,
		committedYRotDeg = preview.yRotDeg,
		emoteAssetId = emotes.selectedEmoteId,
		rigTypeOverride = 0,
		frameImage = 0,
		onYRotDegChanged = 0,
		onDistanceScaleChanged = 0
	}
	local rigTypeOverride

	if FFlagEditProfileImageR15UpgradePrompt then
		rigTypeOverride = props.accountRigType
	end

	v8.rigTypeOverride = rigTypeOverride
	v8.frameImage = frames.selectedImage
	v8.onYRotDegChanged = preview.onYRotDegChanged
	v8.onDistanceScaleChanged = preview.onDistanceScaleChanged
	local element2 = createElement(RotatableAvatarPreview, v8)

	local v9 = not (v6 or navigation.onTitleBack)

	local createElement2 = React.createElement
	local icon = if v6 then IconName.ChevronLargeLeft else IconName.X
	local element3 = createElement2(IconButton, {
		icon = icon,
		size = IconSize.Medium,
		variant = ButtonVariant.Utility,
		isCircular = true,
		onActivated = onActivated
	})
	local closeButton

	if showCloseButton and not useInternalScroll and (v9 or v6) then
		local createElement3 = React.createElement
		local position

		if useInternalScroll then
			position = UDim2.fromScale(Constants.SplitControlsPaneWidthScale, 0)
		end

		closeButton = createElement3(View, {
			tag = "position-top-left auto-xy",
			Position = position,
			ref = navigation.closeButtonRef,
			padding = {
				top = UDim.new(0, closeButtonTopOffset),
				left = UDim.new(0, v.Padding.XLarge)
			},
			ZIndex = 10
		}, { Button = element3 })
	end

	local headerBar = Foundation.HeaderBar
	local header

	if useInternalScroll and v9 and showCloseButton then
		header = React.createElement(
			View,
			{ tag = "size-full-0 auto-y", LayoutOrder = 1, ref = navigation.closeButtonRef },
			{
				Bar = React.createElement(headerBar.Root, nil, {
					Leading = React.createElement(headerBar.Leading, nil, {
						Actions = React.createElement(headerBar.Actions, {
							actions = {
								{ id = "close", icon = IconName.X, onActivated = onActivated }
							}
						}),
						Title = React.createElement(Text, {
							Text = v3.editProfilePicture,
							tag = "auto-xy text-heading-small content-emphasis"
						})
					})
				})
			}
		)
	end

	local v10 = {
		activeView = activeView,
		avatarPreview = element2,
		closeButton = closeButton,
		header = header,
		footer = element,
		options = options
	}
	local v11

	if useInternalScroll then
		v11 = createSplitLayout(v10, previewHeight)
	else
		v11 = createStackedLayout(v10, previewWidth, visiblePreviewHeight)
	end

	return React.createElement(FocusNavigatorWrapper, { onClose = navigation.onBack }, {
		NavigationEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = navigation.onDidFocus
		}),
		Root = React.createElement(View, {
			tag = FFlagAXEnableProfileTab and {
				["bg-surface-0"] = not useInternalScroll,
				["size-full-full"] = true
			} or useInternalScroll and "size-full-full" or "size-full-full bg-surface-0"
		}, v11)
	})
end

local function EditProfileImage(props)
	local v = React.useMemo(function()
		return {
			onOpenEmoteDetails = props.onOpenEmoteDetails,
			onPrepareRecommendedEmotePurchase = props.onPrepareRecommendedEmotePurchase,
			onShopForMoreEmotes = props.onShopForMoreEmotes
		}
	end, { props.onOpenEmoteDetails, props.onPrepareRecommendedEmotePurchase, props.onShopForMoreEmotes })

	local createElement = React.createElement
	local provider = EditProfileImageActionsContext.Provider

	local createElement2 = React.createElement
	local v2 = {
		mode = props.mode,
		initialFrameAssetId = props.initialFrameAssetId,
		initialFrameSelectionRequestId = props.initialFrameSelectionRequestId,
		showCloseButton = props.showCloseButton,
		onClose = props.onClose,
		onSaveSuccess = props.onSaveSuccess,
		onPromptR15Upgrade = props.onPromptR15Upgrade,
		accountRigType = props.accountRigType,
		renderRecommendedEmotePurchaseFooter = props.renderRecommendedEmotePurchaseFooter,
		containerSize = 0
	}
	local containerSize

	if FFlagSplitPaneProfileEditFillPane then
		containerSize = props.containerSize
	end

	v2.containerSize = containerSize
	return createElement(provider, { value = v }, createElement2(EditProfileImageBody, v2))
end

return EditProfileImage
