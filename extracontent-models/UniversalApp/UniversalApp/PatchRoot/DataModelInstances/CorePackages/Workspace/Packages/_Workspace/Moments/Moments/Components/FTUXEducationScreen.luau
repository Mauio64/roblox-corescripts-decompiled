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
local HowToCaptureModal = require(Moments.Components.HowToCaptureModal)
local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local t1 = {
	title = "Feature.Moments.Label.CaptureLibrary",
	description = "Feature.Moments.Description.EmptyCapturesLibrary",
	howToCapture = "Feature.Moments.Action.HowToCapture",
	back = "Feature.Moments.Action.Back"
}

local function FTUXEducationScreen(t2: {[any]: any}) -- line: 55
	-- upvalues: useLocalization (copy), t1 (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), View (copy), FormFactor (copy), Icon (copy), Foundation (copy), FoundationImage (copy), Constants (copy), FoundationText (copy), Button (copy), HowToCaptureModal (copy)
	local v25 = useLocalization(t1)
	local v26 = useDeviceInsets()
	local v27 = useTokens()
	local v28 = useFormFactor()
	local v29, v30 = React.useState(false)

	React.useEffect(function() -- line: 64
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.FTUXEducationScreenImpression)
	end, {})

	local v31 = React.useCallback(function() -- line: 68
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v30 (copy)
		fireAnalyticsEvent(EventNames.FTUXHowToCaptureButtonPressed)
		v30(true)
	end, {})
	local v32 = React.useCallback(function() -- line: 73
		-- upvalues: v30 (copy)
		v30(false)
	end, {})

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full",
		backgroundStyle = v27.Color.Common.Scrim
	}, {
		EducationCard = if v29 then nil else React.createElement(View, {
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
					onActivated = t2.onClose
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
				padding = {
					top = UDim.new(0, v26.top + v27.Padding.XLarge),
					bottom = UDim.new(0, (math.max(v26.bottom, v27.Padding.Medium))),
					left = UDim.new(0, (math.max(v26.left, v27.Padding.Large))),
					right = UDim.new(0, (math.max(v26.right, v27.Padding.Large)))
				},
				tag = v28 ~= FormFactor.Wide and "col align-x-center align-y-center gap-medium size-full" or "col align-x-center align-y-center gap-large size-full"
			}, {
				Graphic = React.createElement(FoundationImage, {
					LayoutOrder = 1,
					Image = Constants.CapturesAssetId,
					ScaleType = Enum.ScaleType.Fit,
					Size = if v28 ~= FormFactor.Wide then UDim2.fromScale(0.6, 0.33749999999999997) else UDim2.fromScale(0.7, 0.39375),
					SizeConstraint = Enum.SizeConstraint.RelativeXX
				}),
				Title = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-heading-large text-align-x-center content-emphasis",
					Text = v25.title
				}),
				Description = React.createElement(FoundationText, {
					LayoutOrder = 3,
					tag = "auto-xy text-body-large text-align-x-center content-muted",
					Text = v25.description
				}),
				ButtonArea = React.createElement(View, {
					LayoutOrder = 4,
					tag = "col align-x-center gap-medium size-full-0 auto-y"
				}, {
					HowToCaptureButton = React.createElement(Button, {
						LayoutOrder = 1,
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						onActivated = v31,
						size = Foundation.Enums.InputSize.Large,
						text = v25.howToCapture,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						width = UDim.new(1, 0)
					}),
					BackButton = React.createElement(Button, {
						LayoutOrder = 2,
						fillBehavior = Foundation.Enums.FillBehavior.Fill,
						onActivated = t2.onClose,
						size = Foundation.Enums.InputSize.Large,
						text = v25.back,
						variant = Foundation.Enums.ButtonVariant.Standard,
						width = UDim.new(1, 0)
					})
				})
			})
		}),
		HowToCard = if not v29 then nil else React.createElement(HowToCaptureModal, {
			onClose = v32
		})
	})
end

return FTUXEducationScreen
