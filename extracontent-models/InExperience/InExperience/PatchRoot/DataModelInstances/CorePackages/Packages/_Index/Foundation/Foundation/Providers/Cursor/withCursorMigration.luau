local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local CursorContext = require(script.Parent.CursorContext)

local function withCursorMigration(callback)
	return React.createElement(CursorContext.Consumer, {
		render = function(p)
			return callback(p.getCursor)
		end
	})
end

return withCursorMigration
