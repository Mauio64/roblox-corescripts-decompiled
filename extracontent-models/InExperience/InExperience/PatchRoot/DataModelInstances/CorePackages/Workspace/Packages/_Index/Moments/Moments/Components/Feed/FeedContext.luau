local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
require(parent.Signals)

require(script.Parent.FeedTypes)

local context = React.createContext(nil)
local FeedContext = {}
FeedContext.FeedContext = context

function FeedContext.useFeed()
	local v = React.useContext(context)

	if v == nil then
		error("useFeed must be used within a Feed")
	end

	return v
end

function FeedContext.useFeedOptional()
	return React.useContext(context)
end

return FeedContext
