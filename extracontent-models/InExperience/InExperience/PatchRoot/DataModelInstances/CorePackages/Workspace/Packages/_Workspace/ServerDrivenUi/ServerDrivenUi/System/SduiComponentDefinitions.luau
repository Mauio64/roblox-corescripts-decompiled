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
local FFlagSduiExperienceDetailsSocialProof = SharedFlags2.FFlagSduiExperienceDetailsSocialProof
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiChipAccessoryProps = SharedFlags3.FFlagSduiChipAccessoryProps
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppDismissUnlockUpsell = SharedFlags4.FFlagLuaAppDismissUnlockUpsell
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags5.FFlagLuaAppSduiGameTileFeedback
local SharedFlags6 = require(parent.SharedFlags)
local FFlagSduiGameTileDirectAction = SharedFlags6.FFlagSduiGameTileDirectAction
local SharedFlags7 = require(parent.SharedFlags)
local FFlagSduiOptionSelectorCollection = SharedFlags7.FFlagSduiOptionSelectorCollection

local SharedFlags8 = require(parent.SharedFlags)
local FFlagSduiCollectionCarouselPlaceholderItem = SharedFlags8.FFlagSduiCollectionCarouselPlaceholderItem
local SharedFlags9 = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags9.FFlagSduiCollectionGridRevealRows
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSduiIndividualFeedItemSpacing = SharedFlags10.FFlagSduiIndividualFeedItemSpacing

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocompleteSuggestionComponent = SharedFlags11.FFlagLuaAppSduiSearchAutocompleteSuggestionComponent
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

	local union = Cryo.Dictionary.union({
		richText = parseBooleanProp_,
		text = parseStringProp_,
		textTruncate = getEngineEnumParser(Enum.TextTruncate),
		textWrapped = parseBooleanProp_,
		textXAlignment = getEngineEnumParser(Enum.TextXAlignment),
		textYAlignment = getEngineEnumParser(Enum.TextYAlignment)
	}, iconOverrides)

	local layoutOverrides = {
		columnGap = parseNumberProp_,
		sideMargin = parseNumberProp_,
		numColumns = parseNumberProp_,
		fractionalItemAmount = parseNumberProp_,
		loadMoreThreshold = parseNumberProp_,
		verticalGap = parseNumberProp_
	}

	local v2 = { _registeredComponents = 0 }

	local attributionRow = SduiComponentType.AttributionRow
	local SduiSharedContent = require(parent.SduiSharedContent)
	local registeredComponents22 = {
		[attributionRow] = {
			component = SduiSharedContent.SduiAttributionRow,
			propParsers = {
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				size = parseUDim2Prop_,
				onActivated = parseCallbackProp_,
				rightButtonContent = parseUiComponentProp_,
				title = parseStringProp_,
				titleFontStyle = parseTypographyTokenProp_,
				titleTextColor = parseColorTokenProp_,
				subtitle = parseStringProp_,
				subtitleFontStyle = parseTypographyTokenProp_,
				subtitleTextColor = parseColor3Prop_,
				subtitleIconName = getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
				subtitleIconSize = getLuaTableEnumParser(Foundation.Enums.IconSize, "string"),
				subtitleIconStyle = parseColorTokenProp_,
				subtitleIconVariant = getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
				subtitleBackgroundIconName = getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
				subtitleBackgroundIconStyle = parseColorTokenProp_,
				subtitleOnActivated = parseCallbackProp_,
				caption = parseStringProp_,
				captionTextColor = parseColorTokenProp_,
				captionFontStyle = parseTypographyTokenProp_,
				textContainerSize = parseUDim2Prop_,
				image = parseImageStringProp_,
				imageSize = parseUDim2Prop_
			},
			propInterface = { title = t.string, subtitle = t.string }
		}
	}

	local button = SduiComponentType.Button
	local SduiSharedContent2 = require(parent.SduiSharedContent)
	registeredComponents22[button] = {
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

	local collectionCarousel = SduiComponentType.CollectionCarousel
	local v3 = {
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
		layoutOverrides = layoutOverrides,
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
	local respectClipAncestors

	if FFlagLuaAppRespectClipAncestorImpressions then
		respectClipAncestors = parseBooleanProp_
	end

	propParsers2.respectClipAncestors = respectClipAncestors
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
	v3.propParsers = propParsers2
	registeredComponents22[collectionCarousel] = v3

	local variableItemWidthCarousel = SduiComponentType.VariableItemWidthCarousel
	registeredComponents22[variableItemWidthCarousel] = {
		component = require(ServerDrivenUi.Content.Collections.SduiVariableItemWidthCarousel)
	}

	local collectionCarouselPlaceholder = SduiComponentType.CollectionCarouselPlaceholder
	registeredComponents22[collectionCarouselPlaceholder] = {
		component = require(ServerDrivenUi.Content.Collections.SduiCollectionCarouselPlaceholder)
	}

	local placeholderTile = SduiComponentType.PlaceholderTile
	local v4

	if FFlagSduiCollectionCarouselPlaceholderItem then
		v4 = { component = 0 }
		local SduiSharedContent3 = require(parent.SduiSharedContent)
		v4.component = SduiSharedContent3.SduiPlaceholderTile
	end

	registeredComponents22[placeholderTile] = v4

	local optionSelectorCollection = SduiComponentType.OptionSelectorCollection
	local v5

	if FFlagSduiOptionSelectorCollection then
		v5 = { component = 0 }
		v5.component = require(ServerDrivenUi.Content.Collections.SduiOptionSelectorCollection)
	end

	registeredComponents22[optionSelectorCollection] = v5

	local collectionGrid = SduiComponentType.CollectionGrid
	registeredComponents22[collectionGrid] = {
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
			layoutOverrides = layoutOverrides,
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

	local revealRowsButtonWithDivider = SduiComponentType.RevealRowsButtonWithDivider
	local v6

	if FFlagSduiCollectionGridRevealRows then
		v6 = { component = 0 }
		v6.component = require(ServerDrivenUi.Content.Collections.SduiRevealRowsButtonWithDivider)
	end

	registeredComponents22[revealRowsButtonWithDivider] = v6

	local dialog = SduiComponentType.Dialog
	registeredComponents22[dialog] = {
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

	local divider = SduiComponentType.Divider
	registeredComponents22[divider] = {
		component = require(ServerDrivenUi.Content.SduiDivider),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			backgroundColor3 = parseColor3Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_
		}
	}

	local focusNavActions = SduiComponentType.FocusNavActions
	registeredComponents22[focusNavActions] = {
		component = require(ServerDrivenUi.FocusNavigation.SduiFocusNavActions),
		propParsers = { focusNavActions = parseFocusNavActionsProp_ },
		propInterface = { focusNavActions = t.table }
	}

	registeredComponents22[SduiComponentType.Fragment] = { component = React.Fragment }

	local gameTileActiveFriendsFooter = SduiComponentType.GameTileActiveFriendsFooter
	registeredComponents22[gameTileActiveFriendsFooter] = {
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

	local heroUnit = SduiComponentType.HeroUnit
	registeredComponents22[heroUnit] = {
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

	local holdToPlay = SduiComponentType.HoldToPlay
	registeredComponents22[holdToPlay] = {
		component = require(ServerDrivenUi.FocusNavigation.SduiHoldToPlay),
		propParsers = { universeId = parseStringProp_, placeId = parseStringProp_ },
		propInterface = { universeId = t.union(t.string, t.number) }
	}

	local image = SduiComponentType.Image
	local SduiSharedContent3 = require(parent.SduiSharedContent)
	registeredComponents22[image] = {
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

	local singleItemCollection = SduiComponentType.SingleItemCollection
	registeredComponents22[singleItemCollection] = {
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

	local playButton = SduiComponentType.PlayButton
	local SduiSharedContent4 = require(parent.SduiSharedContent)
	registeredComponents22[playButton] = {
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

	local sectionHeader = SduiComponentType.SectionHeader
	registeredComponents22[sectionHeader] = {
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

	local searchAutocompleteSuggestion = SduiComponentType.SearchAutocompleteSuggestion
	local v7

	if FFlagLuaAppSduiSearchAutocompleteSuggestionComponent then
		v7 = { component = 0, propInterface = 0 }
		v7.component = require(ServerDrivenUi.Content.SduiSearchAutocompleteSuggestion)
		v7.propInterface = { title = t.string, isRich = t.optional(t.boolean) }
	end

	registeredComponents22[searchAutocompleteSuggestion] = v7

	local seeAllTile = SduiComponentType.SeeAllTile
	local GameCollections = require(parent.GameCollections)
	registeredComponents22[seeAllTile] = {
		component = GameCollections.SeeAllTile,
		propParsers = {
			layoutOrder = parseNumberProp_,
			size = parseUDim2Prop_,
			onActivated = parseCallbackProp_,
			icon = parseIconProp_,
			title = parseStringProp_
		}
	}

	local slotOverlay = SduiComponentType.SlotOverlay
	registeredComponents22[slotOverlay] = {
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

	local text = SduiComponentType.Text
	local SduiSharedContent5 = require(parent.SduiSharedContent)
	registeredComponents22[text] = {
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

	local textIconRow = SduiComponentType.TextIconRow
	registeredComponents22[textIconRow] = {
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
			textOverrides = union,
			iconOverrides = iconOverrides,
			textFlexMode = getEngineEnumParser(Enum.UIFlexMode),
			backgroundStyle = parseColorTokenProp_,
			cornerRadius = parseUDimProp_
		}
	}

	local textPill = SduiComponentType.TextPill
	registeredComponents22[textPill] = {
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

	local tile = SduiComponentType.Tile
	local v8 = {
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
	local enableLegacyHoverState

	if not FFlagSduiTileDisableLegacyHover then
		enableLegacyHoverState = parseBooleanProp_
	end

	propParsers3.enableLegacyHoverState = enableLegacyHoverState
	propParsers3.focusNavActionsComponent = parseUiComponentProp_
	propParsers3.bottomButtonComponent = parseUiComponentProp_
	propParsers3.bottomButtonGap = parseNumberProp_
	propParsers3.holdActionConfig = {
		onHoldCompleted = parseCallbackProp_,
		focusNavigationEventName = parseStringProp_,
		keyCode = getEngineEnumParser(Enum.KeyCode)
	}
	v8.propParsers = propParsers3
	registeredComponents22[tile] = v8

	local tileFooter = SduiComponentType.TileFooter
	registeredComponents22[tileFooter] = {
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

	local view = SduiComponentType.View
	local SduiSharedContent6 = require(parent.SduiSharedContent)
	registeredComponents22[view] = {
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
	v2._registeredComponents = registeredComponents22

	local registeredComponents = v2._registeredComponents
	local countdownTextIconRow = SduiComponentType.CountdownTextIconRow
	registeredComponents[countdownTextIconRow] = {
		component = require(ServerDrivenUi.Content.SduiCountdownTextIconRow),
		propParsers = Cryo.Dictionary.join(v2._registeredComponents[SduiComponentType.TextIconRow], {
			endTimestamp = parseNumberProp_,
			formatStringHoursMinutes = parseStringProp_,
			defaultString = parseStringProp_
		})
	}

	local _registeredComponents = v2._registeredComponents
	local gameTile = SduiComponentType.GameTile
	local v9 = {
		component = require(ServerDrivenUi.Content.SduiGameTile),
		propParsers = 0,
		propInterface = 0
	}
	local join = Cryo.Dictionary.join
	local propParsers = v2._registeredComponents[SduiComponentType.Tile].propParsers
	local v10 = {
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
	local collectionId

	if FFlagLuaAppSduiGameTileFeedback then
		collectionId = parseStringProp_
	end

	v10.collectionId = collectionId
	local hiddenStateComponent

	if FFlagLuaAppSduiGameTileFeedback then
		hiddenStateComponent = parseLazyUiComponentProp_
	end

	v10.hiddenStateComponent = hiddenStateComponent
	local overflowMenuComponent

	if FFlagLuaAppSduiGameTileFeedback then
		overflowMenuComponent = parseLazyUiComponentProp_
	end

	v10.overflowMenuComponent = overflowMenuComponent
	local directActionComponent

	if FFlagSduiGameTileDirectAction then
		directActionComponent = parseLazyUiComponentProp_
	end

	v10.directActionComponent = directActionComponent
	v10.disableHoldToPlay = parseBooleanProp_
	v10.ratingText = parseStringProp_
	v10.playerCount = parseNumberProp_
	v9.propParsers = join(propParsers, v10)

	v9.propInterface = {
		universeId = t.union(t.string, t.number),
		placeId = t.union(t.string, t.number)
	}
	_registeredComponents[gameTile] = v9

	if FFlagLuaAppSduiGameTileFeedback then
		local registeredComponents2 = v2._registeredComponents
		local gameTileHiddenState = SduiComponentType.GameTileHiddenState
		registeredComponents2[gameTileHiddenState] = {
			component = require(ServerDrivenUi.Content.SduiGameTileHiddenState)
		}
	end

	if FFlagSduiEnableHeroUnitBottomRow then
		local registeredComponents2 = v2._registeredComponents
		local heroUnitBottomRow = SduiComponentType.HeroUnitBottomRow
		local v11 = {
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
		v11.propParsers = propParsers4
		registeredComponents2[heroUnitBottomRow] = v11
	end

	local registeredComponents2 = v2._registeredComponents
	local chip = SduiComponentType.Chip
	local SduiSharedContent7 = require(parent.SduiSharedContent)
	registeredComponents2[chip] = {
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

	local registeredComponents3 = v2._registeredComponents
	local dualActionChip = SduiComponentType.DualActionChip
	local SduiSharedContent8 = require(parent.SduiSharedContent)
	registeredComponents3[dualActionChip] = {
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

	local registeredComponents4 = v2._registeredComponents
	local associatedItemsRow = SduiComponentType.AssociatedItemsRow
	registeredComponents4[associatedItemsRow] = {
		component = require(ServerDrivenUi.Content.SduiAssociatedItemsRow),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			footerComponent = parseUiComponentProp_
		}
	}

	local registeredComponents5 = v2._registeredComponents
	local experienceAssociatedItemsRow = SduiComponentType.ExperienceAssociatedItemsRow
	registeredComponents5[experienceAssociatedItemsRow] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceAssociatedItemsRow),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			universeId = parseStringProp_
		},
		propInterface = { universeId = t.string }
	}

	local registeredComponents6 = v2._registeredComponents
	local experienceDetailsVoteChip = SduiComponentType.ExperienceDetailsVoteChip
	registeredComponents6[experienceDetailsVoteChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsVoteChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	local registeredComponents7 = v2._registeredComponents
	local experienceDetailsFavoriteChip = SduiComponentType.ExperienceDetailsFavoriteChip
	registeredComponents7[experienceDetailsFavoriteChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsFavoriteChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	local registeredComponents8 = v2._registeredComponents
	local experienceDetailsNotifyChip = SduiComponentType.ExperienceDetailsNotifyChip
	registeredComponents8[experienceDetailsNotifyChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsNotifyChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	local registeredComponents9 = v2._registeredComponents
	local experienceDetailsActiveChip = SduiComponentType.ExperienceDetailsActiveChip
	registeredComponents9[experienceDetailsActiveChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsActiveChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	local registeredComponents10 = v2._registeredComponents
	local experienceDetailsShareChip = SduiComponentType.ExperienceDetailsShareChip
	registeredComponents10[experienceDetailsShareChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsShareChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	local registeredComponents11 = v2._registeredComponents
	local experienceDetailsReportChip = SduiComponentType.ExperienceDetailsReportChip
	registeredComponents11[experienceDetailsReportChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsReportChip),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	if FFlagSduiExperienceDetailsSocialProof then
		local registeredComponents12 = v2._registeredComponents
		local experienceDetailsConnectionsPlayedChip = SduiComponentType.ExperienceDetailsConnectionsPlayedChip
		registeredComponents12[experienceDetailsConnectionsPlayedChip] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedChip),
			propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
			propInterface = { universeId = t.string }
		}

		local registeredComponents13 = v2._registeredComponents
		local experienceDetailsConnectionsPlayedTextRow = SduiComponentType.ExperienceDetailsConnectionsPlayedTextRow
		registeredComponents13[experienceDetailsConnectionsPlayedTextRow] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedTextRow),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				universeId = parseStringProp_,
				name = parseStringProp_
			},
			propInterface = { universeId = t.string, name = t.optional(t.string) }
		}
	end

	local registeredComponents12 = v2._registeredComponents
	local verticalFeed = SduiComponentType.VerticalFeed
	local SduiSharedContent9 = require(parent.SduiSharedContent)
	local v11 = { component = SduiSharedContent9.SduiVerticalFeed, propParsers = 0 }
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
	local gapAfterFirstFeedItem

	if FFlagSduiIndividualFeedItemSpacing then
		gapAfterFirstFeedItem = parseNumberProp_
	end

	propParsers4.gapAfterFirstFeedItem = gapAfterFirstFeedItem
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
	v11.propParsers = propParsers4
	registeredComponents12[verticalFeed] = v11

	local registeredComponents13 = v2._registeredComponents
	local badgeTile = SduiComponentType.BadgeTile
	registeredComponents13[badgeTile] = {
		component = require(ServerDrivenUi.Content.SduiBadgeTile),
		propParsers = Cryo.Dictionary.join(v2._registeredComponents[SduiComponentType.Tile].propParsers, {
			imageCornerRadius = parseNumberProp_,
			imagePadding = parseNumberProp_
		})
	}

	local registeredComponents14 = v2._registeredComponents
	local badge = SduiComponentType.Badge
	local SduiSharedContent10 = require(parent.SduiSharedContent)
	registeredComponents14[badge] = {
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

	local registeredComponents15 = v2._registeredComponents
	local songTile = SduiComponentType.SongTile
	registeredComponents15[songTile] = {
		component = require(ServerDrivenUi.Content.SduiSongTile)
	}

	local registeredComponents16 = v2._registeredComponents
	local infoTable = SduiComponentType.InfoTable
	local SduiSharedContent11 = require(parent.SduiSharedContent)
	registeredComponents16[infoTable] = {
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

	local registeredComponents17 = v2._registeredComponents
	local infoTableCell = SduiComponentType.InfoTableCell
	local AppBlox = require(parent.AppBlox)
	registeredComponents17[infoTableCell] = {
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

	local registeredComponents18 = v2._registeredComponents
	local expandableText = SduiComponentType.ExpandableText
	local SduiSharedContent12 = require(parent.SduiSharedContent)
	registeredComponents18[expandableText] = {
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

	local registeredComponents19 = v2._registeredComponents
	local overflowMenu = SduiComponentType.OverflowMenu
	local SduiSharedContent13 = require(parent.SduiSharedContent)
	registeredComponents19[overflowMenu] = {
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
		local registeredComponents20 = v2._registeredComponents
		local ageCheckUpsellRow = SduiComponentType.AgeCheckUpsellRow
		registeredComponents20[ageCheckUpsellRow] = {
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

	setmetatable(v2, SduiComponentDefinitions)
	return v2
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
