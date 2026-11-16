local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Responsive")
local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/AppBlox")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Display")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SignalsReact")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/ReactFocusNavigation")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/ReactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local HttpService = game:GetService("HttpService")
local fFlagEnableAEGIS2CommsFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags").FFlagEnableAEGIS2CommsFAEUpsell

local SocialUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/SocialUpsellAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellEntrySurfaceType")
local UpsellComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellComponent")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialLuaAnalytics")
local bannerBadge = AppBlox.BannerBadge
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local FIntMaxDaysToShowCountDownLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FIntMaxDaysToShowCountDownLabel")
local FIntMinDaysToShowCountdownLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FIntMinDaysToShowCountdownLabel")
local useSocialUpsellOverlayController = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Hooks/useSocialUpsellOverlayController")

local minHeightFor = Responsive.BreakpointConfig.getMinHeightFor(Responsive.Keys.Medium)

local badgeVariant = Foundation.Enums.BadgeVariant
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local view = Foundation.View
local image = Foundation.Image
local useScaledValue = Foundation.Hooks.useScaledValue

local v5 = { isInExperience = true }

local function fn(deadlineUtcTimestamp, p2)
	if not deadlineUtcTimestamp or deadlineUtcTimestamp == 0 then
		return nil
	end

	local v6 = math.floor((deadlineUtcTimestamp - os.time()) / 86400)

	if v6 < FIntMinDaysToShowCountdownLabel or FIntMaxDaysToShowCountDownLabel < v6 then
		return nil
	end

	if v6 < 1 then
		return p2.dayLeft
	end

	return p2.daysLeft:gsub("{(.-)}", { daysLeft = tostring(v6) })
end

local getViewportSize

if fFlagEnableAEGIS2CommsFAEUpsell then
	getViewportSize = Display.GetDisplayStore(false).getViewportSize
else
	getViewportSize = nil
end

