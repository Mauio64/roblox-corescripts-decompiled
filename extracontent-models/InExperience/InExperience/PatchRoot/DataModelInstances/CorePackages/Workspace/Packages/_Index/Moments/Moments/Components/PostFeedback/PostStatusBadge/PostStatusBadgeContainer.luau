local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local PostStatusBadgeView = require(script.Parent.PostStatusBadgeView)
local usePostStatusBadgeViewModel = require(script.Parent.usePostStatusBadgeViewModel)

local function PostStatusBadgeContainer(p)
	local v = usePostStatusBadgeViewModel(p)

	if v == nil then
		return nil
	end

	return React.createElement(PostStatusBadgeView, v)
end

return PostStatusBadgeContainer
