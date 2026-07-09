local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local RoactChatAnalyticsContext = require(script.Parent.RoactChatAnalyticsContext)

return function() -- line: 8
	-- upvalues: React (copy), RoactChatAnalyticsContext (copy)
	return React.useContext(RoactChatAnalyticsContext)
end
