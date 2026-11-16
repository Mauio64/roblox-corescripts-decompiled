local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RoactNavigation")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local view = Foundation.View
local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility
local iconButton = Foundation.IconButton
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization").Hooks.useLocalization
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/FocusNavigatorWrapper")
local CombinedCarouselsContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/CombinedCarouselsContent")
local ExpandedEmotesGridContent = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/ExpandedEmotesGridContent")
local AssetGridScrollSection = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/AssetGridScrollSection")
local EditProfileImageFooter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/EditProfileImageFooter")
local EditProfileImageActionsContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Context/EditProfileImageActionsContext")
local useGuiInset = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useGuiInset").useGuiInset

local useEditProfileImageLayout = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageLayout").useEditProfileImageLayout
local useEditProfileImageViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageViewModel")
local FramesPlusUpsellBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/FramesPlusUpsellBar")
local robloxPlusUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RobloxSubscriptionPurchaseApp").Components.RobloxPlusUpsellBanner
local FFlagProfileFramesUpsellFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Flags/FFlagProfileFramesUpsellFreeTrial")
local RotatableAvatarPreview = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/EditProfileImage/RotatableAvatarPreview")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags")
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagSplitPaneProfileEditFillPane = SharedFlags.FFlagSplitPaneProfileEditFillPane
local fFlagEditProfileImageR15UpgradePrompt = SharedFlags.FFlagEditProfileImageR15UpgradePrompt
local EditProfileImageAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")

local function renderFramesPlusUpsellBanner(props)
	return React.createElement(FramesPlusUpsellBar, {
		layoutOrder = props.LayoutOrder,
		actionText = props.actionText,
		onSubscribeActivated = props.onActivated
	})
end

local function createSplitLayout(props, previewHeight)
	local element = React.createElement(view, {
		tag = "col grow size-full-0",
		LayoutOrder = 2
	}, {
		[props.activeView] = props.options
	})

	local splitLayout = {
		Preview = React.createElement(view, {
			tag = "align-x-center position-top-right anchor-top-right",
			Size = UDim2.new(1 - Constants.SplitControlsPaneWidthScale, 0, 0, previewHeight),
			ZIndex = 0
		}, { AvatarPreview = props.avatarPreview }),
		LeftPane = React.createElement(
			view,
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

	local v6 = if not props.header then props.closeButton else nil
	splitLayout.CloseButton = v6
	return splitLayout
end

local function createStackedLayout(props, previewWidth, visiblePreviewHeight)
	local createElement = React.createElement

	local v7 = {
		TitleHeader = props.header,
		Preview = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
			{
				ProfilePhotoRow = React.createElement(
					view,
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
			}
		),
		ScrollBody = 0,
		Footer = 0
	}
	local v8

	if props.activeView == "emotes" then
		v8 = React.createElement(
			view,
			{
				testId = "virtualized-emotes-body",
				tag = "col grow size-full-0",
				LayoutOrder = 3
			},
			{ Emotes = props.options }
		)
	else
		v8 = React.createElement(scrollView, {
			testId = "portrait-scroll-body",
			tag = "grow size-full-0",
			LayoutOrder = 3,
			selection = { Selectable = false },
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 0),
				scrollBarVisibility = visibility.Auto
			}
		}, {
			Content = React.createElement(view, { tag = "col size-full-0 auto-y" }, {
				[props.activeView] = props.options
			})
		})
	end

	v7.ScrollBody = v8

	v7.Footer = props.footer
	return {
		StackedContent = createElement(view, { tag = "col size-full-full" }, v7),
		CloseButton = props.closeButton
	}
end

