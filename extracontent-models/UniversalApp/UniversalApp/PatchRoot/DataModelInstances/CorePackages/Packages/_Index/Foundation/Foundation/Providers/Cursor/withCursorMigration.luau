local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)
local CursorContext = require(script.Parent.CursorContext)

local function withCursorMigration(p1) -- line: 8
	-- upvalues: React (copy), CursorContext (copy)
	return React.createElement(CursorContext.Consumer, {
		render = function(p2) -- line: 10
			-- upvalues: p1 (copy)
			return p1(p2.getCursor)
		end
	})
end

return withCursorMigration
