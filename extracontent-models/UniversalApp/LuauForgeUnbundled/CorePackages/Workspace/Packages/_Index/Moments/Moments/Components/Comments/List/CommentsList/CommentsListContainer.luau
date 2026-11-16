local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentsListView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/CommentsListView")
local useCommentsListViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/CommentsList/useCommentsListViewModel")

local function CommentsListContainer(p2)
	local v5 = useCommentsListViewModel(p2)
	return React.createElement(CommentsListView, v5)
end

return CommentsListContainer
