local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(CurrencyTransfersParent.React)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)
local Foundation = require(CurrencyTransfersParent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens
local GetFFlagCurrencyTransferCenterRobuxIcon = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferCenterRobuxIcon)

local function RobuxText(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), formatNumber (copy), LocalizationService (copy), GetFFlagCurrencyTransferCenterRobuxIcon (copy), useTokens (copy), Icon (copy), FoundationText (copy), View (copy), getIconRichText (copy)
	local v15 = React.useMemo(function() -- line: 26
		-- upvalues: formatNumber (copy), LocalizationService (copy), t1 (copy)
		return formatNumber(LocalizationService.RobloxLocaleId, t1.amount or 0)
	end, {
		t1.amount,
		LocalizationService.RobloxLocaleId
	})

	if GetFFlagCurrencyTransferCenterRobuxIcon() then
		local v16 = useTokens()
		local FontSize = v16.Typography.HeadingLarge.FontSize
		local v18 = math.round(FontSize)
		local v19 = math.round(v16.Typography.DisplaySmall.FontSize)

		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, v19),
			LayoutOrder = t1.layoutOrder
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			IconWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v18, v19)
			}, {
				RobuxIcon = React.createElement(Icon, {
					name = "robux",
					size = FontSize,
					style = v16.Color.Content.Emphasis,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 4)
				})
			}),
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = v15,
				fontStyle = v16.Typography.DisplaySmall,
				textStyle = v16.Color.Content.Emphasis,
				Size = UDim2.fromOffset(0, v19),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Center
			})
		}))
	end

	return React.createElement(View, {
		tag = "row align-x-center align-y-center auto-xy",
		LayoutOrder = t1.layoutOrder
	}, {
		RobuxIcon = React.createElement(FoundationText, {
			tag = "auto-xy text-heading-large content-emphasis text-align-x-center",
			RichText = true,
			LayoutOrder = 1,
			Text = getIconRichText("robux")
		}),
		Spacer = React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = 2,
			Size = UDim2.new(0, 4, 0, 0)
		}),
		RobuxAmount = React.createElement(FoundationText, {
			tag = "auto-xy text-display-small content-emphasis text-align-x-center",
			LayoutOrder = 3,
			Text = v15
		})
	})
end

return RobuxText
