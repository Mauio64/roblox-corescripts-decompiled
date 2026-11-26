local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local PostStatusRowView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusRow/PostStatusRowView")
local usePostStatusRowViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusRow/usePostStatusRowViewModel")

local function PostStatusRowContainer(p2)
	local v5 = usePostStatusRowViewModel(p2)

	if v5 == nil then
		return nil
	end

	return React.createElement(PostStatusRowView, v5)
end

return PostStatusRowContainer
