local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)

require(Parent.Signals)
require(script.Parent.FeedTypes)

local v3 = React.createContext(nil)

return {
	FeedContext = v3,
	useFeed = function() -- line: 54
		-- upvalues: React (copy), v3 (copy)
		local v4 = React.useContext(v3)

		if v4 == nil then
			error("useFeed must be used within a Feed")
		end

		return v4
	end,
	useFeedOptional = function() -- line: 66
		-- upvalues: React (copy), v3 (copy)
		return React.useContext(v3)
	end
}
