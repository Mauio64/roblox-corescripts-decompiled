local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/t")
local collectionItemSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").CollectionViewTypes.CollectionItemSize
local ItemHeightMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/ItemHeightMode")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiComponentType = SduiCoreSystem.SduiComponentType
local sduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry

local fFlagLuaAppRespectClipAncestorImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppRespectClipAncestorImpressions

local parseCallbackProp_ = sduiParsers.parseCallbackProp_
local parseUiComponentProp_ = sduiParsers.parseUiComponentProp_
local parseLazyUiComponentProp_ = sduiParsers.parseLazyUiComponentProp_
local parseIntegerProp_ = sduiParsers.parseIntegerProp_
local parseNumberProp_ = sduiParsers.parseNumberProp_
local parseUDim2Prop_ = sduiParsers.parseUDim2Prop_
local parseUDimProp_ = sduiParsers.parseUDimProp_
local parseImageStringProp_ = sduiParsers.parseImageStringProp_
local parseVector2Prop_ = sduiParsers.parseVector2Prop_
local parseColor3Prop_ = sduiParsers.parseColor3Prop_
local parseBooleanProp_ = sduiParsers.parseBooleanProp_
local parseGradientProp_ = sduiParsers.parseGradientProp_
local parseIconProp_ = sduiParsers.parseIconProp_
local parseTypographyTokenProp_ = sduiParsers.parseTypographyTokenProp_
local parseColorTokenProp_ = sduiParsers.parseColorTokenProp_
local parseImageSetOrImageProp_ = sduiParsers.parseImageSetOrImageProp_
local parseStringProp_ = sduiParsers.parseStringProp_
local parseFocusNavActionsProp_ = sduiParsers.parseFocusNavActionsProp_

local getArrayMetatableParser = sduiParsers.getArrayMetatableParser
local getEngineEnumParser = sduiParsers.getEngineEnumParser
local getLuaTableEnumParser = sduiParsers.getLuaTableEnumParser
local fFlagSduiTileDisableLegacyHover = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Flags").FFlagSduiTileDisableLegacyHover
local fFlagSduiEnableHeroUnitBottomRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Flags").FFlagSduiEnableHeroUnitBottomRow
local fFlagSduiAttributionRowV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiAttributionRowV2
local fFlagSduiExperienceDetailsSocialProof = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiExperienceDetailsSocialProof
local fFlagSduiChipAccessoryProps = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiChipAccessoryProps
local fFlagLuaAppDismissUnlockUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppDismissUnlockUpsell
local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFeedback
local fFlagSduiGameTileDirectAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileDirectAction
local fFlagSduiOptionSelectorCollection = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionSelectorCollection

local fFlagSduiCollectionCarouselPlaceholderItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiCollectionCarouselPlaceholderItem
local fFlagSduiCollectionGridRevealRows = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiCollectionGridRevealRows
local fFlagSduiIndividualFeedItemSpacing = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiIndividualFeedItemSpacing

local fFlagLuaAppSduiSearchAutocompleteSuggestionComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSearchAutocompleteSuggestionComponent
local FFlagLuaAppHeroUnitSecondaryLabelText = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FFlagLuaAppHeroUnitSecondaryLabelText")

local v5 = {}

local class = {}
class.__index = class

