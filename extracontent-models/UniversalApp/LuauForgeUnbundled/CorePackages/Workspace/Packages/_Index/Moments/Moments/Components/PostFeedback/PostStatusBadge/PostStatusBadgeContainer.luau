local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local PostStatusBadgeView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusBadge/PostStatusBadgeView")
local usePostStatusBadgeViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusBadge/usePostStatusBadgeViewModel")

local function PostStatusBadgeContainer(p2)
	local v5 = usePostStatusBadgeViewModel(p2)

	if v5 == nil then
		return nil
	end

	return React.createElement(PostStatusBadgeView, v5)
end

return PostStatusBadgeContainer
