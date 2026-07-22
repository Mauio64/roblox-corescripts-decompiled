local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Cryo = require(ServerDrivenUiParent.Cryo)
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local t = require(ServerDrivenUiParent.t)
local CollectionItemSize = require(ServerDrivenUiParent.CollectionViews).CollectionViewTypes.CollectionItemSize
local ItemHeightMode = require(ServerDrivenUi.Content.Collections.ItemHeightMode)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiParsers = SduiCoreSystem.SduiParsers
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local FFlagSduiExperienceDetailsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppResetHoverOnSduiPlayButtonActivation = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppResetHoverOnSduiPlayButtonActivation
local FFlagSduiGlobalRegistryFallback = require(ServerDrivenUiParent.SharedFlags).FFlagSduiGlobalRegistryFallback
local FFlagLuaAppRespectClipAncestorImpressions = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppRespectClipAncestorImpressions
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
local v38 = game:DefineFastFlag("SduiBadgeComponent", false)
local FFlagSduiTileDisableLegacyHover = require(ServerDrivenUi.Flags).FFlagSduiTileDisableLegacyHover
local FFlagSduiEnableHeroUnitBottomRow = require(ServerDrivenUi.Flags).FFlagSduiEnableHeroUnitBottomRow
local FFlagSduiEnableAssociatedItemsRow = require(ServerDrivenUiParent.SharedFlags).FFlagSduiEnableAssociatedItemsRow
local FFlagSduiAttributionRowV2 = require(ServerDrivenUiParent.SharedFlags).FFlagSduiAttributionRowV2
local FFlagSduiExperienceDetailsSocialProof = require(ServerDrivenUiParent.SharedFlags).FFlagSduiExperienceDetailsSocialProof
local FFlagSduiChipAccessoryProps = require(ServerDrivenUiParent.SharedFlags).FFlagSduiChipAccessoryProps
local FFlagSduiCollectionCarouselOverrides = require(ServerDrivenUiParent.SharedFlags).FFlagSduiCollectionCarouselOverrides
local FFlagSduiChartsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiChartsSupport
local FFlagLuaAppDismissUnlockUpsell = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppDismissUnlockUpsell
local FFlagSduiTileBottomButton = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileBottomButton
local FFlagSduiTileHoldAction = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileHoldAction
local FFlagLuaAppSduiPlaceholderSupport = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppSduiPlaceholderSupport
local FFlagSduiVariableItemWidthCarousel = require(ServerDrivenUiParent.SharedFlags).FFlagSduiVariableItemWidthCarousel
local FFlagSduiOptionSelectorCollection = require(ServerDrivenUiParent.SharedFlags).FFlagSduiOptionSelectorCollection
local FFlagSduiCollectionCarouselPlaceholderItem = require(ServerDrivenUiParent.SharedFlags).FFlagSduiCollectionCarouselPlaceholderItem
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 90
	-- upvalues: parseVector2Prop_ (copy), getEngineEnumParser (copy), parseColor3Prop_ (copy), parseNumberProp_ (copy), parseIntegerProp_ (copy), parseUDim2Prop_ (copy), Cryo (copy), parseBooleanProp_ (copy), parseStringProp_ (copy), SduiComponentType (copy), ServerDrivenUiParent (copy), FFlagSduiAttributionRowV2 (copy), parseCallbackProp_ (copy), parseUiComponentProp_ (copy), parseTypographyTokenProp_ (copy), parseColorTokenProp_ (copy), getLuaTableEnumParser (copy), Foundation (copy), parseImageStringProp_ (copy), t (copy), parseIconProp_ (copy), parseUDimProp_ (copy), ServerDrivenUi (copy), CollectionItemSize (copy), ItemHeightMode (copy), FFlagSduiCollectionCarouselOverrides (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), getArrayMetatableParser (copy), parseLazyUiComponentProp_ (copy), FFlagSduiVariableItemWidthCarousel (copy), FFlagLuaAppSduiPlaceholderSupport (copy), FFlagSduiCollectionCarouselPlaceholderItem (copy), FFlagSduiOptionSelectorCollection (copy), parseFocusNavActionsProp_ (copy), React (copy), parseGradientProp_ (copy), FFlagSduiExperienceDetailsSupport (copy), FFlagLuaAppResetHoverOnSduiPlayButtonActivation (copy), parseImageSetOrImageProp_ (copy), FFlagSduiTileDisableLegacyHover (copy), FFlagSduiTileBottomButton (copy), FFlagSduiTileHoldAction (copy), FFlagSduiEnableHeroUnitBottomRow (copy), FFlagSduiChipAccessoryProps (copy), FFlagSduiEnableAssociatedItemsRow (copy), FFlagSduiExperienceDetailsSocialProof (copy), FFlagSduiChartsSupport (copy), v38 (copy), FFlagLuaAppDismissUnlockUpsell (copy), t2 (copy)
	local t3 = {
		anchorPoint = parseVector2Prop_,
		automaticSize = getEngineEnumParser(Enum.AutomaticSize),
		backgroundColor3 = parseColor3Prop_,
		backgroundTransparency = parseNumberProp_,
		layoutOrder = parseIntegerProp_,
		position = parseUDim2Prop_,
		size = parseUDim2Prop_,
		zIndex = parseNumberProp_
	}
	local v58 = Cryo.Dictionary.union({
		richText = parseBooleanProp_,
		text = parseStringProp_,
		textTruncate = getEngineEnumParser(Enum.TextTruncate),
		textWrapped = parseBooleanProp_,
		textXAlignment = getEngineEnumParser(Enum.TextXAlignment),
		textYAlignment = getEngineEnumParser(Enum.TextYAlignment)
	}, t3)
	local t4 = {
		columnGap = parseNumberProp_,
		sideMargin = parseNumberProp_,
		numColumns = parseNumberProp_,
		fractionalItemAmount = parseNumberProp_,
		loadMoreThreshold = parseNumberProp_,
		verticalGap = parseNumberProp_
	}
	local t5 = {
		_registeredComponents = {
			[SduiComponentType.AttributionRow] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiAttributionRow,
				propParsers = {
					layoutOrder = parseIntegerProp_,
					position = parseUDim2Prop_,
					size = if not FFlagSduiAttributionRowV2 then nil else parseUDim2Prop_,
					onActivated = parseCallbackProp_,
					rightButtonContent = parseUiComponentProp_,
					title = if not FFlagSduiAttributionRowV2 then nil else parseStringProp_,
					titleFontStyle = if not FFlagSduiAttributionRowV2 then nil else parseTypographyTokenProp_,
					titleTextColor = if not FFlagSduiAttributionRowV2 then nil else parseColorTokenProp_,
					subtitle = if not FFlagSduiAttributionRowV2 then nil else parseStringProp_,
					subtitleFontStyle = if not FFlagSduiAttributionRowV2 then nil else parseTypographyTokenProp_,
					subtitleTextColor = if not FFlagSduiAttributionRowV2 then nil else parseColor3Prop_,
					subtitleIconName = if not FFlagSduiAttributionRowV2 then nil else getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
					subtitleIconSize = if not FFlagSduiAttributionRowV2 then nil else getLuaTableEnumParser(Foundation.Enums.IconSize, "string"),
					subtitleIconStyle = if not FFlagSduiAttributionRowV2 then nil else parseColorTokenProp_,
					subtitleIconVariant = if not FFlagSduiAttributionRowV2 then nil else getLuaTableEnumParser(Foundation.Enums.IconVariant, "string"),
					subtitleBackgroundIconName = if not FFlagSduiAttributionRowV2 then nil else getLuaTableEnumParser(Foundation.Enums.IconName, "string"),
					subtitleBackgroundIconStyle = if not FFlagSduiAttributionRowV2 then nil else parseColorTokenProp_,
					subtitleOnActivated = if not FFlagSduiAttributionRowV2 then nil else parseCallbackProp_,
					caption = if not FFlagSduiAttributionRowV2 then nil else parseStringProp_,
					captionTextColor = if not FFlagSduiAttributionRowV2 then nil else parseColorTokenProp_,
					captionFontStyle = if not FFlagSduiAttributionRowV2 then nil else parseTypographyTokenProp_,
					textContainerSize = if not FFlagSduiAttributionRowV2 then nil else parseUDim2Prop_,
					image = parseImageStringProp_,
					imageSize = if not FFlagSduiAttributionRowV2 then nil else parseUDim2Prop_
				},
				propInterface = if not FFlagSduiAttributionRowV2 then nil else {
					title = t.string,
					subtitle = t.string
				}
			},
			[SduiComponentType.Button] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiButton,
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
			},
			[SduiComponentType.CollectionCarousel] = {
				component = require(ServerDrivenUi.Content.Collections.SduiCollectionCarousel),
				propParsers = {
					anchorPoint = parseVector2Prop_,
					position = parseUDim2Prop_,
					size = parseUDim2Prop_,
					collectionItemSize = getLuaTableEnumParser(CollectionItemSize, "string"),
					itemHeightFromWidth = parseUDimProp_,
					headerComponent = parseUiComponentProp_,
					itemHeightMode = getLuaTableEnumParser(ItemHeightMode, "string"),
					layoutOverrides = t4,
					numColumnsOverride = if not FFlagSduiCollectionCarouselOverrides then nil else parseNumberProp_,
					scrollingEnabledOverride = parseBooleanProp_,
					maxItemsToShow = parseNumberProp_,
					shouldUseFrameBoundsForImpressions = parseBooleanProp_,
					respectClipAncestors = if not FFlagLuaAppRespectClipAncestorImpressions then nil else parseBooleanProp_,
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
			},
			[SduiComponentType.VariableItemWidthCarousel] = if not FFlagSduiVariableItemWidthCarousel then nil else {
				component = require(ServerDrivenUi.Content.Collections.SduiVariableItemWidthCarousel)
			},
			[SduiComponentType.CollectionCarouselPlaceholder] = if not FFlagLuaAppSduiPlaceholderSupport then nil else {
				component = require(ServerDrivenUi.Content.Collections.SduiCollectionCarouselPlaceholder)
			},
			[SduiComponentType.PlaceholderTile] = if not FFlagSduiCollectionCarouselPlaceholderItem then nil else {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiPlaceholderTile
			},
			[SduiComponentType.OptionSelectorCollection] = if not FFlagSduiOptionSelectorCollection then nil else {
				component = require(ServerDrivenUi.Content.Collections.SduiOptionSelectorCollection)
			},
			[SduiComponentType.CollectionGrid] = {
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
					layoutOverrides = t4,
					maxNumRows = parseNumberProp_,
					shouldUseFrameBoundsForImpressions = parseBooleanProp_,
					disableSelectionOrder = parseBooleanProp_,
					items = getArrayMetatableParser(parseLazyUiComponentProp_),
					thresholdRowsFromBottom = parseNumberProp_,
					onReachedThresholdFromEnd = parseCallbackProp_,
					impressionEventName = parseStringProp_,
					skipItemImpressionsLog = parseBooleanProp_
				},
				propInterface = {
					itemHeightFromWidth = t.UDim
				}
			},
			[SduiComponentType.Dialog] = {
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
			},
			[SduiComponentType.Divider] = {
				component = require(ServerDrivenUi.Content.SduiDivider),
				propParsers = {
					anchorPoint = parseVector2Prop_,
					backgroundColor3 = parseColor3Prop_,
					position = parseUDim2Prop_,
					size = parseUDim2Prop_
				}
			},
			[SduiComponentType.FocusNavActions] = {
				component = require(ServerDrivenUi.FocusNavigation.SduiFocusNavActions),
				propParsers = {
					focusNavActions = parseFocusNavActionsProp_
				},
				propInterface = {
					focusNavActions = t.table
				}
			},
			[SduiComponentType.Fragment] = {
				component = React.Fragment
			},
			[SduiComponentType.GameTileActiveFriendsFooter] = {
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
				propInterface = {
					universeId = t.union(t.string, t.number)
				}
			},
			[SduiComponentType.HeroUnit] = {
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
			},
			[SduiComponentType.HoldToPlay] = {
				component = require(ServerDrivenUi.FocusNavigation.SduiHoldToPlay),
				propParsers = {
					universeId = parseStringProp_,
					placeId = parseStringProp_
				},
				propInterface = {
					universeId = t.union(t.string, t.number)
				}
			},
			[SduiComponentType.Image] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiImage,
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
			},
			[SduiComponentType.SingleItemCollection] = {
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
			},
			[SduiComponentType.PlayButton] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiPlayButton,
				propParsers = {
					anchorPoint = parseVector2Prop_,
					layoutOrder = parseIntegerProp_,
					position = parseUDim2Prop_,
					tag = if not FFlagSduiExperienceDetailsSupport then nil else parseStringProp_,
					width = parseUDimProp_,
					onActivatedEffect = if not FFlagLuaAppResetHoverOnSduiPlayButtonActivation then nil else parseCallbackProp_
				},
				propInterface = {
					universeId = t.union(t.string, t.number)
				}
			},
			[SduiComponentType.SectionHeader] = {
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
			},
			[SduiComponentType.SeeAllTile] = {
				component = require(ServerDrivenUiParent.GameCollections).SeeAllTile,
				propParsers = {
					layoutOrder = parseNumberProp_,
					size = parseUDim2Prop_,
					onActivated = parseCallbackProp_,
					icon = parseIconProp_,
					title = parseStringProp_
				}
			},
			[SduiComponentType.SlotOverlay] = {
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
			},
			[SduiComponentType.Text] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiText,
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
			},
			[SduiComponentType.TextIconRow] = {
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
					textOverrides = v58,
					iconOverrides = t3,
					textFlexMode = getEngineEnumParser(Enum.UIFlexMode),
					backgroundStyle = parseColorTokenProp_,
					cornerRadius = parseUDimProp_
				}
			},
			[SduiComponentType.TextPill] = {
				component = require(ServerDrivenUi.Content.SduiTextPill),
				propParsers = {
					anchorPoint = parseVector2Prop_,
					backgroundColor3 = parseColor3Prop_,
					position = parseUDim2Prop_,
					size = parseUDim2Prop_,
					textColor3 = parseColor3Prop_,
					fontStyle = parseTypographyTokenProp_
				}
			},
			[SduiComponentType.Tile] = {
				component = require(ServerDrivenUi.Content.SduiTile),
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
					backgroundStyle = if not FFlagSduiExperienceDetailsSupport then nil else parseColorTokenProp_,
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
					enableLegacyHoverState = if not FFlagSduiTileDisableLegacyHover then parseBooleanProp_ else nil,
					focusNavActionsComponent = parseUiComponentProp_,
					bottomButtonComponent = if not FFlagSduiTileBottomButton then nil else parseUiComponentProp_,
					bottomButtonGap = if not FFlagSduiTileBottomButton then nil else parseNumberProp_,
					holdActionConfig = if not FFlagSduiTileHoldAction then nil else {
						onHoldCompleted = parseCallbackProp_,
						focusNavigationEventName = parseStringProp_,
						keyCode = getEngineEnumParser(Enum.KeyCode)
					}
				}
			},
			[SduiComponentType.TileFooter] = {
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
			},
			[SduiComponentType.View] = {
				component = require(ServerDrivenUiParent.SduiSharedContent).SduiView,
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
		}
	}

	t5._registeredComponents[SduiComponentType.CountdownTextIconRow] = {
		component = require(ServerDrivenUi.Content.SduiCountdownTextIconRow),
		propParsers = Cryo.Dictionary.join(t5._registeredComponents[SduiComponentType.TextIconRow], {
			endTimestamp = parseNumberProp_,
			formatStringHoursMinutes = parseStringProp_,
			defaultString = parseStringProp_
		})
	}
	t5._registeredComponents[SduiComponentType.GameTile] = {
		component = require(ServerDrivenUi.Content.SduiGameTile),
		propParsers = Cryo.Dictionary.join(t5._registeredComponents[SduiComponentType.Tile].propParsers, {
			universeId = parseStringProp_,
			placeId = parseStringProp_,
			disableHoldToPlay = parseBooleanProp_,
			ratingText = parseStringProp_,
			playerCount = parseNumberProp_
		}),
		propInterface = {
			universeId = t.union(t.string, t.number),
			placeId = t.union(t.string, t.number)
		}
	}

	if FFlagSduiEnableHeroUnitBottomRow then
		t5._registeredComponents[SduiComponentType.HeroUnitBottomRow] = {
			component = require(ServerDrivenUi.Content.SduiHeroUnitBottomRow),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				position = parseUDim2Prop_,
				zIndex = parseNumberProp_,
				ctaButton = parseUiComponentProp_,
				labelText = parseStringProp_,
				rightLabelContent = parseUiComponentProp_
			}
		}
	end

	t5._registeredComponents[SduiComponentType.Chip] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiChip,
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
		propInterface = if not FFlagSduiChipAccessoryProps then nil else {
			leading = t.optional(t.table),
			trailing = t.optional(t.table)
		}
	}
	t5._registeredComponents[SduiComponentType.DualActionChip] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiDualActionChip,
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

	if FFlagSduiEnableAssociatedItemsRow then
		t5._registeredComponents[SduiComponentType.AssociatedItemsRow] = {
			component = require(ServerDrivenUi.Content.SduiAssociatedItemsRow),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				items = getArrayMetatableParser(parseLazyUiComponentProp_),
				footerComponent = if not FFlagSduiExperienceDetailsSupport then nil else parseUiComponentProp_
			}
		}
	end

	t5._registeredComponents[SduiComponentType.ExperienceAssociatedItemsRow] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceAssociatedItemsRow),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsVoteChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsVoteChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsFavoriteChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsFavoriteChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsNotifyChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsNotifyChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsActiveChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsActiveChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsShareChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsShareChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.ExperienceDetailsReportChip] = {
		component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsReportChip),
		propParsers = {
			layoutOrder = parseIntegerProp_,
			universeId = parseStringProp_
		},
		propInterface = {
			universeId = t.string
		}
	}

	if FFlagSduiExperienceDetailsSocialProof then
		t5._registeredComponents[SduiComponentType.ExperienceDetailsConnectionsPlayedChip] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedChip),
			propParsers = {
				layoutOrder = parseIntegerProp_,
				universeId = parseStringProp_
			},
			propInterface = {
				universeId = t.string
			}
		}
		t5._registeredComponents[SduiComponentType.ExperienceDetailsConnectionsPlayedTextRow] = {
			component = require(ServerDrivenUi.Content.ExperienceDetails.ExperienceDetailsConnectionsPlayedTextRow),
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

	t5._registeredComponents[SduiComponentType.VerticalFeed] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiVerticalFeed,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			feedItems = getArrayMetatableParser(parseLazyUiComponentProp_),
			gapBetweenFeedItems = parseNumberProp_,
			thresholdFromEnd = parseNumberProp_,
			onScrollToEnd = parseCallbackProp_,
			onRefresh = if not FFlagSduiChartsSupport then nil else parseCallbackProp_,
			stickyItems = if not FFlagSduiChartsSupport then nil else getArrayMetatableParser(parseUiComponentProp_),
			gapAfterStickyItems = if not FFlagSduiChartsSupport then nil else parseIntegerProp_,
			gapBetweenStickyItems = if not FFlagSduiChartsSupport then nil else parseIntegerProp_,
			stickyPaddingTop = if not FFlagSduiChartsSupport then nil else parseIntegerProp_,
			stickyPaddingBottom = if not FFlagSduiChartsSupport then nil else parseIntegerProp_,
			stickyBackgroundStyle = if not FFlagSduiChartsSupport then nil else parseColorTokenProp_,
			stickyContentTag = if not FFlagSduiChartsSupport then nil else parseStringProp_,
			backgroundStyle = parseColorTokenProp_
		}
	}
	t5._registeredComponents[SduiComponentType.BadgeTile] = {
		component = require(ServerDrivenUi.Content.SduiBadgeTile),
		propParsers = Cryo.Dictionary.join(t5._registeredComponents[SduiComponentType.Tile].propParsers, {
			imageCornerRadius = parseNumberProp_,
			imagePadding = parseNumberProp_
		})
	}

	if v38 then
		t5._registeredComponents[SduiComponentType.Badge] = {
			component = require(ServerDrivenUiParent.SduiSharedContent).SduiBadge,
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
	end

	if FFlagSduiExperienceDetailsSupport then
		t5._registeredComponents[SduiComponentType.SongTile] = {
			component = require(ServerDrivenUi.Content.SduiSongTile)
		}
	end

	t5._registeredComponents[SduiComponentType.InfoTable] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiInfoTable,
		propParsers = {
			layoutOrder = parseIntegerProp_,
			gridTag = parseStringProp_,
			items = getArrayMetatableParser(parseLazyUiComponentProp_),
			numColumns = parseIntegerProp_,
			tag = if not FFlagSduiExperienceDetailsSupport then nil else parseStringProp_
		},
		propInterface = {
			items = t.array(t.table)
		}
	}
	t5._registeredComponents[SduiComponentType.InfoTableCell] = {
		component = require(ServerDrivenUiParent.AppBlox).InfoTableCell,
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
	t5._registeredComponents[SduiComponentType.ExpandableText] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiExpandableText,
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
			headerComponent = if not FFlagSduiExperienceDetailsSupport then nil else parseUiComponentProp_
		},
		propInterface = {
			text = t.string
		}
	}
	t5._registeredComponents[SduiComponentType.OverflowMenu] = {
		component = require(ServerDrivenUiParent.SduiSharedContent).SduiOverflowMenu,
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
		propInterface = {
			items = if not FFlagSduiExperienceDetailsSupport then t.array(t.table) else t.table
		}
	}

	if FFlagLuaAppDismissUnlockUpsell then
		t5._registeredComponents[SduiComponentType.AgeCheckUpsellRow] = {
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

	setmetatable(t5, t2)

	return t5
end
function t2.getComponentDefinition(p1, p2) -- line: 967
	-- upvalues: FFlagSduiGlobalRegistryFallback (copy), getSduiComponentRegistry (copy)
	local v63 = p1._registeredComponents[p2]

	if not v63 then
		if FFlagSduiGlobalRegistryFallback then
			return (getSduiComponentRegistry().getComponentDefinition(p2))
		end

		v63 = nil
	end

	return v63
end
function t2.doesComponentManageChildren(p3, p4) -- line: 979
	local v66 = p3:getComponentDefinition(p4)

	return not not v66 and (v66.doesManageChildren or false)
end
function t2.getComponent(p5, p6) -- line: 987
	local v69 = p5:getComponentDefinition(p6)

	return v69 and v69.component
end
function t2.getPropParsers(p7, p8) -- line: 992
	-- upvalues: t1 (copy)
	local v72 = p7:getComponentDefinition(p8)

	return v72 and v72.propParsers or t1
end
function t2.getPropInterface(p9, p10) -- line: 1000
	local v75 = p9:getComponentDefinition(p10)

	return v75 and v75.propInterface or nil
end

local t6 = {
	[parseUiComponentProp_] = true,
	[parseCallbackProp_] = true,
	[parseFocusNavActionsProp_] = true
}

function t2.doesParserRequireRenderContext(_, p12) -- line: 1011
	-- upvalues: t6 (copy)
	if p12 and t6[p12] then
		return true
	end

	if typeof(p12) == "table" then
		return true
	end

	return false
end
function t2.registerComponent(p13, p14, p15) -- line: 1026
	p13._registeredComponents[p14] = p15
end

return t2
