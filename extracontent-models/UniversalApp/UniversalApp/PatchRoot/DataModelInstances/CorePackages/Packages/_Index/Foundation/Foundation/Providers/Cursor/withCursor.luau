local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local CursorContext = require(script.Parent.CursorContext)

local function withCursor(render)
	return React.createElement(CursorContext.Consumer, { render = render })
end

return withCursor
