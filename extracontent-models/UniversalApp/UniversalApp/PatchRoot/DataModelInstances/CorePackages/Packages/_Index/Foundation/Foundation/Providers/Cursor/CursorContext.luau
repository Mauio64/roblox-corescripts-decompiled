local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Logger = require(Foundation.Utility.Logger)
local React = require(parent.React)

require(Foundation.Enums.CursorType)

require(Foundation.Components.Types)

return (React.createContext({
	refCache = {},
	setMountedCursors = function(_)
		Logger:warning("No Cursor Provider found")
	end,
	getCursor = function(_)
		Logger:warning("No Cursor Provider found")
	end
}))
