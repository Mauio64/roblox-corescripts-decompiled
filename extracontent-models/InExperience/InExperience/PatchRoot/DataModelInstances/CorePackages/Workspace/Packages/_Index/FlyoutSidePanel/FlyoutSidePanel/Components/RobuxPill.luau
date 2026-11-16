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
local Button = Foundation.Button
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableFlyoutMenuRobuxCardRefactor = SharedFlags2.FFlagEnableFlyoutMenuRobuxCardRefactor
local FFlagEnableSharedFlyoutRobuxPill = SharedFlags2.FFlagEnableSharedFlyoutRobuxPill
local robuxPill

if FFlagEnableSharedFlyoutRobuxPill then
	local RobuxPill = require(parent.RobuxPill)
	robuxPill = RobuxPill.RobuxPill
else
	robuxPill = nil
end

local function numWithCommas(robuxBalance: number) -- 1 equivalent call inferred from this helper
	return tostring(robuxBalance):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function RobuxPill(props)
	local v = useTokens()
	local v2 = useDispatch()
	local v3 = useLocalization({ buyRobux = "IAPExperience.RobuxUpsell.Action.BuyRobux" })

	local v4 = React.useCallback(function()
		props.closeDrawer()
		local v4 = { name = AppPage.PurchaseRobux }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v2(NavigateDown(v4))
		end

		local robuxPill2 = FlyoutContentSettings.ItemType.RobuxPill
		FlyoutAnalytics.onFlyoutContentItemClicked({ integrationId = robuxPill2, source = "click" })
	end, { props.closeDrawer, v2 })

	if FFlagEnableSharedFlyoutRobuxPill then
		return React.createElement(robuxPill, {
			layoutOrder = props.layoutOrder,
			robuxBalance = props.robuxBalance,
			buyButtonText = v3.buyRobux,
			onBuyActivated = v4,
			showBorder = not FFlagEnableFlyoutMenuRobuxCardRefactor
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = FFlagEnableFlyoutMenuRobuxCardRefactor and "size-full-0 auto-y padding-x-medium padding-y-xlarge" or "size-full-0 auto-y padding-xlarge",
		onActivated = v4,
		testId = "--core-ui-flyout-robux-pill",
		LayoutOrder = props.layoutOrder
	}
	local v6 = {
		RobuxContainer = React.createElement(
			Foundation.View,
			{ tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-small" },
			{
				RobuxIcon = React.createElement(Icon, {
					name = "icons/common/goldrobux",
					size = IconSize.Medium,
					LayoutOrder = 1
				}),
				RobuxAmount = React.createElement(Text, {
					Size = UDim2.new(0.5, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					tag = "text-title-large text-align-x-left content-emphasis text-truncate-end",
					Text = numWithCommas(props.robuxBalance), -- inferred equivalent call
					LayoutOrder = 2
				})
			}
		),
		BuyRobuxButton = React.createElement(Button, {
			testId = "--core-ui-flyout-button-buy-robux",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			text = v3.buyRobux,
			size = InputSize.Small,
			onActivated = v4
		}),
		UIStroke = 0,
		UICorner = 0
	}
	local uiStroke

	if not FFlagEnableFlyoutMenuRobuxCardRefactor then
		uiStroke = React.createElement("UIStroke", {
			Color = v.Color.Stroke.Default.Color3,
			Transparency = v.Color.Stroke.Default.Transparency,
			Thickness = v.Stroke.Standard
		})
	end

	v6.UIStroke = uiStroke
	local uiCorner

	if not FFlagEnableFlyoutMenuRobuxCardRefactor then
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) })
	end

	v6.UICorner = uiCorner
	return createElement(view, v5, v6)
end

return React.memo(RobuxPill)
