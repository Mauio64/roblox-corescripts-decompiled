local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local Button = Foundation.Button
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local FormFactor = MomentsCommon.Enums.FormFactor
local FFlagMomentsFixHowToCaptureTextOverflow = require(Moments.Flags.FFlagMomentsFixHowToCaptureTextOverflow)
local Constants = require(Moments.Constants)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local t1 = {
	title = "Feature.Moments.Label.HowToUseCaptureTitle",
	step1 = "Feature.Moments.Description.HowToCaptureStep1",
	step2 = "Feature.Moments.Description.HowToCaptureStep2",
	step3 = "Feature.Moments.Description.HowToCaptureStep3",
	back = "Feature.Moments.Action.Back",
	done = "Feature.Moments.Action.Done",
	next = "Feature.Moments.Action.Continue"
}
local t2 = {
	{
		descriptionKey = "step1",
		image = Constants.HowToCaptureModalSteps.image1
	},
	{
		descriptionKey = "step2",
		image = Constants.HowToCaptureModalSteps.image2
	},
	{
		descriptionKey = "step3",
		image = Constants.HowToCaptureModalSteps.image3
	}
}

local function HowToCaptureModal(t3: {[any]: any}) -- line: 65
	-- upvalues: useLocalization (copy), t1 (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy), View (copy), FormFactor (copy), Icon (copy), Foundation (copy), FoundationText (copy), FFlagMomentsFixHowToCaptureTextOverflow (copy), FoundationImage (copy), Button (copy)
	local v26 = useLocalization(t1)
	local v27 = useDeviceInsets()
	local v28 = useTokens()
	local v29 = useFormFactor()
	local v30, v31 = React.useState(1)
	local v32 = React.useRef({
		[1] = true
	})

	React.useEffect(function() -- line: 75
		-- upvalues: v32 (copy), v30 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v32.current[v30] then
			v32.current[v30] = true
			fireAnalyticsEvent(EventNames.FTUXHowToCaptureCarouselImpression)
		end
	end, { v30 })

	local v33 = React.useCallback(function() -- line: 82
		-- upvalues: v31 (copy)
		v31(function(p1) -- line: 83
			return (math.max(1, p1 - 1))
		end)
	end, {})
	local v34 = React.useCallback(function() -- line: 88
		-- upvalues: v31 (copy), t2 (copy)
		v31(function(p2) -- line: 89
			-- upvalues: t2 (copy)
			return (math.min(#t2, p2 + 1))
		end)
	end, {})
	local v35 = t2[v30]
	local t4 = {}

	for i = 1, #t2 do
		t4["dot_" .. i] = React.createElement(View, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(8, 8),
			tag = {
				["radius-circle bg-system-contrast"] = i == v30,
				["radius-circle bg-system-emphasis"] = i ~= v30
			}
		})
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
		sizeConstraint = {
			MaxSize = if v29 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
		}
	}, {
		CloseButtonContainer = React.createElement(View, {
			tag = "position-top-right anchor-top-right auto-xy",
			padding = {
				top = UDim.new(0, v27.top + v28.Padding.Medium),
				right = UDim.new(0, v27.right + v28.Padding.Medium)
			}
		}, {
			CloseButton = React.createElement(View, {
				tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0",
				onActivated = t3.onClose
			}, {
				CloseIcon = React.createElement(Icon, {
					name = "icons/navigation/close_small",
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = Foundation.Enums.IconSize.Small,
					style = v28.Color.ActionEmphasis.Foreground
				})
			})
		}),
		Body = React.createElement(View, {
			tag = "col align-x-center align-y-center gap-large size-full",
			padding = {
				top = UDim.new(0, v27.top + v28.Padding.XLarge),
				bottom = UDim.new(0, (math.max(v27.bottom, v28.Padding.Medium))),
				left = UDim.new(0, (math.max(v27.left, v28.Padding.Large))),
				right = UDim.new(0, (math.max(v27.right, v28.Padding.Large)))
			}
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = v26.title,
				tag = {
					["size-full-0 auto-y text-heading-large text-wrap text-align-x-center content-emphasis"] = FFlagMomentsFixHowToCaptureTextOverflow,
					["auto-xy text-heading-large text-align-x-center content-emphasis"] = not FFlagMomentsFixHowToCaptureTextOverflow
				}
			}),
			StepImage = React.createElement(FoundationImage, {
				LayoutOrder = 2,
				Image = v35.image,
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromScale(0.8, 0.45),
				SizeConstraint = Enum.SizeConstraint.RelativeXX
			}),
			Dots = React.createElement(View, {
				LayoutOrder = 3,
				tag = "row align-x-center align-y-center gap-small auto-xy"
			}, t4),
			Description = React.createElement(FoundationText, {
				LayoutOrder = 4,
				Text = v26[v35.descriptionKey],
				tag = {
					["size-full-0 auto-y text-body-large text-wrap text-align-x-center content-muted"] = FFlagMomentsFixHowToCaptureTextOverflow,
					["auto-xy text-body-large text-align-x-center content-muted"] = not FFlagMomentsFixHowToCaptureTextOverflow
				}
			}),
			Nav = React.createElement(View, {
				LayoutOrder = 5,
				tag = "row align-x-center align-y-center gap-medium size-full-0 auto-y"
			}, {
				BackButton = if not (v30 > 1) then nil else React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = v33,
					size = Foundation.Enums.InputSize.Large,
					text = v26.back,
					variant = Foundation.Enums.ButtonVariant.Standard,
					width = UDim.new(1, 0)
				}),
				NextButton = React.createElement(Button, {
					LayoutOrder = 2,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = if not (v30 < #t2) then t3.onClose else v34,
					size = Foundation.Enums.InputSize.Large,
					text = if not (v30 < #t2) then v26.done else v26.next,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					width = UDim.new(1, 0)
				})
			})
		})
	})
end

return HowToCaptureModal
