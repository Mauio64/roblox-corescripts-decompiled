local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Logger = require(Foundation.Utility.Logger)
local React = require(FoundationParent.React)

require(Foundation.Enums.CursorType)
require(Foundation.Components.Types)

return (React.createContext({
	refCache = {},
	setMountedCursors = function(_: ((...any) -> ...any)) -- line: 12
		-- upvalues: Logger (copy)
		Logger:warning("No Cursor Provider found")
	end,
	getCursor = function(_) -- line: 15
		-- upvalues: Logger (copy)
		Logger:warning("No Cursor Provider found")
	end
}))
