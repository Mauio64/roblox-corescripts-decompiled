local parent = script:FindFirstAncestor("Moments").Parent
local React = require(parent.React)

local AvatarMomentView = require(script.Parent.AvatarMomentView)
local useAvatarMomentViewModel = require(script.Parent.useAvatarMomentViewModel)

local function AvatarMomentContainer(p)
	local v = useAvatarMomentViewModel(p)
	return React.createElement(AvatarMomentView, v)
end

return AvatarMomentContainer
