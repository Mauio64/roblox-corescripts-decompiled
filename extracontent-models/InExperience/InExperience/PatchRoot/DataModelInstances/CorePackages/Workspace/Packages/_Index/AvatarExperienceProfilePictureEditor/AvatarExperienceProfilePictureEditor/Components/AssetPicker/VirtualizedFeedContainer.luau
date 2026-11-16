local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local React = require(parent.React)

local VirtualizedFeedView = require(script.Parent.VirtualizedFeedView)
local useVirtualizedFeedViewModel = require(script.Parent.useVirtualizedFeedViewModel)

local function AssetPickerVirtualizedFeedContainer(p)
	local v = useVirtualizedFeedViewModel(p)
	return React.createElement(VirtualizedFeedView, v)
end

return AssetPickerVirtualizedFeedContainer
