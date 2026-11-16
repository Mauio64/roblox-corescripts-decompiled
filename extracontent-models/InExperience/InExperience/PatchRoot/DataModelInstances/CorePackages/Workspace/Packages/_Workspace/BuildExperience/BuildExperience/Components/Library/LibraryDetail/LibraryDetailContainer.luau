local BuildExperience = script:FindFirstAncestor("BuildExperience")
local React = require(BuildExperience.Parent.React)

local LibraryDetailView = require(script.Parent.LibraryDetailView)
local useLibraryDetailViewModel = require(script.Parent.useLibraryDetailViewModel)

local function LibraryDetailContainer(p)
	local v = useLibraryDetailViewModel(p)
	return React.createElement(LibraryDetailView, v)
end

return LibraryDetailContainer
