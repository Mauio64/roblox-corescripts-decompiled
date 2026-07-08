local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local usePlaceholderLocalization = require(script.Parent.Parent.Hooks.usePlaceholderLocalization)
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local SharedFlags = require(Parent.SharedFlags)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FFlagBlackbirdUpdateStringFlyoutMenu = SharedFlags.FFlagBlackbirdUpdateStringFlyoutMenu
local v20 = game:DefineFastFlag("FixFlyoutMenuTextWrap", false)
local v21 = game:DefineFastFlag("FlyoutBlackbirdBannerFlexLayout", false)

local function BlackbirdUpsellBanner(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), useDispatch (copy), FFlagBlackbirdUpdateStringFlyoutMenu (copy), useLocalization (copy), usePlaceholderLocalization (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), v20 (copy), v21 (copy), Foundation (copy), Icon (copy), IconName (copy), IconSize (copy), FoundationText (copy)
	local v24 = useTokens()
	local v25 = useDispatch()
	local v26 = if not FFlagBlackbirdUpdateStringFlyoutMenu then usePlaceholderLocalization({
		bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
	}) else useLocalization({
		bannerText = "Feature.RobloxSubscription.Description.ExclusiveBenefits"
	})
	local v27 = React.useCallback(function() -- line: 44
		-- upvalues: t1 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), v25 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy)
		t1.closeDrawer()

		local t2 = {
			name = AppPage.Blackbird
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t2))
		else
			v25(NavigateDown(t2))
		end

		local Blackbird = FlyoutContentSettings.ItemType.Blackbird

		if Blackbird then
			FlyoutAnalytics.onFlyoutContentItemClicked({
				source = "click",
				integrationId = Blackbird
			})
		end
	end, { t1.closeDrawer })

	if v20 and v21 then
		return React.createElement(Foundation.View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-xlarge",
			onActivated = v27,
			LayoutOrder = t1.layoutOrder
		}, {
			BlackbirdIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				style = v24.Color.Content.Emphasis,
				name = IconName.RobloxPlus,
				size = IconSize.Medium
			}),
			BannerText = React.createElement(FoundationText, {
				tag = "fill auto-y text-body-small text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 2,
				Text = v26.bannerText
			}),
			ChevronIcon = React.createElement(Icon, {
				LayoutOrder = 3,
				name = IconName.ChevronLargeRight,
				size = IconSize.Medium,
				style = v24.Color.Content.Default
			})
		})
	end

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y padding-x-medium padding-y-xlarge",
		onActivated = v27,
		LayoutOrder = t1.layoutOrder
	}, {
		ContentContainer = React.createElement(Foundation.View, {
			tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-medium"
		}, {
			BlackbirdIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				style = v24.Color.Content.Emphasis,
				name = IconName.RobloxPlus,
				size = IconSize.Medium
			}),
			BannerText = React.createElement(FoundationText, {
				tag = "text-body-small text-align-x-left text-wrap content-emphasis",
				LayoutOrder = 2,
				Size = if not v20 then UDim2.new(0.65, 0, 0, 0) else UDim2.new(0.75, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v26.bannerText
			})
		}),
		ChevronIcon = React.createElement(Icon, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			name = IconName.ChevronLargeRight,
			size = IconSize.Medium,
			style = v24.Color.Content.Default
		})
	})
end

return BlackbirdUpsellBanner
