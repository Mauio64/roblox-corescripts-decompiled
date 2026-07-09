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

local function HowToCaptureModal(t3: {[any]: any}) -- line: 64
	-- upvalues: useLocalization (copy), t1 (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), t2 (copy), View (copy), FormFactor (copy), Icon (copy), Foundation (copy), FoundationText (copy), FoundationImage (copy), Button (copy)
	local v25 = useLocalization(t1)
	local v26 = useDeviceInsets()
	local v27 = useTokens()
	local v28 = useFormFactor()
	local v29, v30 = React.useState(1)
	local v31 = React.useRef({
		[1] = true
	})

	React.useEffect(function() -- line: 74
		-- upvalues: v31 (copy), v29 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		if not v31.current[v29] then
			v31.current[v29] = true
			fireAnalyticsEvent(EventNames.FTUXHowToCaptureCarouselImpression)
		end
	end, { v29 })

	local v32 = React.useCallback(function() -- line: 81
		-- upvalues: v30 (copy)
		v30(function(p1) -- line: 82
			return (math.max(1, p1 - 1))
		end)
	end, {})
	local v33 = React.useCallback(function() -- line: 87
		-- upvalues: v30 (copy), t2 (copy)
		v30(function(p2) -- line: 88
			-- upvalues: t2 (copy)
			return (math.min(#t2, p2 + 1))
		end)
	end, {})
	local v34 = t2[v29]
	local t4 = {}

	for i = 1, #t2 do
		t4["dot_" .. i] = React.createElement(View, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(8, 8),
			tag = {
				["radius-circle bg-system-contrast"] = i == v29,
				["radius-circle bg-system-emphasis"] = i ~= v29
			}
		})
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
		sizeConstraint = {
			MaxSize = if v28 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
		}
	}, {
		CloseButtonContainer = React.createElement(View, {
			tag = "position-top-right anchor-top-right auto-xy",
			padding = {
				top = UDim.new(0, v26.top + v27.Padding.Medium),
				right = UDim.new(0, v26.right + v27.Padding.Medium)
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
					style = v27.Color.ActionEmphasis.Foreground
				})
			})
		}),
		Body = React.createElement(View, {
			tag = "col align-x-center align-y-center gap-large size-full",
			padding = {
				top = UDim.new(0, v26.top + v27.Padding.XLarge),
				bottom = UDim.new(0, (math.max(v26.bottom, v27.Padding.Medium))),
				left = UDim.new(0, (math.max(v26.left, v27.Padding.Large))),
				right = UDim.new(0, (math.max(v26.right, v27.Padding.Large)))
			}
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-large text-align-x-center content-emphasis",
				Text = v25.title
			}),
			StepImage = React.createElement(FoundationImage, {
				LayoutOrder = 2,
				Image = v34.image,
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
				tag = "auto-xy text-body-large text-align-x-center content-muted",
				Text = v25[v34.descriptionKey]
			}),
			Nav = React.createElement(View, {
				LayoutOrder = 5,
				tag = "row align-x-center align-y-center gap-medium size-full-0 auto-y"
			}, {
				BackButton = if not (v29 > 1) then nil else React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = v32,
					size = Foundation.Enums.InputSize.Large,
					text = v25.back,
					variant = Foundation.Enums.ButtonVariant.Standard,
					width = UDim.new(1, 0)
				}),
				NextButton = React.createElement(Button, {
					LayoutOrder = 2,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = if not (v29 < #t2) then t3.onClose else v33,
					size = Foundation.Enums.InputSize.Large,
					text = if not (v29 < #t2) then v25.done else v25.next,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					width = UDim.new(1, 0)
				})
			})
		})
	})
end

return HowToCaptureModal
