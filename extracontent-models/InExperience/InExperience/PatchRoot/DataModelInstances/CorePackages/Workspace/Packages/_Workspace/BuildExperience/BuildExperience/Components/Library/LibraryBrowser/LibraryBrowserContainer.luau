local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local LibraryBrowserView = require(script.Parent.LibraryBrowserView)
local useLibraryBrowserViewModel = require(script.Parent.useLibraryBrowserViewModel)

local function LibraryBrowserContainer(p)
	local v = useLibraryBrowserViewModel(p)
	return React.createElement(LibraryBrowserView, v)
end

return LibraryBrowserContainer
