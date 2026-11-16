local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local AppBlox = require(parent.AppBlox)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local ReactUtils = require(parent.ReactUtils)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell

local SocialUpsellAnalytics = require(SocialUpsell.Analytics.SocialUpsellAnalytics)
require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
require(SocialUpsell.Enum.SocialUpsellType)
local Constants = require(SocialUpsell.Constants)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local BannerBadge = AppBlox.BannerBadge
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local FIntMaxDaysToShowCountDownLabel = require(SocialUpsell.Flag.FIntMaxDaysToShowCountDownLabel)
local FIntMinDaysToShowCountdownLabel = require(SocialUpsell.Flag.FIntMinDaysToShowCountdownLabel)
local useSocialUpsellOverlayController = require(SocialUpsell.Hooks.useSocialUpsellOverlayController)

local minHeightFor = Responsive.BreakpointConfig.getMinHeightFor(Responsive.Keys.Medium)

local BadgeVariant = Foundation.Enums.BadgeVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local View = Foundation.View
local Image = Foundation.Image
local useScaledValue = Foundation.Hooks.useScaledValue

local v = { isInExperience = true }

local function fn(deadlineUtcTimestamp: number?, p)
	if not deadlineUtcTimestamp or deadlineUtcTimestamp == 0 then
		return nil
	end

	local v2 = math.floor((deadlineUtcTimestamp - os.time()) / 86400)

	if v2 < FIntMinDaysToShowCountdownLabel or FIntMaxDaysToShowCountDownLabel < v2 then
		return nil
	end

	if v2 < 1 then
		return p.dayLeft
	end

	return p.daysLeft:gsub("{(.-)}", { daysLeft = tostring(v2) })
end

local getViewportSize

if FFlagEnableAEGIS2CommsFAEUpsell then
	getViewportSize = Display.GetDisplayStore(false).getViewportSize
else
	getViewportSize = nil
end

return function(p)
	local v2 = p or v
	local v3 = useSocialUpsellOverlayController(v2.isInExperience)
	local ref = React.useRef(nil)
	local vector2 = Vector2.new(useScaledValue(320), useScaledValue(180))
	local ref3, v4 = ReactFocusNavigation.useDefaultFocusBehavior()
	local ref2 = React.useRef(nil)
	local ref4 = ReactUtils.useComposedRef(v4, ref2)

	React.useEffect(function()
		local scrollingFrame = ref2.current and ref2.current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if scrollingFrame then
			scrollingFrame.Selectable = false
		end
	end, {})

	local v5 = React.useMemo(function()
		return v2.impressionId or HttpService:GenerateGUID(false)
	end, { v2.impressionId, v2.upsellEntrySurface, v2.upsellPurpose, v2.upsellEntryComponent })

	local upsellStage = React.useMemo(function()
		return SocialUpsellAnalytics.evaluateUpsellStage(
			v2.upsellEntrySurface,
			UpsellComponent.Modal,
			v2.upsellEntryComponent
		)
	end, { v2.upsellEntrySurface, v2.upsellEntryComponent })

	local v6 = useLocalization({
		daysLeft = "Feature.FAE.Label.DaysLeft",
		dayLeft = "Feature.FAE.Label.DayLeft"
	})

	local v7 = React.useMemo(function()
		if v2.countDownBadge then
			return fn(v2.countDownBadge.deadlineUtcTimestamp, v6)
		end

		return nil
	end, { v2.countDownBadge, v6 })

	local text = React.useMemo(function()
		if not v2.countDownBadge then
			return nil
		end

		if v2.countDownBadge.text then
			return v2.countDownBadge.text
		end

		return v7
	end, { v7, v2.countDownBadge })
	local v8

	if FFlagEnableAEGIS2CommsFAEUpsell then
		v8 = SignalsReact.useSignalState(getViewportSize)
	else
		v8 = useSelector(function(p2)
			return p2.ScreenSize
		end)
	end

	local v9 = minHeightFor <= v8.Y

	React.useEffect(function()
		if v5 and ref.current ~= v5 then
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellShown, {
				upsellPurpose = v2.upsellPurpose,
				upsellEntrySurface = v2.upsellEntrySurface,
				upsellStage = upsellStage,
				upsellImpressionId = v5,
				upsellComponent = UpsellComponent.Modal,
				upsellEntryComponent = v2.upsellEntryComponent
			})

			ref.current = v5
		end
	end, { v2.upsellEntrySurface, v2.upsellPurpose, v5, upsellStage, v2.upsellEntryComponent })

	local v10 = React.useCallback(function(btn: string)
		SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellButtonClick, {
			upsellPurpose = v2.upsellPurpose,
			upsellEntrySurface = v2.upsellEntrySurface,
			upsellStage = upsellStage,
			upsellImpressionId = v5,
			upsellComponent = UpsellComponent.Modal,
			btn = btn,
			upsellEntryComponent = v2.upsellEntryComponent
		})
	end, { v2.upsellEntrySurface, v2.upsellPurpose, v5, upsellStage, v2.upsellEntryComponent })

	local onActivated = React.useCallback(function()
		v10(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Primary)
		v2.primaryAction.onActivated()
	end, { v2.primaryAction, v10 })

	local onClose = React.useCallback(function()
		v10(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Dismiss)
		v3.closeSocialOverlay()

		if v2.onClose then
			v2.onClose()
		end
	end, { v10, v2.onClose, v3.closeSocialOverlay })

	local actions = React.useMemo(function()
		local v11 = {}
		table.insert(v11, {
			text = v2.primaryAction.text,
			variant = ButtonVariant.Emphasis,
			onActivated = onActivated,
			ref = ref3
		})

		return v11
	end, { onActivated, v2.primaryAction, ref3 })

	local createElement = React.createElement
	local root = Dialog.Root
	local v11 = {
		size = DialogSize.Medium,
		hasBackdrop = true,
		closeOnClickOutside = true,
		onClose = onClose,
		ref = ref4
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local createElement3 = React.createElement
	local image

	if v2.imageId and v9 then
		image = React.createElement(Image, {
			tag = "size-full-full self-center content-emphasis",
			Image = v2.imageId,
			aspectRatio = 16 / 9,
			sizeConstraint = { MaxSize = vector2 }
		})
	end

	local badge

	if text then
		badge = React.createElement(BannerBadge, {
			LayoutOrder = 1,
			icon = {
				variant = Foundation.Enums.IconVariant.Filled,
				position = Foundation.Enums.IconPosition.Left,
				name = IconName.Clock
			},
			text = text,
			variant = BadgeVariant.Neutral
		})
	end

	local createElement4 = React.createElement
	local title

	if v2.title then
		title = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, {
			TitleText = React.createElement(Text, {
				Text = v2.title,
				tag = "size-full-0 auto-y content-emphasis text-wrap text-align-x-left text-heading-medium"
			})
		})
	end

	local bodyText

	if v2.bodyText then
		bodyText = React.createElement(Text, {
			tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-medium",
			Text = v2.bodyText,
			LayoutOrder = 3
		})
	end

	return createElement(root, v11, {
		DialogContent = createElement2(content, {}, {
			Content = createElement3(
				View,
				{ tag = "col auto-y size-full-0 gap-medium padding-top-xlarge", LayoutOrder = 1 },
				{
					Image = image,
					Badge = badge,
					TextContainer = createElement4(
						View,
						{
							tag = "col gap-medium size-full-0 auto-y padding-right-xxlarge padding-bottom-xsmall",
							LayoutOrder = 2
						},
						{ Title = title, BodyText = bodyText }
					)
				}
			)
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = text and 3 or 4,
			actions = actions
		})
	})
end
