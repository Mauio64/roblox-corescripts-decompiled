local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(CurrencyTransfersParent.React)
local Foundation = require(CurrencyTransfersParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local Enums = Foundation.Enums
local LocalizationService = game:GetService("LocalizationService")
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)
local GetFFlagCurrencyTransferFixHeaderTouchPadding = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixHeaderTouchPadding)

local function TransferRobuxHeader(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), formatNumber (copy), LocalizationService (copy), getIconRichText (copy), Enums (copy), GetFFlagCurrencyTransferFixHeaderTouchPadding (copy), UserInputService (copy), View (copy), FoundationText (copy)
	local v15 = React.useMemo(function() -- line: 28
		-- upvalues: formatNumber (copy), LocalizationService (copy), t1 (copy), getIconRichText (copy), Enums (copy)
		local v17 = formatNumber(LocalizationService.RobloxLocaleId, t1.robuxBalanceAmount or 0)

		return `{ getIconRichText(Enums.IconName.Robux) } { v17 }`
	end, {
		t1.robuxBalanceAmount,
		LocalizationService.RobloxLocaleId
	})
	local v16 = (not GetFFlagCurrencyTransferFixHeaderTouchPadding() or not UserInputService.TouchEnabled) and "row align-y-center align-x-right gap-large" or "row align-y-center align-x-right gap-large padding-right-large"

	return React.createElement(View, {
		tag = "auto-xy align-y-center align-x-start row"
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small content-default text-align-x-left",
				RichText = true,
				Text = `{ getIconRichText(Enums.IconName.RobloxPlus) } { t1.titleText }`
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = v16,
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-label-large content-emphasis text-align-x-right",
				RichText = true,
				Text = v15
			})
		})
	})
end

return TransferRobuxHeader
