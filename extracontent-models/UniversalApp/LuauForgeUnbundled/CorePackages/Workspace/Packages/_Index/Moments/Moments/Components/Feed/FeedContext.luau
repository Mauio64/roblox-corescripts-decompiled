local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local context = React.createContext(nil)

return {
	FeedContext = context,
	useFeed = function()
		local v5 = React.useContext(context)

		if v5 == nil then
			error("useFeed must be used within a Feed")
		end

		return v5
	end,
	useFeedOptional = function()
		return React.useContext(context)
	end
}
