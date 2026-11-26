local UserInputService = game:GetService("UserInputService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local view = Foundation.View
local text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local enums = Foundation.Enums

local LocalizationService = game:GetService("LocalizationService")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/formatNumber")

local GetFFlagCurrencyTransferFixHeaderTouchPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFixHeaderTouchPadding")

local function TransferRobuxHeader(p2)
	local v5 = React.useMemo(function()
		local v6 = formatNumber(LocalizationService.RobloxLocaleId, p2.robuxBalanceAmount or 0)
		return `{getIconRichText(enums.IconName.Robux)} {v6}`
	end, { p2.robuxBalanceAmount, LocalizationService.RobloxLocaleId })

	local v6 = GetFFlagCurrencyTransferFixHeaderTouchPadding()
		and UserInputService.TouchEnabled
		and "row align-y-center align-x-right gap-large padding-right-large"
		or "row align-y-center align-x-right gap-large"

	return React.createElement(view, {
		tag = "auto-xy align-y-center align-x-start row"
	}, {
		LeftSide = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					Text = `{getIconRichText(enums.IconName.RobloxPlus)} {p2.titleText}`,
					tag = "auto-xy text-heading-small content-default text-align-x-left",
					RichText = true
				})
			}
		),
		RightSide = React.createElement(
			view,
			{ LayoutOrder = 2, tag = v6, Size = UDim2.new(0.5, 0, 1, 0) },
			{
				RobuxPrice = React.createElement(text, {
					LayoutOrder = 2,
					Text = v5,
					tag = "auto-xy text-label-large content-emphasis text-align-x-right",
					RichText = true
				})
			}
		)
	})
end

return TransferRobuxHeader
