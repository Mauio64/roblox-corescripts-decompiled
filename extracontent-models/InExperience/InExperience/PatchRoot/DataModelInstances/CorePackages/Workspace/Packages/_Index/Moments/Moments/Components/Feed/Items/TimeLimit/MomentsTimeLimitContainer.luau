local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local MomentsTimeLimitView = require(script.Parent.MomentsTimeLimitView)
local useMomentsTimeLimitViewModel = require(script.Parent.useMomentsTimeLimitViewModel)

local function MomentsTimeLimitContainer()
	local v = useMomentsTimeLimitViewModel()
	return React.createElement(MomentsTimeLimitView, v)
end

return MomentsTimeLimitContainer
