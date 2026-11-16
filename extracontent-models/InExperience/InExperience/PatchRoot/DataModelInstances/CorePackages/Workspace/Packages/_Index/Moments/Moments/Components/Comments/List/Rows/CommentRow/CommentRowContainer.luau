local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local CommentRowView = require(script.Parent.CommentRowView)
local useCommentRowViewModel = require(script.Parent.useCommentRowViewModel)

local function CommentRowContainer(p)
	local v = useCommentRowViewModel(p)
	return React.createElement(CommentRowView, v)
end

return CommentRowContainer
