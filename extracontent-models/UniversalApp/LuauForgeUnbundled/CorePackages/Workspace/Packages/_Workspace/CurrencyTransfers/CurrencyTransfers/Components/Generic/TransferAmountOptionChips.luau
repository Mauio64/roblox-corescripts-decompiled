local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local enums = Foundation.Enums

local GetFFlagCurrencyTransferFlowUIImprovementFix = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFlowUIImprovementFix")

local function TransferAmountOptionChips(props)
	local v5 = React.useMemo(function()
		local v6 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		local children = {}

		for i, chip in ipairs(props.chips) do
			local v7 = props.selectedAmount == chip.amount

			if v6 then
				local createElement = React.createElement
				local v9 = {
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, 52),
					BackgroundTransparency = 1,
					LayoutOrder = i
				}

				local createElement2 = React.createElement
				local v11 = {
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, 52),
					BackgroundTransparency = 1
				}

				local children3 = {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					ChipButton = 0
				}

				local createElement3 = React.createElement
				local v13 = {
					text = chip.text,
					icon = enums.IconName.Robux,
					variant = 0,
					size = 0,
					onActivated = 0
				}
				local v14 = if v7 then buttonVariant.Subtle else buttonVariant.Standard
				v13.variant = v14
				v13.size = enums.ChipSize.Medium
				function v13.onActivated() end

				children3.ChipButton = createElement3(button, v13)
				children[i] = createElement("Frame", v9, {
					ChipFrame = createElement2("Frame", v11, children3),
					TouchTarget = React.createElement("TextButton", {
						Size = UDim2.new(1, 0, 0, 52),
						BackgroundTransparency = 1,
						Text = "",
						ZIndex = 5,
						[React.Event.Activated] = function()
							props.onChipSelected(chip.amount)
						end,
						[React.Event.InputBegan] = function(p2, p3)
							if p3.UserInputType == Enum.UserInputType.Touch then
								props.onChipSelected(chip.amount)
							end
						end
					})
				})
			else
				local createElement = React.createElement
				local v9 = {
					text = chip.text,
					icon = enums.IconName.Robux,
					onActivated = function()
						props.onChipSelected(chip.amount)
					end,
					LayoutOrder = i,
					variant = 0,
					size = 0
				}

				local v10 = if v7 then buttonVariant.Subtle else buttonVariant.Standard
				v9.variant = v10
				v9.size = enums.ChipSize.Medium
				children[i] = createElement(button, v9)
			end
		end

		return children
	end, { props.chips, props.selectedAmount, props.onChipSelected })

	return React.createElement(view, {
		tag = "row align-x-center align-y-center gap-small auto-xy padding-y-medium",
		LayoutOrder = props.layoutOrder or 1
	}, {
		ChipsContainer = React.createElement(
			view,
			{ tag = "row align-x-center align-y-center gap-small auto-xy" },
			table.unpack(v5)
		)
	})
end

return TransferAmountOptionChips
