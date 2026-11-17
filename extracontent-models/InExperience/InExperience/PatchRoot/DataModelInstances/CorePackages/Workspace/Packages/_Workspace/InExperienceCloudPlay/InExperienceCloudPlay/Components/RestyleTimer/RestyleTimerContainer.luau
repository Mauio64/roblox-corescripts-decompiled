local parent = script:FindFirstAncestor("InExperienceCloudPlay").Parent

local React = require(parent.React)
local RestyleTimerView = require(script.Parent.RestyleTimerView)
local useRestyleTimerViewModel = require(script.Parent.useRestyleTimerViewModel)

local function RestyleTimerContainer(p)
	local v = useRestyleTimerViewModel(p)

	if v then
		return (React.createElement(RestyleTimerView, v))
	end

	return nil
end

return RestyleTimerContainer
