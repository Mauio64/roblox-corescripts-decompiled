local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(parent.React)

local SelectableItemCardRowView = require(script.Parent.SelectableItemCardRowView)
local useSelectableRowViewModel = require(script.Parent.useSelectableRowViewModel)

local function SelectableCardRowContainer(p)
	local v = useSelectableRowViewModel(p)
	return React.createElement(SelectableItemCardRowView, v)
end

return SelectableCardRowContainer
