local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local t = require(parent.t)
local CollectionViews = require(parent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local ItemHeightMode = require(ServerDrivenUi.Content.Collections.ItemHeightMode)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions

local parseCallbackProp_ = SduiParsers.parseCallbackProp_
local parseUiComponentProp_ = SduiParsers.parseUiComponentProp_
local parseLazyUiComponentProp_ = SduiParsers.parseLazyUiComponentProp_
local parseIntegerProp_ = SduiParsers.parseIntegerProp_
local parseNumberProp_ = SduiParsers.parseNumberProp_
local parseUDim2Prop_ = SduiParsers.parseUDim2Prop_
local parseUDimProp_ = SduiParsers.parseUDimProp_
local parseImageStringProp_ = SduiParsers.parseImageStringProp_
local parseVector2Prop_ = SduiParsers.parseVector2Prop_
local parseColor3Prop_ = SduiParsers.parseColor3Prop_
local parseBooleanProp_ = SduiParsers.parseBooleanProp_
local parseGradientProp_ = SduiParsers.parseGradientProp_
local parseIconProp_ = SduiParsers.parseIconProp_
local parseTypographyTokenProp_ = SduiParsers.parseTypographyTokenProp_
local parseColorTokenProp_ = SduiParsers.parseColorTokenProp_
local parseImageSetOrImageProp_ = SduiParsers.parseImageSetOrImageProp_
local parseStringProp_ = SduiParsers.parseStringProp_
local parseFocusNavActionsProp_ = SduiParsers.parseFocusNavActionsProp_

local getArrayMetatableParser = SduiParsers.getArrayMetatableParser
local getEngineEnumParser = SduiParsers.getEngineEnumParser
local getLuaTableEnumParser = SduiParsers.getLuaTableEnumParser
local Flags = require(ServerDrivenUi.Flags)
local FFlagSduiTileDisableLegacyHover = Flags.FFlagSduiTileDisableLegacyHover
local Flags2 = require(ServerDrivenUi.Flags)
local FFlagSduiEnableHeroUnitBottomRow = Flags2.FFlagSduiEnableHeroUnitBottomRow
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiAttributionRowV2 = SharedFlags2.FFlagSduiAttributionRowV2
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiExperienceDetailsSocialProof = SharedFlags3.FFlagSduiExperienceDetailsSocialProof
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiChipAccessoryProps = SharedFlags4.FFlagSduiChipAccessoryProps
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppDismissUnlockUpsell = SharedFlags5.FFlagLuaAppDismissUnlockUpsell
local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags6.FFlagLuaAppSduiGameTileFeedback
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiGameTileDirectAction = SharedFlags7.FFlagSduiGameTileDirectAction
local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiOptionSelectorCollection = SharedFlags8.FFlagSduiOptionSelectorCollection

local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiCollectionCarouselPlaceholderItem = SharedFlags9.FFlagSduiCollectionCarouselPlaceholderItem
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags10.FFlagSduiCollectionGridRevealRows
local SharedFlags11 = require(parent.SharedFlags)
local FFlagSduiIndividualFeedItemSpacing = SharedFlags11.FFlagSduiIndividualFeedItemSpacing

local SharedFlags12 = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocompleteSuggestionComponent = SharedFlags12.FFlagLuaAppSduiSearchAutocompleteSuggestionComponent
local FFlagLuaAppHeroUnitSecondaryLabelText = require(ServerDrivenUi.FFlagLuaAppHeroUnitSecondaryLabelText)

local v = {}

local SduiComponentDefinitions = {}
SduiComponentDefinitions.__index = SduiComponentDefinitions

function SduiComponentDefinitions.new()
	local iconOverrides = {
		anchorPoint = parseVector2Prop_,
		automaticSize = getEngineEnumParser(Enum.AutomaticSize),
		backgroundColor3 = parseColor3Prop_,
		backgroundTransparency = parseNumberProp_,
		layoutOrder = parseIntegerProp_,
		position = parseUDim2Prop_,
		size = parseUDim2Prop_,
		zIndex = parseNumberProp_
	}

	local v2 = Cryo.Dictionary.union({
		richText = parseBooleanProp_,
		text = parseStringProp_,
		textTruncate = getEngineEnumParser(Enum.TextTruncate),
		textWrapped = parseBooleanProp_,
		textXAlignment = getEngineEnumParser(Enum.TextXAlignment),
		textYAlignment = getEngineEnumParser(Enum.TextYAlignment)
	}, iconOverrides)

	local v3 = {
		columnGap = parseNumberProp_,
		sideMargin = parseNumberProp_,
		numColumns = parseNumberProp_,
		fractionalItemAmount = parseNumberProp_,
		loadMoreThreshold = parseNumberProp_,
		verticalGap = parseNumberProp_
	}

	local v4 = { _registeredComponents = 0 }

	local v5 = SduiComponentType.AttributionRow
	local SduiSharedContent = require(parent.SduiSharedContent)
	local v6 = {
		component = SduiSharedContent.SduiAttributionRow,
		propParsers = 0,
		propInterface = 0
	}
	local propParsers = {
		layoutOrder = parseIntegerProp_,
		position = parseUDim2Prop_,
		size = nil,
		onActivated = nil,
		rightButtonContent = nil,
		title = nil,
		titleFontStyle = nil,
		titleTextColor = nil,
		subtitle = nil,
		subtitleFontStyle = nil,
		subtitleTextColor = nil,
		subtitleIconName = 0,
		subtitleIconSize = 0,
		subtitleIconStyle = 0,
		subtitleIconVariant = 0,
		subtitleBackgroundIconName = 0,
		subtitleBackgroundIconStyle = 0,
		subtitleOnActivated = 0,
		caption = 0,
		captionTextColor = 0,
		captionFontStyle = 0,
		textContainerSize = 0,
		image = 0,
		imageSize = 0
	}
	local v7

	if FFlagSduiAttributionRowV2 then
		v7 = parseUDim2Prop_
	end

	propParsers.size = v7
	propParsers.onActivated = parseCallbackProp_
	propParsers.rightButtonContent = parseUiComponentProp_
	v7 = if FFlagSduiAttributionRowV2 then parseStringProp_ else nil
	propParsers.title = v7

	if FFlagSduiAttributionRowV2 then
		v7 = parseTypographyTokenProp_
	else
		v7 = nil
	end

	propParsers.titleFontStyle = v7
	v7 = if FFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	propParsers.titleTextColor = v7
	v7 = if FFlagSduiAttributionRowV2 then parseStringProp_ else nil
	propParsers.subtitle = v7

	if FFlagSduiAttributionRowV2 then
		v7 = parseTypographyTokenProp_
	else
		v7 = nil
	end

	propParsers.subtitleFontStyle = v7
	v7 = if FFlagSduiAttributionRowV2 then parseColor3Prop_ else nil
	propParsers.subtitleTextColor = v7

	if FFlagSduiAttributionRowV2 then
		v7 = getLuaTableEnumParser(Foundation.Enums.IconName, "string")
	else
		v7 = nil
	end

	propParsers.subtitleIconName = v7

	if FFlagSduiAttributionRowV2 then
		v7 = getLuaTableEnumParser(Foundation.Enums.IconSize, "string")
	else
		v7 = nil
	end

	propParsers.subtitleIconSize = v7
	v7 = if FFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	propParsers.subtitleIconStyle = v7

	if FFlagSduiAttributionRowV2 then
		v7 = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string")
	else
		v7 = nil
	end

	propParsers.subtitleIconVariant = v7

	if FFlagSduiAttributionRowV2 then
		v7 = getLuaTableEnumParser(Foundation.Enums.IconName, "string")
	else
		v7 = nil
	end

	propParsers.subtitleBackgroundIconName = v7
	v7 = if FFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	propParsers.subtitleBackgroundIconStyle = v7
	v7 = if FFlagSduiAttributionRowV2 then parseCallbackProp_ else nil
	propParsers.subtitleOnActivated = v7
	v7 = if FFlagSduiAttributionRowV2 then parseStringProp_ else nil
	propParsers.caption = v7
	v7 = if FFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	propParsers.captionTextColor = v7

	if FFlagSduiAttributionRowV2 then
		v7 = parseTypographyTokenProp_
	else
		v7 = nil
	end

	propParsers.captionFontStyle = v7
	v7 = if FFlagSduiAttributionRowV2 then parseUDim2Prop_ else nil
	propParsers.textContainerSize = v7

	propParsers.image = parseImageStringProp_
	v7 = if FFlagSduiAttributionRowV2 then parseUDim2Prop_ else nil
	propParsers.imageSize = v7
	v6.propParsers = propParsers

	v6.propInterface = FFlagSduiAttributionRowV2 and { title = t.string, subtitle = t.string } or nil
	local registeredComponents2 = { [v5] = v6 }

	v5 = SduiComponentType.Button
	local SduiSharedContent2 = require(parent.SduiSharedContent)
	registeredComponents2[v5] = {
		component = SduiSharedContent2.SduiButton,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			cursorType = getLuaTableEnumParser(Foundation.Enums.CursorType, "string"),
			fillBehavior = getLuaTableEnumParser(Foundation.Enums.FillBehavior, "string"),
			icon = parseIconProp_,
			inputDelay = parseNumberProp_,
			isDisabled = parseBooleanProp_,
			isLoading = parseBooleanProp_,
			layoutOrder = parseIntegerProp_,
			onActivated = parseCallbackProp_,
			position = parseUDim2Prop_,
			selectable = parseBooleanProp_,
			size = getLuaTableEnumParser(Foundation.Enums.InputSize, "string"),
			tag = parseStringProp_,
			testId = parseStringProp_,
			text = parseStringProp_,
			variant = getLuaTableEnumParser(Foundation.Enums.ButtonVariant, "string"),
			visible = parseBooleanProp_,
			width = parseUDimProp_,
			zIndex = parseNumberProp_
		}
	}

	v5 = SduiComponentType.CollectionCarousel
	local v8 = {
		component = require(ServerDrivenUi.Content.Collections.SduiCollectionCarousel),
		propParsers = 0
	}
	local propParsers2 = {
		anchorPoint = parseVector2Prop_,
		position = parseUDim2Prop_,
		size = parseUDim2Prop_,
		collectionItemSize = getLuaTableEnumParser(CollectionItemSize, "string"),
		itemHeightFromWidth = parseUDimProp_,
		headerComponent = parseUiComponentProp_,
		itemHeightMode = getLuaTableEnumParser(ItemHeightMode, "string"),
		layoutOverrides = v3,
		numColumnsOverride = parseNumberProp_,
		scrollingEnabledOverride = parseBooleanProp_,
		maxItemsToShow = parseNumberProp_,
		shouldUseFrameBoundsForImpressions = parseBooleanProp_,
		respectClipAncestors = 0,
		backgroundMuralUrl = 0,
		onScrollToEnd = 0,
		scrollThresholdFromEnd = 0,
		itemTemplateKey = 0,
		focusNavActionsComponent = 0,
		disableSelectionOrder = 0,
		numItemsToRenderOffScreen = 0,
		items = 0,
		impressionEventName = 0,
		skipItemImpressionsLog = 0,
		enableHoverOverflow = 0
	}

	if FFlagLuaAppRespectClipAncestorImpressions then
		v7 = parseBooleanProp_
	else
		v7 = nil
	end

	propParsers2.respectClipAncestors = v7
	propParsers2.backgroundMuralUrl = parseImageStringProp_
	propParsers2.onScrollToEnd = parseCallbackProp_
	propParsers2.scrollThresholdFromEnd = parseNumberProp_
	propParsers2.itemTemplateKey = parseStringProp_
	propParsers2.focusNavActionsComponent = parseUiComponentProp_
	propParsers2.disableSelectionOrder = parseBooleanProp_
	propParsers2.numItemsToRenderOffScreen = parseNumberProp_
	propParsers2.items = getArrayMetatableParser(parseLazyUiComponentProp_)
	propParsers2.impressionEventName = parseStringProp_
	propParsers2.skipItemImpressionsLog = parseBooleanProp_
	propParsers2.enableHoverOverflow = parseBooleanProp_
	v8.propParsers = propParsers2
	registeredComponents2[v5] = v8

	v5 = SduiComponentType.VariableItemWidthCarousel
	registeredComponents2[v5] = {
		component = require(ServerDrivenUi.Content.Collections.SduiVariableItemWidthCarousel)
	}

	v5 = SduiComponentType.CollectionCarouselPlaceholder
	registeredComponents2[v5] = {
		component = require(ServerDrivenUi.Content.Collections.SduiCollectionCarouselPlaceholder)
	}

	v5 = SduiComponentType.PlaceholderTile

	if FFlagSduiCollectionCarouselPlaceholderItem then
		v7 = { component = 0 }
		local SduiSharedContent3 = require(parent.SduiSharedContent)
		v7.component = SduiSharedContent3.SduiPlaceholderTile
	else
		v7 = nil
	end

	registeredComponents2[v5] = v7

	v5 = SduiComponentType.OptionSelectorCollection

	if FFlagSduiOptionSelectorCollection then
		v7 = { component = 0 }
		v7.component = require(ServerDrivenUi.Content.Collections.SduiOptionSelectorCollection)
	else
		v7 = nil
	end

	registeredComponents2[v5] = v7

	v5 = SduiComponentType.CollectionGrid
	registeredComponents2[v5] = {
		component = require(ServerDrivenUi.Content.Collections.SduiCollectionGrid),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			bufferRowsBelowScreen = parseNumberProp_,
			bufferRowsAboveScreen = parseNumberProp_,
			collectionItemSize = getLuaTableEnumParser(CollectionItemSize, "string"),
			disableRelativeGap = parseBooleanProp_,
			focusNavActionsComponent = parseUiComponentProp_,
			headerComponent = parseUiComponentProp_,
			itemHeightFromWidth = parseUDimProp_,
			itemTemplateKey = parseStringProp_,
			layoutOverrides = v3,
			maxNumRows = parseNumberProp_,
			shouldUseFrameBoundsForImpressions = parseBooleanProp_,
			disableSelectionOrder = parseBooleanProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			thresholdRowsFromBottom = parseNumberProp_,
			onReachedThresholdFromEnd = parseCallbackProp_,
			impressionEventName = parseStringProp_,
			skipItemImpressionsLog = parseBooleanProp_
		},
		propInterface = { itemHeightFromWidth = t.UDim }
	}

	v3 = SduiComponentType.RevealRowsButtonWithDivider

	if FFlagSduiCollectionGridRevealRows then
		v5 = { component = 0 }
		v5.component = require(ServerDrivenUi.Content.Collections.SduiRevealRowsButtonWithDivider)
	else
		v5 = nil
	end

	registeredComponents2[v3] = v5

	v3 = SduiComponentType.Dialog
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiDialog),
		propParsers = {
			size = getLuaTableEnumParser(Foundation.Enums.DialogSize, "string"),
			image = parseStringProp_,
			imageAspectRatio = parseNumberProp_,
			titleText = parseStringProp_,
			bodyText = parseStringProp_,
			bodyComponent = parseUiComponentProp_,
			actionsLabel = parseStringProp_,
			actionsOrientation = getLuaTableEnumParser(Foundation.Enums.Orientation, "string"),
			primaryButtonAction = parseCallbackProp_,
			primaryButtonText = parseStringProp_,
			primaryButtonIcon = parseIconProp_,
			primaryButtonInputDelay = parseNumberProp_,
			primaryButtonSideEffectAction = parseCallbackProp_,
			secondaryButtonAction = parseCallbackProp_,
			secondaryButtonText = parseStringProp_,
			secondaryButtonIcon = parseIconProp_,
			secondaryButtonInputDelay = parseNumberProp_,
			secondaryButtonSideEffectAction = parseCallbackProp_,
			onClose = parseCallbackProp_,
			disablePortal = parseBooleanProp_,
			hasBackdrop = parseBooleanProp_
		}
	}

	v3 = SduiComponentType.Divider
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiDivider),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			backgroundColor3 = parseColor3Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_
		}
	}

	v3 = SduiComponentType.FocusNavActions
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.FocusNavigation.SduiFocusNavActions),
		propParsers = { focusNavActions = parseFocusNavActionsProp_ },
		propInterface = { focusNavActions = t.table }
	}

	registeredComponents2[SduiComponentType.Fragment] = { component = React.Fragment }

	v3 = SduiComponentType.GameTileActiveFriendsFooter
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiGameTileActiveFriendsFooter),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			backgroundColor3 = parseColor3Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			universeId = parseStringProp_,
			iconWidth = parseNumberProp_,
			maxAvatars = parseNumberProp_,
			onActivated = parseCallbackProp_
		},
		propInterface = { universeId = t.union(t.string, t.number) }
	}

	v3 = SduiComponentType.HeroUnit
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiHeroUnit),
		propParsers = {
			backgroundComponent = parseUiComponentProp_,
			bottomRowComponent = parseUiComponentProp_,
			ctaButtonComponent = parseUiComponentProp_,
			gradient = parseGradientProp_,
			headerComponent = parseUiComponentProp_,
			onActivated = parseCallbackProp_,
			overlayComponent = parseUiComponentProp_,
			backgroundImage = parseImageStringProp_,
			foregroundImage = parseImageStringProp_,
			titleImage = parseImageStringProp_
		}
	}

	v3 = SduiComponentType.HoldToPlay
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.FocusNavigation.SduiHoldToPlay),
		propParsers = { universeId = parseStringProp_, placeId = parseStringProp_ },
		propInterface = { universeId = t.union(t.string, t.number) }
	}

	v3 = SduiComponentType.Image
	local SduiSharedContent3 = require(parent.SduiSharedContent)
	registeredComponents2[v3] = {
		component = SduiSharedContent3.SduiImage,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			aspectRatio = parseNumberProp_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			backgroundStyle = parseColorTokenProp_,
			clipsDescendants = parseBooleanProp_,
			cornerRadius = parseUDimProp_,
			cursorType = getLuaTableEnumParser(Foundation.Enums.CursorType, "string"),
			image = parseImageStringProp_,
			imageStyle = parseColorTokenProp_,
			layoutOrder = parseIntegerProp_,
			onActivated = parseCallbackProp_,
			position = parseUDim2Prop_,
			resampleMode = getEngineEnumParser(Enum.ResamplerMode),
			scaleType = getEngineEnumParser(Enum.ScaleType),
			size = parseUDim2Prop_,
			sizeConstraint = getEngineEnumParser(Enum.SizeConstraint),
			tag = parseStringProp_,
			tileSize = parseUDim2Prop_,
			visible = parseBooleanProp_,
			zIndex = parseNumberProp_
		}
	}

	v3 = SduiComponentType.SingleItemCollection
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiSingleItemCollection),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			item = parseLazyUiComponentProp_,
			impressionEventName = parseStringProp_,
			skipItemImpressionsLog = parseBooleanProp_
		}
	}

	v3 = SduiComponentType.PlayButton
	local SduiSharedContent4 = require(parent.SduiSharedContent)
	registeredComponents2[v3] = {
		component = SduiSharedContent4.SduiPlayButton,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			tag = parseStringProp_,
			width = parseUDimProp_,
			onActivatedEffect = parseCallbackProp_
		},
		propInterface = { universeId = t.union(t.string, t.number) }
	}

	v3 = SduiComponentType.SectionHeader
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiSectionHeader),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			iconComponent = parseUiComponentProp_,
			infoText = parseStringProp_,
			onTitleActivated = parseCallbackProp_,
			onSubtitleActivated = parseCallbackProp_,
			onInfoIconActivated = parseCallbackProp_,
			subtitleColor = parseColor3Prop_,
			subtitleComponent = parseUiComponentProp_,
			subtitleIcon = parseIconProp_,
			subtitleIconWidth = parseNumberProp_,
			subtitleFontStyle = parseTypographyTokenProp_,
			subtitleGap = parseNumberProp_,
			subtitleText = parseStringProp_,
			titleColor = parseColor3Prop_,
			titleComponent = parseUiComponentProp_,
			titleGap = parseNumberProp_,
			titleIcon = parseIconProp_,
			titleIconWidth = parseNumberProp_,
			titleFontStyle = parseTypographyTokenProp_,
			titleText = parseStringProp_,
			verticalGap = parseNumberProp_,
			allowInteractionForDirectionalInput = parseBooleanProp_
		}
	}

	v3 = SduiComponentType.SearchAutocompleteSuggestion

	if FFlagLuaAppSduiSearchAutocompleteSuggestionComponent then
		v5 = { component = 0, propInterface = 0 }
		v5.component = require(ServerDrivenUi.Content.SduiSearchAutocompleteSuggestion)
		v5.propInterface = { title = t.string, isRich = t.optional(t.boolean) }
	else
		v5 = nil
	end

	registeredComponents2[v3] = v5

	v3 = SduiComponentType.SeeAllTile
	local GameCollections = require(parent.GameCollections)
	registeredComponents2[v3] = {
		component = GameCollections.SeeAllTile,
		propParsers = {
			layoutOrder = parseNumberProp_,
			size = parseUDim2Prop_,
			onActivated = parseCallbackProp_,
			icon = parseIconProp_,
			title = parseStringProp_
		}
	}

	v3 = SduiComponentType.SlotOverlay
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiSlotOverlay),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			topLeftSlot = parseUiComponentProp_,
			topMiddleSlot = parseUiComponentProp_,
			topRightSlot = parseUiComponentProp_,
			centerLeftSlot = parseUiComponentProp_,
			centerMiddleSlot = parseUiComponentProp_,
			centerRightSlot = parseUiComponentProp_,
			bottomLeftSlot = parseUiComponentProp_,
			bottomMiddleSlot = parseUiComponentProp_,
			bottomRightSlot = parseUiComponentProp_,
			padding = parseNumberProp_
		}
	}

	v3 = SduiComponentType.Text
	local SduiSharedContent5 = require(parent.SduiSharedContent)
	registeredComponents2[v3] = {
		component = SduiSharedContent5.SduiText,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			aspectRatio = parseNumberProp_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			backgroundStyle = parseColorTokenProp_,
			children = parseUiComponentProp_,
			cornerRadius = parseUDimProp_,
			cursorType = getLuaTableEnumParser(Foundation.Enums.CursorType, "string"),
			fontStyle = parseTypographyTokenProp_,
			isDisabled = parseBooleanProp_,
			layoutOrder = parseIntegerProp_,
			onActivated = parseCallbackProp_,
			onSecondaryActivated = parseCallbackProp_,
			padding = parseNumberProp_,
			position = parseUDim2Prop_,
			richText = parseBooleanProp_,
			rotation = parseNumberProp_,
			scale = parseNumberProp_,
			selectable = parseBooleanProp_,
			size = parseUDim2Prop_,
			sizeConstraint = getEngineEnumParser(Enum.SizeConstraint),
			tag = parseStringProp_,
			testId = parseStringProp_,
			text = parseStringProp_,
			textStyle = parseColorTokenProp_,
			textTruncate = getEngineEnumParser(Enum.TextTruncate),
			textWrapped = parseBooleanProp_,
			textXAlignment = getEngineEnumParser(Enum.TextXAlignment),
			textYAlignment = getEngineEnumParser(Enum.TextYAlignment),
			visible = parseBooleanProp_,
			zIndex = parseNumberProp_
		}
	}

	v3 = SduiComponentType.TextIconRow
	registeredComponents2[v3] = {
		component = require(ServerDrivenUi.Content.SduiTextIconRow),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			selectable = parseBooleanProp_,
			size = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			iconFirst = parseBooleanProp_,
			onActivated = parseCallbackProp_,
			text = parseStringProp_,
			textColor = parseColor3Prop_,
			fontStyle = parseTypographyTokenProp_,
			gap = parseNumberProp_,
			icon = parseIconProp_,
			iconWidth = parseNumberProp_,
			iconColor = parseColor3Prop_,
			textOverrides = v2,
			iconOverrides = iconOverrides,
			textFlexMode = getEngineEnumParser(Enum.UIFlexMode),
			backgroundStyle = parseColorTokenProp_,
			cornerRadius = parseUDimProp_
		}
	}

	iconOverrides = SduiComponentType.TextPill
	registeredComponents2[iconOverrides] = {
		component = require(ServerDrivenUi.Content.SduiTextPill),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			backgroundColor3 = parseColor3Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			textColor3 = parseColor3Prop_,
			fontStyle = parseTypographyTokenProp_
		}
	}

	iconOverrides = SduiComponentType.Tile
	local v9 = {
		component = require(ServerDrivenUi.Content.SduiTile),
		propParsers = 0
	}
	local propParsers3 = {
		anchorPoint = parseVector2Prop_,
		automaticSize = getEngineEnumParser(Enum.AutomaticSize),
		backgroundColor3 = parseColor3Prop_,
		layoutOrder = parseNumberProp_,
		position = parseUDim2Prop_,
		selectionOrder = parseNumberProp_,
		size = parseUDim2Prop_,
		zIndex = parseNumberProp_,
		backgroundImage = parseImageSetOrImageProp_,
		backgroundImageComponent = parseUiComponentProp_,
		backgroundStyle = parseColorTokenProp_,
		containmentPadding = parseNumberProp_,
		cornerRadius = parseNumberProp_,
		ctaButtonComponent = parseUiComponentProp_,
		footerComponent = parseUiComponentProp_,
		image = parseImageStringProp_,
		imageAspectRatio = parseNumberProp_,
		imageComponent = parseUiComponentProp_,
		isContained = parseBooleanProp_,
		onActivated = parseCallbackProp_,
		thumbnailBackgroundStyle = parseColorTokenProp_,
		thumbnailOverlayComponent = parseUiComponentProp_,
		titleComponent = parseUiComponentProp_,
		titleFont = parseTypographyTokenProp_,
		titleLines = parseIntegerProp_,
		titleText = parseStringProp_,
		enableLegacyHoverState = 0,
		focusNavActionsComponent = 0,
		bottomButtonComponent = 0,
		bottomButtonGap = 0,
		holdActionConfig = 0
	}

	if FFlagSduiTileDisableLegacyHover then
		v2 = nil
	else
		v2 = parseBooleanProp_
	end

	propParsers3.enableLegacyHoverState = v2
	propParsers3.focusNavActionsComponent = parseUiComponentProp_
	propParsers3.bottomButtonComponent = parseUiComponentProp_
	propParsers3.bottomButtonGap = parseNumberProp_
	propParsers3.holdActionConfig = {
		onHoldCompleted = parseCallbackProp_,
		focusNavigationEventName = parseStringProp_,
		keyCode = getEngineEnumParser(Enum.KeyCode)
	}
	v9.propParsers = propParsers3
	registeredComponents2[iconOverrides] = v9

	iconOverrides = SduiComponentType.TileFooter
	registeredComponents2[iconOverrides] = {
		component = require(ServerDrivenUi.Content.SduiTileFooter),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			selectable = parseBooleanProp_,
			size = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			sectionGap = parseNumberProp_,
			textIconGap = parseNumberProp_,
			fontStyle = parseTypographyTokenProp_,
			iconColor = parseColor3Prop_,
			iconWidth = parseNumberProp_,
			leftIcon = parseIconProp_,
			leftIconComponent = parseUiComponentProp_,
			leftText = parseStringProp_,
			leftTextFlexMode = getEngineEnumParser(Enum.UIFlexMode),
			onActivated = parseCallbackProp_,
			rightIcon = parseIconProp_,
			rightIconComponent = parseUiComponentProp_,
			rightText = parseStringProp_,
			rightTextFlexMode = getEngineEnumParser(Enum.UIFlexMode),
			textColor = parseColor3Prop_
		}
	}

	iconOverrides = SduiComponentType.View
	local SduiSharedContent6 = require(parent.SduiSharedContent)
	registeredComponents2[iconOverrides] = {
		component = SduiSharedContent6.SduiView,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			aspectRatio = parseNumberProp_,
			automaticSize = getEngineEnumParser(Enum.AutomaticSize),
			backgroundStyle = parseColorTokenProp_,
			children = parseUiComponentProp_,
			clipsDescendants = parseBooleanProp_,
			cornerRadius = parseUDimProp_,
			cursorType = getLuaTableEnumParser(Foundation.Enums.CursorType, "string"),
			groupTransparency = parseNumberProp_,
			isDisabled = parseBooleanProp_,
			layoutOrder = parseIntegerProp_,
			onActivated = parseCallbackProp_,
			onSecondaryActivated = parseCallbackProp_,
			padding = parseNumberProp_,
			position = parseUDim2Prop_,
			rotation = parseNumberProp_,
			scale = parseNumberProp_,
			selectable = parseBooleanProp_,
			selectionGroup = parseBooleanProp_,
			size = parseUDim2Prop_,
			sizeConstraint = getEngineEnumParser(Enum.SizeConstraint),
			tag = parseStringProp_,
			testId = parseStringProp_,
			visible = parseBooleanProp_,
			zIndex = parseNumberProp_
		}
	}
	v4._registeredComponents = registeredComponents2

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.CountdownTextIconRow
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.SduiCountdownTextIconRow),
		propParsers = Cryo.Dictionary.join(v4._registeredComponents[SduiComponentType.TextIconRow], {
			endTimestamp = parseNumberProp_,
			formatStringHoursMinutes = parseStringProp_,
			defaultString = parseStringProp_
		})
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.GameTile
	local v10 = {
		component = require(ServerDrivenUi.Content.SduiGameTile),
		propParsers = 0,
		propInterface = 0
	}
	v3 = Cryo.Dictionary.join
	v5 = v4._registeredComponents[SduiComponentType.Tile].propParsers
	local v11 = {
		universeId = parseStringProp_,
		placeId = parseStringProp_,
		collectionId = nil,
		hiddenStateComponent = nil,
		overflowMenuComponent = nil,
		directActionComponent = nil,
		disableHoldToPlay = nil,
		ratingText = nil,
		playerCount = nil
	}

	if FFlagLuaAppSduiGameTileFeedback then
		v7 = parseStringProp_
	else
		v7 = nil
	end

	v11.collectionId = v7

	if FFlagLuaAppSduiGameTileFeedback then
		v7 = parseLazyUiComponentProp_
	else
		v7 = nil
	end

	v11.hiddenStateComponent = v7

	if FFlagLuaAppSduiGameTileFeedback then
		v7 = parseLazyUiComponentProp_
	else
		v7 = nil
	end

	v11.overflowMenuComponent = v7

	if FFlagSduiGameTileDirectAction then
		v7 = parseLazyUiComponentProp_
	else
		v7 = nil
	end

	v11.directActionComponent = v7
	v11.disableHoldToPlay = parseBooleanProp_
	v11.ratingText = parseStringProp_
	v11.playerCount = parseNumberProp_
	v10.propParsers = v3(v5, v11)

	v10.propInterface = {
		universeId = t.union(t.string, t.number),
		placeId = t.union(t.string, t.number)
	}
	iconOverrides[v2] = v10

	if FFlagLuaAppSduiGameTileFeedback then
		local registeredComponents = v4._registeredComponents
		local gameTileHiddenState = SduiComponentType.GameTileHiddenState
		registeredComponents[gameTileHiddenState] = {
			component = require(ServerDrivenUi.Content.SduiGameTileHiddenState)
		}
	end

	if FFlagSduiEnableHeroUnitBottomRow then
		local registeredComponents = v4._registeredComponents
		local heroUnitBottomRow = SduiComponentType.HeroUnitBottomRow
		local v12 = {
			component = require(ServerDrivenUi.Content.SduiHeroUnitBottomRow),
			propParsers = 0
		}
		local propParsers4 = {
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			ctaButton = parseUiComponentProp_,
			labelText = parseStringProp_,
			secondaryLabelText = nil,
			rightLabelContent = nil
		}
		local secondaryLabelText

		if FFlagLuaAppHeroUnitSecondaryLabelText then
			secondaryLabelText = parseStringProp_
		end

		propParsers4.secondaryLabelText = secondaryLabelText
		propParsers4.rightLabelContent = parseUiComponentProp_
		v12.propParsers = propParsers4
		registeredComponents[heroUnitBottomRow] = v12
	end

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.Chip
	local SduiSharedContent7 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent7.SduiChip,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			text = parseStringProp_,
			leadingIconName = parseStringProp_,
			leadingIconVariant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
			leadingIsCircular = parseBooleanProp_,
			leadingOnActivated = parseCallbackProp_,
			trailingIconName = parseStringProp_,
			trailingIconVariant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
			trailingIsCircular = parseBooleanProp_,
			trailingOnActivated = parseCallbackProp_,
			onActivated = parseCallbackProp_,
			isChecked = parseBooleanProp_,
			size = getLuaTableEnumParser(Foundation.Enums.ChipSize, "string")
		},
		propInterface = FFlagSduiChipAccessoryProps and {
			leading = t.optional(t.table),
			trailing = t.optional(t.table)
		} or nil
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.DualActionChip
	local SduiSharedContent8 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent8.SduiDualActionChip,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			text = parseStringProp_,
			leadingIconName = parseStringProp_,
			leadingIconVariant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
			leadingOnActivated = parseCallbackProp_,
			trailingIconName = parseStringProp_,
			trailingIconVariant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
			trailingOnActivated = parseCallbackProp_
		}
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.AssociatedItemsRow
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.SduiAssociatedItemsRow),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			footerComponent = parseUiComponentProp_
		}
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceAssociatedItemsRow
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceAssociatedItemsRow),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			universeId = parseStringProp_
		},
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsVoteChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsVoteChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsFavoriteChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsFavoriteChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsNotifyChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsNotifyChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsActiveChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsActiveChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsShareChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsShareChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExperienceDetailsReportChip
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsReportChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	if FFlagSduiExperienceDetailsSocialProof then
		local registeredComponents = v4._registeredComponents
		local v12 = SduiComponentType.ExperienceDetailsConnectionsPlayedChip
		registeredComponents[v12] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedChip),
			propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
			propInterface = { universeId = t.string }
		}

		registeredComponents = v4._registeredComponents
		v12 = SduiComponentType.ExperienceDetailsConnectionsPlayedTextRow
		registeredComponents[v12] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedTextRow),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				universeId = parseStringProp_,
				name = parseStringProp_
			},
			propInterface = { universeId = t.string, name = t.optional(t.string) }
		}
	end

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.VerticalFeed
	local SduiSharedContent9 = require(parent.SduiSharedContent)
	local v12 = { component = SduiSharedContent9.SduiVerticalFeed, propParsers = 0 }
	local propParsers4 = {
		layoutOrder = parseIntegerProp_,
		feedItems = getArrayMetatableParser(parseLazyUiComponentProp_),
		gapBetweenFeedItems = parseNumberProp_,
		gapAfterFirstFeedItem = 0,
		thresholdFromEnd = 0,
		onScrollToEnd = 0,
		onRefresh = 0,
		stickyItems = 0,
		gapAfterStickyItems = 0,
		gapBetweenStickyItems = 0,
		stickyPaddingTop = 0,
		stickyPaddingBottom = 0,
		stickyBackgroundStyle = 0,
		stickyContentTag = 0,
		backgroundStyle = 0
	}

	if FFlagSduiIndividualFeedItemSpacing then
		v3 = parseNumberProp_
	else
		v3 = nil
	end

	propParsers4.gapAfterFirstFeedItem = v3
	propParsers4.thresholdFromEnd = parseNumberProp_
	propParsers4.onScrollToEnd = parseCallbackProp_
	propParsers4.onRefresh = parseCallbackProp_
	propParsers4.stickyItems = getArrayMetatableParser(parseUiComponentProp_)
	propParsers4.gapAfterStickyItems = parseIntegerProp_
	propParsers4.gapBetweenStickyItems = parseIntegerProp_
	propParsers4.stickyPaddingTop = parseIntegerProp_
	propParsers4.stickyPaddingBottom = parseIntegerProp_
	propParsers4.stickyBackgroundStyle = parseColorTokenProp_
	propParsers4.stickyContentTag = parseStringProp_
	propParsers4.backgroundStyle = parseColorTokenProp_
	v12.propParsers = propParsers4
	iconOverrides[v2] = v12

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.BadgeTile
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.SduiBadgeTile),
		propParsers = Cryo.Dictionary.join(v4._registeredComponents[SduiComponentType.Tile].propParsers, {
			imageCornerRadius = parseNumberProp_,
			imagePadding = parseNumberProp_
		})
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.Badge
	local SduiSharedContent10 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent10.SduiBadge,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			visible = parseBooleanProp_,
			zIndex = parseNumberProp_,
			text = parseStringProp_,
			icon = parseStringProp_,
			variant = getLuaTableEnumParser(Foundation.Enums.BadgeVariant, "string")
		}
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.SongTile
	iconOverrides[v2] = {
		component = require(ServerDrivenUi.Content.SduiSongTile)
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.InfoTable
	local SduiSharedContent11 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent11.SduiInfoTable,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			gridTag = parseStringProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			numColumns = parseIntegerProp_,
			tag = parseStringProp_
		},
		propInterface = { items = t.array(t.table) }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.InfoTableCell
	local AppBlox = require(parent.AppBlox)
	iconOverrides[v2] = {
		component = AppBlox.InfoTableCell,
		propParsers = {
			labelComponent = parseUiComponentProp_,
			isLastInSingleColumn = parseBooleanProp_,
			numColumns = parseIntegerProp_,
			onActivated = parseCallbackProp_,
			valueComponent = parseUiComponentProp_
		},
		propInterface = {
			labelComponent = t.table,
			valueComponent = t.table,
			isLastInSingleColumn = t.optional(t.boolean)
		}
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.ExpandableText
	local SduiSharedContent12 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent12.SduiExpandableText,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			text = parseStringProp_,
			compactNumberOfLines = parseIntegerProp_,
			fontStyle = parseTypographyTokenProp_,
			textStyle = parseColorTokenProp_,
			pressedTextStyle = parseColorTokenProp_,
			expandedInitially = parseBooleanProp_,
			avoidBlankLineClip = parseBooleanProp_,
			onExpandChanged = parseCallbackProp_,
			headerComponent = parseUiComponentProp_
		},
		propInterface = { text = t.string }
	}

	iconOverrides = v4._registeredComponents
	v2 = SduiComponentType.OverflowMenu
	local SduiSharedContent13 = require(parent.SduiSharedContent)
	iconOverrides[v2] = {
		component = SduiSharedContent13.SduiOverflowMenu,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			zIndex = parseNumberProp_,
			buttonVariant = getLuaTableEnumParser(Foundation.Enums.ButtonVariant, "string"),
			buttonSize = getLuaTableEnumParser(Foundation.Enums.InputSize, "string"),
			buttonIcon = getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
			buttonIconBackgroundStyle = parseColorTokenProp_,
			menuItemSize = getLuaTableEnumParser(Foundation.Enums.InputSize, "string"),
			popoverAlign = getLuaTableEnumParser(Foundation.Enums.PopoverAlign, "string"),
			popoverSide = getLuaTableEnumParser(Foundation.Enums.PopoverSide, "string"),
			menuWidth = parseUDimProp_
		},
		propInterface = { items = t.table }
	}

	if FFlagLuaAppDismissUnlockUpsell then
		local registeredComponents = v4._registeredComponents
		local ageCheckUpsellRow = SduiComponentType.AgeCheckUpsellRow
		registeredComponents[ageCheckUpsellRow] = {
			component = require(ServerDrivenUi.Content.SduiAgeCheckUpsellRow),
			propParsers = {
				leading = parseUiComponentProp_,
				content = parseUiComponentProp_,
				trailing = parseUiComponentProp_,
				onActivated = parseCallbackProp_,
				tag = parseStringProp_,
				leadingTag = parseStringProp_,
				contentTag = parseStringProp_,
				trailingTag = parseStringProp_,
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				zIndex = parseNumberProp_,
				testId = parseStringProp_
			}
		}
	end

	setmetatable(v4, SduiComponentDefinitions)
	return v4
