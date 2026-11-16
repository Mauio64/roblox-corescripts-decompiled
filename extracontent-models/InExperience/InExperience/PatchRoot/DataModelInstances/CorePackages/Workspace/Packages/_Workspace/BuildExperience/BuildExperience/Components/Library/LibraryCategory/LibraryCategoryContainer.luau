local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local LibraryCategoryView = require(script.Parent.LibraryCategoryView)
local useLibraryCategoryViewModel = require(script.Parent.useLibraryCategoryViewModel)

local function LibraryCategoryContainer(p)
	local v = useLibraryCategoryViewModel(p)
	return React.createElement(LibraryCategoryView, v)
end

return LibraryCategoryContainer
