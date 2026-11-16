local parent = script:FindFirstAncestor("Moments").Parent

require(parent.Foundation)
require(parent.MomentsTypes)
local React = require(parent.React)

local context = React.createContext(nil)

return {
	CommentsListRowContext = context,
	useCommentsListRow = function()
		local v = React.useContext(context)
		assert(v ~= nil, "Comments list rows must render inside CommentsListRowContext")
		return v
	end
}
