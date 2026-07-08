local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local CapturesContext = require(ParentParent.Context.CapturesContext)

return function() -- line: 10
	-- upvalues: React (copy), CapturesContext (copy)
	return {
		fireEvent = React.useContext(CapturesContext).fireAnalyticsEvent
	}
end
