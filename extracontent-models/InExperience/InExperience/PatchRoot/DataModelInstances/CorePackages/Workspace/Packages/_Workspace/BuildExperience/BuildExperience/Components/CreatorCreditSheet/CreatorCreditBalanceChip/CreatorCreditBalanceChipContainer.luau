local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local CreatorCreditBalanceChipView = require(script.Parent.CreatorCreditBalanceChipView)
local useCreatorCreditBalanceChipViewModel = require(script.Parent.useCreatorCreditBalanceChipViewModel)

local function CreatorCreditBalanceChipContainer()
	local v = useCreatorCreditBalanceChipViewModel()
	return React.createElement(CreatorCreditBalanceChipView, v)
end

return CreatorCreditBalanceChipContainer
