local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local UserInputService = game:GetService("UserInputService")
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local Enums = Foundation.Enums

local LocalizationService = game:GetService("LocalizationService")

local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local GetFFlagCurrencyTransferFixHeaderTouchPadding = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixHeaderTouchPadding)

local function TransferRobuxHeader(p)
	local text = React.useMemo(function()
		local v = formatNumber(LocalizationService.RobloxLocaleId, p.robuxBalanceAmount or 0)
		return `{getIconRichText(Enums.IconName.Robux)} {v}`
	end, { p.robuxBalanceAmount, LocalizationService.RobloxLocaleId })

	local tag = GetFFlagCurrencyTransferFixHeaderTouchPadding()
		and UserInputService.TouchEnabled
		and "row align-y-center align-x-right gap-large padding-right-large"
		or "row align-y-center align-x-right gap-large"

	return React.createElement(View, { tag = "auto-xy align-y-center align-x-start row" }, {
		LeftSide = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					Text = `{getIconRichText(Enums.IconName.RobloxPlus)} {p.titleText}`,
					tag = "auto-xy text-heading-small content-default text-align-x-left",
					RichText = true
				})
			}
		),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = tag,
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(Text, {
				LayoutOrder = 2,
				Text = text,
				tag = "auto-xy text-label-large content-emphasis text-align-x-right",
				RichText = true
			})
		})
	})
end

return TransferRobuxHeader
