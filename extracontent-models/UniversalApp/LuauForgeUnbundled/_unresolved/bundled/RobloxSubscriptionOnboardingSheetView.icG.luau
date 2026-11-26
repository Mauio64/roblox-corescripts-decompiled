local module = require("@luauforge/bundled/icF")
local module2 = require("@luauforge/bundled/icH")

local button = module2.Button
local icon = module2.Icon
local image = module2.Image
local sheet = module2.Sheet
local text = module2.Text
local view = module2.View
local buttonVariant = module2.Enums.ButtonVariant
local dialogSize = module2.Enums.DialogSize
local fillBehavior = module2.Enums.FillBehavior
local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize
local useScaledValue = module2.Hooks.useScaledValue
local useTokens = module2.Hooks.useTokens

local function renderTileContent(props, p2)
	if props.swatchColor then
		return module.createElement(view, {
			tag = "size-700-700 stroke-standard stroke-emphasis radius-circle",
			backgroundStyle = { Color3 = props.swatchColor, Transparency = 0 },
			testId = `{p2}--swatch`
		})
	end

	local leading = props.leading

	if leading == nil then
		return nil
	end

	if string.find(leading, "://", 1, true) then
		return module.createElement(image, {
			tag = "size-full",
			Image = leading,
			ScaleType = Enum.ScaleType.Fit,
			testId = `{p2}--image`
		})
	end

	return module.createElement(icon, {
		name = leading,
		size = iconSize.Medium,
		testId = `{p2}--icon`
	})
end

local function renderRow(props, p2, p3)
	local createElement = module.createElement
	local v6 = {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-small padding-y-small radius-medium",
		onActivated = props.onActivated,
		LayoutOrder = p2,
		testId = p3
	}

	local children = {
		Tile = module.createElement(
			view,
			{
				tag = "row align-x-center align-y-center size-1200-1200 padding-xsmall radius-medium bg-shift-200",
				LayoutOrder = 1,
				testId = `{p3}--tile`
			},
			renderTileContent(props, p3)
		),
		Text = 0,
		Chevron = 0
	}
	local createElement2 = module.createElement

	local v9 = {
		Title = module.createElement(text, {
			tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = props.title,
			LayoutOrder = 1
		}),
		Metadata = 0
	}

	local v10 = if props.metadata then module.createElement(text, {
		tag = "auto-xy text-body-medium text-align-x-left text-truncate-split",
		Text = props.metadata,
		LayoutOrder = 2
	}) else nil
	v9.Metadata = v10
	children.Text = createElement2(view, {
		tag = "col fill auto-y padding-y-xsmall",
		LayoutOrder = 2
	}, v9)

	children.Chevron = module.createElement(icon, {
		name = iconName.ChevronLargeRight,
		size = iconSize.Medium,
		LayoutOrder = 3
	})
	return createElement(view, v6, children)
end

local function RobloxSubscriptionOnboardingSheetView(props)
	local v5 = useScaledValue(181)
	local v6 = v5 + 2 * useTokens().Padding.Large

	local createElement = module.createElement
	local root = sheet.Root
	local v7 = {
		ref = props.focusRootRef,
		sheetRef = props.sheetRef,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		centerSheetHeight = 1,
		onClose = props.onClose,
		testId = "RobloxSubscriptionOnboardingSheetView"
	}

	local createElement2 = module.createElement
	local fullBleed = sheet.FullBleed
	local v8 = { media = "", height = UDim.new(0, v6) }

	local createElement3 = module.createElement

	local createElement4 = module.createElement
	local v14 = {
		Size = UDim2.fromOffset(v5, v5),
		testId = "roblox-subscription-onboarding-sheet-hero"
	}

	local v15 = {
		Headshot = module.createElement(image, {
			tag = "size-full radius-circle bg-shift-200",
			Image = props.headshotImage,
			testId = "roblox-subscription-onboarding-sheet-headshot"
		}),
		Frame = 0
	}

	local v16 = if props.frameImage then module.createElement(image, {
		tag = "size-full",
		Image = props.frameImage,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 2,
		testId = "roblox-subscription-onboarding-sheet-frame"
	}) else nil
	v15.Frame = v16
	local children = {
		FullBleed = createElement2(fullBleed, v8, {
			Hero = createElement3(
				view,
				{
					tag = "row align-x-center align-y-center size-full radius-top-large bg-shift-100",
					testId = "roblox-subscription-onboarding-sheet-hero-band"
				},
				{ Avatar = createElement4(view, v14, v15) }
			)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = module.createElement
	local content = sheet.Content

	local createElement6 = module.createElement

	local v21 = {
		Details = module.createElement(
			view,
			{
				tag = "col gap-large size-full-0 auto-y padding-x-xlarge",
				LayoutOrder = 1
			},
			{
				Copy = module.createElement(
					view,
					{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 1 },
					{
						Title = module.createElement(text, {
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
							Text = props.titleText,
							LayoutOrder = 1,
							testId = "roblox-subscription-onboarding-sheet-title"
						}),
						Body = module.createElement(text, {
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
							Text = props.bodyText,
							LayoutOrder = 2,
							testId = "roblox-subscription-onboarding-sheet-body"
						})
					}
				)
			}
		),
		Rows = 0
	}

	local createElement7 = module.createElement

	local v25 = if props.themeRow then renderRow(
		props.themeRow,
		1,
		"roblox-subscription-onboarding-sheet-app-themes"
	) else nil

	local v26 = if props.frameRow then renderRow(
		props.frameRow,
		2,
		"roblox-subscription-onboarding-sheet-profile-frames"
	) else nil
	v21.Rows = createElement7(
		view,
		{
			tag = "col size-full-0 auto-y padding-x-large",
			LayoutOrder = 2,
			testId = "roblox-subscription-onboarding-sheet-rows"
		},
		{ AppThemes = v25, ProfileFrames = v26 }
	)
	children.Content = createElement5(content, { isContentFullBleed = true }, {
		Body = createElement6(
			view,
			{
				tag = "col gap-large size-full-0 auto-y padding-bottom-small padding-top-large"
			},
			v21
		)
	})

	children.Actions = module.createElement(sheet.Actions, {}, {
		Buttons = module.createElement(view, {
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, {
			Shuffle = module.createElement(button, {
				text = props.shuffleText,
				variant = buttonVariant.Emphasis,
				fillBehavior = fillBehavior.Fill,
				isDisabled = props.isShuffleDisabled,
				onActivated = props.onShuffle,
				LayoutOrder = 1,
				testId = "roblox-subscription-onboarding-sheet-shuffle"
			}),
			Reset = module.createElement(button, {
				text = props.resetText,
				variant = buttonVariant.Standard,
				fillBehavior = fillBehavior.Fill,
				isDisabled = props.isResetDisabled,
				onActivated = props.onReset,
				LayoutOrder = 2,
				testId = "roblox-subscription-onboarding-sheet-reset"
			})
		})
	})
	return createElement(root, v7, children)
end

return RobloxSubscriptionOnboardingSheetView
