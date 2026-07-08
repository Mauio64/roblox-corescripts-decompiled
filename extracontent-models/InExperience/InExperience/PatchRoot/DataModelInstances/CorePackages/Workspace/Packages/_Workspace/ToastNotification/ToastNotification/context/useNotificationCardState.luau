local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)
local NotificationCardContext = require(scriptParent.NotificationCardContext)

require(scriptParentParent.type)

local function useNotificationCardState(p1) -- line: 8
	-- upvalues: React (copy), NotificationCardContext (copy)
	local v8 = React.useContext(NotificationCardContext)

	if p1 then
		return v8.state and (not not v8.state.visualItems and v8.state.visualItems[p1]) or {}
	end

	return v8.state
end

return useNotificationCardState
