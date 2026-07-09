local Parent = script:FindFirstAncestor("FriendsActivityFeed").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View

local function FriendsActivityFeedScreen(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "size-full",
		LayoutOrder = t1.layoutOrder
	})
end

return FriendsActivityFeedScreen
