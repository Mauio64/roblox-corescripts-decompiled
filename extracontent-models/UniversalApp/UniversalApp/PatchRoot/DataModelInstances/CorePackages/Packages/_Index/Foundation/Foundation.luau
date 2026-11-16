local strict = require(script.Utility.strict)

require(script.Providers.Preferences)
local Responsive = require(script.Providers.Responsive)
local responsiveProvider = Responsive.ResponsiveProvider
local Tokens = require(script.Providers.Style.Tokens)
require(script.Components.Types)

local StyleSheetRegistry = require(script.StyleSheet.StyleSheetRegistry)

local parent = script.Parent
local inputFocusBehavior = require(parent.BuilderIcons)

local AccessoryType = require(script.Enums.AccessoryType)
local AlertSeverity = require(script.Enums.AlertSeverity)
local AlertVariant = require(script.Enums.AlertVariant)
local AvatarGroupType = require(script.Enums.AvatarGroupType)
local AvatarIconSize = require(script.Enums.AvatarIconSize)
local AvatarSize = require(script.Enums.AvatarSize)
local BadgeShape = require(script.Enums.BadgeShape)
local BadgeSize = require(script.Enums.BadgeSize)
local BadgeVariant = require(script.Enums.BadgeVariant)
local BannerContextPresentation = require(script.Enums.BannerContextPresentation)
local BannerContextVariant = require(script.Enums.BannerContextVariant)
local BannerSize = require(script.Enums.BannerSize)
local Breakpoint = require(script.Enums.Breakpoint)
local ButtonVariant = require(script.Enums.ButtonVariant)
local CardDensity = require(script.Enums.CardDensity)
local CardHeaderSize = require(script.Enums.CardHeaderSize)
local CardHeight = require(script.Enums.CardHeight)
local CardMediaAspectRatio = require(script.Enums.CardMediaAspectRatio)
local CardMediaPlacement = require(script.Enums.CardMediaPlacement)
local CardVariant = require(script.Enums.CardVariant)
local ChipGroupVariant = require(script.Enums.ChipGroupVariant)
local ChipSize = require(script.Enums.ChipSize)
local ChipVariant = require(script.Enums.ChipVariant)
local ColorMode = require(script.Enums.ColorMode)
local ControlState = require(script.Enums.ControlState)
local CursorType = require(script.Enums.CursorType)
local DateTimePickerVariant = require(script.Enums.DateTimePickerVariant)
local Device = require(script.Enums.Device)
local DialogSize = require(script.Enums.DialogSize)
local DividerVariant = require(script.Enums.DividerVariant)
local FillBehavior = require(script.Enums.FillBehavior)
local FontName = require(script.Enums.FontName)
local icon = inputFocusBehavior.Icon
local IconPosition = require(script.Enums.IconPosition)
local IconSize = require(script.Enums.IconSize)
local iconVariant = inputFocusBehavior.IconVariant
inputFocusBehavior = require(script.Enums.InputFocusBehavior)
local InputLabelSize = require(script.Enums.InputLabelSize)
local InputPlacement = require(script.Enums.InputPlacement)
local InputSize = require(script.Enums.InputSize)
local InputVariant = require(script.Enums.InputVariant)
local LinkVariant = require(script.Enums.LinkVariant)
local ListItemInputType = require(script.Enums.ListItemInputType)
local MediaAspectRatio = require(script.Enums.MediaAspectRatio)
local MediaOrientation = require(script.Enums.MediaOrientation)
local MetadataSize = require(script.Enums.MetadataSize)
local NumberInputControlsVariant = require(script.Enums.NumberInputControlsVariant)
local OnChangeCallbackReason = require(script.Enums.OnChangeCallbackReason)
local OnCloseCallbackReason = require(script.Enums.OnCloseCallbackReason)
local OptionSelectorGroupSize = require(script.Enums.OptionSelectorGroupSize)
local Orientation = require(script.Enums.Orientation)
local PaginationSize = require(script.Enums.PaginationSize)
local PaginationVariant = require(script.Enums.PaginationVariant)
local Placement = require(script.Enums.Placement)
local PopoverAlign = require(script.Enums.PopoverAlign)
local PopoverSide = require(script.Enums.PopoverSide)
local ProgressShape = require(script.Enums.ProgressShape)
local ProgressSize = require(script.Enums.ProgressSize)
local Radius = require(script.Enums.Radius)
local RatingValue = require(script.Enums.RatingValue)
local ScrollBarVisibility = require(script.Enums.ScrollBarVisibility)
local ScrubBehavior = require(script.Enums.ScrubBehavior)
local SearchInputShape = require(script.Enums.SearchInputShape)
local SegmentedControlVariant = require(script.Enums.SegmentedControlVariant)
local ShortcutSeparator = require(script.Enums.ShortcutSeparator)
local ShortcutVariant = require(script.Enums.ShortcutVariant)
local SliderType = require(script.Enums.SliderType)
local SliderVariant = require(script.Enums.SliderVariant)
local StateLayerAffordance = require(script.Enums.StateLayerAffordance)
local StateLayerMode = require(script.Enums.StateLayerMode)
local StatusBadgeShape = require(script.Enums.StatusBadgeShape)
local StatusBadgeSize = require(script.Enums.StatusBadgeSize)
local StatusBadgeVariant = require(script.Enums.StatusBadgeVariant)
local StatusIndicatorShape = require(script.Enums.StatusIndicatorShape)
local StatusIndicatorSize = require(script.Enums.StatusIndicatorSize)
local StatusIndicatorVariant = require(script.Enums.StatusIndicatorVariant)
local TextOverflow = require(script.Enums.TextOverflow)

