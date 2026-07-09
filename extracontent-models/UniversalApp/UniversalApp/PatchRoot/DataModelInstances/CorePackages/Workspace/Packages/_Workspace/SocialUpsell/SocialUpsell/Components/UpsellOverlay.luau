local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Foundation = require(SocialUpsellParent.Foundation)
local React = require(SocialUpsellParent.React)
local Responsive = require(SocialUpsellParent.Responsive)
local AppBlox = require(SocialUpsellParent.AppBlox)
local Display = require(SocialUpsellParent.Display)
local SignalsReact = require(SocialUpsellParent.SignalsReact)
local ReactFocusNavigation = require(SocialUpsellParent.ReactFocusNavigation)
local ReactUtils = require(SocialUpsellParent.ReactUtils)
local useLocalization = require(SocialUpsellParent.Localization).Hooks.useLocalization
local useSelector = require(SocialUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local HttpService = game:GetService("HttpService")
local FFlagEnableAEGIS2CommsFAEUpsell = require(SocialUpsellParent.SharedFlags).FFlagEnableAEGIS2CommsFAEUpsell
local SocialUpsellAnalytics = require(SocialUpsell.Analytics.SocialUpsellAnalytics)

require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)

local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)

require(SocialUpsell.Enum.SocialUpsellType)

local Constants = require(SocialUpsell.Constants)
local SocialLuaAnalytics = require(SocialUpsellParent.SocialLuaAnalytics)
local BannerBadge = AppBlox.BannerBadge
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local FIntMaxDaysToShowCountDownLabel = require(SocialUpsell.Flag.FIntMaxDaysToShowCountDownLabel)
local FIntMinDaysToShowCountdownLabel = require(SocialUpsell.Flag.FIntMinDaysToShowCountdownLabel)
local useSocialUpsellOverlayController = require(SocialUpsell.Hooks.useSocialUpsellOverlayController)
local FFlagAddUpsellEntryComponentToAnalytics = require(SocialUpsell.Flag.FFlagAddUpsellEntryComponentToAnalytics)
local v25 = Responsive.BreakpointConfig.getMinHeightFor(Responsive.Keys.Medium)
local BadgeVariant = Foundation.Enums.BadgeVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local View = Foundation.View
local FoundationImage = Foundation.Image
local useScaledValue = Foundation.Hooks.useScaledValue
local t1 = {
	isInExperience = true
}

local function v36(n1: number?, p1) -- line: 81
	-- upvalues: FIntMinDaysToShowCountdownLabel (copy), FIntMaxDaysToShowCountDownLabel (copy)
	if not n1 or n1 == 0 then
		return nil
	end

	local v40 = math.floor((n1 - os.time()) / 86400)

	if v40 < FIntMinDaysToShowCountdownLabel or v40 > FIntMaxDaysToShowCountDownLabel then
		return nil
	end

	if v40 < 1 then
		return p1.dayLeft
	end

	return p1.daysLeft:gsub("{(.-)}", {
		daysLeft = tostring(v40)
	})
end

local getViewportSize = nil

if FFlagEnableAEGIS2CommsFAEUpsell then
	getViewportSize = Display.GetDisplayStore(false).getViewportSize
end

