local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local CommentsPanelBodyView = require(script.Parent.CommentsPanelBodyView)
local useCommentsPanelBodyViewModel = require(script.Parent.useCommentsPanelBodyViewModel)

local function CommentsPanelBodyContainer(p)
	local v = useCommentsPanelBodyViewModel(p)
	return React.createElement(CommentsPanelBodyView, v)
end

return CommentsPanelBodyContainer
