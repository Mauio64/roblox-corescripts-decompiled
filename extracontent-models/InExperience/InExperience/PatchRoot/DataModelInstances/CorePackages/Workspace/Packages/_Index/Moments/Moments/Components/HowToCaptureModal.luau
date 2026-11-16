local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor
local Constants = require(Moments.Constants)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local v = {
	title = "Feature.Moments.Label.HowToUseCaptureTitle",
	step1 = "Feature.Moments.Description.HowToCaptureStep1",
	step2 = "Feature.Moments.Description.HowToCaptureStep2",
	step3 = "Feature.Moments.Description.HowToCaptureStep3",
	back = "Feature.Moments.Action.Back",
	done = "Feature.Moments.Action.Done",
	next = "Feature.Moments.Action.Continue"
}

local v2 = {
	{ image = Constants.HowToCaptureModalSteps.image1, descriptionKey = "step1" },
	{ image = Constants.HowToCaptureModalSteps.image2, descriptionKey = "step2" },
	{ image = Constants.HowToCaptureModalSteps.image3, descriptionKey = "step3" }
}

local function HowToCaptureModal(p)
	local v3 = useLocalization(v)
	local v4 = useDeviceInsets()
	local v5 = useTokens()
	local v6 = useFormFactor()

	local state, setState = React.useState(1)

	local ref = React.useRef({ true })

	React.useEffect(function()
		if not ref.current[state] then
			ref.current[state] = true
			fireAnalyticsEvent(EventNames.FTUXHowToCaptureCarouselImpression)
		end
	end, { state })

	local onActivated = React.useCallback(function()
		setState(function(p2)
			return (math.max(1, p2 - 1))
		end)
	end, {})

	local onActivated2 = React.useCallback(function()
		setState(function(p2)
			return (math.min(#v2, p2 + 1))
		end)
	end, {})

	local v7 = v2[state]

	local children = {}

	for i = 1, #v2 do
		children["dot_" .. i] = React.createElement(View, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(8, 8),
			tag = {
				["radius-circle bg-system-contrast"] = i == state,
				["radius-circle bg-system-emphasis"] = i ~= state
			}
		})
	end

	local createElement = React.createElement
	local maxSize

	if v6 == FormFactor.Wide then
		maxSize = Vector2.new(600, 700)
	end

	local v8 = {
		CloseButtonContainer = React.createElement(View, {
			padding = {
				top = UDim.new(0, v4.top + v5.Padding.Medium),
				right = UDim.new(0, v4.right + v5.Padding.Medium)
			},
			tag = "position-top-right anchor-top-right auto-xy"
		}, {
			CloseButton = React.createElement(
				View,
				{
					onActivated = p.onClose,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0"
				},
				{
					CloseIcon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = "icons/navigation/close_small",
						size = Foundation.Enums.IconSize.Small,
						style = v5.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		}),
		Body = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		padding = {
			top = UDim.new(0, v4.top + v5.Padding.XLarge),
			bottom = UDim.new(0, (math.max(v4.bottom, v5.Padding.Medium))),
			left = UDim.new(0, (math.max(v4.left, v5.Padding.Large))),
			right = UDim.new(0, (math.max(v4.right, v5.Padding.Large)))
		},
		tag = "col align-x-center align-y-center gap-large size-full"
	}

	local v10 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v3.title,
			tag = "size-full-0 auto-y text-heading-large text-wrap text-align-x-center content-emphasis"
		}),
		StepImage = React.createElement(Image, {
			Image = v7.image,
			LayoutOrder = 2,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(0.8, 0.45),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}),
		Dots = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "row align-x-center align-y-center gap-small auto-xy" },
			children
		),
		Description = React.createElement(Text, {
			LayoutOrder = 4,
			Text = v3[v7.descriptionKey],
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-muted"
		}),
		Nav = 0
	}

	local createElement3 = React.createElement
	local backButton

	if state > 1 then
		backButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 1,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Large,
			text = v3.back,
			variant = Foundation.Enums.ButtonVariant.Standard,
			width = UDim.new(1, 0)
		})
	end

	local createElement4 = React.createElement
	local v11 = {
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		LayoutOrder = 2,
		onActivated = 0,
		size = 0,
		text = 0,
		variant = 0,
		width = 0
	}

	if not (state < #v2) then
		onActivated2 = p.onClose
	end

	v11.onActivated = onActivated2
	v11.size = Foundation.Enums.InputSize.Large
	local text = if state < #v2 then v3.next else v3.done
	v11.text = text
	v11.variant = Foundation.Enums.ButtonVariant.Emphasis
	v11.width = UDim.new(1, 0)
	v10.Nav = createElement3(
		View,
		{ LayoutOrder = 5, tag = "row align-x-center align-y-center gap-medium size-full-0 auto-y" },
		{ BackButton = backButton, NextButton = createElement4(Button, v11) }
	)
	v8.Body = createElement2(View, v9, v10)
	return createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
		sizeConstraint = { MaxSize = maxSize }
	}, v8)
end

return HowToCaptureModal
