local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Components.Types)

local React = require(FoundationParent.React)
local TileContext = require(script.Parent.TileContext)

return function() -- line: 17
	-- upvalues: React (copy), TileContext (copy)
	return React.useContext(TileContext)
end
