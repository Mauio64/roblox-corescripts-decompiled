local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local CreatorCreditBalanceChipView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditBalanceChip/CreatorCreditBalanceChipView")
local useCreatorCreditBalanceChipViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditBalanceChip/useCreatorCreditBalanceChipViewModel")

local function CreatorCreditBalanceChipContainer()
	local v5 = useCreatorCreditBalanceChipViewModel()
	return React.createElement(CreatorCreditBalanceChipView, v5)
end

return CreatorCreditBalanceChipContainer
