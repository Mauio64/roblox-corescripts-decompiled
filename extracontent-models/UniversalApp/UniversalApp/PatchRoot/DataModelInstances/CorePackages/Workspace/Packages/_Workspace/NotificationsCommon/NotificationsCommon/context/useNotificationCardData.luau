local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local React = require(ParentParent.React)
local NotificationCardContext = require(scriptParent.NotificationCardContext)

local function useNotificationCardData() -- line: 7
	-- upvalues: React (copy), NotificationCardContext (copy)
	return (React.useContext(NotificationCardContext))
end

return useNotificationCardData