local Theme = require(script.Enums.Theme)
local ThemeName = require(script.Enums.ThemeName)
local ThumbnailSize = require(script.Enums.ThumbnailSize)
local ThumbnailType = require(script.Enums.ThumbnailType)
local UserPresence = require(script.Enums.UserPresence)
local Visibility = require(script.Enums.Visibility)

local Accordion = require(script.Components.Accordion)

local Alert = require(script.Components.Alert)

local BannerContext = require(script.Components.BannerContext)

local Banner = require(script.Components.Banner)

local Avatar = require(script.Components.Avatar)

local AvatarGroup = require(script.Components.AvatarGroup)

local AvatarIcon = require(script.Components.AvatarIcon)

local AvatarIconGroup = require(script.Components.AvatarIconGroup)

local Badge = require(script.Components.Badge)

local BaseMenu = require(script.Components.BaseMenu)

local Breadcrumb = require(script.Components.Breadcrumb)

local Button = require(script.Components.Button)

local ButtonGroup = require(script.Components.ButtonGroup)

local Card = require(script.Components.Card)

local Checkbox = require(script.Components.Checkbox)

local CheckboxGroup = require(script.Components.CheckboxGroup)

local Coachmark = require(script.Components.Coachmark)

local EducationalTooltip = require(script.Components.EducationalTooltip)

local Chip = require(script.Components.Chip)

local ChipGroup = require(script.Components.ChipGroup)

local ColorPicker = require(script.Components.ColorPicker)

local Dialog = require(script.Components.Dialog)

local DateTimePicker = require(script.Components.DateTimePicker)

local Divider = require(script.Components.Divider)

local Dropdown = require(script.Components.Dropdown)

local Grid = require(script.Components.Grid)

local HeaderBar = require(script.Components.HeaderBar)

local Empty = require(script.Components.Empty)

local FeedbackAlert = require(script.Components.FeedbackAlert)

local Icon = require(script.Components.Icon)

local IconButton = require(script.Components.IconButton)

local Image = require(script.Components.Image)

local InputChip = require(script.Components.InputChip)

local InputLabel = require(script.Components.InputLabel)

local KeyLabel = require(script.Components.KeyLabel)

local Knob = require(script.Components.Knob)

local Link = require(script.Components.Link)

local List = require(script.Components.List)

local Loading = require(script.Components.Loading)

local Media = require(script.Components.Media)

local Metadata = require(script.Components.Metadata)

