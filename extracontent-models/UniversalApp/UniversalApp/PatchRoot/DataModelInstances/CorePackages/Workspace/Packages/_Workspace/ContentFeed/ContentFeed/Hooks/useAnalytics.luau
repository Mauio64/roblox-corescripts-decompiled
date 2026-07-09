local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local FeedContext = require(ParentParent.App.FeedContext)

return function() -- line: 10
	-- upvalues: React (copy), FeedContext (copy)
	return {
		fireEvent = React.useContext(FeedContext).fireAnalyticsEvent
	}
end
