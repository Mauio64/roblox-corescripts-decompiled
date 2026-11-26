local LocalizationService = game:GetService("LocalizationService")
local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/RobloxAppLocales").Localization
local useLocalization = Localization.Hooks.useLocalization
local numberLocalization = Localization.NumberLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local view = Foundation.View
local enums = Foundation.Enums
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceAnalytics")
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local fFlagAXWearTimeListItemUnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/AvatarExperienceFlags").FFlagAXWearTimeListItemUnifiedLogging

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local v6 = React.useMemo(function()
		return localization.new(LocalizationService.RobloxLocaleId)
	end, {})
	local v7 = useLocalization({
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

	local v8 = if props.days == 0 then v7.infinite elseif props.days == 1 then v7.xDay else v7.xDays

	if fFlagAXWearTimeListItemUnifiedLogging and not p2 then
		p2 = React.createRef()
	end

	if fFlagAXWearTimeListItemUnifiedLogging then
		React.useEffect(function()
			addUnifiedEventLogging(p2, {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = "TIMED_OPTION_LIST_ITEM",
				elementMetadata = HttpService:JSONEncode({
					days = props.days == 0 and "permanent" or tostring(props.days),
					price = tostring(props.price)
				})
			}, { sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME })
		end, { props.days, props.price })
	end

	local createElement = React.createElement
	local v10 = {
		tag = "row align-y-center gap-medium padding-medium radius-medium size-full-0 auto-y",
		ref = p2,
		onActivated = props.onActivated,
		backgroundStyle = 0,
		LayoutOrder = 0,
		stateLayer = 0,
		selection = 0
	}
	local v11 = if props.isActive then v5.Color.Shift.Shift_300 else nil
	v10.backgroundStyle = v11
	v10.LayoutOrder = props.LayoutOrder
	v10.stateLayer = { affordance = enums.StateLayerAffordance.None }

	v10.selection = { Selectable = true }
	return createElement(view, v10, {
		ContentContainer = React.createElement(
			view,
			{
				tag = "row align-y-center size-full-0 auto-y flex-x-between",
				LayoutOrder = 1
			},
			{
				DurationText = React.createElement(text, {
					tag = "auto-xy",
					Text = v8,
					textStyle = v5.Color.Content.Emphasis,
					fontStyle = {
						Font = v5.Typography.LabelMedium.Font,
						FontSize = v5.FontSize.FontSize_400
					},
					LayoutOrder = 1,
					selection = { Selectable = false }
				}),
				PriceContainer = React.createElement(
					view,
					{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 2 },
					{
						RobuxIcon = React.createElement(Foundation.Icon, {
							name = enums.IconName.Robux,
							variant = enums.IconVariant.Regular,
							size = enums.IconSize.Medium,
							style = v5.Color.Content.Default,
							LayoutOrder = 1
						}),
						PriceText = React.createElement(text, {
							tag = "auto-xy",
							Text = numberLocalization.localize(props.price, v6:GetLocale()),
							textStyle = v5.Color.Content.Default,
							fontStyle = {
								Font = v5.Typography.LabelMedium.Font,
								FontSize = v5.FontSize.FontSize_400
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
