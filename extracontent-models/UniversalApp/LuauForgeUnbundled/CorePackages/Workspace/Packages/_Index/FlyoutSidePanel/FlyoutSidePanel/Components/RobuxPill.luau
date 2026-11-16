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
local button = Foundation.Button
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagEnableFlyoutMenuRobuxCardRefactor = SharedFlags.FFlagEnableFlyoutMenuRobuxCardRefactor
local fFlagEnableSharedFlyoutRobuxPill = SharedFlags.FFlagEnableSharedFlyoutRobuxPill

local robuxPill = if fFlagEnableSharedFlyoutRobuxPill then require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobuxPill").RobuxPill else nil

local function numWithCommas(p2)
	return tostring(p2):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function RobuxPill(props)
	local v5 = useTokens()
	local v6 = useDispatch()
	local v7 = useLocalization({
		buyRobux = "IAPExperience.RobuxUpsell.Action.BuyRobux"
	})

	local v8 = React.useCallback(function()
		props.closeDrawer()
		local v9 = { name = appPage.PurchaseRobux }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v6(navigateDown(v9))
		end

		local robuxPill2 = FlyoutContentSettings.ItemType.RobuxPill
		FlyoutAnalytics.onFlyoutContentItemClicked({
			integrationId = robuxPill2,
			source = "click"
		})
	end, { props.closeDrawer, v6 })

	if fFlagEnableSharedFlyoutRobuxPill then
		return React.createElement(robuxPill, {
			layoutOrder = props.layoutOrder,
			robuxBalance = props.robuxBalance,
			buyButtonText = v7.buyRobux,
			onBuyActivated = v8,
			showBorder = not fFlagEnableFlyoutMenuRobuxCardRefactor
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		tag = fFlagEnableFlyoutMenuRobuxCardRefactor and "size-full-0 auto-y padding-x-medium padding-y-xlarge" or "size-full-0 auto-y padding-xlarge",
		onActivated = v8,
		testId = "--core-ui-flyout-robux-pill",
		LayoutOrder = props.layoutOrder
	}
	local v11 = {
		RobuxContainer = React.createElement(
			Foundation.View,
			{
				tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-small"
			},
			{
				RobuxIcon = React.createElement(icon, {
					name = "icons/common/goldrobux",
					size = iconSize.Medium,
					LayoutOrder = 1
				}),
				RobuxAmount = React.createElement(text, {
					Size = UDim2.new(0.5, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					tag = "text-title-large text-align-x-left content-emphasis text-truncate-end",
					Text = tostring(props.robuxBalance):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub(
						"^,",
						""
					),
					LayoutOrder = 2
				})
			}
		),
		BuyRobuxButton = React.createElement(button, {
			testId = "--core-ui-flyout-button-buy-robux",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			text = v7.buyRobux,
			size = inputSize.Small,
			onActivated = v8
		}),
		UIStroke = 0,
		UICorner = 0
	}

	local v12 = if not fFlagEnableFlyoutMenuRobuxCardRefactor then React.createElement("UIStroke", {
		Color = v5.Color.Stroke.Default.Color3,
		Transparency = v5.Color.Stroke.Default.Transparency,
		Thickness = v5.Stroke.Standard
	}) else nil
	v11.UIStroke = v12

	local v13 = if not fFlagEnableFlyoutMenuRobuxCardRefactor then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, v5.Radius.Medium)
	}) else nil
	v11.UICorner = v13
	return createElement(view, v10, v11)
end

return React.memo(RobuxPill)
