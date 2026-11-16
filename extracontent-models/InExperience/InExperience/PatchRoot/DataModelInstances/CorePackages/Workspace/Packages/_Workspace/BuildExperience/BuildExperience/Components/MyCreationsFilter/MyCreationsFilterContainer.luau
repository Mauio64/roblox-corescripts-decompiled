local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local MyCreationsFilterView = require(script.Parent.MyCreationsFilterView)
local useMyCreationsFilterViewModel = require(script.Parent.useMyCreationsFilterViewModel)

local function MyCreationsFilterContainer(p)
	local v = useMyCreationsFilterViewModel(p)
	return React.createElement(MyCreationsFilterView, v)
end

return MyCreationsFilterContainer
