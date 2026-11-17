local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.Breakpoint)
require(Foundation.Providers.Responsive.ResponsiveContext)

return React.createContext(nil)
