local parent = script.Parent
local parent2 = parent.Parent.Parent
local React = require(parent2.React)
local NotificationCardContext = require(parent.NotificationCardContext)

local function useNotificationCardData()
	return (React.useContext(NotificationCardContext))
end

return useNotificationCardData
