local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local Foundation = require(CurrencyTransfersParent.Foundation)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local Enums = Foundation.Enums
local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)

local function TransferAmountOptionChips(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), Button (copy), Enums (copy), ButtonVariant (copy), View (copy)
	local v12 = React.useMemo(function() -- line: 34
		-- upvalues: GetFFlagCurrencyTransferFlowUIImprovementFix (copy), t1 (copy), React (copy), Button (copy), Enums (copy), ButtonVariant (copy)
		local t2 = {}
		local v14 = GetFFlagCurrencyTransferFlowUIImprovementFix()

		for i, v in ipairs(t1.chips) do
			local v17 = t1.selectedAmount == v.amount

			if v14 then
				t2[i] = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					Size = UDim2.new(0, 0, 0, 52),
					LayoutOrder = i
				}, {
					ChipFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 0, 52)
					}, {
						Layout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						ChipButton = React.createElement(Button, {
							text = v.text,
							icon = Enums.IconName.Robux,
							variant = if not v17 then ButtonVariant.Standard else ButtonVariant.Subtle,
							size = Enums.ChipSize.Medium,
							onActivated = function() -- line: 77
							end
						})
					}),
					TouchTarget = React.createElement("TextButton", {
						Size = UDim2.new(1, 0, 0, 52),
						BackgroundTransparency = 1,
						Text = "",
						ZIndex = 5,
						[React.Event.Activated] = function() -- line: 88
							-- upvalues: t1 (copy), v (copy)
							t1.onChipSelected(v.amount)
						end,
						[React.Event.InputBegan] = function(_, p2) -- line: 98
							-- upvalues: t1 (copy), v (copy)
							if p2.UserInputType == Enum.UserInputType.Touch then
								t1.onChipSelected(v.amount)
							end
						end
					})
				})
			else
				t2[i] = React.createElement(Button, {
					text = v.text,
					icon = Enums.IconName.Robux,
					onActivated = function() -- line: 111
						-- upvalues: t1 (copy), v (copy)
						t1.onChipSelected(v.amount)
					end,
					LayoutOrder = i,
					variant = if not v17 then ButtonVariant.Standard else ButtonVariant.Subtle,
					size = Enums.ChipSize.Medium
				})
			end
		end

		return t2
	end, {
		t1.chips,
		t1.selectedAmount,
		t1.onChipSelected
	})

	return React.createElement(View, {
		tag = "row align-x-center align-y-center gap-small auto-xy padding-y-medium",
		LayoutOrder = t1.layoutOrder or 1
	}, {
		ChipsContainer = React.createElement(View, {
			tag = "row align-x-center align-y-center gap-small auto-xy"
		}, table.unpack(v12))
	})
end

return TransferAmountOptionChips
