local t1 = {
	Transparency = 0,
	Color = Color3.fromRGB(255, 0, 255)
}
local t2 = {
	BackgroundDefault = t1,
	BackgroundContrast = t1,
	BackgroundMuted = t1,
	BackgroundUIDefault = t1,
	BackgroundUIContrast = t1,
	BackgroundOnHover = t1,
	BackgroundOnPress = t1,
	UIDefault = t1,
	UIMuted = t1,
	UIEmphasis = t1,
	ContextualPrimaryDefault = t1,
	ContextualPrimaryOnHover = t1,
	ContextualPrimaryContent = t1,
	SystemPrimaryDefault = t1,
	SystemPrimaryOnHover = t1,
	SystemPrimaryContent = t1,
	SecondaryDefault = t1,
	SecondaryOnHover = t1,
	SecondaryContent = t1,
	IconDefault = t1,
	IconEmphasis = t1,
	IconOnHover = t1,
	TextEmphasis = t1,
	TextDefault = t1,
	TextMuted = t1,
	Divider = t1,
	Overlay = t1,
	DropShadow = t1,
	NavigationBar = t1,
	PlaceHolder = t1,
	OnlineStatus = t1,
	OfflineStatus = t1,
	Success = t1,
	Alert = t1,
	Badge = t1,
	BadgeContent = t1
}
local t3 = {
	RelativeSize = 1,
	RelativeMinSize = 1,
	Font = Enum.Font.GothamSemibold
}
local t4 = {
	BaseSize = 10,
	Title = t3,
	Header1 = t3,
	Header2 = t3,
	SubHeader1 = t3,
	Body = t3,
	CaptionHeader = t3,
	CaptionSubHeader = t3,
	CaptionBody = t3,
	Footer = t3
}

return {
	Theme = t2,
	Font = t4
}
