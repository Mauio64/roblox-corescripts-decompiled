local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconName = Foundation.Enums.IconName

local function CreatorCreditBalanceChipView(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), Chip (copy), IconName (copy), ChipVariant (copy), ChipSize (copy)
	if t1.balanceText == nil then
		return nil
	end

	return React.createElement(Chip, {
		testId = "creator-credit-balance-chip",
		text = t1.balanceText,
		leading = IconName.Robux,
		variant = ChipVariant.Standard,
		size = ChipSize.Medium,
		onActivated = t1.onActivated
	})
end

return CreatorCreditBalanceChipView
