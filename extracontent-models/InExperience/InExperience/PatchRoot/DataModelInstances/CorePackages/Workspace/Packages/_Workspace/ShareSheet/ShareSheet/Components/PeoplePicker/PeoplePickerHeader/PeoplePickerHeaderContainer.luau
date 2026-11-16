local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)

local PeoplePickerHeaderView = require(script.Parent.PeoplePickerHeaderView)
local usePeoplePickerHeaderViewModel = require(script.Parent.usePeoplePickerHeaderViewModel)

local function PeoplePickerHeaderContainer(p)
	local v = usePeoplePickerHeaderViewModel(p)

	return React.createElement(PeoplePickerHeaderView, v)
end

return PeoplePickerHeaderContainer
