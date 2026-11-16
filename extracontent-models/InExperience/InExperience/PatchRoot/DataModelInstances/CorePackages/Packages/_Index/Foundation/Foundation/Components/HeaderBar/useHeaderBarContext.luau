local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)

local function useHeaderBarContext()
	return React.useContext(HeaderBarContext.Context)
end

return useHeaderBarContext
