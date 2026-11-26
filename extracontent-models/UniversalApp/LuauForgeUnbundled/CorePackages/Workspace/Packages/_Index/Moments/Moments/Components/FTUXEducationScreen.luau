local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FoundationCloudAssets")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local button = Foundation.Button
local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local formFactor = MomentsCommon.Enums.FormFactor

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local HowToCaptureModal = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/HowToCaptureModal")
local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent
local FFlagMomentsFtuxEducationScreenRefresh = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFtuxEducationScreenRefresh")

local v5 = {
	title = "Feature.Moments.Label.CaptureLibrary",
	description = "Feature.Moments.Description.EmptyCapturesLibrary",
	howToCapture = "Feature.Moments.Action.HowToCapture",
	back = "Feature.Moments.Action.Back"
}

if FFlagMomentsFtuxEducationScreenRefresh then
	FoundationCloudAssets.preloadAsset("pictograms/captures")
end

local function FTUXEducationScreen(p2)
	local v6 = useLocalization(v5)
	local v7 = useDeviceInsets()
	local v8 = useTokens()
	local v9 = useFormFactor()

	local state, setState = React.useState(false)

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.FTUXEducationScreenImpression)
	end, {})

	local v10 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FTUXHowToCaptureButtonPressed)
		setState(true)
	end, {})

	local v11 = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local v13 = {
		backgroundStyle = v8.Color.Common.Scrim,
		tag = "position-center-center anchor-center-center size-full-full"
	}
	local v15

	if not state then
		local createElement2 = React.createElement

		local v19 = if v9 == formFactor.Wide then Vector2.new(600, 700) else nil

		local createElement3 = React.createElement
		local v21 = {
			padding = {
				top = UDim.new(0, v7.top + v8.Padding.Medium),
				right = UDim.new(0, v7.right + v8.Padding.Medium)
			},
			tag = "position-top-right anchor-top-right auto-xy"
		}
		local v23

		if FFlagMomentsFtuxEducationScreenRefresh then
			v23 = React.createElement(iconButton, {
				icon = BuilderIcons.Icon.X,
				isCircular = true,
				onActivated = p2.onClose,
				size = Foundation.Enums.InputSize.Large,
				variant = Foundation.Enums.ButtonVariant.Utility
			})
		else
			v23 = React.createElement(
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
						style = v8.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		end

		local children = {
			CloseButtonContainer = createElement3(view, v21, { CloseButton = v23 }),
			Body = 0
		}

		local createElement4 = React.createElement
		local v25 = {
			padding = {
				top = UDim.new(0, v7.top + v8.Padding.XLarge),
				bottom = UDim.new(0, (math.max(v7.bottom, v8.Padding.Medium))),
				left = UDim.new(0, (math.max(v7.left, v8.Padding.Large))),
				right = UDim.new(0, (math.max(v7.right, v8.Padding.Large)))
			},
			tag = v9 == formFactor.Wide and "col align-x-center align-y-center gap-large size-full" or "col align-x-center align-y-center gap-medium size-full"
		}

		local createElement5 = React.createElement

		local v28 = if FFlagMomentsFtuxEducationScreenRefresh then FoundationCloudAssets.Assets["pictograms/captures"].assetId else Constants.CapturesAssetId

		local v29 = if FFlagMomentsFtuxEducationScreenRefresh then v8.Color.Content.Emphasis else nil
		local v27 = {
			Image = v28,
			imageStyle = v29,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Fit,
			Size = 0,
			SizeConstraint = 0
		}
		local v30 = if v9 == formFactor.Wide then UDim2.fromScale(0.7, 0.39375) else UDim2.fromScale(0.6, 0.33749999999999997)
		v27.Size = v30

		v27.SizeConstraint = Enum.SizeConstraint.RelativeXX
		local children2 = {
			Graphic = createElement5(image, v27),
			Title = React.createElement(text, {
				LayoutOrder = 2,
				Text = v6.title,
				tag = "auto-xy text-heading-large text-align-x-center content-emphasis"
			}),
			Description = React.createElement(text, {
				LayoutOrder = 3,
				Text = v6.description,
				tag = "auto-xy text-body-large text-align-x-center content-muted"
			}),
			ButtonArea = 0
		}

		local createElement6 = React.createElement

		local createElement7 = React.createElement

		local v36 = if not FFlagMomentsFtuxEducationScreenRefresh then Foundation.Enums.FillBehavior.Fill else nil
		local v35 = {
			fillBehavior = v36,
			LayoutOrder = 1,
			onActivated = v10,
			size = Foundation.Enums.InputSize.Large,
			text = v6.howToCapture,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			width = 0
		}
		local v37 = if not FFlagMomentsFtuxEducationScreenRefresh then UDim.new(1, 0) else nil
		v35.width = v37
		local v33 = { HowToCaptureButton = createElement7(button, v35), BackButton = 0 }

		local v38 = if not FFlagMomentsFtuxEducationScreenRefresh then React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			onActivated = p2.onClose,
			size = Foundation.Enums.InputSize.Large,
			text = v6.back,
			variant = Foundation.Enums.ButtonVariant.Standard,
			width = UDim.new(1, 0)
		}) else nil
		v33.BackButton = v38
		children2.ButtonArea = createElement6(
			view,
			{
				LayoutOrder = 4,
				tag = "col align-x-center gap-medium size-full-0 auto-y"
			},
			v33
		)
		children.Body = createElement4(view, v25, children2)
		v15 = createElement2(view, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = { MaxSize = v19 }
		}, children)
	end

	local v16 = if state then React.createElement(HowToCaptureModal, { onClose = v11 }) else nil
	return createElement(view, v13, { EducationCard = v15, HowToCard = v16 })
end

return FTUXEducationScreen
