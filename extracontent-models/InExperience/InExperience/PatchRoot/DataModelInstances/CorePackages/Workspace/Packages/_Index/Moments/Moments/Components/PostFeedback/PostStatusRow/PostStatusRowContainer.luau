local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local PostStatusRowView = require(script.Parent.PostStatusRowView)
local usePostStatusRowViewModel = require(script.Parent.usePostStatusRowViewModel)

local function PostStatusRowContainer(p)
	local v = usePostStatusRowViewModel(p)

	if v == nil then
		return nil
	end

	return React.createElement(PostStatusRowView, v)
end

return PostStatusRowContainer