local Menu = require(script.Components.Menu)

local NavigationBar = require(script.Components.NavigationBar)

local NumberInput = require(script.Components.NumberInput)

local OptionSelectorGroup = require(script.Components.OptionSelectorGroup)

local Pagination = require(script.Components.Pagination)

local Popover = require(script.Components.Popover)

local Progress = require(script.Components.Progress)

local RadioGroup = require(script.Components.RadioGroup)

local Rating = require(script.Components.Rating)

local SearchInput = require(script.Components.SearchInput)

local ScrollView = require(script.Components.ScrollView)

local SegmentedControl = require(script.Components.SegmentedControl)

local Sheet = require(script.Components.Sheet)

local Shortcut = require(script.Components.Shortcut)

local Skeleton = require(script.Components.Skeleton)

local Slider = require(script.Components.Slider)

local Snackbar = require(script.Components.Snackbar)

local StatusBadge = require(script.Components.StatusBadge)

local StatusIndicator = require(script.Components.StatusIndicator)

local Stepper = require(script.Components.Stepper)

require(script.Components.AlertActions)

local v = {
	Accordion = Accordion,
	Alert = Alert,
	Banner = Banner,
	BannerContext = BannerContext,
	Avatar = Avatar,
	AvatarGroup = AvatarGroup,
	AvatarIcon = AvatarIcon,
	AvatarIconGroup = AvatarIconGroup,
	Badge = Badge,
	Breadcrumb = Breadcrumb,
	Button = Button,
	ButtonGroup = ButtonGroup,
	Card = Card,
	Checkbox = Checkbox,
	CheckboxGroup = CheckboxGroup,
	Chip = Chip,
	ChipGroup = ChipGroup,
	Coachmark = Coachmark,
	ColorPicker = ColorPicker,
	DateTimePicker = DateTimePicker,
	Dialog = Dialog,
	Divider = Divider,
	Dropdown = Dropdown,
	EducationalTooltip = EducationalTooltip,
	Grid = Grid,
	HeaderBar = HeaderBar,
	Empty = Empty,
	FeedbackAlert = FeedbackAlert,
	Icon = Icon,
	IconButton = IconButton,
	Image = Image,
	InputChip = InputChip,
	InputLabel = InputLabel,
	KeyLabel = KeyLabel,
	Knob = Knob,
	Link = Link,
	List = List,
	Loading = Loading,
	Media = Media,
	Metadata = Metadata,
	Menu = Menu,
	NavigationBar = NavigationBar,
	NumberInput = NumberInput,
	OptionSelectorGroup = OptionSelectorGroup,
	Pagination = Pagination,
	Pill = Chip,
	Popover = Popover,
	Progress = Progress,
	RadioGroup = RadioGroup,
	Rating = Rating,
	SearchInput = SearchInput,
	ScrollView = ScrollView,
	SegmentedControl = SegmentedControl,
	Sheet = Sheet,
	Shortcut = Shortcut,
	Skeleton = Skeleton,
	Slider = Slider,
	Snackbar = Snackbar,
	StatusBadge = StatusBadge,
	StatusIndicator = StatusIndicator,
	Stepper = Stepper,
	SystemBanner = require(script.Components.SystemBanner),
	Tabs = require(script.Components.Tabs),
	Text = require(script.Components.Text),
	TextArea = require(script.Components.TextArea),
	TextInput = require(script.Components.TextInput),
	Toggle = require(script.Components.Toggle),
	ToggleGroup = require(script.Components.ToggleGroup),
	Tooltip = require(script.Components.Tooltip),
	Toast = require(script.Components.Toast),
	View = require(script.Components.View),
	FoundationProvider = require(script.Providers.Foundation),
	OverlayProvider = require(script.Providers.Overlay),
	ResponsiveProvider = responsiveProvider,
	BackgroundStyleContext = require(script.Providers.Style.BackgroundStyleContext)
}

