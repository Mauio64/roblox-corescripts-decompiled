local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local useTimeoutBannerProps = require(script.Parent.useTimeoutBannerProps)
local TimeoutBanner = require(script.Parent.TimeoutBanner)

local function TimeoutBannerContainer(p1) -- line: 16
	-- upvalues: useTimeoutBannerProps (copy), React (copy), TimeoutBanner (copy)
	local v7 = useTimeoutBannerProps(p1)

	return React.createElement(TimeoutBanner, v7)
end

return React.memo(TimeoutBannerContainer)
