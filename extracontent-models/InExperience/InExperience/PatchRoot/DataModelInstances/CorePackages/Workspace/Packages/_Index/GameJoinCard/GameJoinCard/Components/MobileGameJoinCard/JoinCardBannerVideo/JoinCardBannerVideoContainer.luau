local parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(parent.React)

local JoinCardBannerVideoView = require(script.Parent.JoinCardBannerVideoView)
local useJoinCardBannerVideoViewModel = require(script.Parent.useJoinCardBannerVideoViewModel)

local function JoinCardBannerVideoContainer(p)
	local v = useJoinCardBannerVideoViewModel(p)
	return React.createElement(JoinCardBannerVideoView, v)
end

return JoinCardBannerVideoContainer