local hooks = {
	useBreakpoint = require(script.Providers.Responsive.Hooks.useBreakpoint),
	useResponsiveValue = require(script.Providers.Responsive.Hooks.useResponsiveValue),
	useResponsive = require(script.Providers.Responsive.useResponsive),
	useCumulativeBackground = require(script.Utility.useCumulativeBackground),
	useCursor = require(script.Providers.Cursor.useCursor),
	useDefaultTags = require(script.Utility.useDefaultTags),
	useDialogNavigation = require(script.Components.Dialog.useDialogNavigation),
	useSheetNavigation = require(script.Components.Sheet.useSheetNavigation),
	useIconSize = require(script.Utility.useIconSize),
	useMeasurableRef = require(script.Components.Popover.useMeasurableRef),
	useOverlay = require(script.Providers.Overlay.useOverlay),
	usePointerPosition = require(script.Utility.usePointerPosition),
	usePreferences = require(script.Providers.Preferences.usePreferences),
	usePulseBinding = require(script.Utility.usePulseBinding),
	useRotation = require(script.Utility.useRotation),
	useScaledValue = require(script.Utility.useScaledValue),
	useStyleSheet = 0,
	useStyleTags = 0,
	useTextSize = 0,
	useTextSizeOffset = 0,
	useTokens = 0,
	withCursor = 0,
	withTokens_DEPRECATED = 0
}
local StyleSheetContext = require(script.Providers.Style.StyleSheetContext)
hooks.useStyleSheet = StyleSheetContext.useStyleSheet
hooks.useStyleTags = require(script.Providers.Style.useStyleTags)
hooks.useTextSize = require(script.Utility.useTextSize)
hooks.useTextSizeOffset = require(script.Providers.Style.useTextSizeOffset)
hooks.useTokens = require(script.Providers.Style.useTokens)
hooks.withCursor = require(script.Providers.Cursor.withCursor)
hooks.withTokens_DEPRECATED = require(script.Providers.Style.withTokens_DEPRECATED)
v.Hooks = hooks

v.Enums = {
	AccessoryType = AccessoryType,
	AlertSeverity = AlertSeverity,
	AlertVariant = AlertVariant,
	BannerSize = BannerSize,
	BannerContextPresentation = BannerContextPresentation,
	BannerContextVariant = BannerContextVariant,
	AvatarGroupType = AvatarGroupType,
	AvatarIconSize = AvatarIconSize,
	AvatarSize = AvatarSize,
	BadgeShape = BadgeShape,
	BadgeSize = BadgeSize,
	BadgeVariant = BadgeVariant,
	Breakpoint = Breakpoint,
	ButtonSize = require(script.Enums.InputSize),
	ButtonVariant = ButtonVariant,
	CardDensity = CardDensity,
	CardHeaderSize = CardHeaderSize,
	CardHeight = CardHeight,
	CardMediaAspectRatio = CardMediaAspectRatio,
	CardMediaPlacement = CardMediaPlacement,
	CardVariant = CardVariant,
	CheckboxSize = require(script.Enums.InputSize),
	ControlState = ControlState,
	ChipGroupVariant = ChipGroupVariant,
	ChipSize = ChipSize,
	ChipVariant = ChipVariant,
	ColorMode = ColorMode,
	CursorType = CursorType,
	DateTimePickerVariant = DateTimePickerVariant,
	Device = Device,
	DialogSize = DialogSize,
	DividerOrientation = require(script.Enums.Orientation),
	DividerVariant = DividerVariant,
	FillBehavior = FillBehavior,
	FontName = FontName,
	IconName = icon,
	IconPosition = IconPosition,
	IconSize = IconSize,
	IconVariant = iconVariant,
	InputFocusBehavior = inputFocusBehavior,
	InputSize = InputSize,
	InputVariant = InputVariant,
	InputPlacement = InputPlacement,
	InputLabelSize = InputLabelSize,
	LinkVariant = LinkVariant,
	ListItemInputType = ListItemInputType,
	MediaAspectRatio = MediaAspectRatio,
	MediaOrientation = MediaOrientation,
	MetadataSize = MetadataSize,
	NumberInputControlsVariant = NumberInputControlsVariant,
	ScrubBehavior = ScrubBehavior,
	OnChangeCallbackReason = OnChangeCallbackReason,
	OnCloseCallbackReason = OnCloseCallbackReason,
	OptionSelectorGroupSize = OptionSelectorGroupSize,
	Orientation = Orientation,
	PaginationSize = PaginationSize,
	PaginationVariant = PaginationVariant,
	Placement = Placement,
	PopoverAlign = PopoverAlign,
	PopoverSide = PopoverSide,
	ProgressShape = ProgressShape,
	ProgressSize = ProgressSize,
	RatingValue = RatingValue,
	Radius = Radius,
	SearchInputShape = SearchInputShape,
	SegmentedControlVariant = SegmentedControlVariant,
	ShortcutSeparator = ShortcutSeparator,
	ShortcutVariant = ShortcutVariant,
	ScrollBarVisibility = ScrollBarVisibility,
	SliderType = SliderType,
	SliderVariant = SliderVariant,
	StateLayerAffordance = StateLayerAffordance,
	StateLayerMode = StateLayerMode,
	StatusBadgeShape = StatusBadgeShape,
	StatusBadgeSize = StatusBadgeSize,
	StatusBadgeVariant = StatusBadgeVariant,
	StatusIndicatorShape = StatusIndicatorShape,
	StatusIndicatorSize = StatusIndicatorSize,
	StatusIndicatorVariant = StatusIndicatorVariant,
	TextOverflow = TextOverflow,
	Theme = Theme,
	ThemeName = ThemeName,
	ThumbnailType = ThumbnailType,
	ThumbnailSize = ThumbnailSize,
	ToggleSize = require(script.Enums.InputSize),
	UserPresence = UserPresence,
	Visibility = Visibility
}

