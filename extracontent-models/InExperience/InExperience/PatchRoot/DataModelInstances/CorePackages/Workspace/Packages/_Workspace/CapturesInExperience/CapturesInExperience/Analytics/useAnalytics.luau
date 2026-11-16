local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local CapturesContext = require(parent.Context.CapturesContext)

return function()
	return { fireEvent = React.useContext(CapturesContext).fireAnalyticsEvent }
end
