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
local Button = Foundation.Button
local IconSize = Foundation.Enums.IconSize
local InputSize = Foundation.Enums.InputSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local FFlagEnableFlyoutMenuRobuxCardRefactor = require(Parent.SharedFlags).FFlagEnableFlyoutMenuRobuxCardRefactor

local function numWithCommas(n1: number) -- line: 31
	return tostring(n1):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end
local function RobuxPill(t1: {[any]: any}) -- line: 35
	-- upvalues: useTokens (copy), useDispatch (copy), useLocalization (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), FFlagEnableFlyoutMenuRobuxCardRefactor (copy), Foundation (copy), Icon (copy), IconSize (copy), FoundationText (copy), Button (copy), InputSize (copy)
	local v23 = useTokens()
	local v24 = useDispatch()
	local v25 = useLocalization({
		buyRobux = "IAPExperience.RobuxUpsell.Action.BuyRobux"
	})
	local v26 = React.useCallback(function() -- line: 41
		-- upvalues: t1 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), v24 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy)
		t1.closeDrawer()

		local t2 = {
			name = AppPage.PurchaseRobux
		}

		if FFlagSignalsNavP3Dispatch then
			v7.down(v7.fromLegacyPage(t2))
		else
			v24(NavigateDown(t2))
		end

		local RobuxPill2 = FlyoutContentSettings.ItemType.RobuxPill

		FlyoutAnalytics.onFlyoutContentItemClicked({
			source = "click",
			integrationId = RobuxPill2
		})
	end, {
		t1.closeDrawer,
		v24
	})
	local v27 = not FFlagEnableFlyoutMenuRobuxCardRefactor and "size-full-0 auto-y padding-xlarge" or "size-full-0 auto-y padding-x-medium padding-y-xlarge"

	return React.createElement(Foundation.View, {
		tag = v27,
		onActivated = v26,
		LayoutOrder = t1.layoutOrder
	}, {
		RobuxContainer = React.createElement(Foundation.View, {
			tag = "position-center-left anchor-center-left auto-xy align-y-center row gap-small"
		}, {
			RobuxIcon = React.createElement(Icon, {
				name = "icons/common/goldrobux",
				LayoutOrder = 1,
				size = IconSize.Medium
			}),
			RobuxAmount = React.createElement(FoundationText, {
				tag = "text-title-large text-align-x-left content-emphasis text-truncate-end",
				LayoutOrder = 2,
				Size = UDim2.new(0.5, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = tostring(t1.robuxBalance):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			})
		}),
		BuyRobuxButton = React.createElement(Button, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			text = v25.buyRobux,
			size = InputSize.Small,
			onActivated = v26
		}),
		UIStroke = if FFlagEnableFlyoutMenuRobuxCardRefactor then nil else React.createElement("UIStroke", {
			Color = v23.Color.Stroke.Default.Color3,
			Transparency = v23.Color.Stroke.Default.Transparency,
			Thickness = v23.Stroke.Standard
		}),
		UICorner = if FFlagEnableFlyoutMenuRobuxCardRefactor then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v23.Radius.Medium)
		})
	})
end

return React.memo(RobuxPill)