v.Utility = {
	getStyleSheet = StyleSheetRegistry.getStyleSheet,
	addStyleTags = StyleSheetRegistry.addStyleTags,
	releaseStyleSheet = StyleSheetRegistry.releaseStyleSheet,
	getTokens = Tokens.getTokens,
	blendColors = require(script.Utility.blendColors),
	composeStyleVariant = require(script.Utility.composeStyleVariant),
	getBuilderIconForKeycode = require(script.Utility.getBuilderIconForKeycode),
	getBuilderIconForCurrentPlatform = require(script.Utility.getBuilderIconForCurrentPlatform),
	getBuilderIconVariant = require(script.Utility.getBuilderIconVariant),
	getGridMetrics = require(script.Utility.getGridMetrics),
	getRbxThumb = require(script.Utility.getRbxThumb),
	getIconRichText = require(script.Utility.getIconRichText),
	getTextBoundsAsync = require(script.Utility.getTextBoundsAsync),
	getTextSizeOffset = require(script.Utility.getTextSizeOffset),
	indexBindable = require(script.Utility.indexBindable),
	mockComponent = require(script.Utility.mockComponent),
	withCommonProps = require(script.Utility.withCommonProps),
	withDefaults = require(script.Utility.withDefaults),
	isBuilderIcon = require(script.Utility.isBuilderIcon),
	isPointInGuiObjectBounds = require(script.Utility.isPointInGuiObjectBounds),
	normalizeFontFace = require(script.Utility.normalizeFontFace),
	preloadCloudAssets = require(script.Utility.preloadAssets),
	Flags = require(script.Utility.Flags)
}

v.UNSTABLE = {
	Interactable = require(script.Components.Interactable),
	withCursorMigration = require(script.Providers.Cursor.withCursorMigration),
	BaseMenu = BaseMenu
}
responsiveProvider = strict(v)

if _G.__FOUNDATION_TRACK_USAGE__ then
	local UsageTracker = require(script.Parent.UsageTracker)

	responsiveProvider = UsageTracker.trackMemberAccess("Foundation", responsiveProvider, UsageTracker.isReactComponent)
end

if _G.__FOUNDATION_TRACE_LOG__ then
	local Logger = require(script.Utility.Logger)
	Logger:enableTraceLog()
end

return responsiveProvider
