local makeConfigurable = require(script.Core.Config.makeConfigurable)
local UIBloxDefaultConfig = require(script.UIBloxDefaultConfig)

local createLazyComponent = require(script.Utility.createLazyComponent)

require(script.App.Style.Fonts)
require(script.App.ImageSet.ImagesTypes)
require(script.App.Style.StyleTypes)
require(script.Core.Layout.Responsive.ResponsiveLayoutConfigReader)
local Overlay = require(script.App.Dialog.Overlay.Overlay)
local ControlState = require(script.Core.Control.Enum.ControlState)

require(script.Parent.React)

local function initializeLibrary(p)
	local strict = require(script.Utility.strict)

	local function lazify(callback)
		return (createLazyComponent(callback))
	end

	local v2 = {
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
		ImageSet = 0,
		Control = 0,
		Style = 0,
		VR = 0,
		Text = 0,
		Enums = 0
	}

	local ImageSetComponent = require(script.Core.ImageSet.ImageSetComponent)
	local v3 = { ImageSetButton = ImageSetComponent.Button, ImageSetLabel = 0, Validator = 0 }
	local ImageSetComponent2 = require(script.Core.ImageSet.ImageSetComponent)
	v3.ImageSetLabel = ImageSetComponent2.Label
	v3.Validator = strict({
		validateImage = require(script.Core.ImageSet.Validator.validateImage)
	})
	v2.ImageSet = strict(v3)
	v2.Control = strict({
		Enum = strict({ ControlState = ControlState }),
		Interactable = createLazyComponent(function()
			return require(script.Core.Control.Interactable)
		end),
		StateLayer = createLazyComponent(function()
			return require(script.Core.Control.StateLayer)
		end),
		FeedbackManagerInjectionContext = require(script.Core.Control.FeedbackManagerInjectionContext)
	})

	v2.Style = strict({
		Provider = require(script.Core.Style.StyleProvider),
		withStyle = require(script.Core.Style.withStyle),
		useStyle = require(script.Core.Style.useStyle),
		useTextSizeOffset = require(script.Core.Style.useTextSizeOffset),
		withTextSizeOffset = require(script.Core.Style.withTextSizeOffset),
		useStyleMetadata = require(script.Core.Style.useStyleMetadata)
	})
	v2.VR = strict({
		Panel3D = createLazyComponent(function()
			return require(script.Core.VR.Panel3D)
		end),
		Constants = require(script.Core.VR.Constants),
		PointerOverlay = createLazyComponent(function()
			return require(script.Core.VR.PointerOverlay)
		end)
	})

	local ExpandableTextUtils = require(script.Core.Text.ExpandableText.ExpandableTextUtils)
	v2.Text = strict({
		ExpandableText = strict({ GetCanExpand = ExpandableTextUtils.getCanExpand }),
		GetTextSize = require(script.Core.Text.GetTextSize),
		EmojiTextLabel = createLazyComponent(function()
			return require(script.Core.Text.EmojiTextLabel.EmojiTextLabel)
		end)
	})

	v2.Enums = strict({
		InputType = require(script.Enums.InputType)
	})
	local v = {}

	v.Core = strict(v2)

	v.Common = strict({
		Style = strict({
			ColorSystem = require(script.Common.Style.ColorSystem)
		})
	})
	v.App = strict({
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
			HeaderBar = createLazyComponent(function()
				return require(script.App.Bar.HeaderBar)
			end),
			FullscreenTitleBar = createLazyComponent(function()
				return require(script.App.Bar.FullscreenTitleBar)
			end),
			ControllerBar = createLazyComponent(function()
				return require(script.App.Bar.ControllerBar)
			end)
		}),
		Button = strict({
			Enum = strict({
				ButtonType = require(script.App.Button.Enum.ButtonType),
				StandardButtonSize = require(script.Core.Button.Enum.StandardButtonSize)
			}),
			Button = createLazyComponent(function()
				return require(script.App.Button.Button)
			end),
			ButtonStack = createLazyComponent(function()
				return require(script.App.Button.ButtonStack)
			end),
			TextButton = createLazyComponent(function()
				return require(script.App.Button.TextButton)
			end),
			LinkButton = createLazyComponent(function()
				return require(script.App.Button.LinkButton)
			end),
			IconButton = createLazyComponent(function()
				return require(script.App.Button.IconButton)
			end),
			ActionBar = createLazyComponent(function()
				return require(script.App.Button.ActionBar)
			end),
			UtilityActionIcon = createLazyComponent(function()
				return require(script.App.Button.UtilityActionIcon)
			end),
			ComboButton = createLazyComponent(function()
				return require(script.App.Button.ComboButton)
			end)
		}),
		Cell = strict({
			Small = strict({
				SelectionGroup = strict({
					SmallRadioButtonGroup = createLazyComponent(function()
						return require(script.App.Cell.Small.SelectionGroup.SmallRadioButtonGroup)
					end)
				})
			})
		}),
		Text = strict({
			ExpandableTextArea = createLazyComponent(function()
				return require(script.App.Text.ExpandableTextArea.ExpandableTextArea)
			end),
			StyledTextLabel = createLazyComponent(function()
				return require(script.App.Text.StyledTextLabel)
			end)
		}),
		Loading = strict({
			Enum = strict({
				RetrievalStatus = require(script.App.Loading.Enum.RetrievalStatus),
				LoadingStrategy = require(script.App.Loading.Enum.LoadingStrategy)
			}),
			LoadableImage = createLazyComponent(function()
				return require(script.App.Loading.LoadableImage)
			end)
		}),
		InputButton = strict({
			RadioButtonList = createLazyComponent(function()
				return require(script.App.InputButton.RadioButtonList)
			end)
		}),
		Container = strict({
			Enum = strict({
				ScrollBarType = require(script.App.Container.Enum.ScrollBarType)
			}),
			Carousel = strict({
				FreeFlowCarousel = createLazyComponent(function()
					return require(script.App.Container.Carousel.FreeFlowCarousel)
				end)
			}),
			Grid = strict({
				ResponsiveGrid = createLazyComponent(function()
					return require(script.App.Container.Grid.ResponsiveGrid)
				end)
			}),
			VerticalScrollView = createLazyComponent(function()
				return require(script.App.Container.VerticalScrollView)
			end),
			VerticalScrollViewWithMargin = require(script.App.Container.VerticalScrollViewWithMargin),
			getPageMargin = require(script.App.Container.getPageMargin),
			LoadingStateContainer = createLazyComponent(function()
				return require(script.App.Container.LoadingStateContainer)
			end),
			LoadingStatePage = createLazyComponent(function()
				return require(script.App.Container.LoadingStatePage)
			end),
			HorizontalPageMargin = createLazyComponent(function()
				return require(script.App.Container.HorizontalPageMargin)
			end)
		}),
		Slider = strict({
			ContextualSlider = createLazyComponent(function()
				return require(script.App.Slider.ContextualSlider)
			end),
			SystemSlider = createLazyComponent(function()
				return require(script.App.Slider.SystemSlider)
			end)
		}),
		Emoji = strict({
			Enum = strict({
				Emoji = require(script.Core.Emoji.Enum.Emoji)
			})
		}),
		Grid = strict({
			GridView = createLazyComponent(function()
				return require(script.App.Grid.GridView)
			end),
			GridMetrics = require(script.App.Grid.GridMetrics),
			DefaultMetricsGridView = createLazyComponent(function()
				return require(script.App.Grid.DefaultMetricsGridView)
			end)
		}),
		Tile = strict({
			MenuTile = createLazyComponent(function()
				return require(script.App.Tile.MenuTile.MenuTile)
			end),
			PlayerTile = createLazyComponent(function()
				return require(script.App.Tile.PlayerTile.PlayerTile)
			end),
			ExperienceTileV3 = createLazyComponent(function()
				return require(script.App.Tile.SplitTile.ExperienceTile.ExperienceTileV3)
			end),
			AspectRatioModeEnum = require(script.App.Tile.SplitTile.ExperienceTile.Enum.AspectRatioMode),
			getExperienceTileRelativeHeight = require(script.App.Tile.SplitTile.ExperienceTile.getExperienceTileRelativeHeight),
			ExperienceActionRow = createLazyComponent(function()
				return require(script.App.Tile.SplitTile.ExperienceTile.ExperienceActionRow)
			end),
			VerticalTile = createLazyComponent(function()
				return require(script.App.Tile.SplitTile.VerticalTile.VerticalTile)
			end),
			VerticalTileThumbnail = createLazyComponent(function()
				return require(script.App.Tile.SplitTile.VerticalTile.VerticalTileThumbnail)
			end),
			ExperienceTileMetadata = strict({
				SocialProofFooter = createLazyComponent(function()
					return require(script.App.Tile.ExperienceTileMetadata.SocialProofFooter)
				end),
				CoPlayFooter = createLazyComponent(function()
					return require(script.App.Tile.ExperienceTileMetadata.CoPlayFooter)
				end),
				TextFooter = createLazyComponent(function()
					return require(script.App.Tile.ExperienceTileMetadata.TextFooter)
				end)
			})
		}),
		Dialog = strict({
			Modal = strict({
				FullPageModal = createLazyComponent(function()
					return require(script.App.Dialog.Modal.FullPageModal)
				end),
				getPartialPageModalMiddleContentWidth = require(script.App.Dialog.Modal.getPartialPageModalMiddleContentWidth),
				PartialPageModal = createLazyComponent(function()
					return require(script.App.Dialog.Modal.PartialPageModal)
				end),
				EducationalModal = createLazyComponent(function()
					return require(script.App.Dialog.Modal.EducationalModal)
				end),
				ModalWindow = createLazyComponent(function()
					return require(script.App.Dialog.Modal.ModalWindow)
				end)
			}),
			Alert = strict({
				InteractiveAlert = createLazyComponent(function()
					return require(script.App.Dialog.Alert.InteractiveAlert)
				end),
				LoadingAlert = createLazyComponent(function()
					return require(script.App.Dialog.Alert.LoadingAlert)
				end)
			}),
			Enum = strict({
				CloseButtonIcon = require(script.App.Dialog.Modal.Enum.CloseButtonIcon),
				TooltipOrientation = require(script.App.Dialog.Tooltip.Enum.TooltipOrientation)
			}),
			Toast = createLazyComponent(function()
				return require(script.App.Dialog.Toast.Toast)
			end),
			Tooltip = createLazyComponent(function()
				return require(script.App.Dialog.Tooltip.Tooltip)
			end),
			TooltipV2 = require(script.App.Dialog.TooltipV2.Controllers),
			TooltipCallout = createLazyComponent(function()
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
			Badge = createLazyComponent(function()
				return require(script.App.Indicator.Badge)
			end),
			EmptyState = createLazyComponent(function()
				return require(script.App.Indicator.EmptyState)
			end),
			Enum = strict({
				BadgeStates = require(script.App.Indicator.Enum.BadgeStates),
				BadgeVariant = require(script.App.Indicator.Enum.BadgeVariant),
				VoteStates = require(script.App.Indicator.Enum.VoteStates)
			}),
			PlayerContext = require(script.App.Indicator.PlayerContext),
			PlayerCount = createLazyComponent(function()
				return require(script.App.Indicator.PlayerCount)
			end),
			RateCount = createLazyComponent(function()
				return require(script.App.Indicator.RateCount)
			end),
			StatWidget = createLazyComponent(function()
				return require(script.App.Indicator.StatWidget)
			end),
			StatGroup = createLazyComponent(function()
				return require(script.App.Indicator.StatGroup)
			end),
			PlayerName = createLazyComponent(function()
				return require(script.App.Indicator.PlayerName)
			end)
		}),
		Menu = strict({
			BaseMenu = createLazyComponent(function()
				return require(script.App.Menu.BaseMenu)
			end),
			ContextualMenu = createLazyComponent(function()
				return require(script.App.Menu.ContextualMenu)
			end),
			MenuDirection = require(script.App.Menu.MenuDirection),
			DropdownMenu = createLazyComponent(function()
				return require(script.App.Menu.DropdownMenu)
			end),
			KeyLabel = createLazyComponent(function()
				return require(script.App.Menu.KeyLabel.KeyLabel)
			end),
			KeyLabelUtilities = require(script.App.Menu.KeyLabel.Utilities)
		}),
		Control = strict({
			SegmentedControl = createLazyComponent(function()
				return require(script.App.Control.SegmentedControl)
			end),
			Pill = createLazyComponent(function()
				return require(script.App.Control.Pill.Pill)
			end),
			Pillv2 = createLazyComponent(function()
				return require(script.App.Control.Pill.Pillv2)
			end),
			Slot = strict({
				SlotTray = createLazyComponent(function()
					return require(script.App.Control.Slot.SlotTray)
				end)
			}),
			PillGroup = createLazyComponent(function()
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
			SystemBar = createLazyComponent(function()
				return require(script.App.Navigation.SystemBar)
			end),
			NavigationBar = createLazyComponent(function()
				return require(script.App.Navigation.NavigationBar)
			end),
			NavigationRailV2 = createLazyComponent(function()
				return require(script.App.Navigation.NavigationRailV2)
			end),
			NavigationTab = require(script.App.Navigation.NavigationTab),
			PrimaryNavBar = strict({
				IconTabGroup = createLazyComponent(function()
					return require(script.App.Navigation.PrimaryNavBar.IconTabGroup)
				end)
			}),
			ShortcutBar = createLazyComponent(function()
				return require(script.App.Navigation.ShortcutBar.ShortcutBar)
			end),
			Shortcut = createLazyComponent(function()
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
			ListTable = createLazyComponent(function()
				return require(script.App.Table.ListTable)
			end),
			ScrollingListTable = createLazyComponent(function()
				return require(script.App.Table.ScrollingListTable)
			end),
			Cell = createLazyComponent(function()
				return require(script.App.Table.Cell)
			end),
			CellHeadDetail = createLazyComponent(function()
				return require(script.App.Table.CellHeadDetail)
			end),
			CellTailDescription = createLazyComponent(function()
				return require(script.App.Table.CellTailDescription)
			end)
		}),
		Input = strict({
			TextField = createLazyComponent(function()
				return require(script.App.Input.TextField)
			end)
		})
	})

	v.UnitTestHelpers = {
		MockContentProvider = require(script.UnitTestHelpers.MockContentProvider)
	}

	v.Style = {
		Provider = v.Core.Style.Provider,
		withStyle = v.Core.Style.withStyle,
		Validator = {
			validateStyle = require(script.App.Style.Validator.validateStyle),
			validateFontInfo = require(script.Core.Style.Validator.validateFontInfo),
			validateTypographyInfo = require(script.Core.Style.Validator.validateTypographyInfo),
			validateColorInfo = require(script.Core.Style.Validator.validateColorInfo)
		},
		Context = require(script.Core.Style.StyleContext)
	}
	v.AccordionView = createLazyComponent(function()
		return require(script.App.Accordion.AccordionView)
	end)
	v.Tile = {
		SaveTile = createLazyComponent(function()
			return require(script.App.Tile.SaveTile.SaveTile)
		end),
		ItemTile = createLazyComponent(function()
			return require(script.App.Tile.ItemTile.ItemTile)
		end),
		ItemTileEnums = require(script.App.Tile.Enum.ItemTileEnums)
	}

	v.Utility = {
		SpringAnimatedItem = require(script.Utility.SpringAnimatedItem),
		OpenTypeSupport = require(script.Utility.OpenTypeSupport)
	}
	v.ModalBottomSheet = createLazyComponent(function()
		return require(script.ModalBottomSheet.ModalBottomSheet)
	end)

	if _G.__UIBLOX_TRACK_USAGE__ then
		local UsageTracker = require(script.Parent.UsageTracker)

		v = UsageTracker.trackMemberAccess("UIBlox", v, UsageTracker.isReactComponent)
	end

	if p.enableTraceLevelLog then
		local Logger = require(script.Logger)
		Logger:enableTraceLog()
	end

	return v
end

return (makeConfigurable(initializeLibrary, "UIBlox", UIBloxDefaultConfig))