return function(p2) -- line: 109
	-- upvalues: t1 (copy), useSocialUpsellOverlayController (copy), React (copy), useScaledValue (copy), ReactFocusNavigation (copy), ReactUtils (copy), HttpService (copy), SocialUpsellAnalytics (copy), UpsellComponent (copy), useLocalization (copy), v36 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), SignalsReact (copy), getViewportSize (ref), useSelector (copy), v25 (copy), EventTypes (copy), FFlagAddUpsellEntryComponentToAnalytics (copy), Constants (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy), View (copy), FoundationImage (copy), BannerBadge (copy), Foundation (copy), IconName (copy), BadgeVariant (copy), FoundationText (copy)
	local v42 = p2 or t1
	local v43 = useSocialUpsellOverlayController(v42.isInExperience)
	local v44 = React.useRef(nil)
	local vector2 = Vector2.new(useScaledValue(320), useScaledValue(180))
	local v46, v47 = ReactFocusNavigation.useDefaultFocusBehavior()
	local v48 = React.useRef(nil)
	local v49 = ReactUtils.useComposedRef(v47, v48)

	React.useEffect(function() -- line: 118
		-- upvalues: v48 (copy)
		if v48.current then
			local ScrollingFrame = v48.current:FindFirstChildWhichIsA("ScrollingFrame", true)

			if ScrollingFrame then
				ScrollingFrame.Selectable = false
			end
		end
	end, {})

	local v50 = React.useMemo(function() -- line: 129
		-- upvalues: v42 (copy), HttpService (copy)
		return v42.impressionId or HttpService:GenerateGUID(false)
	end, {
		v42.impressionId,
		v42.upsellEntrySurface,
		v42.upsellPurpose,
		v42.upsellEntryComponent
	})
	local v51 = React.useMemo(function() -- line: 140
		-- upvalues: SocialUpsellAnalytics (copy), v42 (copy), UpsellComponent (copy)
		return SocialUpsellAnalytics.evaluateUpsellStage(v42.upsellEntrySurface, UpsellComponent.Modal, v42.upsellEntryComponent)
	end, {
		v42.upsellEntrySurface,
		v42.upsellEntryComponent
	})
	local v52 = useLocalization({
		daysLeft = "Feature.FAE.Label.DaysLeft",
		dayLeft = "Feature.FAE.Label.DayLeft"
	})
	local v53 = React.useMemo(function() -- line: 153
		-- upvalues: v42 (copy), v36 (copy), v52 (copy)
		if v42.countDownBadge then
			return v36(v42.countDownBadge.deadlineUtcTimestamp, v52)
		end

		return nil
	end, {
		v42.countDownBadge,
		v52
	})
	local v54 = React.useMemo(function() -- line: 160
		-- upvalues: v42 (copy), v53 (copy)
		if v42.countDownBadge then
			if v42.countDownBadge.text then
				return v42.countDownBadge.text
			end

			return v53
		end

		return nil
	end, {
		v53,
		v42.countDownBadge
	})
	local v55 = ((if not FFlagEnableAEGIS2CommsFAEUpsell then useSelector(function(p3) -- line: 173
		return p3.ScreenSize
	end) else SignalsReact.useSignalState(getViewportSize))).Y >= v25

	React.useEffect(function() -- line: 181
		-- upvalues: v50 (copy), v44 (copy), SocialUpsellAnalytics (copy), EventTypes (copy), v42 (copy), v51 (copy), UpsellComponent (copy), FFlagAddUpsellEntryComponentToAnalytics (copy)
		if v50 and v44.current ~= v50 then
			SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellShown, {
				upsellPurpose = v42.upsellPurpose,
				upsellEntrySurface = v42.upsellEntrySurface,
				upsellStage = v51,
				upsellImpressionId = v50,
				upsellComponent = UpsellComponent.Modal,
				upsellEntryComponent = if not FFlagAddUpsellEntryComponentToAnalytics then nil else v42.upsellEntryComponent
			})
			v44.current = v50
		end
	end, {
		v42.upsellEntrySurface,
		v42.upsellPurpose,
		v50,
		v51,
		if not FFlagAddUpsellEntryComponentToAnalytics then nil else v42.upsellEntryComponent
	})

	local v56 = React.useCallback(function(s1: string) -- line: 207
		-- upvalues: SocialUpsellAnalytics (copy), EventTypes (copy), v42 (copy), v51 (copy), v50 (copy), UpsellComponent (copy), FFlagAddUpsellEntryComponentToAnalytics (copy)
		SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellButtonClick, {
			upsellPurpose = v42.upsellPurpose,
			upsellEntrySurface = v42.upsellEntrySurface,
			upsellStage = v51,
			upsellImpressionId = v50,
			upsellComponent = UpsellComponent.Modal,
			btn = s1,
			upsellEntryComponent = if not FFlagAddUpsellEntryComponentToAnalytics then nil else v42.upsellEntryComponent
		})
	end, {
		v42.upsellEntrySurface,
		v42.upsellPurpose,
		v50,
		v51,
		if not FFlagAddUpsellEntryComponentToAnalytics then nil else v42.upsellEntryComponent
	})
	local v57 = React.useCallback(function() -- line: 231
		-- upvalues: v56 (copy), Constants (copy), v42 (copy)
		v56(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Primary)
		v42.primaryAction.onActivated()
	end, {
		v42.primaryAction,
		v56
	})
	local v58 = React.useCallback(function() -- line: 243
		-- upvalues: v56 (copy), Constants (copy), v43 (copy), v42 (copy)
		v56(Constants.UPSELL_OVERLAY_BUTTON_ACTION.Dismiss)
		v43.closeSocialOverlay()

		if v42.onClose then
			v42.onClose()
		end
	end, {
		v56,
		v42.onClose,
		v43.closeSocialOverlay
	})
	local v59 = React.useMemo(function() -- line: 257
		-- upvalues: v42 (copy), ButtonVariant (copy), v57 (copy), v46 (copy)
		local t2 = {}

		table.insert(t2, {
			text = v42.primaryAction.text,
			variant = ButtonVariant.Emphasis,
			onActivated = v57,
			ref = v46
		})

		return t2
	end, {
		v57,
		v42.primaryAction,
		v46
	})

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		closeOnClickOutside = true,
		size = DialogSize.Medium,
		onClose = v58,
		ref = v49
	}, {
		DialogContent = React.createElement(Dialog.Content, {}, {
			Content = React.createElement(View, {
				tag = "col auto-y size-full-0 gap-medium padding-top-xlarge",
				LayoutOrder = 1
			}, {
				Image = if not v42.imageId or not v55 then nil else React.createElement(FoundationImage, {
					tag = "size-full-full self-center content-emphasis",
					aspectRatio = 1.7777777777777777,
					Image = v42.imageId,
					sizeConstraint = {
						MaxSize = vector2
					}
				}),
				Badge = if not v54 then nil else React.createElement(BannerBadge, {
					LayoutOrder = 1,
					icon = {
						variant = Foundation.Enums.IconVariant.Filled,
						position = Foundation.Enums.IconPosition.Left,
						name = IconName.Clock
					},
					text = v54,
					variant = BadgeVariant.Neutral
				}),
				TextContainer = React.createElement(View, {
					tag = "col gap-medium size-full-0 auto-y padding-right-xxlarge padding-bottom-xsmall",
					LayoutOrder = 2
				}, {
					Title = if not v42.title then nil else React.createElement(View, {
						tag = "size-full-0 auto-y",
						LayoutOrder = 2
					}, {
						TitleText = React.createElement(FoundationText, {
							tag = "size-full-0 auto-y content-emphasis text-wrap text-align-x-left text-heading-medium",
							Text = v42.title
						})
					}),
					BodyText = if not v42.bodyText then nil else React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-wrap text-align-x-left text-body-medium",
						LayoutOrder = 3,
						Text = v42.bodyText
					})
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = not v54 and 4 or 3,
			actions = v59
		})
	})
end
