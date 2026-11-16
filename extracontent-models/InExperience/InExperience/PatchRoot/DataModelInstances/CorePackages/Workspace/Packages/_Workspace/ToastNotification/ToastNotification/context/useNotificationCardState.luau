local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local React = require(parent3.React)
local NotificationCardContext = require(parent.NotificationCardContext)
require(parent2.type)

local function useNotificationCardState(p)
	local v = React.useContext(NotificationCardContext)

	if p then
		return v.state and v.state.visualItems and v.state.visualItems[p] or {}
	end

	return v.state
end

return useNotificationCardState
