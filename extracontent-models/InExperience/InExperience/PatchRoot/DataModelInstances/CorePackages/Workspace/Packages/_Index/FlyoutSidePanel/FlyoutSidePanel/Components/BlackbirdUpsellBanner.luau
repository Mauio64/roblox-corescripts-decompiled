local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local usePlaceholderLocalization = require(script.Parent.Parent.Hooks.usePlaceholderLocalization)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local SharedFlags2 = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagBlackbirdUpdateStringFlyoutMenu = SharedFlags2.FFlagBlackbirdUpdateStringFlyoutMenu
local defineFastFlag = game:DefineFastFlag("FixFlyoutMenuTextWrap", false)
local defineFastFlag2 = game:DefineFastFlag("FlyoutBlackbirdBannerFlexLayout", false)

local function BlackbirdUpsellBanner(p)
	local v = useTokens()
	local v2 = useDispatch()
	local v3

	if FFlagBlackbirdUpdateStringFlyoutMenu then
		v3 = useLocalization({
			bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
		})
	else
		v3 = usePlaceholderLocalization({
			bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
		})
	end

	local onActivated = React.useCallback(function()
		p.closeDrawer()
		local v4 = { name = AppPage.Blackbird }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v2(NavigateDown(v4))
		end

		local blackbird = FlyoutContentSettings.ItemType.Blackbird

		if blackbird then
			FlyoutAnalytics.onFlyoutContentItemClicked({
				integrationId = blackbird,
				source = "click"
			})
		end
	end, { p.closeDrawer })

	if defineFastFlag and defineFastFlag2 then
		return React.createElement(
			Foundation.View,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-xlarge",
				onActivated = onActivated,
				testId = "--core-ui-flyout-blackbird-upsell",
				LayoutOrder = p.layoutOrder
			},
			{
				BlackbirdIcon = React.createElement(Icon, {
					style = v.Color.Content.Emphasis,
					name = IconName.RobloxPlus,
					size = IconSize.Medium,
					LayoutOrder = 1
				}),
				BannerText = React.createElement(Text, {
					tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
					Text = v3.bannerText,
					LayoutOrder = 2
				}),
				ChevronIcon = React.createElement(Icon, {
					name = IconName.ChevronLargeRight,
					size = IconSize.Medium,
					style = v.Color.Content.Default,
					LayoutOrder = 3
				})
			}
		)
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		tag = "size-full-0 auto-y padding-x-medium padding-y-xlarge",
		onActivated = onActivated,
		testId = "--core-ui-flyout-blackbird-upsell",
		LayoutOrder = p.layoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v5 = {
		BlackbirdIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Medium,
			LayoutOrder = 1
		}),
		BannerText = 0
	}

	local createElement3 = React.createElement
	local size

	if defineFastFlag then
		size = UDim2.new(0.75, 0, 0, 0)
	else
		size = UDim2.new(0.65, 0, 0, 0)
	end

	v5.BannerText = createElement3(Text, {
		Size = size,
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = "text-body-small text-align-x-left text-wrap content-emphasis",
		Text = v3.bannerText,
		LayoutOrder = 2
	})
	return createElement(view, v4, {
		ContentContainer = createElement2(
			view2,
			{
				tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-medium"
			},
			v5
		),
		ChevronIcon = React.createElement(Icon, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			name = IconName.ChevronLargeRight,
			size = IconSize.Medium,
			style = v.Color.Content.Default
		})
	})
end

return BlackbirdUpsellBanner
