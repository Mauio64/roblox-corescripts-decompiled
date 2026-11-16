local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Chip = Foundation.Chip

local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconName = Foundation.Enums.IconName

local function CreatorCreditBalanceChipView(p)
	if p.balanceText == nil then
		return nil
	end

	return React.createElement(Chip, {
		text = p.balanceText,
		leading = IconName.Robux,
		variant = ChipVariant.Standard,
		size = ChipSize.Medium,
		onActivated = p.onActivated,
		testId = "creator-credit-balance-chip"
	})
end

return CreatorCreditBalanceChipView
