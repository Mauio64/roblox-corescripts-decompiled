local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentsPanelBodyView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/CommentsPanelBodyView")
local useCommentsPanelBodyViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Panel/CommentsPanelBody/useCommentsPanelBodyViewModel")

local function CommentsPanelBodyContainer(p2)
	local v5 = useCommentsPanelBodyViewModel(p2)
	return React.createElement(CommentsPanelBodyView, v5)
end

return CommentsPanelBodyContainer
