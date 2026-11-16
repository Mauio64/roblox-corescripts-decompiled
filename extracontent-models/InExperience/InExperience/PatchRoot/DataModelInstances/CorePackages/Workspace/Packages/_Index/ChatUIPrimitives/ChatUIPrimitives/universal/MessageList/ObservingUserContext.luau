local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)

local context = React.createContext(nil)

return {
	Context = context,
	useObservingUserId = function()
		return React.useContext(context)
	end
}
