local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentsComposerView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/CommentsComposerView")
local useCommentsComposerViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Composer/useCommentsComposerViewModel")

local function CommentsComposerContainer(p2)
	local v5 = useCommentsComposerViewModel(p2)
	return React.createElement(CommentsComposerView, v5)
end

return CommentsComposerContainer
