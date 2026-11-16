local v = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0 }

local selectionCursor = {
	Color = Color3.new(0.086, 0.678, 0.847),
	Transparency = 0,
	AnimatedColor = Color3.new(1, 1, 1),
	GradientRotationSpeed = 2,
	GradientColorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0.514, 0.82, 0.992)),
		ColorSequenceKeypoint.new(1, Color3.new(0.086, 0.678, 0.847))
	}),
	GradientTransparencySequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
}

local v2 = { Color = Color3.fromRGB(0, 0, 0), Transparency = 0, Image = "" }

local v3 = { Font = Enum.Font.GothamMedium, RelativeSize = 1, RelativeMinSize = 1 }
return {
	Theme = {
		BackgroundDefault = v,
		BackgroundContrast = v,
		BackgroundMuted = v,
		BackgroundUIDefault = v,
		BackgroundUIContrast = v,
		BackgroundOnHover = v,
		BackgroundOnPress = v,
		UIDefault = v,
		UIMuted = v,
		UIEmphasis = v,
		ContextualPrimaryDefault = v,
		ContextualPrimaryOnHover = v,
		ContextualPrimaryContent = v,
		SystemPrimaryDefault = v,
		SystemPrimaryOnHover = v,
		SystemPrimaryContent = v,
		SecondaryDefault = v,
		SecondaryOnHover = v,
		SecondaryContent = v,
		IconDefault = v,
		IconEmphasis = v,
		IconOnHover = v,
		TextEmphasis = v,
		TextDefault = v,
		TextMuted = v,
		TextLink = v,
		Divider = v,
		Overlay = v,
		DropShadow = v,
		NavigationBar = v,
		PlaceHolder = v,
		OnlineStatus = v,
		OfflineStatus = v,
		Success = v,
		Alert = v,
		Badge = v,
		BadgeContent = v,
		SelectionCursor = selectionCursor,
		PlayerBackgroundDefault = v2,
		ItemBackgroundDefault = v2
	},
	Font = {
		BaseSize = 10,
		Title = v3,
		Header1 = v3,
		Header2 = v3,
		SubHeader1 = v3,
		Body = v3,
		CaptionHeader = v3,
		CaptionSubHeader = v3,
		CaptionBody = v3,
		Footer = v3,
		HeadingLarge = v3,
		HeadingSmall = v3,
		TitleLarge = v3,
		BodyLarge = v3,
		CaptionLarge = v3,
		BodySmall = v3,
		CaptionSmall = v3
	},
	Settings = { PreferredTransparency = 0.56, ReducedMotion = true }
}
