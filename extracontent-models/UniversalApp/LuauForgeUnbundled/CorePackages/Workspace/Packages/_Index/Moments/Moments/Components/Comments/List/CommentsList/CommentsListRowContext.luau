require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local context = React.createContext(nil)

return {
	CommentsListRowContext = context,
	useCommentsListRow = function()
		local v5 = React.useContext(context)
		assert(v5 ~= nil, "Comments list rows must render inside CommentsListRowContext")
		return v5
	end
}
