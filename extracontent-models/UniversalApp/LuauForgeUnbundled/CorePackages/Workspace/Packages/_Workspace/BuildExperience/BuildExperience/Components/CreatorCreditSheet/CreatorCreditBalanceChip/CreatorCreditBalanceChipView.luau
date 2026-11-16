local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chip = Foundation.Chip

local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local iconName = Foundation.Enums.IconName

local function CreatorCreditBalanceChipView(p2)
	if p2.balanceText == nil then
		return nil
	end

	return React.createElement(chip, {
		text = p2.balanceText,
		leading = iconName.Robux,
		variant = chipVariant.Standard,
		size = chipSize.Medium,
		onActivated = p2.onActivated,
		testId = "creator-credit-balance-chip"
	})
end

return CreatorCreditBalanceChipView
