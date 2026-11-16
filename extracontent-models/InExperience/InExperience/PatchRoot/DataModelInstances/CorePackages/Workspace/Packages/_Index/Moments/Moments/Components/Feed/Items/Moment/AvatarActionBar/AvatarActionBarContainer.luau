local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local AvatarActionBar = require(script.Parent.AvatarActionBar)
local useAvatarActionBarViewModel = require(script.Parent.useAvatarActionBarViewModel)

local function AvatarActionBarContainer(p)
	local v = useAvatarActionBarViewModel(p)
	return React.createElement(AvatarActionBar, v)
end

return React.memo(AvatarActionBarContainer)
