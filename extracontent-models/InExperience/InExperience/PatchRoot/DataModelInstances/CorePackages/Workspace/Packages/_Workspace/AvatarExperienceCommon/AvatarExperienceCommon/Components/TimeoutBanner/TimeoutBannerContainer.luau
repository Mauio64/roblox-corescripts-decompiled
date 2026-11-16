local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local useTimeoutBannerProps = require(script.Parent.useTimeoutBannerProps)
local TimeoutBanner = require(script.Parent.TimeoutBanner)

local function TimeoutBannerContainer(p)
	local v = useTimeoutBannerProps(p)
	return React.createElement(TimeoutBanner, v)
end

return React.memo(TimeoutBannerContainer)
