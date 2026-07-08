local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)

local function useHeaderBarContext() -- line: 8
	-- upvalues: React (copy), HeaderBarContext (copy)
	return React.useContext(HeaderBarContext.Context)
end

return useHeaderBarContext