return function(p2)
	local v6 = p2 or v5
	local v7 = useSocialUpsellOverlayController(v6.isInExperience)
	local ref = React.useRef(nil)
	local vector2 = Vector2.new(useScaledValue(320), useScaledValue(180))
	local v8, v9 = ReactFocusNavigation.useDefaultFocusBehavior()
	local ref2 = React.useRef(nil)
	local v10 = ReactUtils.useComposedRef(v9, ref2)

	React.useEffect(function()
		local scrollingFrame = ref2.current and ref2.current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if scrollingFrame then
			scrollingFrame.Selectable = false
		end
	end, {})

	local v11 = React.useMemo(function()
		return v6.impressionId or HttpService:GenerateGUID(false)
	end, {
		v6.impressionId,
		v6.upsellEntrySurface,
		v6.upsellPurpose,
		v6.upsellEntryComponent
	})

	local v12 = React.useMemo(function()
		return SocialUpsellAnalytics.evaluateUpsellStage(v6.upsellEntrySurface, UpsellComponent.Modal, v6.upsellEntryComponent)
	end, { v6.upsellEntrySurface, v6.upsellEntryComponent })

	local v13 = useLocalization({
		daysLeft = "Feature.FAE.Label.DaysLeft",
		dayLeft = "Feature.FAE.Label.DayLeft"
	})

	local v14 = React.useMemo(function()
		if v6.countDownBadge then
			return fn(v6.countDownBadge.deadlineUtcTimestamp, v13)
		end

		return nil
	end, { v6.countDownBadge, v13 })

	local v15 = React.useMemo(function()
		if not v6.countDownBadge then
			return nil
		end

		if v6.countDownBadge.text then
			return v6.countDownBadge.text
		end

		return v14
	end, { v14, v6.countDownBadge })
	local v16

	if fFlagEnableAEGIS2CommsFAEUpsell then
		v16 = SignalsReact.useSignalState(getViewportSize)
	else
		v16 = useSelector(function(p3)
			return p3.ScreenSize
		end)
	end

	local v17 = minHeightFor <= v16.Y

	React.useEffect(function()
		if v11 and ref.current ~= v11 then
			SocialUpsellAnalytics.logUpsellEvent(eventTypes.SocialUpsellShown, {
				upsellPurpose = v6.upsellPurpose,
				upsellEntrySurface = v6.upsellEntrySurface,
				upsellStage = v12,
				upsellImpressionId = v11,
				upsellComponent = UpsellComponent.Modal,
				upsellEntryComponent = v6.upsellEntryComponent
			})

			ref.current = v11
		end
	end, { v6.upsellEntrySurface, v6.upsellPurpose, v11, v12, v6.upsellEntryComponent })

	local v18 = React.useCallback(function(p3)
		SocialUpsellAnalytics.logUpsellEvent(eventTypes.SocialUpsellButtonClick, {
			upsellPurpose = v6.upsellPurpose,
			upsellEntrySurface = v6.upsellEntrySurface,
			upsellStage = v12,
			upsellImpressionId = v11,
			upsellComponent = UpsellComponent.Modal,
			btn = p3,
			upsellEntryComponent = v6.upsellEntryComponent
		})
	end, { v6.upsellEntrySurface, v6.upsellPurpose, v11, v12, v6.upsellEntryComponent })

	local v19 = React.useCallback(function()
		v18(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Primary)
		v6.primaryAction.onActivated()
	end, { v6.primaryAction, v18 })

	local v20 = React.useCallback(function()
		v18(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Dismiss)
		v7.closeSocialOverlay()

		if v6.onClose then
			v6.onClose()
		end
	end, { v18, v6.onClose, v7.closeSocialOverlay })

	local v21 = React.useMemo(function()
		local v22 = {}
		table.insert(v22, {
			text = v6.primaryAction.text,
			variant = buttonVariant.Emphasis,
			onActivated = v19,
			ref = v8
		})

		return v22
	end, { v19, v6.primaryAction, v8 })

	local createElement = React.createElement
	local root = dialog.Root
	local v22 = {
		size = dialogSize.Medium,
		hasBackdrop = true,
		closeOnClickOutside = true,
		onClose = v20,
		ref = v10
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local createElement3 = React.createElement

	local v28 = if v6.imageId and v17 then React.createElement(image, {
		tag = "size-full-full self-center content-emphasis",
		Image = v6.imageId,
		aspectRatio = 16 / 9,
		sizeConstraint = { MaxSize = vector2 }
	}) else nil

	local v29 = if v15 then React.createElement(bannerBadge, {
		LayoutOrder = 1,
		icon = {
			variant = Foundation.Enums.IconVariant.Filled,
			position = Foundation.Enums.IconPosition.Left,
			name = iconName.Clock
		},
		text = v15,
		variant = badgeVariant.Neutral
	}) else nil

	local createElement4 = React.createElement

	local v33 = if v6.title then React.createElement(
		view,
		{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
		{
			TitleText = React.createElement(text, {
				Text = v6.title,
				tag = "size-full-0 auto-y content-emphasis text-wrap text-align-x-left text-heading-medium"
			})
		}
	) else nil

	local v34 = if v6.bodyText then React.createElement(text, {
		tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-medium",
		Text = v6.bodyText,
		LayoutOrder = 3
	}) else nil
	return createElement(root, v22, {
		DialogContent = createElement2(content, {}, {
			Content = createElement3(
				view,
				{
					tag = "col auto-y size-full-0 gap-medium padding-top-xlarge",
					LayoutOrder = 1
				},
				{
					Image = v28,
					Badge = v29,
					TextContainer = createElement4(
						view,
						{
							tag = "col gap-medium size-full-0 auto-y padding-right-xxlarge padding-bottom-xsmall",
							LayoutOrder = 2
						},
						{ Title = v33, BodyText = v34 }
					)
				}
			)
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = v15 and 3 or 4,
			actions = v21
		})
	})
end
