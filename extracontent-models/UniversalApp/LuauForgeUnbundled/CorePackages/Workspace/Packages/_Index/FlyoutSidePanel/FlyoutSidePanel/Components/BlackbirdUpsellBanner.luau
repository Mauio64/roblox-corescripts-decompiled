local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppNavigation").NavigationCommands else nil

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local usePlaceholderLocalization = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/usePlaceholderLocalization")
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization

local fFlagBlackbirdUpdateStringFlyoutMenu = SharedFlags.FFlagBlackbirdUpdateStringFlyoutMenu
local defineFastFlag = game:DefineFastFlag("FixFlyoutMenuTextWrap", false)
local defineFastFlag2 = game:DefineFastFlag("FlyoutBlackbirdBannerFlexLayout", false)

local function BlackbirdUpsellBanner(p2)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7

	if fFlagBlackbirdUpdateStringFlyoutMenu then
		v7 = useLocalization({
			bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
		})
	else
		v7 = usePlaceholderLocalization({
			bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
		})
	end

	local v8 = React.useCallback(function()
		p2.closeDrawer()
		local v9 = { name = appPage.Blackbird }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v6(navigateDown(v9))
		end

		local blackbird = FlyoutContentSettings.ItemType.Blackbird

		if blackbird then
			FlyoutAnalytics.onFlyoutContentItemClicked({
				integrationId = blackbird,
				source = "click"
			})
		end
	end, { p2.closeDrawer })

	if defineFastFlag and defineFastFlag2 then
		return React.createElement(
			Foundation.View,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-xlarge",
				onActivated = v8,
				testId = "--core-ui-flyout-blackbird-upsell",
				LayoutOrder = p2.layoutOrder
			},
			{
				BlackbirdIcon = React.createElement(icon, {
					style = v5.Color.Content.Emphasis,
					name = iconName.RobloxPlus,
					size = iconSize.Medium,
					LayoutOrder = 1
				}),
				BannerText = React.createElement(text, {
					tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
					Text = v7.bannerText,
					LayoutOrder = 2
				}),
				ChevronIcon = React.createElement(icon, {
					name = iconName.ChevronLargeRight,
					size = iconSize.Medium,
					style = v5.Color.Content.Default,
					LayoutOrder = 3
				})
			}
		)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = "size-full-0 auto-y padding-x-medium padding-y-xlarge",
		onActivated = v8,
		testId = "--core-ui-flyout-blackbird-upsell",
		LayoutOrder = p2.layoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v11 = {
		BlackbirdIcon = React.createElement(icon, {
			style = v5.Color.Content.Emphasis,
			name = iconName.RobloxPlus,
			size = iconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = 0
	}

	local createElement3 = React.createElement
	local v14 = if defineFastFlag then UDim2.new(0.75, 0, 0, 0) else UDim2.new(0.65, 0, 0, 0)
	v11.BannerText = createElement3(text, {
		Size = v14,
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = "text-body-small text-align-x-left text-wrap content-emphasis",
		Text = v7.bannerText,
		LayoutOrder = 2
	})
	return createElement(view, v9, {
		ContentContainer = createElement2(
			view2,
			{
				tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-medium"
			},
			v11
		),
		ChevronIcon = React.createElement(icon, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			name = iconName.ChevronLargeRight,
			size = iconSize.Medium,
			style = v5.Color.Content.Default
		})
	})
end

return BlackbirdUpsellBanner
