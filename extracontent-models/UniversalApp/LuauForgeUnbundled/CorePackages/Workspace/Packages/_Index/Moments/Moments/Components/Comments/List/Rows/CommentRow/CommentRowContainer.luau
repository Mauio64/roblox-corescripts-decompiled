local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentRowView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowView")
local useCommentRowViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/useCommentRowViewModel")

local function CommentRowContainer(p2)
	local v5 = useCommentRowViewModel(p2)
	return React.createElement(CommentRowView, v5)
end

return CommentRowContainer