end

function SduiComponentDefinitions:getComponentDefinition(p)
	return self._registeredComponents[p] or getSduiComponentRegistry().getComponentDefinition(p)
end

function SduiComponentDefinitions:doesComponentManageChildren(p)
	local componentDefinition = self:getComponentDefinition(p)
	return componentDefinition and componentDefinition.doesManageChildren or false
end

function SduiComponentDefinitions:getComponent(p)
	local componentDefinition = self:getComponentDefinition(p)
	return componentDefinition and componentDefinition.component
end

function SduiComponentDefinitions:getPropParsers(p)
	local componentDefinition = self:getComponentDefinition(p)
	return componentDefinition and componentDefinition.propParsers or v
end

function SduiComponentDefinitions:getPropInterface(p)
	local componentDefinition = self:getComponentDefinition(p)
	return componentDefinition and componentDefinition.propInterface or nil
end

local v2 = {
	[parseUiComponentProp_] = true,
	[parseCallbackProp_] = true,
	[parseFocusNavActionsProp_] = true
}

function SduiComponentDefinitions.doesParserRequireRenderContext(_, p): boolean
	if p and v2[p] then
		return true
	end

	return typeof(p) == "table"
end

function SduiComponentDefinitions:registerComponent(p, p2)
	self._registeredComponents[p] = p2
end

return SduiComponentDefinitions