function class.new()
	local v6 = {
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
	}, v6)

	local v7 = {
		columnGap = parseNumberProp_,
		sideMargin = parseNumberProp_,
		numColumns = parseNumberProp_,
		fractionalItemAmount = parseNumberProp_,
		loadMoreThreshold = parseNumberProp_,
		verticalGap = parseNumberProp_
	}

	local attributionRow = sduiComponentType.AttributionRow
	local v10 = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiAttributionRow,
		propParsers = 0,
		propInterface = 0
	}
	local v11 = {
		layoutOrder = parseIntegerProp_,
		position = parseUDim2Prop_,
		size = if fFlagSduiAttributionRowV2 then parseUDim2Prop_ else nil,
		onActivated = parseCallbackProp_,
		rightButtonContent = parseUiComponentProp_,
		title = if fFlagSduiAttributionRowV2 then parseStringProp_ else nil,
		titleFontStyle = if fFlagSduiAttributionRowV2 then parseTypographyTokenProp_ else nil,
		titleTextColor = if fFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil,
		subtitle = if fFlagSduiAttributionRowV2 then parseStringProp_ else nil,
		subtitleFontStyle = if fFlagSduiAttributionRowV2 then parseTypographyTokenProp_ else nil,
		subtitleTextColor = if fFlagSduiAttributionRowV2 then parseColor3Prop_ else nil,
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

	local v19 = if fFlagSduiAttributionRowV2 then getLuaTableEnumParser(Foundation.Enums.IconName, "string") else nil
	v11.subtitleIconName = v19

	local v20 = if fFlagSduiAttributionRowV2 then getLuaTableEnumParser(Foundation.Enums.IconSize, "string") else nil
	v11.subtitleIconSize = v20

	v11.subtitleIconStyle = if fFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil

	local v22 = if fFlagSduiAttributionRowV2 then getLuaTableEnumParser(Foundation.Enums.IconVariant, "string") else nil
	v11.subtitleIconVariant = v22

	local v23 = if fFlagSduiAttributionRowV2 then getLuaTableEnumParser(Foundation.Enums.IconName, "string") else nil
	v11.subtitleBackgroundIconName = v23

	v11.subtitleBackgroundIconStyle = if fFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	v11.subtitleOnActivated = if fFlagSduiAttributionRowV2 then parseCallbackProp_ else nil

	v11.caption = if fFlagSduiAttributionRowV2 then parseStringProp_ else nil
	v11.captionTextColor = if fFlagSduiAttributionRowV2 then parseColorTokenProp_ else nil
	v11.captionFontStyle = if fFlagSduiAttributionRowV2 then parseTypographyTokenProp_ else nil

	v11.textContainerSize = if fFlagSduiAttributionRowV2 then parseUDim2Prop_ else nil

	v11.image = parseImageStringProp_
	v11.imageSize = if fFlagSduiAttributionRowV2 then parseUDim2Prop_ else nil
	v10.propParsers = v11

	v10.propInterface = fFlagSduiAttributionRowV2
		and { title = t.string, subtitle = t.string }
		or nil
	local v9 = {
		[attributionRow] = v10,
		[sduiComponentType.Button] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiButton,
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
	}

	local collectionCarousel = sduiComponentType.CollectionCarousel
	v9[collectionCarousel] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionCarousel"),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			collectionItemSize = getLuaTableEnumParser(collectionItemSize, "string"),
			itemHeightFromWidth = parseUDimProp_,
			headerComponent = parseUiComponentProp_,
			itemHeightMode = getLuaTableEnumParser(ItemHeightMode, "string"),
			layoutOverrides = v7,
			numColumnsOverride = parseNumberProp_,
			scrollingEnabledOverride = parseBooleanProp_,
			maxItemsToShow = parseNumberProp_,
			shouldUseFrameBoundsForImpressions = parseBooleanProp_,
			respectClipAncestors = if fFlagLuaAppRespectClipAncestorImpressions then parseBooleanProp_ else nil,
			backgroundMuralUrl = parseImageStringProp_,
			onScrollToEnd = parseCallbackProp_,
			scrollThresholdFromEnd = parseNumberProp_,
			itemTemplateKey = parseStringProp_,
			focusNavActionsComponent = parseUiComponentProp_,
			disableSelectionOrder = parseBooleanProp_,
			numItemsToRenderOffScreen = parseNumberProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			impressionEventName = parseStringProp_,
			skipItemImpressionsLog = parseBooleanProp_,
			enableHoverOverflow = parseBooleanProp_
		}
	}

	v9[sduiComponentType.VariableItemWidthCarousel] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiVariableItemWidthCarousel")
	}

	v9[sduiComponentType.CollectionCarouselPlaceholder] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionCarouselPlaceholder")
	}

	v9[sduiComponentType.PlaceholderTile] = fFlagSduiCollectionCarouselPlaceholderItem
		and { component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiPlaceholderTile }
		or nil

	v9[sduiComponentType.OptionSelectorCollection] = fFlagSduiOptionSelectorCollection
		and { component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiOptionSelectorCollection") }
		or nil

	v9[sduiComponentType.CollectionGrid] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiCollectionGrid"),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			bufferRowsBelowScreen = parseNumberProp_,
			bufferRowsAboveScreen = parseNumberProp_,
			collectionItemSize = getLuaTableEnumParser(collectionItemSize, "string"),
			disableRelativeGap = parseBooleanProp_,
			focusNavActionsComponent = parseUiComponentProp_,
			headerComponent = parseUiComponentProp_,
			itemHeightFromWidth = parseUDimProp_,
			itemTemplateKey = parseStringProp_,
			layoutOverrides = v7,
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

	v9[sduiComponentType.RevealRowsButtonWithDivider] = fFlagSduiCollectionGridRevealRows
		and { component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiRevealRowsButtonWithDivider") }
		or nil

	v9[sduiComponentType.Dialog] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiDialog"),
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

	v9[sduiComponentType.Divider] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiDivider"),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			backgroundColor3 = parseColor3Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_
		}
	}

	v9[sduiComponentType.FocusNavActions] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FocusNavigation/SduiFocusNavActions"),
		propParsers = { focusNavActions = parseFocusNavActionsProp_ },
		propInterface = { focusNavActions = t.table }
	}

	v9[sduiComponentType.Fragment] = { component = React.Fragment }

	v9[sduiComponentType.GameTileActiveFriendsFooter] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameTileActiveFriendsFooter"),
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
		propInterface = {
			universeId = t.union(t.string, t.number)
		}
	}

	v9[sduiComponentType.HeroUnit] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiHeroUnit"),
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

	v9[sduiComponentType.HoldToPlay] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FocusNavigation/SduiHoldToPlay"),
		propParsers = { universeId = parseStringProp_, placeId = parseStringProp_ },
		propInterface = {
			universeId = t.union(t.string, t.number)
		}
	}

	v9[sduiComponentType.Image] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiImage,
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

	v9[sduiComponentType.SingleItemCollection] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiSingleItemCollection"),
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

	v9[sduiComponentType.PlayButton] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiPlayButton,
		propParsers = {
			anchorPoint = parseVector2Prop_,
			layoutOrder = parseIntegerProp_,
			position = parseUDim2Prop_,
			tag = parseStringProp_,
			width = parseUDimProp_,
			onActivatedEffect = parseCallbackProp_
		},
		propInterface = {
			universeId = t.union(t.string, t.number)
		}
	}

	v9[sduiComponentType.SectionHeader] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiSectionHeader"),
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

	v9[sduiComponentType.SearchAutocompleteSuggestion] = fFlagLuaAppSduiSearchAutocompleteSuggestionComponent
		and {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiSearchAutocompleteSuggestion"),
			propInterface = {
				title = t.string,
				isRich = t.optional(t.boolean)
			}
		}
		or nil

	v9[sduiComponentType.SeeAllTile] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameCollections").SeeAllTile,
		propParsers = {
			layoutOrder = parseNumberProp_,
			size = parseUDim2Prop_,
			onActivated = parseCallbackProp_,
			icon = parseIconProp_,
			title = parseStringProp_
		}
	}

	v9[sduiComponentType.SlotOverlay] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiSlotOverlay"),
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

	v9[sduiComponentType.Text] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiText,
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

	v9[sduiComponentType.TextIconRow] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTextIconRow"),
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
			iconOverrides = v6,
			textFlexMode = getEngineEnumParser(Enum.UIFlexMode),
			backgroundStyle = parseColorTokenProp_,
			cornerRadius = parseUDimProp_
		}
	}

	v9[sduiComponentType.TextPill] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTextPill"),
		propParsers = {
			anchorPoint = parseVector2Prop_,
			backgroundColor3 = parseColor3Prop_,
			position = parseUDim2Prop_,
			size = parseUDim2Prop_,
			textColor3 = parseColor3Prop_,
			fontStyle = parseTypographyTokenProp_
		}
	}

	local tile = sduiComponentType.Tile
	v9[tile] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTile"),
		propParsers = {
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
			enableLegacyHoverState = if not fFlagSduiTileDisableLegacyHover then parseBooleanProp_ else nil,
			focusNavActionsComponent = parseUiComponentProp_,
			bottomButtonComponent = parseUiComponentProp_,
			bottomButtonGap = parseNumberProp_,
			holdActionConfig = {
				onHoldCompleted = parseCallbackProp_,
				focusNavigationEventName = parseStringProp_,
				keyCode = getEngineEnumParser(Enum.KeyCode)
			}
		}
	}

	v9[sduiComponentType.TileFooter] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTileFooter"),
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

	v9[sduiComponentType.View] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiView,
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
	local v8 = { _registeredComponents = v9 }

	v8._registeredComponents[sduiComponentType.CountdownTextIconRow] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiCountdownTextIconRow"),
		propParsers = Cryo.Dictionary.join(v8._registeredComponents[sduiComponentType.TextIconRow], {
			endTimestamp = parseNumberProp_,
			formatStringHoursMinutes = parseStringProp_,
			defaultString = parseStringProp_
		})
	}

	local registeredComponents = v8._registeredComponents
	local gameTile = sduiComponentType.GameTile
	registeredComponents[gameTile] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameTile"),
		propParsers = Cryo.Dictionary.join(v8._registeredComponents[sduiComponentType.Tile].propParsers, {
			universeId = parseStringProp_,
			placeId = parseStringProp_,
			collectionId = if fFlagLuaAppSduiGameTileFeedback then parseStringProp_ else nil,
			hiddenStateComponent = if fFlagLuaAppSduiGameTileFeedback then parseLazyUiComponentProp_ else nil,
			overflowMenuComponent = if fFlagLuaAppSduiGameTileFeedback then parseLazyUiComponentProp_ else nil,
			directActionComponent = if fFlagSduiGameTileDirectAction then parseLazyUiComponentProp_ else nil,
			disableHoldToPlay = parseBooleanProp_,
			ratingText = parseStringProp_,
			playerCount = parseNumberProp_
		}),
		propInterface = {
			universeId = t.union(t.string, t.number),
			placeId = t.union(t.string, t.number)
		}
	}

	if fFlagLuaAppSduiGameTileFeedback then
		v8._registeredComponents[sduiComponentType.GameTileHiddenState] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiGameTileHiddenState")
		}
	end

	if fFlagSduiEnableHeroUnitBottomRow then
		local registeredComponents2 = v8._registeredComponents
		local heroUnitBottomRow = sduiComponentType.HeroUnitBottomRow
		registeredComponents2[heroUnitBottomRow] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiHeroUnitBottomRow"),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				zIndex = parseNumberProp_,
				ctaButton = parseUiComponentProp_,
				labelText = parseStringProp_,
				secondaryLabelText = if FFlagLuaAppHeroUnitSecondaryLabelText then parseStringProp_ else nil,
				rightLabelContent = parseUiComponentProp_
			}
		}
	end

	v8._registeredComponents[sduiComponentType.Chip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiChip,
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
		propInterface = fFlagSduiChipAccessoryProps and {
			leading = t.optional(t.table),
			trailing = t.optional(t.table)
		} or nil
	}

	v8._registeredComponents[sduiComponentType.DualActionChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiDualActionChip,
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

	v8._registeredComponents[sduiComponentType.AssociatedItemsRow] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiAssociatedItemsRow"),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			footerComponent = parseUiComponentProp_
		}
	}

	v8._registeredComponents[sduiComponentType.ExperienceAssociatedItemsRow] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceAssociatedItemsRow"),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			universeId = parseStringProp_
		},
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsVoteChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsVoteChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsFavoriteChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsFavoriteChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsNotifyChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsNotifyChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsActiveChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsActiveChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsShareChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsShareChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	v8._registeredComponents[sduiComponentType.ExperienceDetailsReportChip] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsReportChip"),
		propParsers = { layoutOrder = parseIntegerProp_, universeId = parseStringProp_ },
		propInterface = { universeId = t.string }
	}

	if fFlagSduiExperienceDetailsSocialProof then
		v8._registeredComponents[sduiComponentType.ExperienceDetailsConnectionsPlayedChip] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsConnectionsPlayedChip"),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				universeId = parseStringProp_
			},
			propInterface = { universeId = t.string }
		}

		v8._registeredComponents[sduiComponentType.ExperienceDetailsConnectionsPlayedTextRow] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/ExperienceDetailsConnectionsPlayedTextRow"),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				universeId = parseStringProp_,
				name = parseStringProp_
			},
			propInterface = {
				universeId = t.string,
				name = t.optional(t.string)
			}
		}
	end

	local registeredComponents2 = v8._registeredComponents
	local verticalFeed = sduiComponentType.VerticalFeed
	registeredComponents2[verticalFeed] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiVerticalFeed,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			feedItems = getArrayMetatableParser(parseLazyUiComponentProp_),
			gapBetweenFeedItems = parseNumberProp_,
			gapAfterFirstFeedItem = if fFlagSduiIndividualFeedItemSpacing then parseNumberProp_ else nil,
			thresholdFromEnd = parseNumberProp_,
			onScrollToEnd = parseCallbackProp_,
			onRefresh = parseCallbackProp_,
			stickyItems = getArrayMetatableParser(parseUiComponentProp_),
			gapAfterStickyItems = parseIntegerProp_,
			gapBetweenStickyItems = parseIntegerProp_,
			stickyPaddingTop = parseIntegerProp_,
			stickyPaddingBottom = parseIntegerProp_,
			stickyBackgroundStyle = parseColorTokenProp_,
			stickyContentTag = parseStringProp_,
			backgroundStyle = parseColorTokenProp_
		}
	}

	v8._registeredComponents[sduiComponentType.BadgeTile] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiBadgeTile"),
		propParsers = Cryo.Dictionary.join(v8._registeredComponents[sduiComponentType.Tile].propParsers, {
			imageCornerRadius = parseNumberProp_,
			imagePadding = parseNumberProp_
		})
	}

	v8._registeredComponents[sduiComponentType.Badge] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiBadge,
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

	v8._registeredComponents[sduiComponentType.SongTile] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiSongTile")
	}

	v8._registeredComponents[sduiComponentType.InfoTable] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiInfoTable,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			gridTag = parseStringProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			numColumns = parseIntegerProp_,
			tag = parseStringProp_
		},
		propInterface = { items = t.array(t.table) }
	}

	v8._registeredComponents[sduiComponentType.InfoTableCell] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppBlox").InfoTableCell,
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

	v8._registeredComponents[sduiComponentType.ExpandableText] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiExpandableText,
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

	v8._registeredComponents[sduiComponentType.OverflowMenu] = {
		component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiOverflowMenu,
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

	if fFlagLuaAppDismissUnlockUpsell then
		v8._registeredComponents[sduiComponentType.AgeCheckUpsellRow] = {
			component = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiAgeCheckUpsellRow"),
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

	setmetatable(v8, class)
	return v8
end

function class:getComponentDefinition(p3)
	return self._registeredComponents[p3] or getSduiComponentRegistry().getComponentDefinition(p3)
end

function class:doesComponentManageChildren(p2)
	local componentDefinition = self:getComponentDefinition(p2)
	return componentDefinition and componentDefinition.doesManageChildren or false
end

function class:getComponent(p2)
	local componentDefinition = self:getComponentDefinition(p2)
	return componentDefinition and componentDefinition.component
end

function class:getPropParsers(p2)
	local componentDefinition = self:getComponentDefinition(p2)
	return componentDefinition and componentDefinition.propParsers or v5
end

function class:getPropInterface(p2)
	local componentDefinition = self:getComponentDefinition(p2)
	return componentDefinition and componentDefinition.propInterface or nil
end

local v6 = {
	[parseUiComponentProp_] = true,
	[parseCallbackProp_] = true,
	[parseFocusNavActionsProp_] = true
}

function class:doesParserRequireRenderContext(p3): boolean
	if p3 and v6[p3] then
		return true
	end

	return typeof(p3) == "table"
end

function class:registerComponent(p3, p4)
	self._registeredComponents[p3] = p4
end

return class
