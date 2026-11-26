local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local useRobuxText = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useRobuxText")

local function UnifiedPurchaseModalHeader(props)
	local v5 = React.useMemo(function()
		return utf8.char(57346) .. " " .. formatNumber(
			LocalizationService.RobloxLocaleId,
			props.robuxBalanceAmount or 0
		)
	end, { props.robuxBalanceAmount, LocalizationService.RobloxLocaleId })

	if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		v5 = useRobuxText(props.robuxBalanceAmount or 0)
	end

	local createElement = React.createElement

	local v8 = {
		LeftSide = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxAmount = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.titleText,
					tag = "auto-xy text-heading-small content-default text-align-x-left"
				})
			}
		),
		RightSide = 0
	}

	local v9 = if not (fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and props.hideUserRobuxBalance) then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		},
		{
			RobuxPrice = React.createElement(text, {
				LayoutOrder = 2,
				Text = v5,
				tag = "auto-xy text-label-medium content-emphasis text-align-x-right",
				RichText = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and true or nil
			})
		}
	) else nil
	v8.RightSide = v9
	return createElement(view, { tag = "auto-xy align-y-center align-x-start row" }, v8)
end

return UnifiedPurchaseModalHeader
