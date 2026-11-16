local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local Enums = Foundation.Enums

local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)

local function TransferAmountOptionChips(props)
	local v = React.useMemo(function()
		local fFlagCurrencyTransferFlowUIImprovementFix = GetFFlagCurrencyTransferFlowUIImprovementFix()
		local children = {}

		for i, chip in ipairs(props.chips) do
			local v = props.selectedAmount == chip.amount

			if fFlagCurrencyTransferFlowUIImprovementFix then
				local createElement = React.createElement
				local v2 = {
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, 52),
					BackgroundTransparency = 1,
					LayoutOrder = i
				}

				local createElement2 = React.createElement
				local v3 = {
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, 52),
					BackgroundTransparency = 1
				}

				local children2 = {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					ChipButton = 0
				}

				local createElement3 = React.createElement
				local v4 = {
					text = chip.text,
					icon = Enums.IconName.Robux,
					variant = 0,
					size = 0,
					onActivated = 0
				}
				local variant

				if v then
					variant = ButtonVariant.Subtle
				else
					variant = ButtonVariant.Standard
				end

				v4.variant = variant
				v4.size = Enums.ChipSize.Medium
				function v4.onActivated() end

				children2.ChipButton = createElement3(Button, v4)
				children[i] = createElement("Frame", v2, {
					ChipFrame = createElement2("Frame", v3, children2),
					TouchTarget = React.createElement("TextButton", {
						Size = UDim2.new(1, 0, 0, 52),
						BackgroundTransparency = 1,
						Text = "",
						ZIndex = 5,
						[React.Event.Activated] = function()
							props.onChipSelected(chip.amount)
						end,
						[React.Event.InputBegan] = function(_, p)
							if p.UserInputType == Enum.UserInputType.Touch then
								props.onChipSelected(chip.amount)
							end
						end
					})
				})
			else
				local createElement = React.createElement
				local v2 = {
					text = chip.text,
					icon = Enums.IconName.Robux,
					onActivated = function()
						props.onChipSelected(chip.amount)
					end,
					LayoutOrder = i,
					variant = 0,
					size = 0
				}
				local variant

				if v then
					variant = ButtonVariant.Subtle
				else
					variant = ButtonVariant.Standard
				end

				v2.variant = variant
				v2.size = Enums.ChipSize.Medium
				children[i] = createElement(Button, v2)
			end
		end

		return children
	end, { props.chips, props.selectedAmount, props.onChipSelected })

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-small auto-xy padding-y-medium",
		LayoutOrder = props.layoutOrder or 1
	}, {
		ChipsContainer = React.createElement(
			View,
			{ tag = "row align-x-center align-y-center gap-small auto-xy" },
			table.unpack(v)
		)
	})
end

return TransferAmountOptionChips
