local t1 = {
	Transparency = 0,
	Color = Color3.fromRGB(0, 0, 0)
}
local t2 = {
	Transparency = 0,
	GradientRotationSpeed = 2,
	Color = Color3.new(0.086, 0.678, 0.847),
	AnimatedColor = Color3.new(1, 1, 1),
	GradientColorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.514, 0.82, 0.992)),
		ColorSequenceKeypoint.new(1, Color3.new(0.086, 0.678, 0.847))
	}),
	GradientTransparencySequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
}
local t3 = {
	Transparency = 0,
	Image = "",
	Color = Color3.fromRGB(0, 0, 0)
}
local t4 = {
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
	TextLink = t1,
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
	BadgeContent = t1,
	SelectionCursor = t2,
	PlayerBackgroundDefault = t3,
	ItemBackgroundDefault = t3
}
local t5 = {
	RelativeSize = 1,
	RelativeMinSize = 1,
	Font = Enum.Font.GothamMedium
}
local t6 = {
	BaseSize = 10,
	Title = t5,
	Header1 = t5,
	Header2 = t5,
	SubHeader1 = t5,
	Body = t5,
	CaptionHeader = t5,
	CaptionSubHeader = t5,
	CaptionBody = t5,
	Footer = t5,
	HeadingLarge = t5,
	HeadingSmall = t5,
	TitleLarge = t5,
	BodyLarge = t5,
	CaptionLarge = t5,
	BodySmall = t5,
	CaptionSmall = t5
}
local t7 = {
	PreferredTransparency = 0.56,
	ReducedMotion = true
}

return {
	Theme = t4,
	Font = t6,
	Settings = t7
}
