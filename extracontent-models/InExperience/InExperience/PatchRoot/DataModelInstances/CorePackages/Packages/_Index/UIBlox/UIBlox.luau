local makeConfigurable = require(script.Core.Config.makeConfigurable)
local UIBloxDefaultConfig = require(script.UIBloxDefaultConfig)
local createLazyComponent = require(script.Parent.LazyRequire).createLazyComponent

require(script.App.Style.Fonts)
require(script.App.ImageSet.ImagesTypes)
require(script.App.Style.StyleTypes)
require(script.Core.Layout.Responsive.ResponsiveLayoutConfigReader)

local Overlay = require(script.App.Dialog.Overlay.Overlay)
local ControlState = require(script.Core.Control.Enum.ControlState)

require(script.Parent.React)

local function initializeLibrary(p1) -- line: 34
	-- upvalues: createLazyComponent (copy), ControlState (copy), Overlay (copy)
	local strict = require(script.Utility.strict)

	local function lazify(p2: ((...any) -> ...any)) -- line: 37
		-- upvalues: createLazyComponent (copy)
		return createLazyComponent(p2)
	end

	local t1 = {
		Core = strict({
			Layout = strict({
				Responsive = strict({
					ResponsiveLayoutProvider = require(script.Core.Layout.Responsive.ResponsiveLayoutProvider),
					useResponsiveLayout = require(script.Core.Layout.Responsive.useResponsiveLayout)
				}),
				Grid = strict({
					withGridConfig_DEPRECATED = require(script.Core.Layout.Grid.withGridConfig_DEPRECATED)
				}),
				LayerCollector = strict({
					LayerCollectorProvider = require(script.Core.Layout.LayerCollector.LayerCollectorProvider),
					useLayerCollector = require(script.Core.Layout.LayerCollector.useLayerCollector)
				})
			}),
			Animation = strict({
				withAnimation = require(script.Core.Animation.withAnimation)
			}),
			ImageSet = strict({
				ImageSetButton = require(script.Core.ImageSet.ImageSetComponent).Button,
				ImageSetLabel = require(script.Core.ImageSet.ImageSetComponent).Label,
				Validator = strict({
					validateImage = require(script.Core.ImageSet.Validator.validateImage)
				})
			}),
			Control = strict({
				Enum = strict({
					ControlState = ControlState
				}),
				Interactable = createLazyComponent(function() -- line: 74
					return require(script.Core.Control.Interactable)
				end),
				StateLayer = createLazyComponent(function() -- line: 77
					return require(script.Core.Control.StateLayer)
				end),
				FeedbackManagerInjectionContext = require(script.Core.Control.FeedbackManagerInjectionContext)
			}),
			Style = strict({
				Provider = require(script.Core.Style.StyleProvider),
				withStyle = require(script.Core.Style.withStyle),
				useStyle = require(script.Core.Style.useStyle),
				useTextSizeOffset = require(script.Core.Style.useTextSizeOffset),
				withTextSizeOffset = require(script.Core.Style.withTextSizeOffset),
				useStyleMetadata = require(script.Core.Style.useStyleMetadata)
			}),
			VR = strict({
				Panel3D = createLazyComponent(function() -- line: 94
					return require(script.Core.VR.Panel3D)
				end),
				Constants = require(script.Core.VR.Constants),
				PointerOverlay = createLazyComponent(function() -- line: 98
					return require(script.Core.VR.PointerOverlay)
				end)
			}),
			Text = strict({
				ExpandableText = strict({
					GetCanExpand = require(script.Core.Text.ExpandableText.ExpandableTextUtils).getCanExpand
				}),
				EmojiTextLabel = createLazyComponent(function() -- line: 107
					return require(script.Core.Text.EmojiTextLabel.EmojiTextLabel)
				end)
			}),
			Enums = strict({
				InputType = require(script.Enums.InputType)
			})
		}),
		Common = strict({
			Style = strict({
				ColorSystem = require(script.Common.Style.ColorSystem)
			})
		}),
		App = strict({
			Context = strict({
				ContentProvider = require(script.App.Context.ContentProvider)
			}),
			ImageSet = strict({
				Images = require(script.App.ImageSet.Images),
				getIconSize = require(script.App.ImageSet.getIconSize),
				getIconSizeUDim2 = require(script.App.ImageSet.getIconSizeUDim2),
				Enum = strict({
					IconSize = require(script.App.ImageSet.Enum.IconSize)
				})
			}),
			Bar = strict({
				HeaderBar = createLazyComponent(function() -- line: 138
					return require(script.App.Bar.HeaderBar)
				end),
				FullscreenTitleBar = createLazyComponent(function() -- line: 141
					return require(script.App.Bar.FullscreenTitleBar)
				end),
				ControllerBar = createLazyComponent(function() -- line: 144
					return require(script.App.Bar.ControllerBar)
				end)
			}),
			Button = strict({
				Enum = strict({
					ButtonType = require(script.App.Button.Enum.ButtonType),
					StandardButtonSize = require(script.Core.Button.Enum.StandardButtonSize)
				}),
				Button = createLazyComponent(function() -- line: 154
					return require(script.App.Button.Button)
				end),
				ButtonStack = createLazyComponent(function() -- line: 157
					return require(script.App.Button.ButtonStack)
				end),
				TextButton = createLazyComponent(function() -- line: 160
					return require(script.App.Button.TextButton)
				end),
				LinkButton = createLazyComponent(function() -- line: 163
					return require(script.App.Button.LinkButton)
				end),
				IconButton = createLazyComponent(function() -- line: 166
					return require(script.App.Button.IconButton)
				end),
				ActionBar = createLazyComponent(function() -- line: 169
					return require(script.App.Button.ActionBar)
				end),
				UtilityActionIcon = createLazyComponent(function() -- line: 172
					return require(script.App.Button.UtilityActionIcon)
				end),
				ComboButton = createLazyComponent(function() -- line: 175
					return require(script.App.Button.ComboButton)
				end)
			}),
			Cell = strict({
				Small = strict({
					SelectionGroup = strict({
						SmallRadioButtonGroup = createLazyComponent(function() -- line: 183
							return require(script.App.Cell.Small.SelectionGroup.SmallRadioButtonGroup)
						end)
					})
				})
			}),
			Text = strict({
				ExpandableTextArea = createLazyComponent(function() -- line: 191
					return require(script.App.Text.ExpandableTextArea.ExpandableTextArea)
				end),
				StyledTextLabel = createLazyComponent(function() -- line: 194
					return require(script.App.Text.StyledTextLabel)
				end)
			}),
			Loading = strict({
				Enum = strict({
					RetrievalStatus = require(script.App.Loading.Enum.RetrievalStatus),
					LoadingStrategy = require(script.App.Loading.Enum.LoadingStrategy)
				}),
				LoadableImage = createLazyComponent(function() -- line: 204
					return require(script.App.Loading.LoadableImage)
				end)
			}),
			InputButton = strict({
				RadioButtonList = createLazyComponent(function() -- line: 210
					return require(script.App.InputButton.RadioButtonList)
				end)
			}),
			Container = strict({
				Enum = strict({
					ScrollBarType = require(script.App.Container.Enum.ScrollBarType)
				}),
				Carousel = strict({
					FreeFlowCarousel = createLazyComponent(function() -- line: 220
						return require(script.App.Container.Carousel.FreeFlowCarousel)
					end)
				}),
				Grid = strict({
					ResponsiveGrid = createLazyComponent(function() -- line: 225
						return require(script.App.Container.Grid.ResponsiveGrid)
					end)
				}),
				VerticalScrollView = createLazyComponent(function() -- line: 229
					return require(script.App.Container.VerticalScrollView)
				end),
				VerticalScrollViewWithMargin = require(script.App.Container.VerticalScrollViewWithMargin),
				getPageMargin = require(script.App.Container.getPageMargin),
				LoadingStateContainer = createLazyComponent(function() -- line: 234
					return require(script.App.Container.LoadingStateContainer)
				end),
				LoadingStatePage = createLazyComponent(function() -- line: 237
					return require(script.App.Container.LoadingStatePage)
				end),
				HorizontalPageMargin = createLazyComponent(function() -- line: 240
					return require(script.App.Container.HorizontalPageMargin)
				end)
			}),
			Slider = strict({
				ContextualSlider = createLazyComponent(function() -- line: 246
					return require(script.App.Slider.ContextualSlider)
				end),
				SystemSlider = createLazyComponent(function() -- line: 249
					return require(script.App.Slider.SystemSlider)
				end)
			}),
			Emoji = strict({
				Enum = strict({
					Emoji = require(script.Core.Emoji.Enum.Emoji)
				})
			}),
			Grid = strict({
				GridView = createLazyComponent(function() -- line: 261
					return require(script.App.Grid.GridView)
				end),
				GridMetrics = require(script.App.Grid.GridMetrics),
				DefaultMetricsGridView = createLazyComponent(function() -- line: 265
					return require(script.App.Grid.DefaultMetricsGridView)
				end)
			}),
			Tile = strict({
				MenuTile = createLazyComponent(function() -- line: 271
					return require(script.App.Tile.MenuTile.MenuTile)
				end),
				PlayerTile = createLazyComponent(function() -- line: 274
					return require(script.App.Tile.PlayerTile.PlayerTile)
				end),
				ExperienceTileV3 = createLazyComponent(function() -- line: 277
					return require(script.App.Tile.SplitTile.ExperienceTile.ExperienceTileV3)
				end),
				AspectRatioModeEnum = require(script.App.Tile.SplitTile.ExperienceTile.Enum.AspectRatioMode),
				getExperienceTileRelativeHeight = require(script.App.Tile.SplitTile.ExperienceTile.getExperienceTileRelativeHeight),
				ExperienceActionRow = createLazyComponent(function() -- line: 284
					return require(script.App.Tile.SplitTile.ExperienceTile.ExperienceActionRow)
				end),
				VerticalTile = createLazyComponent(function() -- line: 287
					return require(script.App.Tile.SplitTile.VerticalTile.VerticalTile)
				end),
				VerticalTileThumbnail = createLazyComponent(function() -- line: 290
					return require(script.App.Tile.SplitTile.VerticalTile.VerticalTileThumbnail)
				end),
				ExperienceTileMetadata = strict({
					SocialProofFooter = createLazyComponent(function() -- line: 294
						return require(script.App.Tile.ExperienceTileMetadata.SocialProofFooter)
					end),
					CoPlayFooter = createLazyComponent(function() -- line: 297
						return require(script.App.Tile.ExperienceTileMetadata.CoPlayFooter)
					end),
					TextFooter = createLazyComponent(function() -- line: 300
						return require(script.App.Tile.ExperienceTileMetadata.TextFooter)
					end)
				})
			}),
			Dialog = strict({
				Modal = strict({
					FullPageModal = createLazyComponent(function() -- line: 308
						return require(script.App.Dialog.Modal.FullPageModal)
					end),
					getPartialPageModalMiddleContentWidth = require(script.App.Dialog.Modal.getPartialPageModalMiddleContentWidth),
					PartialPageModal = createLazyComponent(function() -- line: 314
						return require(script.App.Dialog.Modal.PartialPageModal)
					end),
					EducationalModal = createLazyComponent(function() -- line: 317
						return require(script.App.Dialog.Modal.EducationalModal)
					end),
					ModalWindow = createLazyComponent(function() -- line: 320
						return require(script.App.Dialog.Modal.ModalWindow)
					end)
				}),
				Alert = strict({
					InteractiveAlert = createLazyComponent(function() -- line: 325
						return require(script.App.Dialog.Alert.InteractiveAlert)
					end),
					LoadingAlert = createLazyComponent(function() -- line: 328
						return require(script.App.Dialog.Alert.LoadingAlert)
					end)
				}),
				Enum = strict({
					CloseButtonIcon = require(script.App.Dialog.Modal.Enum.CloseButtonIcon),
					TooltipOrientation = require(script.App.Dialog.Tooltip.Enum.TooltipOrientation)
				}),
				Toast = createLazyComponent(function() -- line: 336
					return require(script.App.Dialog.Toast.Toast)
				end),
				Tooltip = createLazyComponent(function() -- line: 339
					return require(script.App.Dialog.Tooltip.Tooltip)
				end),
				TooltipV2 = require(script.App.Dialog.TooltipV2.Controllers),
				TooltipCallout = createLazyComponent(function() -- line: 343
					return require(script.App.Dialog.TooltipV2.TooltipCallout)
				end),
				TooltipOrientation = require(script.App.Dialog.Tooltip.Enum.TooltipOrientation),
				Overlay = Overlay
			}),
			Constant = strict({
				IconSize = require(script.App.Constant.IconSize)
			}),
			Style = strict({
				AppStyleProvider = require(script.App.Style.AppStyleProvider),
				Colors = require(script.App.Style.Colors),
				Constants = require(script.App.Style.Constants),
				Themes = {
					DarkTheme = require(script.App.Style.Themes.DarkTheme),
					LightTheme = require(script.App.Style.Themes.LightTheme)
				},
				Tokens = require(script.App.Style.Tokens)
			}),
			Indicator = strict({
				Badge = createLazyComponent(function() -- line: 367
					return require(script.App.Indicator.Badge)
				end),
				EmptyState = createLazyComponent(function() -- line: 370
					return require(script.App.Indicator.EmptyState)
				end),
				Enum = strict({
					BadgeStates = require(script.App.Indicator.Enum.BadgeStates),
					BadgeVariant = require(script.App.Indicator.Enum.BadgeVariant),
					VoteStates = require(script.App.Indicator.Enum.VoteStates)
				}),
				PlayerContext = require(script.App.Indicator.PlayerContext),
				PlayerCount = createLazyComponent(function() -- line: 379
					return require(script.App.Indicator.PlayerCount)
				end),
				RateCount = createLazyComponent(function() -- line: 382
					return require(script.App.Indicator.RateCount)
				end),
				StatWidget = createLazyComponent(function() -- line: 385
					return require(script.App.Indicator.StatWidget)
				end),
				StatGroup = createLazyComponent(function() -- line: 388
					return require(script.App.Indicator.StatGroup)
				end),
				PlayerName = createLazyComponent(function() -- line: 391
					return require(script.App.Indicator.PlayerName)
				end)
			}),
			Menu = strict({
				BaseMenu = createLazyComponent(function() -- line: 397
					return require(script.App.Menu.BaseMenu)
				end),
				ContextualMenu = createLazyComponent(function() -- line: 400
					return require(script.App.Menu.ContextualMenu)
				end),
				MenuDirection = require(script.App.Menu.MenuDirection),
				DropdownMenu = createLazyComponent(function() -- line: 406
					return require(script.App.Menu.DropdownMenu)
				end),
				KeyLabel = createLazyComponent(function() -- line: 410
					return require(script.App.Menu.KeyLabel.KeyLabel)
				end),
				KeyLabelUtilities = require(script.App.Menu.KeyLabel.Utilities)
			}),
			Control = strict({
				SegmentedControl = createLazyComponent(function() -- line: 417
					return require(script.App.Control.SegmentedControl)
				end),
				Pill = createLazyComponent(function() -- line: 420
					return require(script.App.Control.Pill.Pill)
				end),
				Pillv2 = createLazyComponent(function() -- line: 423
					return require(script.App.Control.Pill.Pillv2)
				end),
				Slot = strict({
					SlotTray = createLazyComponent(function() -- line: 427
						return require(script.App.Control.Slot.SlotTray)
					end)
				}),
				PillGroup = createLazyComponent(function() -- line: 431
					return require(script.App.Control.Pill.PillGroup)
				end)
			}),
			Navigation = strict({
				Enum = strict({
					Placement = require(script.App.Navigation.Enum.Placement),
					NavigationBarAlignment = require(script.App.Navigation.Enum.NavigationBarAlignment),
					NavigationRailAlignment = require(script.App.Navigation.Enum.NavigationRailAlignment),
					NavigationTabLayout = require(script.App.Navigation.Enum.NavigationTabLayout)
				}),
				SystemBar = createLazyComponent(function() -- line: 443
					return require(script.App.Navigation.SystemBar)
				end),
				NavigationBar = createLazyComponent(function() -- line: 446
					return require(script.App.Navigation.NavigationBar)
				end),
				NavigationRailV2 = createLazyComponent(function() -- line: 449
					return require(script.App.Navigation.NavigationRailV2)
				end),
				NavigationTab = require(script.App.Navigation.NavigationTab),
				PrimaryNavBar = strict({
					IconTabGroup = createLazyComponent(function() -- line: 454
						return require(script.App.Navigation.PrimaryNavBar.IconTabGroup)
					end)
				}),
				ShortcutBar = createLazyComponent(function() -- line: 458
					return require(script.App.Navigation.ShortcutBar.ShortcutBar)
				end),
				Shortcut = createLazyComponent(function() -- line: 461
					return require(script.App.Navigation.ShortcutBar.Shortcut)
				end)
			}),
			SelectionImage = strict({
				SelectionCursorProvider = require(script.App.SelectionImage.SelectionCursorProvider),
				CursorKind = require(script.App.SelectionImage.CursorKind),
				withSelectionCursorProvider = require(script.App.SelectionImage.withSelectionCursorProvider),
				useSelectionCursor = require(script.App.SelectionImage.useSelectionCursor)
			}),
			SelectionCursor = strict({
				CursorProvider = require(script.App.SelectionCursor.CursorProvider),
				useCursor = require(script.App.SelectionCursor.useCursor),
				useCursorByType = require(script.App.SelectionCursor.useCursorByType),
				CursorType = require(script.App.SelectionCursor.CursorType)
			}),
			Table = strict({
				ListTable = createLazyComponent(function() -- line: 481
					return require(script.App.Table.ListTable)
				end),
				ScrollingListTable = createLazyComponent(function() -- line: 484
					return require(script.App.Table.ScrollingListTable)
				end),
				Cell = createLazyComponent(function() -- line: 487
					return require(script.App.Table.Cell)
				end),
				CellHeadDetail = createLazyComponent(function() -- line: 490
					return require(script.App.Table.CellHeadDetail)
				end),
				CellTailDescription = createLazyComponent(function() -- line: 493
					return require(script.App.Table.CellTailDescription)
				end)
			}),
			Input = strict({
				TextField = createLazyComponent(function() -- line: 499
					return require(script.App.Input.TextField)
				end)
			})
		}),
		UnitTestHelpers = {
			MockContentProvider = require(script.UnitTestHelpers.MockContentProvider)
		}
	}

	t1.Style = {
		Provider = t1.Core.Style.Provider,
		withStyle = t1.Core.Style.withStyle,
		Validator = {
			validateStyle = require(script.App.Style.Validator.validateStyle),
			validateFontInfo = require(script.Core.Style.Validator.validateFontInfo),
			validateTypographyInfo = require(script.Core.Style.Validator.validateTypographyInfo),
			validateColorInfo = require(script.Core.Style.Validator.validateColorInfo)
		},
		Context = require(script.Core.Style.StyleContext)
	}
	t1.AccordionView = createLazyComponent(function() -- line: 522
		return require(script.App.Accordion.AccordionView)
	end)
	t1.Tile = {
		SaveTile = createLazyComponent(function() -- line: 527
			return require(script.App.Tile.SaveTile.SaveTile)
		end),
		ItemTile = createLazyComponent(function() -- line: 530
			return require(script.App.Tile.ItemTile.ItemTile)
		end),
		ItemTileEnums = require(script.App.Tile.Enum.ItemTileEnums)
	}
	t1.Utility = {
		SpringAnimatedItem = require(script.Utility.SpringAnimatedItem),
		OpenTypeSupport = require(script.Utility.OpenTypeSupport)
	}
	t1.ModalBottomSheet = createLazyComponent(function() -- line: 545
		return require(script.ModalBottomSheet.ModalBottomSheet)
	end)

	if _G.__UIBLOX_TRACK_USAGE__ then
		local UsageTracker = require(script.Parent.UsageTracker)

		t1 = UsageTracker.trackMemberAccess("UIBlox", t1, UsageTracker.isReactComponent)
	end

	if p1.enableTraceLevelLog then
		require(script.Logger):enableTraceLog()
	end

	return t1
end

return (makeConfigurable(initializeLibrary, "UIBlox", UIBloxDefaultConfig))
