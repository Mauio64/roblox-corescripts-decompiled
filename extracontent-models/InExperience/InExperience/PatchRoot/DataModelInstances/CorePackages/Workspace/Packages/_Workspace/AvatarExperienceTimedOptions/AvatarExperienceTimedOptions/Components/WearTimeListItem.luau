local LocalizationService = game:GetService("LocalizationService")
local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local useLocalization = Localization.Hooks.useLocalization
local NumberLocalization = Localization.NumberLocalization
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local View = Foundation.View
local Enums = Foundation.Enums
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXWearTimeListItemUnifiedLogging = AvatarExperienceFlags.FFlagAXWearTimeListItemUnifiedLogging

return (React.forwardRef(function(props, ref)
	local v = useTokens()
	local v2 = React.useMemo(function()
		return localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local v3 = useLocalization({
		infinite = "Feature.Durables.ItemDetails.WearTimeOptions.Button.Infinite",
		xDay = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDay",
			num = props.days
		},
		xDays = {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = props.days
		}
	})
	local text

	if props.days == 0 then
		text = v3.infinite
	else
		text = if props.days == 1 then v3.xDay else v3.xDays
	end

	if FFlagAXWearTimeListItemUnifiedLogging and not ref then
		ref = React.createRef()
	end

	if FFlagAXWearTimeListItemUnifiedLogging then
		React.useEffect(function()
			addUnifiedEventLogging(ref, {
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = "TIMED_OPTION_LIST_ITEM",
				elementMetadata = HttpService:JSONEncode({
					days = props.days == 0 and "permanent" or tostring(props.days),
					price = tostring(props.price)
				})
			}, { sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME })
		end, { props.days, props.price })
	end

	local createElement = React.createElement
	local v4 = {
		tag = "row align-y-center gap-medium padding-medium radius-medium size-full-0 auto-y",
		ref = ref,
		onActivated = props.onActivated,
		backgroundStyle = 0,
		LayoutOrder = 0,
		stateLayer = 0,
		selection = 0
	}
	local backgroundStyle

	if props.isActive then
		backgroundStyle = v.Color.Shift.Shift_300
	end

	v4.backgroundStyle = backgroundStyle
	v4.LayoutOrder = props.LayoutOrder
	v4.stateLayer = { affordance = Enums.StateLayerAffordance.None }

	v4.selection = { Selectable = true }
	return createElement(View, v4, {
		ContentContainer = React.createElement(
			View,
			{ tag = "row align-y-center size-full-0 auto-y flex-x-between", LayoutOrder = 1 },
			{
				DurationText = React.createElement(Text, {
					tag = "auto-xy",
					Text = text,
					textStyle = v.Color.Content.Emphasis,
					fontStyle = {
						Font = v.Typography.LabelMedium.Font,
						FontSize = v.FontSize.FontSize_400
					},
					LayoutOrder = 1,
					selection = { Selectable = false }
				}),
				PriceContainer = React.createElement(
					View,
					{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 2 },
					{
						RobuxIcon = React.createElement(Foundation.Icon, {
							name = Enums.IconName.Robux,
							variant = Enums.IconVariant.Regular,
							size = Enums.IconSize.Medium,
							style = v.Color.Content.Default,
							LayoutOrder = 1
						}),
						PriceText = React.createElement(Text, {
							tag = "auto-xy",
							Text = NumberLocalization.localize(props.price, v2:GetLocale()),
							textStyle = v.Color.Content.Default,
							fontStyle = {
								Font = v.Typography.LabelMedium.Font,
								FontSize = v.FontSize.FontSize_400
							},
							LayoutOrder = 2,
							selection = { Selectable = false }
						})
					}
				)
			}
		)
	})
end))
