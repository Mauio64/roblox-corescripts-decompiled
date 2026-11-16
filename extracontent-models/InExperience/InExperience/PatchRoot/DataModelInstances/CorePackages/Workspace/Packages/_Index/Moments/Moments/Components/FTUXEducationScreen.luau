local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Image = Foundation.Image
local Text = Foundation.Text
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
local FFlagMomentsFtuxEducationScreenRefresh = require(Moments.Flags.FFlagMomentsFtuxEducationScreenRefresh)

local v = {
	title = "Feature.Moments.Label.CaptureLibrary",
	description = "Feature.Moments.Description.EmptyCapturesLibrary",
	howToCapture = "Feature.Moments.Action.HowToCapture",
	back = "Feature.Moments.Action.Back"
}

if FFlagMomentsFtuxEducationScreenRefresh then
	FoundationCloudAssets.preloadAsset("pictograms/captures")
end

local function FTUXEducationScreen(p)
	local v2 = useLocalization(v)
	local v3 = useDeviceInsets()
	local v4 = useTokens()
	local v5 = useFormFactor()

	local state, setState = React.useState(false)

	React.useEffect(function()
		fireAnalyticsEvent(EventNames.FTUXEducationScreenImpression)
	end, {})

	local onActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FTUXHowToCaptureButtonPressed)
		setState(true)
	end, {})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local v6 = {
		backgroundStyle = v4.Color.Common.Scrim,
		tag = "position-center-center anchor-center-center size-full-full"
	}
	local educationCard

	if not state then
		local createElement2 = React.createElement
		local maxSize

		if v5 == FormFactor.Wide then
			maxSize = Vector2.new(600, 700)
		end

		local createElement3 = React.createElement
		local v7 = {
			padding = {
				top = UDim.new(0, v3.top + v4.Padding.Medium),
				right = UDim.new(0, v3.right + v4.Padding.Medium)
			},
			tag = "position-top-right anchor-top-right auto-xy"
		}
		local closeButton

		if FFlagMomentsFtuxEducationScreenRefresh then
			closeButton = React.createElement(IconButton, {
				icon = BuilderIcons.Icon.X,
				isCircular = true,
				onActivated = p.onClose,
				size = Foundation.Enums.InputSize.Large,
				variant = Foundation.Enums.ButtonVariant.Utility
			})
		else
			closeButton = React.createElement(
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
						style = v4.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		end

		local children = {
			CloseButtonContainer = createElement3(View, v7, { CloseButton = closeButton }),
			Body = 0
		}

		local createElement4 = React.createElement
		local v8 = {
			padding = {
				top = UDim.new(0, v3.top + v4.Padding.XLarge),
				bottom = UDim.new(0, (math.max(v3.bottom, v4.Padding.Medium))),
				left = UDim.new(0, (math.max(v3.left, v4.Padding.Large))),
				right = UDim.new(0, (math.max(v3.right, v4.Padding.Large)))
			},
			tag = v5 == FormFactor.Wide and "col align-x-center align-y-center gap-large size-full" or "col align-x-center align-y-center gap-medium size-full"
		}

		local createElement5 = React.createElement
		local image

		if FFlagMomentsFtuxEducationScreenRefresh then
			image = FoundationCloudAssets.Assets["pictograms/captures"].assetId
		else
			image = Constants.CapturesAssetId
		end

		local imageStyle

		if FFlagMomentsFtuxEducationScreenRefresh then
			imageStyle = v4.Color.Content.Emphasis
		end

		local v9 = {
			Image = image,
			imageStyle = imageStyle,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = 0,
			SizeConstraint = 0
		}
		local size

		if v5 == FormFactor.Wide then
			size = UDim2.fromScale(0.7, 0.39375)
		else
			size = UDim2.fromScale(0.6, 0.33749999999999997)
		end

		v9.Size = size

		v9.SizeConstraint = Enum.SizeConstraint.RelativeXX
		local children2 = {
			Graphic = createElement5(Image, v9),
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v2.title,
				tag = "auto-xy text-heading-large text-align-x-center content-emphasis"
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 3,
				Text = v2.description,
				tag = "auto-xy text-body-large text-align-x-center content-muted"
			}),
			ButtonArea = 0
		}

		local createElement6 = React.createElement

		local createElement7 = React.createElement
		local fillBehavior

		if not FFlagMomentsFtuxEducationScreenRefresh then
			fillBehavior = Foundation.Enums.FillBehavior.Fill
		end

		local v10 = {
			fillBehavior = fillBehavior,
			LayoutOrder = 1,
			onActivated = onActivated,
			size = Foundation.Enums.InputSize.Large,
			text = v2.howToCapture,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			width = 0
		}
		local width

		if not FFlagMomentsFtuxEducationScreenRefresh then
			width = UDim.new(1, 0)
		end

		v10.width = width
		local v11 = { HowToCaptureButton = createElement7(Button, v10), BackButton = 0 }
		local backButton

		if not FFlagMomentsFtuxEducationScreenRefresh then
			backButton = React.createElement(Button, {
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				LayoutOrder = 2,
				onActivated = p.onClose,
				size = Foundation.Enums.InputSize.Large,
				text = v2.back,
				variant = Foundation.Enums.ButtonVariant.Standard,
				width = UDim.new(1, 0)
			})
		end

		v11.BackButton = backButton
		children2.ButtonArea = createElement6(
			View,
			{ LayoutOrder = 4, tag = "col align-x-center gap-medium size-full-0 auto-y" },
			v11
		)
		children.Body = createElement4(View, v8, children2)
		educationCard = createElement2(View, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = { MaxSize = maxSize }
		}, children)
	end

	local howToCard

	if state then
		howToCard = React.createElement(HowToCaptureModal, { onClose = onClose })
	end

	return createElement(View, v6, { EducationCard = educationCard, HowToCard = howToCard })
end

return FTUXEducationScreen
