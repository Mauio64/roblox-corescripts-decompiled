local LocalizationService = game:GetService("LocalizationService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local Localization = require(Parent.Localization)
local Localization2 = require(Parent.RobloxAppLocales).Localization
local useLocalization = Localization.Hooks.useLocalization
local NumberLocalization = Localization.NumberLocalization
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums
local AvatarExperienceAnalytics = require(Parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local FFlagAXWearTimeListItemUnifiedLogging = require(Parent.AvatarExperienceFlags).FFlagAXWearTimeListItemUnifiedLogging

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 30
	-- upvalues: useTokens (copy), React (copy), Localization2 (copy), LocalizationService (copy), useLocalization (copy), FFlagAXWearTimeListItemUnifiedLogging (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), HttpService (copy), UnifiedEventLogConstants (copy), View (copy), Enums (copy), FoundationText (copy), Foundation (copy), NumberLocalization (copy)
	local v22 = useTokens()
	local v23 = React.useMemo(function() -- line: 32
		-- upvalues: Localization2 (copy), LocalizationService (copy)
		return Localization2.new(LocalizationService.RobloxLocaleId)
	end, {})
	local v24 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = t1.days
		},
		xDays = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = t1.days
		}
	})
	local v25 = if t1.days ~= 0 then if t1.days ~= 1 then v24.xDays else v24.xDay else v24.infinite

	if FFlagAXWearTimeListItemUnifiedLogging and not p1 then
		p1 = React.createRef()
	end

	if FFlagAXWearTimeListItemUnifiedLogging then
		React.useEffect(function() -- line: 55
			-- upvalues: addUnifiedEventLogging (copy), p1 (ref), UnifiedEventLogEnums (copy), HttpService (copy), t1 (copy), UnifiedEventLogConstants (copy)
			addUnifiedEventLogging(p1, {
				elementName = "TIMED_OPTION_LIST_ITEM",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementMetadata = HttpService:JSONEncode({
					days = if t1.days ~= 0 then tostring(t1.days) else "permanent",
					price = tostring(t1.price)
				})
			}, {
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end, {
			t1.days,
			t1.price
		})
	end

	return React.createElement(View, {
		tag = "row align-y-center gap-medium padding-medium radius-medium size-full-0 auto-y",
		ref = p1,
		onActivated = t1.onActivated,
		backgroundStyle = if not t1.isActive then nil else v22.Color.Shift.Shift_300,
		LayoutOrder = t1.LayoutOrder,
		stateLayer = {
			affordance = Enums.StateLayerAffordance.None
		},
		selection = {
			Selectable = true
		}
	}, {
		ContentContainer = React.createElement(View, {
			tag = "row align-y-center size-full-0 auto-y flex-x-between",
			LayoutOrder = 1
		}, {
			DurationText = React.createElement(FoundationText, {
				tag = "auto-xy",
				LayoutOrder = 1,
				Text = v25,
				textStyle = v22.Color.Content.Emphasis,
				fontStyle = {
					Font = v22.Typography.LabelMedium.Font,
					FontSize = v22.FontSize.FontSize_400
				},
				selection = {
					Selectable = false
				}
			}),
			PriceContainer = React.createElement(View, {
				tag = "row align-y-center gap-xsmall auto-xy",
				LayoutOrder = 2
			}, {
				RobuxIcon = React.createElement(Foundation.Icon, {
					LayoutOrder = 1,
					name = Enums.IconName.Robux,
					variant = Enums.IconVariant.Regular,
					size = Enums.IconSize.Medium,
					style = v22.Color.Content.Default
				}),
				PriceText = React.createElement(FoundationText, {
					tag = "auto-xy",
					LayoutOrder = 2,
					Text = NumberLocalization.localize(t1.price, v23:GetLocale()),
					textStyle = v22.Color.Content.Default,
					fontStyle = {
						Font = v22.Typography.LabelMedium.Font,
						FontSize = v22.FontSize.FontSize_400
					},
					selection = {
						Selectable = false
					}
				})
			})
		})
	})
end))