local function EditProfileImageBody(props)
	local v5 = useTokens()
	local v6 = useGuiInset()
	local v7 = { editProfilePicture = TextKeys.EditProfilePicture }

	if FFlagProfileFramesUpsellFreeTrial then
		v7.profileFramesUnlockBanner = TextKeys.ProfileFramesUnlockBanner
		v7.subscribe = TextKeys.Subscribe
		v7.tryItForFree = TextKeys.TryItForFree
	end

	local v8 = useLocalization(v7)
	local showCloseButton = props.showCloseButton ~= false

	local v11 = if fFlagSplitPaneProfileEditFillPane then props.containerSize else nil
	local v12 = useEditProfileImageLayout({ guiInset = v6, containerSize = v11 })

	local cutoutFieldOfViewDeg = v12.cutoutFieldOfViewDeg

	local v13 = useEditProfileImageViewModel({
		mode = props.mode,
		initialFrameAssetId = props.initialFrameAssetId,
		initialFrameSelectionRequestId = props.initialFrameSelectionRequestId,
		onClose = props.onClose,
		onSaveSuccess = props.onSaveSuccess,
		cutoutFieldOfViewDeg = cutoutFieldOfViewDeg
	})

	local navigation = v13.navigation
	local emotes = v13.emotes
	local frames = v13.frames
	local preview = v13.preview
	local footer = v13.footer

	local activeView = navigation.activeView
	local v14 = emotes.onSelect

	if fFlagEditProfileImageR15UpgradePrompt then
		local accountRigType = props.accountRigType
		v14 = React.useCallback(function(p2)
			local onPromptR15Upgrade = props.onPromptR15Upgrade

			if
				accountRigType == Enum.HumanoidRigType.R6
				and p2 ~= emotes.selectedEmoteId
				and onPromptR15Upgrade
			then
				onPromptR15Upgrade(function()
					emotes.onSelect(p2)
				end)
			else
				emotes.onSelect(p2)
			end
		end, {
			accountRigType,
			emotes.selectedEmoteId,
			emotes.onSelect,
			props.onPromptR15Upgrade
		})
	end

	React.useEffect(function()
		EditProfileImageAnalytics.logPageView({ mode = props.mode })
	end, { props.mode })

	local v15 = React.useCallback(function()
		EditProfileImageAnalytics.logClose({ mode = props.mode, activeView = activeView })

		navigation.onLeaveScreen()
	end, { props.mode, activeView, navigation.onLeaveScreen })

	local v16 = props.mode == Enums.EditProfileImageMode.FramesOnly
	local v17

	if frames.shouldShowUpsell then
		if FFlagProfileFramesUpsellFreeTrial then
			v17 = React.createElement(robloxPlusUpsellBanner, {
				message = v8.profileFramesUnlockBanner,
				subscribeText = v8.subscribe,
				freeTrialText = v8.tryItForFree,
				onActivated = function()
					frames.onOpenSubscriptionUpsell("banner")
				end,
				showPlusIcon = true,
				testId = "FramesPlusUpsellBar",
				renderBanner = renderFramesPlusUpsellBanner
			})
		else
			v17 = React.createElement(FramesPlusUpsellBar, {
				onSubscribeActivated = function()
					frames.onOpenSubscriptionUpsell("banner")
				end
			})
		end
	end

	local cutoutTopOffset = v12.cutoutTopOffset
	local cutoutSize = v12.cutoutSize
	local previewHeight = v12.previewHeight
	local visiblePreviewHeight = v12.visiblePreviewHeight
	local previewWidth = v12.previewWidth
	local v18 = v12.mode == "split"
	local v19

	if v18 then
		v19 = math.floor(v12.safeWidth * Constants.SplitControlsPaneWidthScale + 0.5)
	else
		v19 = v12.safeWidth
	end

	local closeButtonTopOffset = v12.closeButtonTopOffset
	local v20

	if v16 then
		if v18 then
			v20 = v15
		end
	else
		v20 = navigation.onTitleBack
	end

	local v21

	if activeView == "frames" then
		if frames.show then
			v21 = React.createElement(AssetGridScrollSection, {
				title = frames.localizedTitle,
				titleLeadingIconName = iconName.RobloxPlus,
				onTitleBack = v20,
				layoutOrder = 3,
				useInternalScroll = v18,
				gridProps = {
					items = frames.items,
					isLoading = frames.isLoading,
					hasError = frames.hasError,
					onRetry = frames.onRetry,
					bannerComponent = v17,
					selectedId = frames.selectedFrameId,
					onSelect = frames.onSelect,
					tileSize = 96,
					containerWidth = v19
				}
			})
		else
			v21 = React.createElement(view, { tag = "size-full-0", LayoutOrder = 3 })
		end
	elseif activeView == "emotes" then
		v21 = React.createElement(ExpandedEmotesGridContent, {
			layoutOrder = 3,
			tileSize = 96,
			containerWidth = v19,
			onTitleBack = v20,
			useInternalScroll = v18,
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
			onSelectEmote = v14
		})
	else
		v21 = React.createElement(CombinedCarouselsContent, {
			layoutOrder = 3,
			tileSize = 96,
			showFrames = frames.show,
			useInternalScroll = v18,
			emoteItems = emotes.items,
			emotesLoading = emotes.isLoading,
			emotesError = emotes.hasError,
			onRetryEmotes = emotes.onRetry,
			selectedEmoteId = emotes.selectedEmoteId,
			onSelectEmote = v14,
			onExpandEmotes = navigation.onExpandEmotes,
			frameItems = frames.items,
			framesLoading = frames.isLoading,
			framesError = frames.hasError,
			onRetryFrames = frames.onRetry,
			selectedFrameId = frames.selectedFrameId,
			onSelectFrame = frames.onSelect,
			onExpandFrames = navigation.onExpandFrames,
			framesBannerComponent = v17
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
	local v23 = {
		userId = preview.localUserId or "",
		width = previewWidth,
		height = previewHeight,
		fillContainer = false,
		cutoutSize = cutoutSize,
		cutoutTopOffset = cutoutTopOffset,
		isCameraControlBarDisabled = not v18,
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
	local v24 = if fFlagEditProfileImageR15UpgradePrompt then props.accountRigType else nil
	v23.rigTypeOverride = v24
	v23.frameImage = frames.selectedImage
	v23.onYRotDegChanged = preview.onYRotDegChanged
	v23.onDistanceScaleChanged = preview.onDistanceScaleChanged
	local element2 = createElement(RotatableAvatarPreview, v23)

	local v25 = not (v16 or navigation.onTitleBack)

	local createElement2 = React.createElement
	local v29 = if v16 then iconName.ChevronLargeLeft else iconName.X
	local element3 = createElement2(iconButton, {
		icon = v29,
		size = iconSize.Medium,
		variant = buttonVariant.Utility,
		isCircular = true,
		onActivated = v15
	})
	local v30

	if showCloseButton and not v18 and (v25 or v16) then
		local createElement3 = React.createElement

		local v33 = if v18 then UDim2.fromScale(Constants.SplitControlsPaneWidthScale, 0) else nil
		v30 = createElement3(view, {
			tag = "position-top-left auto-xy",
			Position = v33,
			ref = navigation.closeButtonRef,
			padding = {
				top = UDim.new(0, closeButtonTopOffset),
				left = UDim.new(0, v5.Padding.XLarge)
			},
			ZIndex = 10
		}, { Button = element3 })
	end

	local headerBar = Foundation.HeaderBar

	local v31 = if v18 and v25 and showCloseButton then React.createElement(
		view,
		{ tag = "size-full-0 auto-y", LayoutOrder = 1, ref = navigation.closeButtonRef },
		{
			Bar = React.createElement(headerBar.Root, nil, {
				Leading = React.createElement(headerBar.Leading, nil, {
					Actions = React.createElement(headerBar.Actions, {
						actions = {
							{ id = "close", icon = iconName.X, onActivated = v15 }
						}
					}),
					Title = React.createElement(text, {
						Text = v8.editProfilePicture,
						tag = "auto-xy text-heading-small content-emphasis"
					})
				})
			})
		}
	) else nil

	local v32 = {
		activeView = activeView,
		avatarPreview = element2,
		closeButton = v30,
		header = v31,
		footer = element,
		options = v21
	}
	local v33

	if v18 then
		v33 = createSplitLayout(v32, previewHeight)
	else
		v33 = createStackedLayout(v32, previewWidth, visiblePreviewHeight)
	end

	return React.createElement(FocusNavigatorWrapper, { onClose = navigation.onBack }, {
		NavigationEvents = React.createElement(RoactNavigation.NavigationEvents, {
			onDidFocus = navigation.onDidFocus
		}),
		Root = React.createElement(view, {
			tag = fFlagAXEnableProfileTab and {
				["bg-surface-0"] = not v18,
				["size-full-full"] = true
			} or v18 and "size-full-full" or "size-full-full bg-surface-0"
		}, v33)
	})
end

local function EditProfileImage(props)
	local v5 = React.useMemo(function()
		return {
			onOpenEmoteDetails = props.onOpenEmoteDetails,
			onPrepareRecommendedEmotePurchase = props.onPrepareRecommendedEmotePurchase,
			onShopForMoreEmotes = props.onShopForMoreEmotes
		}
	end, { props.onOpenEmoteDetails, props.onPrepareRecommendedEmotePurchase, props.onShopForMoreEmotes })

	local createElement = React.createElement
	local provider = EditProfileImageActionsContext.Provider

	local createElement2 = React.createElement
	local v8 = {
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
	local v9 = if fFlagSplitPaneProfileEditFillPane then props.containerSize else nil
	v8.containerSize = v9
	return createElement(provider, { value = v5 }, createElement2(EditProfileImageBody, v8))
end

return EditProfileImage
