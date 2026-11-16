local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local t = require(parent2.t)

local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local validateSelectionCursorInfo = require(parent.Core.Style.Validator.validateSelectionCursorInfo)
local validateThemedBackgroundImageInfo = require(parent.Core.Style.Validator.validateThemedBackgroundImageInfo)

return (t.strictInterface({
	BackgroundDefault = validateColorInfo,
	BackgroundContrast = validateColorInfo,
	BackgroundMuted = validateColorInfo,
	BackgroundUIDefault = validateColorInfo,
	BackgroundUIContrast = validateColorInfo,
	BackgroundOnHover = validateColorInfo,
	BackgroundOnPress = validateColorInfo,
	UIDefault = validateColorInfo,
	UIMuted = validateColorInfo,
	UIEmphasis = validateColorInfo,
	ContextualPrimaryDefault = validateColorInfo,
	ContextualPrimaryOnHover = validateColorInfo,
	ContextualPrimaryContent = validateColorInfo,
	SystemPrimaryDefault = validateColorInfo,
	SystemPrimaryOnHover = validateColorInfo,
	SystemPrimaryContent = validateColorInfo,
	SecondaryDefault = validateColorInfo,
	SecondaryOnHover = validateColorInfo,
	SecondaryContent = validateColorInfo,
	IconDefault = validateColorInfo,
	IconEmphasis = validateColorInfo,
	IconOnHover = validateColorInfo,
	TextEmphasis = validateColorInfo,
	TextDefault = validateColorInfo,
	TextMuted = validateColorInfo,
	TextLink = validateColorInfo,
	Divider = validateColorInfo,
	Overlay = validateColorInfo,
	DropShadow = validateColorInfo,
	NavigationBar = validateColorInfo,
	PlaceHolder = validateColorInfo,
	OnlineStatus = validateColorInfo,
	OfflineStatus = validateColorInfo,
	Success = validateColorInfo,
	Alert = validateColorInfo,
	Badge = validateColorInfo,
	BadgeContent = validateColorInfo,
	SelectionCursor = validateSelectionCursorInfo,
	PlayerBackgroundDefault = validateThemedBackgroundImageInfo,
	ItemBackgroundDefault = validateThemedBackgroundImageInfo
}))
