local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)

local function MessageListView(p)
	return React.createElement(ViewRecycler.VirtualList, p.listProps)
end

return React.memo(MessageListView)
