local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local CommentsComposerView = require(script.Parent.CommentsComposerView)
local useCommentsComposerViewModel = require(script.Parent.useCommentsComposerViewModel)

local function CommentsComposerContainer(p)
	local v = useCommentsComposerViewModel(p)
	return React.createElement(CommentsComposerView, v)
end

return CommentsComposerContainer
