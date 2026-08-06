local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local CreatorCreditBalanceChipView = require(script.Parent.CreatorCreditBalanceChipView)
local useCreatorCreditBalanceChipViewModel = require(script.Parent.useCreatorCreditBalanceChipViewModel)

local function CreatorCreditBalanceChipContainer() -- line: 9
	-- upvalues: useCreatorCreditBalanceChipViewModel (copy), React (copy), CreatorCreditBalanceChipView (copy)
	local v6 = useCreatorCreditBalanceChipViewModel()

	return React.createElement(CreatorCreditBalanceChipView, v6)
end

return CreatorCreditBalanceChipContainer
