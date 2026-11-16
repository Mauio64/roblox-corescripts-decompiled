local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local CommentsListView = require(script.Parent.CommentsListView)
local useCommentsListViewModel = require(script.Parent.useCommentsListViewModel)

local function CommentsListContainer(p)
	local v = useCommentsListViewModel(p)
	return React.createElement(CommentsListView, v)
end

return CommentsListContainer
