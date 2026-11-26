local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local icon = Foundation.Icon
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local formFactor = MomentsCommon.Enums.FormFactor
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent

local v5 = {
	title = "Feature.Moments.Label.HowToUseCaptureTitle",
	step1 = "Feature.Moments.Description.HowToCaptureStep1",
	step2 = "Feature.Moments.Description.HowToCaptureStep2",
	step3 = "Feature.Moments.Description.HowToCaptureStep3",
	back = "Feature.Moments.Action.Back",
	done = "Feature.Moments.Action.Done",
	next = "Feature.Moments.Action.Continue"
}

local v6 = {
	{ image = Constants.HowToCaptureModalSteps.image1, descriptionKey = "step1" },
	{ image = Constants.HowToCaptureModalSteps.image2, descriptionKey = "step2" },
	{ image = Constants.HowToCaptureModalSteps.image3, descriptionKey = "step3" }
}

local function HowToCaptureModal(p2)
	local v7 = useLocalization(v5)
	local v8 = useDeviceInsets()
	local v9 = useTokens()
	local v10 = useFormFactor()

	local state, setState = React.useState(1)

	local ref = React.useRef({ true })

	React.useEffect(function()
		if not ref.current[state] then
			ref.current[state] = true
			fireAnalyticsEvent(eventNames.FTUXHowToCaptureCarouselImpression)
		end
	end, { state })

	local v11 = React.useCallback(function()
		setState(function(p3)
			return (math.max(1, p3 - 1))
		end)
	end, {})

	local v12 = React.useCallback(function()
		setState(function(p3)
			return (math.min(#v6, p3 + 1))
		end)
	end, {})

	local v13 = v6[state]

	local children = {}

	for i = 1, #v6 do
		children["dot_" .. i] = React.createElement(view, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(8, 8),
			tag = {
				["radius-circle bg-system-contrast"] = i == state,
				["radius-circle bg-system-emphasis"] = i ~= state
			}
		})
	end

	local createElement = React.createElement

	local v17 = if v10 == formFactor.Wide then Vector2.new(600, 700) else nil

	local v18 = {
		CloseButtonContainer = React.createElement(view, {
			padding = {
				top = UDim.new(0, v8.top + v9.Padding.Medium),
				right = UDim.new(0, v8.right + v9.Padding.Medium)
			},
			tag = "position-top-right anchor-top-right auto-xy"
		}, {
			CloseButton = React.createElement(
				view,
				{
					onActivated = p2.onClose,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0"
				},
				{
					CloseIcon = React.createElement(icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = "icons/navigation/close_small",
						size = Foundation.Enums.IconSize.Small,
						style = v9.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		}),
		Body = 0
	}

	local createElement2 = React.createElement
	local v20 = {
		padding = {
			top = UDim.new(0, v8.top + v9.Padding.XLarge),
			bottom = UDim.new(0, (math.max(v8.bottom, v9.Padding.Medium))),
			left = UDim.new(0, (math.max(v8.left, v9.Padding.Large))),
			right = UDim.new(0, (math.max(v8.right, v9.Padding.Large)))
		},
		tag = "col align-x-center align-y-center gap-large size-full"
	}

	local v21 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = v7.title,
			tag = "size-full-0 auto-y text-heading-large text-wrap text-align-x-center content-emphasis"
		}),
		StepImage = React.createElement(image, {
			Image = v13.image,
			LayoutOrder = 2,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(0.8, 0.45),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}),
		Dots = React.createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "row align-x-center align-y-center gap-small auto-xy"
			},
			children
		),
		Description = React.createElement(text, {
			LayoutOrder = 4,
			Text = v7[v13.descriptionKey],
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-muted"
		}),
		Nav = 0
	}

	local createElement3 = React.createElement

	local v25 = if state > 1 then React.createElement(button, {
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		LayoutOrder = 1,
		onActivated = v11,
		size = Foundation.Enums.InputSize.Large,
		text = v7.back,
		variant = Foundation.Enums.ButtonVariant.Standard,
		width = UDim.new(1, 0)
	}) else nil

	local createElement4 = React.createElement
	local v27 = {
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		LayoutOrder = 2,
		onActivated = 0,
		size = 0,
		text = 0,
		variant = 0,
		width = 0
	}

	if not (state < #v6) then
		v12 = p2.onClose
	end

	v27.onActivated = v12
	v27.size = Foundation.Enums.InputSize.Large
	local v28 = if state < #v6 then v7.next else v7.done
	v27.text = v28
	v27.variant = Foundation.Enums.ButtonVariant.Emphasis
	v27.width = UDim.new(1, 0)
	v21.Nav = createElement3(
		view,
		{
			LayoutOrder = 5,
			tag = "row align-x-center align-y-center gap-medium size-full-0 auto-y"
		},
		{ BackButton = v25, NextButton = createElement4(button, v27) }
	)
	v18.Body = createElement2(view, v20, v21)
	return createElement(view, {
		tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
		sizeConstraint = { MaxSize = v17 }
	}, v18)
end

return HowToCaptureModal
