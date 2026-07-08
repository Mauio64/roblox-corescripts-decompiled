local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local CursorContext = require(script.Parent.CursorContext)

local function withCursor(p1) -- line: 8
	-- upvalues: React (copy), CursorContext (copy)
	return React.createElement(CursorContext.Consumer, {
		render = p1
	})
end

return withCursor
